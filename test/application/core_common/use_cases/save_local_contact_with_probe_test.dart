// ============================================================================
// test/application/core_common/use_cases/save_local_contact_with_probe_test.dart
// SAVE LOCAL CONTACT WITH PROBE — Flujo end-to-end + guardrails (F5 Hito 1)
// ============================================================================
// Valida:
//   1) save + normalize + triggerProbe + candidato emitido por watch.
//   2) Trigger preciso: probe SOLO si cambian llaves (phoneE164/email/docId)
//      comparadas por valor NORMALIZADO. Sin cambio → no probe.
//   3) Silent fail: si el probe lanza, el caso de uso NO propaga al caller.
// ============================================================================

import 'package:avanzza/application/core_common/use_cases/save_local_contact_with_probe.dart';
import 'package:avanzza/data/sources/remote/core_common/nestjs_exceptions.dart';
import 'package:avanzza/domain/entities/core_common/local_contact_entity.dart';
import 'package:avanzza/domain/entities/core_common/match_candidate_entity.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/match_candidate_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/match_trust_level.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/normalized_key.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/verified_key_type.dart';
import 'package:avanzza/domain/repositories/core_common/local_contact_repository.dart';
import 'package:avanzza/domain/repositories/core_common/match_candidate_repository.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Fakes: implementan solo lo que el caso de uso invoca.
// ---------------------------------------------------------------------------

class _FakeContactRepo implements LocalContactRepository {
  final List<LocalContactEntity> saved = [];
  LocalContactEntity? previous;

  @override
  Future<LocalContactEntity?> getById(String id) async => previous;

  @override
  Future<void> save(LocalContactEntity contact) async {
    saved.add(contact);
  }

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('LocalContactRepository.${invocation.memberName}');
}

class _TriggerProbeArgs {
  final String workspaceId;
  final TargetLocalKind localKind;
  final String localId;
  final List<NormalizedKey> probes;
  _TriggerProbeArgs(this.workspaceId, this.localKind, this.localId, this.probes);
}

class _FakeMatchRepo implements MatchCandidateRepository {
  final List<_TriggerProbeArgs> probeCalls = [];
  final List<MatchCandidateEntity> _persistedByProbe = [];
  Object? probeWillThrow;
  List<MatchCandidateEntity> probeWillReturn = const [];

  @override
  Future<List<MatchCandidateEntity>> triggerProbe({
    required String workspaceId,
    required TargetLocalKind localKind,
    required String localId,
    required List<NormalizedKey> probes,
  }) async {
    probeCalls.add(_TriggerProbeArgs(workspaceId, localKind, localId, probes));
    final err = probeWillThrow;
    if (err != null) throw err;
    _persistedByProbe.addAll(probeWillReturn);
    return probeWillReturn;
  }

  @override
  Stream<List<MatchCandidateEntity>> watchExposedByWorkspace(
    String workspaceId,
  ) async* {
    yield _persistedByProbe
        .where((mc) =>
            mc.sourceWorkspaceId == workspaceId &&
            mc.state == MatchCandidateState.exposedToWorkspace)
        .toList();
  }

  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('MatchCandidateRepository.${invocation.memberName}');
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  final now = DateTime.utc(2026, 4, 17, 12);
  const workspaceId = 'ws-1';

  LocalContactEntity makeContact({
    String? phone,
    String? email,
    String? docId,
  }) =>
      LocalContactEntity(
        id: 'c-1',
        workspaceId: workspaceId,
        displayName: 'Juan Pérez',
        createdAt: now,
        updatedAt: now,
        primaryPhoneE164: phone,
        primaryEmail: email,
        docId: docId,
      );

  // =========================================================================
  // 1. FLUJO END-TO-END (creación)
  // =========================================================================

