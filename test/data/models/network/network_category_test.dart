// ============================================================================
// test/data/models/network/network_category_test.dart
// NetworkCategory.fromWire — catálogo cerrado + fallback forward-compat
// ============================================================================

import 'package:avanzza/data/models/network/network_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NetworkCategory.fromWire', () {
    test('parsea cada uno de los 9 valores canónicos', () {
      final cases = {
        'workshop': NetworkCategory.workshop,
        'provider': NetworkCategory.provider,
        'technician': NetworkCategory.technician,
        'owner': NetworkCategory.owner,
        'driver': NetworkCategory.driver,
        'operator': NetworkCategory.operator,
        'tenant': NetworkCategory.tenant,
        'legal': NetworkCategory.legal,
        'unclassified': NetworkCategory.unclassified,
      };
      for (final entry in cases.entries) {
        expect(NetworkCategory.fromWire(entry.key), entry.value,
            reason: 'wire="${entry.key}"');
      }
    });

    test('valor desconocido cae a unclassified (forward-compat)', () {
      expect(
        NetworkCategory.fromWire('insurer_broker_extension'),
        NetworkCategory.unclassified,
      );
      expect(
        NetworkCategory.fromWire('FUTURE_VALUE'),
        NetworkCategory.unclassified,
      );
    });

    test('string vacío cae a unclassified', () {
      expect(NetworkCategory.fromWire(''), NetworkCategory.unclassified);
    });

    test('wireName es estable y reversible', () {
      for (final c in NetworkCategory.values) {
        expect(NetworkCategory.fromWire(c.wireName), c);
      }
    });
  });
}
