// ============================================================================
// test/data/repositories/asset_repository_impl_actor_link_test.dart
// AssetRepositoryImpl.enqueueDeclareAssetActorLink — orquestación + error map
// ============================================================================
//
// QUÉ CUBRE:
//   - Happy path: encola un POST con assetClass=vehicle + role=owner +
//     actorRefKind=local + localKind=organization + localId=orgId.
//   - UnauthorizedException (capability faltante): swallow, NO rethrow.
//   - BadRequestException (ASSET_TYPE_NOT_FOUND, INVALID_ACTOR_REF_SHAPE,
//     INVALID_ASSET_TYPE_INPUT): swallow, NO rethrow.
//   - NetworkException: rethrow para que SyncService reintente.
//   - ServerException: rethrow para que SyncService reintente.
//
// QUÉ NO CUBRE:
//   - El flujo end-to-end de `createAssetFromRuntAndLinkToPortfolio`
//     (requiere fakes Isar fuera del alcance de este hito).
//   - El parser del response (lo cubre el spec del ApiClient).
//
// PATRÓN: fake `AssetActorLinkRepository` con noSuchMethod (mismo del
// proyecto). Cero mockito/mocktail.
// ============================================================================

import 'package:avanzza/data/repositories/asset_repository_impl.dart';
import 'package:avanzza/data/sources/local/asset_local_ds.dart';
import 'package:avanzza/data/sources/local/portfolio_local_ds.dart';
import 'package:avanzza/data/sources/remote/asset_remote_ds.dart';
import 'package:avanzza/domain/entities/core_common/asset_actor_link_entity.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/actor_ref_kind_value.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/asset_class.dart';
import 'package:avanzza/domain/entities/core_common/value_objects/target_local_kind.dart';
import 'package:avanzza/domain/errors/remote_exceptions.dart';
import 'package:avanzza/domain/repositories/core_common/asset_actor_link_repository.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Fakes ──────────────────────────────────────────────────────────────────

class _FakeAssetActorLinks implements AssetActorLinkRepository {
  /// Histórico de llamadas a `create()`.
  final List<({
    String assetId,
    String? assetTypeId,
    AssetClass? assetClass,
    AssetActorRole role,
    ActorRefKindValue actorRefKind,
    String? platformActorId,
    TargetLocalKind? localKind,
    String? localId,
  })> createCalls = [];

  /// Si está seteado, `create()` lo lanza en vez de retornar.
  Object? willThrow;

  @override
  Future<AssetActorLinkEntity> create({
    required String assetId,
    String? assetTypeId,
    AssetClass? assetClass,
    required AssetActorRole role,
    required ActorRefKindValue actorRefKind,
    String? platformActorId,
    TargetLocalKind? localKind,
    String? localId,
  }) async {
    createCalls.add((
      assetId: assetId,
      assetTypeId: assetTypeId,
      assetClass: assetClass,
      role: role,
      actorRefKind: actorRefKind,
      platformActorId: platformActorId,
      localKind: localKind,
      localId: localId,
    ));
    if (willThrow != null) throw willThrow!;
    return AssetActorLinkEntity(
      id: 'aal-1',
      orgId: localId ?? 'org-1',
      assetId: assetId,
      role: role,
      actorRefKind: actorRefKind,
      source: 'user_declared',
      verificationStatus: 'pending',
      status: 'active',
      startedAt: DateTime.utc(2026, 4, 26, 12),
      createdAt: DateTime.utc(2026, 4, 26, 12),
      updatedAt: DateTime.utc(2026, 4, 26, 12),
      platformActorId: platformActorId,
      localKind: localKind,
      localId: localId,
      endedAt: null,
    );
  }

  @override
  noSuchMethod(Invocation i) =>
      throw UnimplementedError(
          'AssetActorLinkRepository.${i.memberName}');
}

class _UnusedLocalDS implements AssetLocalDataSource {
  @override
  noSuchMethod(Invocation i) => throw UnimplementedError(
      'AssetLocalDataSource.${i.memberName} — no debería usarse en este test');
}

class _UnusedRemoteDS implements AssetRemoteDataSource {
  @override
  noSuchMethod(Invocation i) => throw UnimplementedError(
      'AssetRemoteDataSource.${i.memberName} — no debería usarse en este test');
}

class _UnusedPortfolioDS implements PortfolioLocalDataSource {
  @override
  noSuchMethod(Invocation i) => throw UnimplementedError(
      'PortfolioLocalDataSource.${i.memberName} — no debería usarse en este test');
}

// ─── Setup ──────────────────────────────────────────────────────────────────

