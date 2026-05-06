// ============================================================================
// test/domain/entities/purchase/purchase_request_target_entity_test.dart
// PF1 — Auditoría del mapper de PurchaseRequestTarget.
//
// QUÉ HACE:
//   Verifica que `PurchaseRequestTargetEntity.fromJson` parsea los 3
//   campos críticos persistidos por el backend tras los hitos
//   multi-actor (target_workspace + claim lifecycle):
//     - targetWorkspaceId (workspace del proveedor real)
//     - providerProfileId (FK al perfil canónico)
//     - vendorContactId   (compat-column legacy)
//
//   El JSON fixture replica la forma EXACTA que devuelve
//   `GET /v1/purchase-requests/:id` cuando el target nació vía matching
//   canónico (`useProviderMatching=true`).
//
// QUÉ NO HACE:
//   - No prueba round-trips ni Isar persistence (entity es read-only).
//   - No prueba serialización inversa (UI no envía estos campos).
// ============================================================================

import 'package:avanzza/domain/entities/purchase/purchase_request_detail_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PurchaseRequestTargetEntity.fromJson — PF1 multi-actor fields', () {
    test('hidrata targetWorkspaceId, providerProfileId y vendorContactId', () {
      final json = <String, dynamic>{
        'id': 'target-uuid-1',
        'purchaseRequestId': 'pr-uuid-1',
        'actorRefKind': 'platform',
        'platformActorId': 'pa-bob',
        'vendorContactId': 'pa-bob',
        'targetWorkspaceId': 'ws-bob',
        'providerProfileId': 'pp-bob-self',
        'status': 'pending',
        'round': 1,
        'sentAt': '2026-04-27T10:00:00.000Z',
        'respondedAt': null,
      };

      final target = PurchaseRequestTargetEntity.fromJson(json);

      expect(target.id, 'target-uuid-1');
      expect(target.purchaseRequestId, 'pr-uuid-1');
      expect(target.actorRefKind, 'platform');
      expect(target.platformActorId, 'pa-bob');
      expect(target.vendorContactId, 'pa-bob');
      // PF1 — nuevos campos multi-actor.
      expect(target.targetWorkspaceId, 'ws-bob');
      expect(target.providerProfileId, 'pp-bob-self');
      expect(target.status, 'pending');
    });

    test('legacy target sin targetWorkspaceId/providerProfileId → null', () {
      final json = <String, dynamic>{
        'id': 'target-legacy',
        'purchaseRequestId': 'pr-legacy',
        'actorRefKind': 'local',
        'localKind': 'contact',
        'localId': 'lc-1',
        'vendorContactId': 'lc-1',
        'status': 'pending',
        // targetWorkspaceId y providerProfileId ausentes (filas pre-matching).
      };

      final target = PurchaseRequestTargetEntity.fromJson(json);

      expect(target.targetWorkspaceId, isNull);
      expect(target.providerProfileId, isNull);
      expect(target.vendorContactId, 'lc-1');
    });

    test('strings vacíos en targetWorkspaceId/providerProfileId → null', () {
      final json = <String, dynamic>{
        'id': 'target-empty',
        'purchaseRequestId': 'pr-1',
        'actorRefKind': 'local',
        'vendorContactId': 'x',
        'targetWorkspaceId': '',
        'providerProfileId': '',
        'status': 'pending',
      };

      final target = PurchaseRequestTargetEntity.fromJson(json);

      expect(target.targetWorkspaceId, isNull);
      expect(target.providerProfileId, isNull);
    });
  });
}