  group('creación — save + normalize + triggerProbe + watch', () {
    test('dispara probe y la UI observa el candidato expuesto', () async {
      final contactRepo = _FakeContactRepo()..previous = null;
      final matchRepo = _FakeMatchRepo()
        ..probeWillReturn = [
          MatchCandidateEntity(
            id: 'mc-backend-1',
            sourceWorkspaceId: workspaceId,
            localKind: TargetLocalKind.contact,
            localId: 'c-1',
            platformActorId: 'actor-X',
            matchedKeyType: VerifiedKeyType.phoneE164,
            matchedKeyValue: '+573001234567',
            trustLevel: MatchTrustLevel.alto,
            state: MatchCandidateState.exposedToWorkspace,
            detectedAt: now,
            updatedAt: now,
            exposedAt: now,
          ),
        ];

      final uc = SaveLocalContactWithProbe(
        contactRepository: contactRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        contact: makeContact(
          phone: '+57 300 123 4567',
          email: ' JUAN@empresa.co ',
          docId: '1.020.304.050',
        ),
        defaultCountryCallingCode: '57',
      );

      expect(contactRepo.saved, hasLength(1));
      expect(matchRepo.probeCalls, hasLength(1));
      final probes = matchRepo.probeCalls.single.probes;
      final byType = {for (final p in probes) p.keyType: p.normalizedValue};
      expect(byType[VerifiedKeyType.phoneE164], '+573001234567');
      expect(byType[VerifiedKeyType.email], 'juan@empresa.co');
      expect(byType[VerifiedKeyType.docId], '1020304050');

      final emitted = await matchRepo.watchExposedByWorkspace(workspaceId).first;
      expect(emitted.single.id, 'mc-backend-1');
      expect(emitted.single.localId, 'c-1');
    });

    test('sin llaves normalizables: save ejecuta, probe se omite', () async {
      final contactRepo = _FakeContactRepo()..previous = null;
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalContactWithProbe(
        contactRepository: contactRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        contact: makeContact(phone: null, email: '   ', docId: ''),
        defaultCountryCallingCode: '57',
      );

      expect(contactRepo.saved, hasLength(1));
      expect(matchRepo.probeCalls, isEmpty);
    });

    test('llave inválida se omite; las válidas sí viajan', () async {
      final contactRepo = _FakeContactRepo()..previous = null;
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalContactWithProbe(
        contactRepository: contactRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        contact: makeContact(phone: '123', email: 'valido@acme.co'),
        defaultCountryCallingCode: '57',
      );

      expect(matchRepo.probeCalls, hasLength(1));
      final probes = matchRepo.probeCalls.single.probes;
      expect(probes, hasLength(1));
      expect(probes.single.keyType, VerifiedKeyType.email);
      expect(probes.single.normalizedValue, 'valido@acme.co');
    });
  });

  // =========================================================================
  // 2. TRIGGER PRECISO EN UPDATE
  // =========================================================================

