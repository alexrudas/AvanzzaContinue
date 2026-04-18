// ============================================================================
// lib/application/core_common/use_cases/save_local_contact_with_probe.dart
// SAVE LOCAL CONTACT WITH PROBE — F5 Hito 1
// ============================================================================
// QUÉ HACE:
//   - Persiste un LocalContact (create o update) y decide si disparar el
//     matcher remoto según si cambian llaves relevantes.
//   - Camino único autorizado en F5 Hito 1 para activar probe sobre un
//     LocalContact; ningún otro flujo lo hace.
//
// QUÉ NO HACE:
//   - NO dispara probe en cada save indiscriminadamente: solo cuando hay
//     cambio real en phoneE164, email o docId (comparación por valor
//     NORMALIZADO). Creación siempre dispara (si hay llaves).
//   - NO maneja LocalOrganization ni otros actores.
//   - NO encola reintentos.
//
// POLÍTICA DE ERROR EN v1 — SILENT FAIL + LOG:
//   Si el probe remoto falla (NetworkException / UnauthorizedException /
//   ServerException / BadRequestException), el caso de uso:
//     - NO propaga la excepción al caller;
//     - NO muestra error bloqueante al usuario;
//     - NO invoca retry automático;
//     - Escribe un log de debug (debugPrint) para trazabilidad blanda.
//   Racional: el próximo update del contacto (create o cambio de llave)
//   volverá a disparar el probe naturalmente. La idempotencia del unique
//   constraint en backend garantiza convergencia sin estado huérfano.
//   Cualquier política distinta (UX de error, retry, outbox) queda para
//   un hito posterior — no se disfraza aquí.
//
//   IMPORTANTE: el save local SÍ propaga errores (p. ej. IO en Isar): si
//   la persistencia local falla, el caller debe enterarse. Solo se captura
//   el fallo del probe, no el del save.
//
// GUARDRAILS F5 APLICADOS:
//   - Comparación por valor normalizado (ignora whitespace/casing/puntuación).
//   - Triggers acotados a phoneE164 / email / docId.
//   - IDs en Isar: backendId (MatchCandidate.id) con índice único.
// ============================================================================

import 'package:flutter/foundation.dart';

import '../../../domain/entities/core_common/local_contact_entity.dart';
import '../../../domain/entities/core_common/value_objects/normalized_key.dart';
import '../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../domain/entities/core_common/value_objects/verified_key_type.dart';
import '../../../domain/repositories/core_common/local_contact_repository.dart';
import '../../../domain/repositories/core_common/match_candidate_repository.dart';
import '../../../domain/services/core_common/key_normalizer.dart';

class SaveLocalContactWithProbe {
  final LocalContactRepository _contactRepository;
  final MatchCandidateRepository _matchCandidateRepository;

  const SaveLocalContactWithProbe({
    required LocalContactRepository contactRepository,
    required MatchCandidateRepository matchCandidateRepository,
  })  : _contactRepository = contactRepository,
        _matchCandidateRepository = matchCandidateRepository;

  /// Guarda el contacto y dispara probe SI corresponde:
  ///   - creación (no existe previo): dispara si el nuevo tiene llaves normalizables.
  ///   - update: dispara SOLO si alguna llave (phoneE164 / email / docId)
  ///     cambió respecto del previo, comparando por valor NORMALIZADO.
  ///
  /// [defaultCountryCallingCode] alimenta el normalizer de phone; debe ser la
  /// misma fuente única consolidada en el resto del cliente (pendiente).
  Future<void> execute({
    required LocalContactEntity contact,
    required String defaultCountryCallingCode,
  }) async {
    // 1. Estado previo (null = creación). Save propaga errores tal cual.
    final LocalContactEntity? previous =
        await _contactRepository.getById(contact.id);

    // 2. Persistencia local (+ enqueue Firestore interno del repo). Errores
    //    del save SÍ propagan (no es silent fail).
    await _contactRepository.save(contact);

    // 3. ¿Debe disparar probe?
    //    - Creación: sí, si hay probes.
    //    - Update: sí, si cambió alguna llave normalizada.
    final shouldProbe = previous == null ||
        _normalizedKeysChanged(
          previous: previous,
          current: contact,
          defaultCountryCallingCode: defaultCountryCallingCode,
        );
    if (!shouldProbe) return;

    final probes = _buildProbes(contact, defaultCountryCallingCode);
    if (probes.isEmpty) return;

    // 4. Silent fail + log. NO retry. NO propagar al caller.
    try {
      await _matchCandidateRepository.triggerProbe(
        workspaceId: contact.workspaceId,
        localKind: TargetLocalKind.contact,
        localId: contact.id,
        probes: probes,
      );
    } catch (err, st) {
      // Log blando para trazabilidad. Se adopta debugPrint para evitar
      // dependencia del Logger de dominio; si se estandariza en otra capa,
      // cambiar aquí.
      debugPrint(
        '[SaveLocalContactWithProbe] probe silent-fail '
        'contactId=${contact.id} workspaceId=${contact.workspaceId} '
        'error=$err',
      );
      debugPrint(st.toString());
    }
  }

  /// Compara las 3 llaves relevantes por valor normalizado.
  /// Retorna true si alguna cambió (incluye transición null ↔ presente).
  bool _normalizedKeysChanged({
    required LocalContactEntity previous,
    required LocalContactEntity current,
    required String defaultCountryCallingCode,
  }) {
    final prevPhone = _normPhone(previous.primaryPhoneE164, defaultCountryCallingCode);
    final currPhone = _normPhone(current.primaryPhoneE164, defaultCountryCallingCode);
    if (prevPhone != currPhone) return true;

    final prevEmail = _normEmail(previous.primaryEmail);
    final currEmail = _normEmail(current.primaryEmail);
    if (prevEmail != currEmail) return true;

    final prevDoc = _normDoc(previous.docId);
    final currDoc = _normDoc(current.docId);
    if (prevDoc != currDoc) return true;

    return false;
  }

  String? _normPhone(String? raw, String cc) {
    if (raw == null || raw.trim().isEmpty) return null;
    return normalizePhoneE164(raw, defaultCountryCallingCode: cc);
  }

  String? _normEmail(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return normalizeEmail(raw);
  }

  String? _normDoc(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return normalizeDocId(raw);
  }

  /// Construye probes a partir de las llaves normalizables del contacto.
  /// Llaves que no normalizan (formato inválido) se descartan; el flujo no aborta.
  List<NormalizedKey> _buildProbes(
    LocalContactEntity c,
    String defaultCountryCallingCode,
  ) {
    final result = <NormalizedKey>[];

    final phone = _normPhone(c.primaryPhoneE164, defaultCountryCallingCode);
    if (phone != null) {
      result.add(NormalizedKey(
        keyType: VerifiedKeyType.phoneE164,
        normalizedValue: phone,
      ));
    }

    final email = _normEmail(c.primaryEmail);
    if (email != null) {
      result.add(NormalizedKey(
        keyType: VerifiedKeyType.email,
        normalizedValue: email,
      ));
    }

    final doc = _normDoc(c.docId);
    if (doc != null) {
      result.add(NormalizedKey(
        keyType: VerifiedKeyType.docId,
        normalizedValue: doc,
      ));
    }

    return result;
  }
}
