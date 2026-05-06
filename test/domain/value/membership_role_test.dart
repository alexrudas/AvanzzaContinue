// ============================================================================
// test/domain/value/membership_role_test.dart
// MembershipRole tests — catálogo cerrado de permisos internos
// ============================================================================
// QUÉ HACE:
//   - Valida wireName de cada valor del enum.
//   - Valida fromWire (throws) y tryFromWire (no-throw) en valores válidos
//     e inválidos.
//   - Valida isValidWireName para strings dentro y fuera del catálogo.
//   - Valida snapshot allWireNames (catálogo cerrado, orden estable).
//   - Valida roundtrip enum → wireName → enum.
//   - Valida rechazo de strings prohibidos por la regla canónica:
//     'provider', 'owner', 'renter', 'broker', 'legal', 'advisor', 'insurer'
//     no son MembershipRole — pertenecen a CapabilityProfile.kind o
//     AssetActorRole.
//
// QUÉ NO HACE:
//   - No prueba el bypass de isOwner: ese enforcement vive en la capa de
//     policy, no en el catálogo.
//   - No prueba persistencia ni serialización completa de MembershipEntity.
// ============================================================================

import 'package:avanzza/domain/value/membership_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MembershipRole — wireName', () {
    test('cada valor tiene wireName estable', () {
      expect(MembershipRole.admin.wireName, 'admin');
      expect(MembershipRole.salesAgent.wireName, 'sales_agent');
      expect(MembershipRole.purchaseManager.wireName, 'purchase_manager');
      expect(MembershipRole.operator.wireName, 'operator');
      expect(MembershipRole.viewer.wireName, 'viewer');
    });

    test('todos los wireName son únicos', () {
      final wires = MembershipRole.values.map((r) => r.wireName).toList();
      expect(wires.toSet().length, wires.length);
    });
  });

  group('MembershipRole — fromWire (throws en desconocido)', () {
    test('parsea valores válidos del catálogo', () {
      expect(MembershipRoleX.fromWire('admin'), MembershipRole.admin);
      expect(MembershipRoleX.fromWire('sales_agent'), MembershipRole.salesAgent);
      expect(
        MembershipRoleX.fromWire('purchase_manager'),
        MembershipRole.purchaseManager,
      );
      expect(MembershipRoleX.fromWire('operator'), MembershipRole.operator);
      expect(MembershipRoleX.fromWire('viewer'), MembershipRole.viewer);
    });

    test('throws ArgumentError para string vacío', () {
      expect(() => MembershipRoleX.fromWire(''), throwsArgumentError);
    });

    test('throws ArgumentError para valor desconocido', () {
      expect(
        () => MembershipRoleX.fromWire('superuser'),
        throwsArgumentError,
      );
    });

    test('throws para valores prohibidos por la regla canónica', () {
      // Estos pertenecen a CapabilityProfile.kind o AssetActorRole, jamás
      // a Membership.roles. El catálogo debe rechazarlos.
      const prohibidos = [
        'provider',
        'owner',
        'renter',
        'broker',
        'legal',
        'advisor',
        'insurer',
        'tenant',
        'driver',
        'manager',
      ];
      for (final w in prohibidos) {
        expect(
          () => MembershipRoleX.fromWire(w),
          throwsArgumentError,
          reason: '"$w" no debe ser un MembershipRole válido',
        );
      }
    });

    test('case-sensitive: "Admin" no es válido', () {
      expect(() => MembershipRoleX.fromWire('Admin'), throwsArgumentError);
      expect(() => MembershipRoleX.fromWire('ADMIN'), throwsArgumentError);
    });
  });

  group('MembershipRole — tryFromWire (no-throw)', () {
    test('retorna el valor para strings válidos', () {
      expect(MembershipRoleX.tryFromWire('admin'), MembershipRole.admin);
      expect(
        MembershipRoleX.tryFromWire('purchase_manager'),
        MembershipRole.purchaseManager,
      );
    });

    test('retorna null para strings inválidos', () {
      expect(MembershipRoleX.tryFromWire(''), isNull);
      expect(MembershipRoleX.tryFromWire('provider'), isNull);
      expect(MembershipRoleX.tryFromWire('Admin'), isNull);
      expect(MembershipRoleX.tryFromWire('  admin  '), isNull);
    });
  });

  group('MembershipRole — isValidWireName', () {
    test('true para todos los wireName del catálogo', () {
      for (final r in MembershipRole.values) {
        expect(MembershipRoleX.isValidWireName(r.wireName), isTrue);
      }
    });

    test('false para strings fuera del catálogo', () {
      const fuera = ['', 'provider', 'owner', 'admin ', 'Admin', 'super'];
      for (final w in fuera) {
        expect(MembershipRoleX.isValidWireName(w), isFalse, reason: '"$w"');
      }
    });
  });

  group('MembershipRole — allWireNames (snapshot del catálogo)', () {
    test('contiene exactamente 5 entradas en orden de declaración', () {
      expect(MembershipRoleX.allWireNames, [
        'admin',
        'sales_agent',
        'purchase_manager',
        'operator',
        'viewer',
      ]);
    });

    test('coincide con MembershipRole.values', () {
      expect(MembershipRoleX.allWireNames.length, MembershipRole.values.length);
    });
  });

  group('MembershipRole — roundtrip', () {
    test('enum → wireName → enum preserva identidad', () {
      for (final r in MembershipRole.values) {
        expect(MembershipRoleX.fromWire(r.wireName), r);
      }
    });
  });
}
