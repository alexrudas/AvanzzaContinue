// ============================================================================
// test/presentation/controllers/org_selection_controller_role_resolution_test.dart
// Tests del helper resolveActiveRoleWireName extraído de
// OrgSelectionController.selectOrg (ítem 7).
// ============================================================================
// Verifica que la lógica que canaliza Membership.roles → ActiveContext.rol
// pase por MembershipPolicy y NO consuma el campo legacy directo. Casos:
//   - membership=null ⇒ fallback admin.
//   - membership con roles vacíos ⇒ fallback admin.
//   - membership con admin lowercase ⇒ admin.
//   - membership con 'ADMIN' (case mixto) ⇒ admin (normalizado).
//   - membership con '  Admin  ' (whitespace) ⇒ admin.
//   - membership con roles desconocidos ⇒ fallback admin.
//   - membership con sales_agent ⇒ sales_agent.
//   - membership con [unknown, viewer] ⇒ viewer (descarta el unknown,
//     toma el primero válido).
// ============================================================================

import 'package:avanzza/domain/entities/user/membership_entity.dart';
import 'package:avanzza/presentation/controllers/org_selection_controller.dart';
import 'package:flutter_test/flutter_test.dart';

MembershipEntity _membership({
  List<String> roles = const [],
  bool? isOwner,
}) {
  return MembershipEntity(
    userId: 'u',
    orgId: 'o',
    orgName: 'O',
    roles: roles,
    estatus: 'activo',
    primaryLocation: const {'countryId': 'CO'},
    isOwner: isOwner,
  );
}

void main() {
  group('resolveActiveRoleWireName', () {
    test('membership=null ⇒ fallback admin', () {
      expect(resolveActiveRoleWireName(null), 'admin');
    });

    test('membership con roles=[] ⇒ fallback admin', () {
      expect(resolveActiveRoleWireName(_membership()), 'admin');
    });

    test('roles=[admin] ⇒ admin', () {
      expect(
        resolveActiveRoleWireName(_membership(roles: const ['admin'])),
        'admin',
      );
    });

    test('roles=[ADMIN] (case mixto) ⇒ admin (normalizado)', () {
      expect(
        resolveActiveRoleWireName(_membership(roles: const ['ADMIN'])),
        'admin',
      );
    });

    test('roles=[Admin] (capitalizado) ⇒ admin', () {
      expect(
        resolveActiveRoleWireName(_membership(roles: const ['Admin'])),
        'admin',
      );
    });

    test('roles=["  admin  "] (whitespace) ⇒ admin', () {
      expect(
        resolveActiveRoleWireName(_membership(roles: const ['  admin  '])),
        'admin',
      );
    });

    test('roles=[sales_agent] ⇒ sales_agent', () {
      expect(
        resolveActiveRoleWireName(_membership(roles: const ['sales_agent'])),
        'sales_agent',
      );
    });

    test('roles=[SALES_AGENT] ⇒ sales_agent (normalizado)', () {
      expect(
        resolveActiveRoleWireName(_membership(roles: const ['SALES_AGENT'])),
        'sales_agent',
      );
    });

    test('roles desconocidos solamente ⇒ fallback admin', () {
      expect(
        resolveActiveRoleWireName(_membership(
          roles: const ['unknown_role', 'super_admin'],
        )),
        'admin',
      );
    });

    test('roles=[unknown, viewer] ⇒ viewer (toma el primer válido)', () {
      expect(
        resolveActiveRoleWireName(_membership(
          roles: const ['unknown_role', 'viewer'],
        )),
        'viewer',
      );
    });

    test('roles=[admin, sales_agent] ⇒ admin (primer válido)', () {
      expect(
        resolveActiveRoleWireName(_membership(
          roles: const ['admin', 'sales_agent'],
        )),
        'admin',
      );
    });

    test('roles desconocidos + isOwner=true ⇒ fallback admin', () {
      // Aunque sea founder, este helper devuelve solo el wireName del rol
      // del activeContext. El bypass de fundador vive en MembershipPolicy
      // y se evalúa en otra capa.
      expect(
        resolveActiveRoleWireName(_membership(
          roles: const ['unknown_role'],
          isOwner: true,
        )),
        'admin',
      );
    });

    test('roles=[viewer] + isOwner=true ⇒ viewer (helper NO mezcla policy)',
        () {
      // El helper produce el "rol del contexto activo" para UI, no la
      // decisión de permisos. isOwner es independiente.
      expect(
        resolveActiveRoleWireName(_membership(
          roles: const ['viewer'],
          isOwner: true,
        )),
        'viewer',
      );
    });

    test('strings vacíos en roles ⇒ se descartan, fallback admin', () {
      expect(
        resolveActiveRoleWireName(_membership(roles: const ['', '   '])),
        'admin',
      );
    });

    test('duplicados con case distinto ⇒ deduplicados, primer válido', () {
      // ['Admin', 'ADMIN', 'admin'] todos normalizan a admin → uno solo.
      expect(
        resolveActiveRoleWireName(_membership(
          roles: const ['Admin', 'ADMIN', 'admin'],
        )),
        'admin',
      );
    });
  });
}