AssetRepositoryImpl _makeRepo(_FakeAssetActorLinks fake) {
  return AssetRepositoryImpl(
    local: _UnusedLocalDS(),
    remote: _UnusedRemoteDS(),
    enqueueSync: (_) {}, // no-op: este test no ejercita createAssetFromRunt...
    portfolioLocalDS: _UnusedPortfolioDS(),
    assetActorLinks: fake,
  );
}

// ─── Tests ──────────────────────────────────────────────────────────────────

void main() {
  group('AssetRepositoryImpl.enqueueDeclareAssetActorLink — happy path', () {
    test('invoca create() con shape canónico user_declared', () async {
      final fake = _FakeAssetActorLinks();
      final repo = _makeRepo(fake);

      await repo.enqueueDeclareAssetActorLink(
        assetId: 'asset-42',
        orgId: 'org-1',
        assetClass: AssetClass.vehicle,
      );

      expect(fake.createCalls, hasLength(1));
      final c = fake.createCalls.first;
      expect(c.assetId, 'asset-42');
      expect(c.assetTypeId, isNull);
      expect(c.assetClass, AssetClass.vehicle);
      expect(c.role, AssetActorRole.owner);
      expect(c.actorRefKind, ActorRefKindValue.local);
      expect(c.localKind, TargetLocalKind.organization);
      expect(c.localId, 'org-1');
      expect(c.platformActorId, isNull);
    });
  });

  group('AssetRepositoryImpl.enqueueDeclareAssetActorLink — errores no fatales',
      () {
    test('UnauthorizedException (capability faltante): swallow, NO rethrow',
        () async {
      final fake = _FakeAssetActorLinks()
        ..willThrow = const UnauthorizedException('forbidden');
      final repo = _makeRepo(fake);

      // No debe rethrow — el activo ya está en Isar/Firestore.
      await repo.enqueueDeclareAssetActorLink(
        assetId: 'asset-42',
        orgId: 'org-1',
        assetClass: AssetClass.vehicle,
      );

      expect(fake.createCalls, hasLength(1));
    });

    test('BadRequestException ASSET_TYPE_NOT_FOUND: swallow', () async {
      final fake = _FakeAssetActorLinks()
        ..willThrow = const BadRequestException(
          400,
          'AssetType "vehicle" no existe.',
          code: 'ASSET_TYPE_NOT_FOUND',
        );
      final repo = _makeRepo(fake);

      await repo.enqueueDeclareAssetActorLink(
        assetId: 'asset-42',
        orgId: 'org-1',
        assetClass: AssetClass.vehicle,
      );

      expect(fake.createCalls, hasLength(1));
    });

    test('BadRequestException INVALID_ACTOR_REF_SHAPE: swallow', () async {
      final fake = _FakeAssetActorLinks()
        ..willThrow = const BadRequestException(
          400,
          'shape',
          code: 'INVALID_ACTOR_REF_SHAPE',
        );
      final repo = _makeRepo(fake);

      await repo.enqueueDeclareAssetActorLink(
        assetId: 'asset-42',
        orgId: 'org-1',
        assetClass: AssetClass.vehicle,
      );
    });

    test('BadRequestException INVALID_ASSET_TYPE_INPUT: swallow', () async {
      final fake = _FakeAssetActorLinks()
        ..willThrow = const BadRequestException(
          400,
          'xor',
          code: 'INVALID_ASSET_TYPE_INPUT',
        );
      final repo = _makeRepo(fake);

      await repo.enqueueDeclareAssetActorLink(
        assetId: 'asset-42',
        orgId: 'org-1',
        assetClass: AssetClass.vehicle,
      );
    });
  });

  group('AssetRepositoryImpl.enqueueDeclareAssetActorLink — errores reintentables',
      () {
    test('NetworkException: rethrow para que SyncService reintente', () async {
      final fake = _FakeAssetActorLinks()
        ..willThrow = const NetworkException('offline');
      final repo = _makeRepo(fake);

      await expectLater(
        () => repo.enqueueDeclareAssetActorLink(
          assetId: 'asset-42',
          orgId: 'org-1',
          assetClass: AssetClass.vehicle,
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test('ServerException: rethrow para que SyncService reintente', () async {
      final fake = _FakeAssetActorLinks()
        ..willThrow = const ServerException(503, 'gateway');
      final repo = _makeRepo(fake);

      await expectLater(
        () => repo.enqueueDeclareAssetActorLink(
          assetId: 'asset-42',
          orgId: 'org-1',
          assetClass: AssetClass.vehicle,
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
