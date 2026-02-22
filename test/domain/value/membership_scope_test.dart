// ============================================================================
// test/domain/value/membership_scope_test.dart
// MEMBERSHIP SCOPE TESTS — Enterprise Ultra Pro (Test / Domain)
//
// QUÉ HACE:
// - Valida contrato de MembershipScope (defaults, constructores, helpers).
// - Valida canAccessAsset() para global/restricted/none.
// - Valida isEffectivelyEmpty() en escenarios relevantes (incluyendo overrides).
// - Valida JSON roundtrip (toJson/fromJson) con assigned* y granularOverrides.
// - Valida parse seguro de MembershipModel.scopeJson (null/vacío/corrupto/mal tipado).
// - Valida roundtrip MembershipEntity → MembershipModel → MembershipEntity preserva scope.
//
// QUÉ NO HACE:
// - No prueba enforcement de acceso (repositorios/UI/policies) — fase posterior.
// - No prueba persistencia real Isar/Firestore (integration test).
// - No valida el formato de granularOverrides (solo transporte) — enforcement posterior.
//
// NOTAS:
// - REQUIERE ejecutar build_runner (freezed/json_serializable) o fallará con undefined_*.
// - MembershipEntity requiere estatus y primaryLocation: este test los provee explícitamente.
// ============================================================================

import 'dart:convert';

