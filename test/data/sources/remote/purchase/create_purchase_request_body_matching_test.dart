// ============================================================================
// test/data/sources/remote/purchase/create_purchase_request_body_matching_test.dart
// PF2 — Verifica que CreatePurchaseRequestBody.withMatching produce el
// JSON que el backend (ProviderMatchingService) espera y que NO mezcla
// vendorActorRefs/vendorContactIds (mutua exclusión por contrato del
// Core API).
// ============================================================================

import 'package:avanzza/data/sources/remote/purchase/purchase_api_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreatePurchaseRequestBody.withMatching — PF2 contract', () {
    test('toJson emite useProviderMatching + matchSpecialtyId', () {
      final body = CreatePurchaseRequestBody.withMatching(
        title: 'Cambio de aceite',
        items: const [
          CreatePurchaseRequestItem(
            description: 'Aceite 5W30',
            quantity: 1,
            unit: 'galon',
          ),
        ],
        matchSpecialtyId: 'sp-engine-repair',
      );

      final json = body.toJson();

      expect(json['title'], 'Cambio de aceite');
      expect(json['useProviderMatching'], true);
      expect(json['matchSpecialtyId'], 'sp-engine-repair');
      // matchAssetTypeId omitido cuando es null.
      expect(json.containsKey('matchAssetTypeId'), isFalse);
      // Mutua exclusión: NO debe haber vendorActorRefs ni vendorContactIds.
      expect(json.containsKey('vendorActorRefs'), isFalse);
      expect(json.containsKey('vendorContactIds'), isFalse);
    });

    test('toJson incluye matchAssetTypeId cuando se pasa', () {
      final body = CreatePurchaseRequestBody.withMatching(
        title: 'X',
        items: const [
          CreatePurchaseRequestItem(
            description: 'Y',
            quantity: 1,
            unit: 'und',
          ),
        ],
        matchSpecialtyId: 'sp-1',
        matchAssetTypeId: 'vehicle.car',
      );

      final json = body.toJson();
      expect(json['matchAssetTypeId'], 'vehicle.car');
    });

  });
}
