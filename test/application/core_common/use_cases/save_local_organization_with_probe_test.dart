// ============================================================================
// test/application/core_common/use_cases/save_local_organization_with_probe_test.dart
// SAVE LOCAL ORGANIZATION WITH PROBE — Flujo end-to-end + guardrails (F5 Hito 2)
// ============================================================================
// Valida el mismo patrón que LocalContact, adaptado a Organization:
//   1) save + normalize + triggerProbe + candidato emitido por watch.
//   2) Trigger preciso: probe SOLO si cambian llaves normalizadas
//      (taxId / phoneE164 / email). Sin cambio → no probe.
//   3) Silent fail: si probe lanza, el caso de uso NO propaga.
//
// NOTA de mapeo: taxId (NIT) viaja como VerifiedKeyType.docId; el matcher
// discrimina el nivel de trust por ActorKind (organization vs person).
// ============================================================================

import 'package:avanzza/application/core_common/use_cases/save_local_organization_with_probe.dart';
import 'package:avanzza/data/sources/remote/core_common/nestjs_exceptions.dart';
import 'package:avanzza/domain/entities/core_common/local_organization_entity.dart';
import 'package:avanzza/domain/entities/core_common/match_candidate_entity.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/match_candidate_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/match_trust_level.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/normalized_key.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/verified_key_type.dart';
import 'package:avanzza/domain/repositories/core_common/local_organization_repository.dart';
import 'package:avanzza/domain/repositories/core_common/match_candidate_repository.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Fakes mínimos.
// ---------------------------------------------------------------------------

class _FakeOrgRepo implements LocalOrganizationRepository {
  final List<LocalOrganizationEntity> saved = [];
  LocalOrganizationEntity? previous;

  @override
  Future<LocalOrganizationEntity?> getById(String id) async => previous;

  @override
  Future<void> save(LocalOrganizationEntity organization) async {
    saved.add(organization);
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'LocalOrganizationRepository.${invocation.memberName}');
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
  noSuchMethod(Invocation invocation) => throw UnimplementedError(
      'MatchCandidateRepository.${invocation.memberName}');
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  final now = DateTime.utc(2026, 4, 17, 12);
  const workspaceId = 'ws-1';

  LocalOrganizationEntity makeOrg({
    String? taxId,
    String? phone,
    String? email,
  }) =>
      LocalOrganizationEntity(
        id: 'org-1',
        workspaceId: workspaceId,
        displayName: 'Taller La Roca',
        createdAt: now,
        updatedAt: now,
        taxId: taxId,
        primaryPhoneE164: phone,
        primaryEmail: email,
      );

  // =========================================================================
  // 1. FLUJO END-TO-END (creación)
  // =========================================================================

  group('creación — save + normalize + triggerProbe + watch', () {
    test('dispara probe y la UI observa el candidato expuesto', () async {
      final orgRepo = _FakeOrgRepo()..previous = null;
      final matchRepo = _FakeMatchRepo()
        ..probeWillReturn = [
          MatchCandidateEntity(
            id: 'mc-backend-org-1',
            sourceWorkspaceId: workspaceId,
            localKind: TargetLocalKind.organization,
            localId: 'org-1',
            platformActorId: 'actor-ACME',
            matchedKeyType: VerifiedKeyType.docId,
            matchedKeyValue: '900123456',
            trustLevel: MatchTrustLevel.alto,
            state: MatchCandidateState.exposedToWorkspace,
            detectedAt: now,
            updatedAt: now,
            exposedAt: now,
          ),
        ];

      final uc = SaveLocalOrganizationWithProbe(
        organizationRepository: orgRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        organization: makeOrg(
          taxId: '900.123.456-7',
          phone: '+57 (1) 234 5678',
          email: ' CONTACTO@acme.co ',
        ),
        defaultCountryCallingCode: '57',
      );

      expect(orgRepo.saved, hasLength(1));
      expect(matchRepo.probeCalls, hasLength(1));
      final call = matchRepo.probeCalls.single;
      expect(call.localKind, TargetLocalKind.organization);
      expect(call.localId, 'org-1');

      final byType = {for (final p in call.probes) p.keyType: p.normalizedValue};
      // taxId (NIT sin DV) → VerifiedKeyType.docId
      expect(byType[VerifiedKeyType.docId], '900123456');
      expect(byType[VerifiedKeyType.phoneE164], '+5712345678');
      expect(byType[VerifiedKeyType.email], 'contacto@acme.co');

      final emitted = await matchRepo.watchExposedByWorkspace(workspaceId).first;
      expect(emitted.single.id, 'mc-backend-org-1');
      expect(emitted.single.localKind, TargetLocalKind.organization);
    });

    test('sin llaves normalizables: save ejecuta, probe se omite', () async {
      final orgRepo = _FakeOrgRepo()..previous = null;
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalOrganizationWithProbe(
        organizationRepository: orgRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        organization: makeOrg(taxId: '', phone: null, email: '   '),
        defaultCountryCallingCode: '57',
      );

      expect(orgRepo.saved, hasLength(1));
      expect(matchRepo.probeCalls, isEmpty);
    });
  });

  // =========================================================================
  // 2. TRIGGER PRECISO EN UPDATE
  // =========================================================================