import 'package:avanzza/data/models/user/membership_model.dart';
import 'package:avanzza/domain/entities/user/membership_entity.dart';
import 'package:avanzza/domain/value/membership_scope.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MembershipScope — defaults y constructores', () {
    test('default → restricted vacío (sin acceso)', () {
      const s = MembershipScope();

      expect(s.type, ScopeType.restricted);
      expect(s.assignedAssetIds, isEmpty);
      expect(s.assignedGroupIds, isEmpty);
      expect(s.granularOverrides, isEmpty);

      expect(s.isRestricted, isTrue);
      expect(s.isGlobal, isFalse);
      expect(s.isNone, isFalse);

      expect(s.hasAssignments, isFalse);
      expect(s.isEffectivelyEmpty, isTrue);
    });

    test('global() → type global + acceso total', () {
      final s = MembershipScope.global();
      expect(s.type, ScopeType.global);
      expect(s.isGlobal, isTrue);
      expect(s.isEffectivelyEmpty, isFalse);
      expect(s.canAccessAsset('any'), isTrue);
    });

    test('none() → type none + sin acceso', () {
      final s = MembershipScope.none();
      expect(s.type, ScopeType.none);
      expect(s.isNone, isTrue);
      expect(s.canAccessAsset('any'), isFalse);
      expect(s.isEffectivelyEmpty, isTrue);
    });

    test('restricted(assetIds/groupIds) → asignaciones presentes', () {
      final s = MembershipScope.restricted(
        assetIds: const ['a1', 'a2'],
        groupIds: const ['g1'],
      );

      expect(s.type, ScopeType.restricted);
      expect(s.assignedAssetIds, ['a1', 'a2']);
      expect(s.assignedGroupIds, ['g1']);
      expect(s.hasAssignments, isTrue);
      expect(s.isEffectivelyEmpty, isFalse);
    });
  });

  group('MembershipScope — canAccessAsset', () {
    test('global → siempre true', () {
      final s = MembershipScope.global();
      expect(s.canAccessAsset('x'), isTrue);
      expect(s.canAccessAsset(''), isTrue);
    });

    test('restricted → true solo si assetId está en assignedAssetIds', () {
      final s = MembershipScope.restricted(assetIds: const ['abc', 'xyz']);
      expect(s.canAccessAsset('abc'), isTrue);
      expect(s.canAccessAsset('xyz'), isTrue);
      expect(s.canAccessAsset('nope'), isFalse);
    });

    test('restricted vacío → false para cualquier asset', () {
      final s = MembershipScope.restricted();
      expect(s.canAccessAsset('any'), isFalse);
    });

    test('none → false para cualquier asset', () {
      final s = MembershipScope.none();
      expect(s.canAccessAsset('any'), isFalse);
    });

    test('case-sensitive (contrato actual)', () {
      final s = MembershipScope.restricted(assetIds: const ['asset-1']);
      expect(s.canAccessAsset('asset-1'), isTrue);
      expect(s.canAccessAsset('ASSET-1'), isFalse);
    });
  });

  group('MembershipScope — isEffectivelyEmpty', () {
    test('restricted sin asignaciones ni overrides → true', () {
      const s = MembershipScope();
      expect(s.isEffectivelyEmpty, isTrue);
    });

    test('restricted con assetIds → false', () {
      final s = MembershipScope.restricted(assetIds: const ['a1']);
      expect(s.isEffectivelyEmpty, isFalse);
    });

    test('restricted con groupIds → false', () {
      final s = MembershipScope.restricted(groupIds: const ['g1']);
      expect(s.isEffectivelyEmpty, isFalse);
    });

    test('restricted con granularOverrides → false', () {
      const s = MembershipScope(
        granularOverrides: ['asset:a1:perm:readonly'],
      );
      expect(s.isEffectivelyEmpty, isFalse);
    });

    test('none sin asignaciones ni overrides → true', () {
      final s = MembershipScope.none();
      expect(s.isEffectivelyEmpty, isTrue);
    });

    test('global siempre → false', () {
      final s = MembershipScope.global();
      expect(s.isEffectivelyEmpty, isFalse);
    });
  });

  group('MembershipScope — JSON', () {
    test('fromJson({}) → default seguro (restricted vacío)', () {
      final s = MembershipScope.fromJson(const <String, dynamic>{});
      expect(s.type, ScopeType.restricted);
      expect(s.isEffectivelyEmpty, isTrue);
    });

    test('roundtrip toJson/fromJson preserva assets y groups', () {
      final original = MembershipScope.restricted(
        assetIds: const ['v1', 'v2'],
        groupIds: const ['g1'],
      );
      final restored = MembershipScope.fromJson(original.toJson());

      expect(restored, original);
      expect(restored.assignedAssetIds, ['v1', 'v2']);
      expect(restored.assignedGroupIds, ['g1']);
    });

    test('roundtrip incluye granularOverrides (transport only)', () {
      const original = MembershipScope(
        type: ScopeType.restricted,
        assignedAssetIds: ['a1'],
        granularOverrides: ['asset:a1:perm:readonly', 'invalid_format'],
      );
      final restored = MembershipScope.fromJson(original.toJson());

      expect(restored, original);
      expect(restored.granularOverrides,
          ['asset:a1:perm:readonly', 'invalid_format']);
    });
  });

  group('MembershipModel — parsedScope parse seguro (scopeJson)', () {
    test('scopeJson null → default seguro', () {
      final m = MembershipModel(
        id: 'u1_o1',
        userId: 'u1',
        orgId: 'o1',
        orgName: 'Org',
        estatus: 'activo',
        scopeJson: null,
      );
      expect(m.parsedScope.type, ScopeType.restricted);
      expect(m.parsedScope.isEffectivelyEmpty, isTrue);
    });

    test('scopeJson vacío → default seguro', () {
      final m = MembershipModel(
        id: 'u1_o1',
        userId: 'u1',
        orgId: 'o1',
        orgName: 'Org',
        estatus: 'activo',
        scopeJson: '',
      );
      expect(m.parsedScope.type, ScopeType.restricted);
      expect(m.parsedScope.isEffectivelyEmpty, isTrue);
    });

    test('scopeJson corrupto → default seguro', () {
      final m = MembershipModel(
        id: 'u1_o1',
        userId: 'u1',
        orgId: 'o1',
        orgName: 'Org',
        estatus: 'activo',
        scopeJson: '{not valid json!!!}',
      );
      expect(m.parsedScope.type, ScopeType.restricted);
      expect(m.parsedScope.isEffectivelyEmpty, isTrue);
    });

    test('scopeJson mal tipado (type:int) → default seguro', () {
      final m = MembershipModel(
        id: 'u1_o1',
        userId: 'u1',
        orgId: 'o1',
        orgName: 'Org',
        estatus: 'activo',
        scopeJson: '{"type": 42}',
      );
      expect(m.parsedScope.type, ScopeType.restricted);
      expect(m.parsedScope.isEffectivelyEmpty, isTrue);
    });

    test('scopeJson válido global → parse global', () {
      final scope = MembershipScope.global();
      final m = MembershipModel(
        id: 'u1_o1',
        userId: 'u1',
        orgId: 'o1',
        orgName: 'Org',
        estatus: 'activo',
        scopeJson: jsonEncode(scope.toJson()),
      );
      expect(m.parsedScope.isGlobal, isTrue);
      expect(m.parsedScope.canAccessAsset('any'), isTrue);
    });

    test('scopeJson válido restricted → parse correcto', () {
      final scope = MembershipScope.restricted(assetIds: const ['v1', 'v2']);
      final m = MembershipModel(
        id: 'u1_o1',
        userId: 'u1',
        orgId: 'o1',
        orgName: 'Org',
        estatus: 'activo',
        scopeJson: jsonEncode(scope.toJson()),
      );
      expect(m.parsedScope.isRestricted, isTrue);
      expect(m.parsedScope.assignedAssetIds, ['v1', 'v2']);
      expect(m.parsedScope.canAccessAsset('v1'), isTrue);
      expect(m.parsedScope.canAccessAsset('v3'), isFalse);
    });
  });

  group('MembershipEntity ↔ MembershipModel — roundtrip completo', () {
    test('Entity → Model → Entity preserva scope y core fields', () {
      final entity = MembershipEntity(
        userId: 'u1',
        orgId: 'o1',
        orgName: 'Org',
        roles: const ['admin', 'asset_rw'],
        providerProfiles: const [],
        estatus: 'activo',
        primaryLocation: const {'countryId': 'CO', 'cityId': 'BAQ'},
        scope: MembershipScope.restricted(
          assetIds: const ['a1', 'a2'],
          groupIds: const ['g1'],
        ),
        isOwner: true,
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 2, 1),
      );

      final model = MembershipModel.fromEntity(entity);

      // scopeJson debe existir y ser parseable
      expect(model.scopeJson, isNotNull);
      expect(model.scopeJson, isNotEmpty);
      expect(model.parsedScope.assignedAssetIds, ['a1', 'a2']);
      expect(model.parsedScope.assignedGroupIds, ['g1']);

      final restored = model.toEntity();

      expect(restored.userId, entity.userId);
      expect(restored.orgId, entity.orgId);
      expect(restored.orgName, entity.orgName);
      expect(restored.roles, entity.roles);
      expect(restored.estatus, entity.estatus);
      expect(restored.primaryLocation, entity.primaryLocation);
      expect(restored.isOwner, entity.isOwner);

      expect(restored.scope, entity.scope);
      expect(restored.scope.canAccessAsset('a1'), isTrue);
      expect(restored.scope.canAccessAsset('nope'), isFalse);

      expect(restored.createdAt, entity.createdAt);
      expect(restored.updatedAt, entity.updatedAt);
    });

    test(
        'Entity con scope default (MembershipScope()) se preserva en roundtrip',
        () {
      const entity = MembershipEntity(
        userId: 'u1',
        orgId: 'o1',
        orgName: 'Org',
        roles: ['driver'],
        providerProfiles: [],
        estatus: 'activo',
        primaryLocation: {'countryId': 'CO'},
        // scope default: @Default(MembershipScope())
      );

      final model = MembershipModel.fromEntity(entity);
      final restored = model.toEntity();

      expect(restored.scope.type, ScopeType.restricted);
      expect(restored.scope.isEffectivelyEmpty, isTrue);
      expect(restored.scope.canAccessAsset('any'), isFalse);
    });
  });
}
