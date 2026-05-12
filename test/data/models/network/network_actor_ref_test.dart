// ============================================================================
// test/data/models/network/network_actor_ref_test.dart
// NetworkActorRef.parse — formato canónico de `ref` en Mi Red Operativa v1
// ============================================================================

import 'package:avanzza/data/models/network/network_actor_ref.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NetworkActorRef.parse — kind=platform', () {
    test('platform:<uuid> parsea y mantiene id', () {
      final ref = NetworkActorRef.parse('platform:abc-123-def');
      expect(ref.kind, NetworkActorRefKind.platform);
      expect(ref.id, 'abc-123-def');
      expect(ref.localSubKind, isNull);
      expect(ref.isPlatform, isTrue);
      expect(ref.raw, 'platform:abc-123-def');
    });

    test('rechaza platform sin id', () {
      expect(
        () => NetworkActorRef.parse('platform:'),
        throwsFormatException,
      );
    });

    test('rechaza platform con segmentos extra', () {
      expect(
        () => NetworkActorRef.parse('platform:org:123'),
        throwsFormatException,
      );
    });
  });

  group('NetworkActorRef.parse — kind=local', () {
    test('local:contact:<id> parsea con subKind=contact', () {
      final ref = NetworkActorRef.parse('local:contact:lc-99');
      expect(ref.kind, NetworkActorRefKind.local);
      expect(ref.localSubKind, NetworkLocalRefKind.contact);
      expect(ref.id, 'lc-99');
      expect(ref.isLocal, isTrue);
    });

    test('local:organization:<id> parsea con subKind=organization', () {
      final ref = NetworkActorRef.parse('local:organization:lo-01');
      expect(ref.kind, NetworkActorRefKind.local);
      expect(ref.localSubKind, NetworkLocalRefKind.organization);
      expect(ref.id, 'lo-01');
    });

    test('rechaza local con subKind desconocido', () {
      expect(
        () => NetworkActorRef.parse('local:xxx:id-1'),
        throwsFormatException,
      );
    });

    test('rechaza local con 2 segmentos (faltó subKind)', () {
      expect(
        () => NetworkActorRef.parse('local:lc-99'),
        throwsFormatException,
      );
    });

    test('rechaza local con id vacío', () {
      expect(
        () => NetworkActorRef.parse('local:contact:'),
        throwsFormatException,
      );
    });
  });

  group('NetworkActorRef.parse — kind=user', () {
    test('user:<userId> parsea', () {
      final ref = NetworkActorRef.parse('user:u-77');
      expect(ref.kind, NetworkActorRefKind.user);
      expect(ref.id, 'u-77');
      expect(ref.localSubKind, isNull);
      expect(ref.isUser, isTrue);
    });

    test('rechaza user sin id', () {
      expect(
        () => NetworkActorRef.parse('user:'),
        throwsFormatException,
      );
    });

    test('rechaza user con segmentos extra', () {
      expect(
        () => NetworkActorRef.parse('user:org:123'),
        throwsFormatException,
      );
    });
  });

  group('NetworkActorRef.parse — errores generales', () {
    test('rechaza string vacío', () {
      expect(() => NetworkActorRef.parse(''), throwsFormatException);
    });

    test('rechaza string sin separador', () {
      expect(() => NetworkActorRef.parse('platform'), throwsFormatException);
    });

    test('rechaza kind desconocido', () {
      expect(
        () => NetworkActorRef.parse('alien:xxx'),
        throwsFormatException,
      );
    });
  });

  group('NetworkActorRef.tryParse', () {
    test('retorna null en lugar de lanzar', () {
      expect(NetworkActorRef.tryParse(''), isNull);
      expect(NetworkActorRef.tryParse('garbage'), isNull);
      expect(NetworkActorRef.tryParse('local:invalid:'), isNull);
    });

    test('retorna instancia cuando es válido', () {
      expect(NetworkActorRef.tryParse('user:u-1'), isNotNull);
    });
  });

  group('NetworkActorRef equality', () {
    test('dos refs con mismo raw son iguales', () {
      final a = NetworkActorRef.parse('platform:p-1');
      final b = NetworkActorRef.parse('platform:p-1');
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('refs con raw distinto no son iguales', () {
      final a = NetworkActorRef.parse('platform:p-1');
      final b = NetworkActorRef.parse('platform:p-2');
      expect(a, isNot(equals(b)));
    });
  });
}