  group('update — trigger SOLO si cambian llaves normalizadas', () {
    test('mismas llaves (distinto formato superficial) → NO probe', () async {
      final orgRepo = _FakeOrgRepo()
        ..previous = makeOrg(
          taxId: '900.123.456-7',
          phone: '+57 (1) 234 5678',
          email: 'CONTACTO@acme.co',
        );
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalOrganizationWithProbe(
        organizationRepository: orgRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        organization: makeOrg(
          taxId: '900123456-7',
          phone: '(+57)1-234-5678',
          email: ' contacto@acme.co ',
        ),
        defaultCountryCallingCode: '57',
      );

      expect(orgRepo.saved, hasLength(1));
      expect(matchRepo.probeCalls, isEmpty,
          reason: 'llaves normalizadas idénticas → sin probe');
    });

    test('cambio de taxId → dispara probe', () async {
      final orgRepo = _FakeOrgRepo()..previous = makeOrg(taxId: '900111111');
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalOrganizationWithProbe(
        organizationRepository: orgRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        organization: makeOrg(taxId: '900999999'),
        defaultCountryCallingCode: '57',
      );

      expect(matchRepo.probeCalls, hasLength(1));
      expect(
        matchRepo.probeCalls.single.probes.single.normalizedValue,
        '900999999',
      );
    });

    test('cambio de phone → dispara probe', () async {
      final orgRepo = _FakeOrgRepo()
        ..previous = makeOrg(phone: '+5712345678');
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalOrganizationWithProbe(
        organizationRepository: orgRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        organization: makeOrg(phone: '+5719999999'),
        defaultCountryCallingCode: '57',
      );

      expect(matchRepo.probeCalls, hasLength(1));
    });

    test('cambio de email → dispara probe', () async {
      final orgRepo = _FakeOrgRepo()
        ..previous = makeOrg(email: 'viejo@acme.co');
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalOrganizationWithProbe(
        organizationRepository: orgRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        organization: makeOrg(email: 'nuevo@acme.co'),
        defaultCountryCallingCode: '57',
      );

      expect(matchRepo.probeCalls, hasLength(1));
    });

    test('cambio en displayName (no-llave) → NO probe', () async {
      final prev = makeOrg(taxId: '900123456');
      final orgRepo = _FakeOrgRepo()..previous = prev;
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalOrganizationWithProbe(
        organizationRepository: orgRepo,
        matchCandidateRepository: matchRepo,
      );

      final renamed = LocalOrganizationEntity(
        id: prev.id,
        workspaceId: prev.workspaceId,
        displayName: 'Taller La Roca RENOMBRADO',
        createdAt: prev.createdAt,
        updatedAt: now,
        taxId: prev.taxId,
      );

      await uc.execute(
        organization: renamed,
        defaultCountryCallingCode: '57',
      );

      expect(orgRepo.saved, hasLength(1));
      expect(matchRepo.probeCalls, isEmpty);
    });

    test('agregar una llave nueva (null → presente) → dispara probe', () async {
      final orgRepo = _FakeOrgRepo()..previous = makeOrg(taxId: null);
      final matchRepo = _FakeMatchRepo();
      final uc = SaveLocalOrganizationWithProbe(
        organizationRepository: orgRepo,
        matchCandidateRepository: matchRepo,
      );

      await uc.execute(
        organization: makeOrg(taxId: '900123456'),
        defaultCountryCallingCode: '57',
      );

      expect(matchRepo.probeCalls, hasLength(1));
    });
  });

  // =========================================================================
  // 3. SILENT FAIL
  // =========================================================================

  group('silent fail — probe error NO propaga', () {
    test('NetworkException: save OK, caso de uso termina sin lanzar', () async {
      final orgRepo = _FakeOrgRepo()..previous = null;
      final matchRepo = _FakeMatchRepo()
        ..probeWillThrow = const NetworkException('down');
      final uc = SaveLocalOrganizationWithProbe(
        organizationRepository: orgRepo,
        matchCandidateRepository: matchRepo,
      );

      await expectLater(
        uc.execute(
          organization: makeOrg(taxId: '900123456'),
          defaultCountryCallingCode: '57',
        ),
        completes,
      );

      expect(orgRepo.saved, hasLength(1));
      expect(matchRepo.probeCalls, hasLength(1));
    });

    test('UnauthorizedException: silent fail', () async {
      final matchRepo = _FakeMatchRepo()
        ..probeWillThrow = const UnauthorizedException('no token');
      final uc = SaveLocalOrganizationWithProbe(
        organizationRepository: _FakeOrgRepo()..previous = null,
        matchCandidateRepository: matchRepo,
      );

      await expectLater(
        uc.execute(
          organization: makeOrg(taxId: '900123456'),
          defaultCountryCallingCode: '57',
        ),
        completes,
      );
    });

    test('ServerException 500: silent fail', () async {
      final matchRepo = _FakeMatchRepo()
        ..probeWillThrow = const ServerException(500, 'boom');
      final uc = SaveLocalOrganizationWithProbe(
        organizationRepository: _FakeOrgRepo()..previous = null,
        matchCandidateRepository: matchRepo,
      );

      await expectLater(
        uc.execute(
          organization: makeOrg(taxId: '900123456'),
          defaultCountryCallingCode: '57',
        ),
        completes,
      );
    });
  });
}
