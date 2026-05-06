// ============================================================================
// test/presentation/view_models/network/network_actor_vm_test.dart
// NetworkActorVm.fromAssetActorLink — mapper genérico (ADR §10)
// ============================================================================
// Cubre:
//   - actorKey platform / local / fallback link:<id>.
//   - displayName hidratado desde LocalContact.
//   - displayName hidratado desde LocalOrganization.
//   - displayName fallback neutral cuando no hay libreta.
//   - relationshipState opcional se propaga.
// ============================================================================

import 'package:avanzza/domain/entities/core_common/asset_actor_link_entity.dart';
import 'package:avanzza/domain/entities/core_common/local_contact_entity.dart';
import 'package:avanzza/domain/entities/core_common/local_organization_entity.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/actor_ref_kind_value.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/relationship_state.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:avanzza/presentation/view_models/network/network_actor_vm.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime.utc(2026, 4, 15);

AssetActorLinkEntity _localLink({
  String id = 'aal-1',
  TargetLocalKind localKind = TargetLocalKind.contact,
  String? localId = 'local-abc',
  AssetActorRole role = AssetActorRole.owner,
}) {
  return AssetActorLinkEntity(
    id: id,
    orgId: 'org-1',
    assetId: 'asset-1',
    role: role,
    actorRefKind: ActorRefKindValue.local,
    source: 'user_declared',
    verificationStatus: 'pending',
    status: 'active',
    startedAt: _now,
    createdAt: _now,
    updatedAt: _now,
    localKind: localKind,
    localId: localId,
  );
}

AssetActorLinkEntity _platformLink({
  String id = 'aal-plat',
  String? platformActorId = 'pa-42',
}) {
  return AssetActorLinkEntity(
    id: id,
    orgId: 'org-1',
    assetId: 'asset-1',
    role: AssetActorRole.technician,
    actorRefKind: ActorRefKindValue.platform,
    source: 'import',
    verificationStatus: 'verified',
    status: 'active',
    startedAt: _now,
    createdAt: _now,
    updatedAt: _now,
    platformActorId: platformActorId,
  );
}

LocalContactEntity _contact({String id = 'local-abc', String name = 'Ana Pérez'}) {
  return LocalContactEntity(
    id: id,
    workspaceId: 'org-1',
    displayName: name,
    createdAt: _now,
    updatedAt: _now,
  );
}

LocalOrganizationEntity _org({String id = 'local-org', String name = 'Taller XYZ S.A.S.'}) {
  return LocalOrganizationEntity(
    id: id,
    workspaceId: 'org-1',
    displayName: name,
    createdAt: _now,
    updatedAt: _now,
  );
}

void main() {
  group('actorKey', () {
    test('platform → "platform:<id>"', () {
      final vm = NetworkActorVm.fromAssetActorLink(_platformLink(platformActorId: 'pa-1'));
      expect(vm.actorKey, 'platform:pa-1');
    });

    test('local contact → "local:contact:<id>"', () {
      final vm = NetworkActorVm.fromAssetActorLink(_localLink(localId: 'ct-9'));
      expect(vm.actorKey, 'local:contact:ct-9');
    });

    test('local organization → "local:organization:<id>"', () {
      final vm = NetworkActorVm.fromAssetActorLink(
        _localLink(localKind: TargetLocalKind.organization, localId: 'og-3'),
      );
      expect(vm.actorKey, 'local:organization:og-3');
    });

    test('fallback "link:<id>" si falta la ref (no debería pasar)', () {
      final link = _localLink().copyWith(
        localKind: null,
        localId: null,
      );
      final vm = NetworkActorVm.fromAssetActorLink(link);
      expect(vm.actorKey, 'link:${link.id}');
    });
  });

  group('displayName', () {
    test('local contact con libreta → usa displayName de LocalContact', () {
      final vm = NetworkActorVm.fromAssetActorLink(
        _localLink(localId: 'ct-1'),
        localContact: _contact(id: 'ct-1', name: 'Ana Pérez'),
      );
      expect(vm.displayName, 'Ana Pérez');
    });

    test('local organization con libreta → usa displayName de LocalOrganization', () {
      final vm = NetworkActorVm.fromAssetActorLink(
        _localLink(localKind: TargetLocalKind.organization, localId: 'og-1'),
        localOrganization: _org(id: 'og-1', name: 'Taller XYZ S.A.S.'),
      );
      expect(vm.displayName, 'Taller XYZ S.A.S.');
    });

    test('local sin libreta → fallback neutral con id corto', () {
      final vm = NetworkActorVm.fromAssetActorLink(_localLink(localId: 'abcdef1234xyz'));
      expect(vm.displayName, startsWith('Actor · '));
      expect(vm.displayName, contains('abcdef12')); // los primeros 8 chars
    });

    test('platform sin hidratación → fallback neutral (5c aún no lee PlatformActor)', () {
      final vm = NetworkActorVm.fromAssetActorLink(
        _platformLink(platformActorId: 'pa-abcdef1234'),
      );
      expect(vm.displayName, startsWith('Actor · '));
    });

    test('libreta con displayName vacío → fallback neutral', () {
      final vm = NetworkActorVm.fromAssetActorLink(
        _localLink(localId: 'ct-1'),
        localContact: _contact(id: 'ct-1', name: '   '),
      );
      expect(vm.displayName, startsWith('Actor · '));
    });
  });

  group('campos proyectados', () {
    test('role, assetId, linkStatus, linkSource, actorRefKind se propagan', () {
      final vm = NetworkActorVm.fromAssetActorLink(
        _localLink(role: AssetActorRole.driver),
      );
      expect(vm.role, AssetActorRole.driver);
      expect(vm.assetId, 'asset-1');
      expect(vm.linkStatus, 'active');
      expect(vm.linkSource, 'user_declared');
      expect(vm.actorRefKind, ActorRefKindValue.local);
    });

    test('relationshipState opcional se propaga al VM', () {
      final vm = NetworkActorVm.fromAssetActorLink(
        _localLink(),
        relationshipState: RelationshipState.vinculada,
      );
      expect(vm.relationshipState, RelationshipState.vinculada);
    });

    test('relationshipState null si no se pasa', () {
      final vm = NetworkActorVm.fromAssetActorLink(_localLink());
      expect(vm.relationshipState, isNull);
    });
  });
}
