// ============================================================================
// lib/application/core_common/use_cases/save_local_organization_with_probe.dart
// SAVE LOCAL ORGANIZATION WITH PROBE — F5 Hito 2
// ============================================================================
// QUÉ HACE:
//   - Persiste una LocalOrganization (create o update) y dispara el matcher
//     remoto con las llaves candidatas (taxId, phoneE164, email) normalizadas.
//   - Camino único autorizado en F5 Hito 2 para activar probe sobre una
//     LocalOrganization; ningún otro flujo lo hace.
//
// QUÉ NO HACE:
//   - NO dispara probe en cada save indiscriminadamente: solo cuando hay
//     cambio real en taxId, phoneE164 o primaryEmail (comparación por valor
//     NORMALIZADO). Creación siempre dispara (si hay llaves).
//   - NO toca LocalContact ni otros actores.
//   - NO encola reintentos ni propaga errores de probe al caller.
//
// POLÍTICA DE ERROR EN v1 — SILENT FAIL + LOG:
//   Misma política que SaveLocalContactWithProbe:
//     - Si el probe lanza (NetworkException / UnauthorizedException /
//       ServerException / BadRequestException): NO se propaga al caller, NO
//       se muestra error bloqueante, NO se reintenta. Solo log de debug.
//     - Próximo update de la organización redispara naturalmente.
//     - Save local SÍ propaga errores (IO en Isar) — solo se captura el
//       fallo del probe.
//
// MAPEO DE LLAVES:
//   - taxId (NIT sin DV, normalizado) → VerifiedKeyType.docId
//       (el matcher discrimina por ActorKind; docId en organization = NIT)
//   - primaryPhoneE164 normalizado → VerifiedKeyType.phoneE164
//   - primaryEmail normalizado → VerifiedKeyType.email
//
// GUARDRAILS F5 APLICADOS:
//   - Comparación por valor normalizado.
//   - Triggers acotados a taxId / phoneE164 / email.
//   - IDs en Isar: backendId (MatchCandidate.id) con índice único.
// ============================================================================

import 'package:flutter/foundation.dart';

import '../../../domain/entities/core_common/local_organization_entity.dart';
import '../../../domain/entities/core_common/value_objects/normalized_key.dart';
import '../../../domain/entities/core_common/value_objects/target_local_kind.dart';
import '../../../domain/entities/core_common/value_objects/verified_key_type.dart';
import '../../../domain/repositories/core_common/local_organization_repository.dart';
import '../../../domain/repositories/core_common/match_candidate_repository.dart';
import '../../../domain/services/core_common/key_normalizer.dart';

class SaveLocalOrganizationWithProbe {
  final LocalOrganizationRepository _organizationRepository;
  final MatchCandidateRepository _matchCandidateRepository;

  const SaveLocalOrganizationWithProbe({
    required LocalOrganizationRepository organizationRepository,
    required MatchCandidateRepository matchCandidateRepository,
  })  : _organizationRepository = organizationRepository,
        _matchCandidateRepository = matchCandidateRepository;

  /// Guarda la organización y dispara probe SI corresponde:
  ///   - creación (no existe previo): dispara si el nuevo tiene llaves normalizables.
  ///   - update: dispara SOLO si alguna llave (taxId / phoneE164 / email)
  ///     cambió respecto del previo, comparando por valor NORMALIZADO.
  ///
  /// [defaultCountryCallingCode] alimenta el normalizer de phone; misma fuente
  /// única que en SaveLocalContactWithProbe.
  Future<void> execute({
    required LocalOrganizationEntity organization,
    required String defaultCountryCallingCode,
  }) async {
    final LocalOrganizationEntity? previous =
        await _organizationRepository.getById(organization.id);

    await _organizationRepository.save(organization);

    final shouldProbe = previous == null ||
        _normalizedKeysChanged(
          previous: previous,
          current: organization,
          defaultCountryCallingCode: defaultCountryCallingCode,
        );
    if (!shouldProbe) return;

    final probes = _buildProbes(organization, defaultCountryCallingCode);
    if (probes.isEmpty) return;

    try {
      await _matchCandidateRepository.triggerProbe(
        workspaceId: organization.workspaceId,
        localKind: TargetLocalKind.organization,
        localId: organization.id,
        probes: probes,
      );
    } catch (err, st) {
      debugPrint(
        '[SaveLocalOrganizationWithProbe] probe silent-fail '
        'organizationId=${organization.id} workspaceId=${organization.workspaceId} '
        'error=$err',
      );
      debugPrint(st.toString());
    }
  }

  bool _normalizedKeysChanged({
    required LocalOrganizationEntity previous,
    required LocalOrganizationEntity current,
    required String defaultCountryCallingCode,
  }) {
    final prevTax = _normTax(previous.taxId);
    final currTax = _normTax(current.taxId);
    if (prevTax != currTax) return true;

    final prevPhone =
        _normPhone(previous.primaryPhoneE164, defaultCountryCallingCode);
    final currPhone =
        _normPhone(current.primaryPhoneE164, defaultCountryCallingCode);
    if (prevPhone != currPhone) return true;

    final prevEmail = _normEmail(previous.primaryEmail);
    final currEmail = _normEmail(current.primaryEmail);
    if (prevEmail != currEmail) return true;

    return false;
  }

  String? _normTax(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return normalizeTaxId(raw);
  }

  String? _normPhone(String? raw, String cc) {
    if (raw == null || raw.trim().isEmpty) return null;
    return normalizePhoneE164(raw, defaultCountryCallingCode: cc);
  }

  String? _normEmail(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return normalizeEmail(raw);
  }

  List<NormalizedKey> _buildProbes(
    LocalOrganizationEntity o,
    String defaultCountryCallingCode,
  ) {
    final result = <NormalizedKey>[];

    // taxId (NIT) → keyType docId. El matcher discrimina por ActorKind.
    final tax = _normTax(o.taxId);
    if (tax != null) {
      result.add(NormalizedKey(
        keyType: VerifiedKeyType.docId,
        normalizedValue: tax,
      ));
    }

    final phone = _normPhone(o.primaryPhoneE164, defaultCountryCallingCode);
    if (phone != null) {
      result.add(NormalizedKey(
        keyType: VerifiedKeyType.phoneE164,
        normalizedValue: phone,
      ));
    }

    final email = _normEmail(o.primaryEmail);
    if (email != null) {
      result.add(NormalizedKey(
        keyType: VerifiedKeyType.email,
        normalizedValue: email,
      ));
    }

    return result;
  }
}
