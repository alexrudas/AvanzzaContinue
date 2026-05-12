// ============================================================================
// test/domain/entities/core_common/value_objects/asset_actor_role_test.dart
// Tests del enum AssetActorRole (incluye nuevo valor `manager` + tryFromWire)
// ============================================================================
// Cubre:
//   - Catálogo cerrado: 8 valores (incluye `manager` v3).
//   - wireName mapping (snake-case stable per ADR §2.9).
//   - fromWire (throws en desconocido) preservado.
//   - tryFromWire (no-throw): null/válido/desconocido.
//   - allWireNames: orden estable de declaración (append-only).
//   - Roundtrip enum → wireName → enum.
//   - manager NO confunde con otros roles cercanos (workshop/operator/owner).
// ============================================================================

import 'package:avanzza/domain/entities/core_common/value_objects/asset_actor_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AssetActorRole — catálogo', () {
    test('8 valores en el orden de declaración (append-only)', () {
      expect(AssetActorRole.values, [
        AssetActorRole.owner,
        AssetActorRole.tenant,
        AssetActorRole.operator,
        AssetActorRole.driver,
        AssetActorRole.technician,
        AssetActorRole.workshop,
        AssetActorRole.legal,
        AssetActorRole.manager,
      ]);
    });

    test('manager está al final (preserva indices estables previos)', () {
      expect(
        AssetActorRole.values.last,
        AssetActorRole.manager,
      );
    });
  });

  group('AssetActorRole — wireName', () {
    test('cada valor tiene su wireName canónico', () {
      expect(AssetActorRole.owner.wireName, 'owner');
      expect(AssetActorRole.tenant.wireName, 'tenant');
      expect(AssetActorRole.operator.wireName, 'operator');
      expect(AssetActorRole.driver.wireName, 'driver');
      expect(AssetActorRole.technician.wireName, 'technician');
      expect(AssetActorRole.workshop.wireName, 'workshop');
      expect(AssetActorRole.legal.wireName, 'legal');
      expect(AssetActorRole.manager.wireName, 'manager');
    });

    test('todos los wireName son únicos', () {
      final wires = AssetActorRole.values.map((r) => r.wireName).toList();
      expect(wires.toSet().length, wires.length);
    });
  });

  group('AssetActorRole.fromWire — estricto (throws en desconocido)', () {
    test('parsea todos los valores válidos', () {
      for (final r in AssetActorRole.values) {
        expect(AssetActorRoleX.fromWire(r.wireName), r);
      }
    });

    test('parsea manager correctamente', () {
      expect(AssetActorRoleX.fromWire('manager'), AssetActorRole.manager);
    });

    test('throws ArgumentError para wire desconocido', () {
      expect(() => AssetActorRoleX.fromWire(''), throwsArgumentError);
      expect(() => AssetActorRoleX.fromWire('admin'), throwsArgumentError);
      expect(
        () => AssetActorRoleX.fromWire('Manager'),
        throwsArgumentError,
        reason: 'case-sensitive: Manager (mayúscula) no es válido',
      );
    });
  });

  group('AssetActorRole.tryFromWire — no-throw', () {
    test('null ⇒ null', () {
      expect(AssetActorRoleX.tryFromWire(null), isNull);
    });

    test('valor válido ⇒ enum', () {
      expect(AssetActorRoleX.tryFromWire('owner'), AssetActorRole.owner);
      expect(AssetActorRoleX.tryFromWire('manager'), AssetActorRole.manager);
      expect(AssetActorRoleX.tryFromWire('legal'), AssetActorRole.legal);
    });

    test('valor desconocido ⇒ null (silencio)', () {
      expect(AssetActorRoleX.tryFromWire(''), isNull);
      expect(AssetActorRoleX.tryFromWire('admin'), isNull);
      expect(AssetActorRoleX.tryFromWire('owner '), isNull); // trailing space
      expect(AssetActorRoleX.tryFromWire('OWNER'), isNull);
      expect(AssetActorRoleX.tryFromWire('future_role_v4'), isNull);
    });

    test('roundtrip enum → wireName → tryFromWire ⇒ misma identidad', () {
      for (final r in AssetActorRole.values) {
        expect(AssetActorRoleX.tryFromWire(r.wireName), r);
      }
    });
  });

  group('AssetActorRole — allWireNames (snapshot)', () {
    test('contiene 8 entradas en orden de declaración', () {
      expect(AssetActorRoleX.allWireNames, [
        'owner',
        'tenant',
        'operator',
        'driver',
        'technician',
        'workshop',
        'legal',
        'manager',
      ]);
    });

    test('coincide con AssetActorRole.values.length', () {
      expect(
        AssetActorRoleX.allWireNames.length,
        AssetActorRole.values.length,
      );
    });
  });

  group('AssetActorRole.manager — semántica distintiva', () {
    test('manager ≠ workshop (taller)', () {
      expect(AssetActorRole.manager, isNot(AssetActorRole.workshop));
      expect(
        AssetActorRoleX.fromWire('manager'),
        isNot(AssetActorRoleX.fromWire('workshop')),
      );
    });

    test('manager ≠ operator (operador)', () {
      expect(AssetActorRole.manager, isNot(AssetActorRole.operator));
    });

    test('manager ≠ owner (propietario)', () {
      expect(AssetActorRole.manager, isNot(AssetActorRole.owner));
    });

    test('manager ≠ tenant (arrendatario)', () {
      expect(AssetActorRole.manager, isNot(AssetActorRole.tenant));
    });
  });
}