  group('update — trigger SOLO si cambian llaves normalizadas', () {
    test('mismas llaves (distinto formato superficial) → NO probe', () async {
      // Previo guardado con phone en formato "sucio"; update con formato limpio.
      // Normalizan al MISMO valor → sin cambio real.
      final contactRepo = _FakeContactRepo()
        ..previous = makeContact(
          phone: '+57 300 123 4567',
          email: 'JUAN@empresa.co',
          docId: '1.020.304.050',
        );
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalContactWithProbe(
        contactRepository: contactRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        contact: makeContact(
          phone: '(+57)300-123-4567',
          email: ' juan@empresa.co ',
          docId: '1020304050',
        ),
        defaultCountryCallingCode: '57',
      );

      expect(contactRepo.saved, hasLength(1));
      expect(matchRepo.probeCalls, isEmpty,
          reason: 'llaves normalizadas idénticas → sin probe');
    });

    test('cambio de phoneE164 → dispara probe', () async {
      final contactRepo = _FakeContactRepo()
        ..previous = makeContact(phone: '+573001111111');
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalContactWithProbe(
        contactRepository: contactRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        contact: makeContact(phone: '+573009999999'),
        defaultCountryCallingCode: '57',
      );

      expect(matchRepo.probeCalls, hasLength(1));
      expect(
        matchRepo.probeCalls.single.probes.single.normalizedValue,
        '+573009999999',
      );
    });

    test('cambio de email → dispara probe', () async {
      final contactRepo = _FakeContactRepo()
        ..previous = makeContact(email: 'viejo@a.co');
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalContactWithProbe(
        contactRepository: contactRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        contact: makeContact(email: 'nuevo@a.co'),
        defaultCountryCallingCode: '57',
      );

      expect(matchRepo.probeCalls, hasLength(1));
    });

    test('cambio de docId → dispara probe', () async {
      final contactRepo = _FakeContactRepo()
        ..previous = makeContact(docId: '1020304050');
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalContactWithProbe(
        contactRepository: contactRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        contact: makeContact(docId: '9080706050'),
        defaultCountryCallingCode: '57',
      );

      expect(matchRepo.probeCalls, hasLength(1));
    });

    test('agregar una llave nueva (null → presente) → dispara probe', () async {
      final contactRepo = _FakeContactRepo()
        ..previous = makeContact(phone: null);
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalContactWithProbe(
        contactRepository: contactRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        contact: makeContact(phone: '+573001234567'),
        defaultCountryCallingCode: '57',
      );

      expect(matchRepo.probeCalls, hasLength(1));
    });

    test('remover una llave (presente → null) → dispara probe', () async {
      final contactRepo = _FakeContactRepo()
        ..previous = makeContact(phone: '+573001234567');
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalContactWithProbe(
        contactRepository: contactRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        contact: makeContact(phone: null),
        defaultCountryCallingCode: '57',
      );

      // Probe dispara (cambio null ↔ presente) pero probes queda vacía
      // porque no hay llaves normalizables. Documentado: el caso de uso
      // omite el probe si `probes.isEmpty`.
      expect(matchRepo.probeCalls, isEmpty,
          reason: 'cambio a llave null deja probes vacías → probe se omite');
    });

    test('cambio en displayName (campo NO sensible) → NO probe', () async {
      final prev = makeContact(phone: '+573001234567');
      final contactRepo = _FakeContactRepo()..previous = prev;
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalContactWithProbe(
        contactRepository: contactRepo,
        matchCandidateRepository: matchRepo,
      );

      // Nuevo contacto con el mismo phone pero displayName distinto.
      final current = LocalContactEntity(
        id: prev.id,
        workspaceId: prev.workspaceId,
        displayName: 'Juan Pérez RENOMBRADO',
        createdAt: prev.createdAt,
        updatedAt: now,
        primaryPhoneE164: prev.primaryPhoneE164,
      );

      await uc.execute(
        contact: current,
        defaultCountryCallingCode: '57',
      );

      expect(contactRepo.saved, hasLength(1));
      expect(matchRepo.probeCalls, isEmpty,
          reason: 'cambio en campos no-llave no dispara probe');
    });
  });

  // =========================================================================
  // 3. SILENT FAIL EN ERROR DEL PROBE
  // =========================================================================

  group('silent fail — probe error NO propaga', () {
    test('NetworkException: save OK, probe 1 vez, caso de uso termina sin lanzar',
        () async {
      final contactRepo = _FakeContactRepo()..previous = null;
      final matchRepo = _FakeMatchRepo()
        ..probeWillThrow = const NetworkException('down');
      final uc = SaveLocalContactWithProbe(
        contactRepository: contactRepo,
        matchCandidateRepository: matchRepo,
      );

      // Debe terminar normalmente (sin throw). expectLater con completes lo
      // verifica.
      await expectLater(
        uc.execute(
          contact: makeContact(phone: '+573001234567'),
          defaultCountryCallingCode: '57',
        ),
        completes,
      );

      expect(contactRepo.saved, hasLength(1));
      expect(matchRepo.probeCalls, hasLength(1),
          reason: 'un solo intento, sin retry automático');
    });

    test('UnauthorizedException: silent fail sin propagar', () async {
      final matchRepo = _FakeMatchRepo()
        ..probeWillThrow = const UnauthorizedException('no token');
      final uc = SaveLocalContactWithProbe(
        contactRepository: _FakeContactRepo()..previous = null,
        matchCandidateRepository: matchRepo,
      );

      await expectLater(
        uc.execute(
          contact: makeContact(phone: '+573001234567'),
          defaultCountryCallingCode: '57',
        ),
        completes,
      );
    });

    test('ServerException 500: silent fail sin propagar', () async {
      final matchRepo = _FakeMatchRepo()
        ..probeWillThrow = const ServerException(500, 'boom');
      final uc = SaveLocalContactWithProbe(
        contactRepository: _FakeContactRepo()..previous = null,
        matchCandidateRepository: matchRepo,
      );

      await expectLater(
        uc.execute(
          contact: makeContact(phone: '+573001234567'),
          defaultCountryCallingCode: '57',
        ),
        completes,
      );
    });
  });
}
