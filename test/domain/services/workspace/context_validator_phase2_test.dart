// ============================================================================
// test/domain/services/workspace/context_validator_phase2_test.dart
//
// QUÉ HACE:
// - Verifica el comportamiento de ContextValidator tras Fase 2
//   (KILL SWITCH ROL LEGACY).
// - Caso primario: un usuario NUEVO sin `Membership.roles[]` poblado y sin
//   `roleCode` en el WorkspaceContext debe seguir siendo VÁLIDO mientras
//   tenga membership ACTIVE en la misma orgId.
// - Garantiza que el guard rechaza membership inactiva, orgId distinto y
//   tipo `unknown`.
// ============================================================================
import 'package:flutter_test/flutter_test.dart';

import 'package:avanzza/domain/entities/user/membership_entity.dart';
import 'package:avanzza/domain/entities/workspace/workspace_context.dart';
import 'package:avanzza/domain/entities/workspace/workspace_type.dart';
import 'package:avanzza/domain/services/workspace/context_validator.dart';

WorkspaceContext _ctx({
  String orgId = 'org_demo',
  String orgName = 'Org Demo',
  String roleCode = '',
  String membershipId = 'user_demo_org_demo',
  WorkspaceType type = WorkspaceType.assetAdmin,
}) =>
    WorkspaceContext(
      workspaceId: 'ws_org_demo_user_demo_org_demo_${type.wireName}_no_role',
      membershipId: membershipId,
      orgId: orgId,
      orgName: orgName,
      type: type,
      roleCode: roleCode,
      source: WorkspaceContextSource.resolvedFromMembership,
    );

MembershipEntity _membership({
  String orgId = 'org_demo',
  String estatus = 'activo',
  List<String> roles = const <String>[],
}) =>
    MembershipEntity(
      userId: 'user_demo',
      orgId: orgId,
      orgName: 'Org Demo',
      roles: roles,
      estatus: estatus,
      primaryLocation: const {'countryId': 'CO'},
    );

void main() {
  group('ContextValidator — Fase 2 (sin roles)', () {
    test('contexto SIN roleCode pero CON membership ACTIVE en la org → válido',
        () {
      final ctx = _ctx(roleCode: '');
      final memberships = [_membership(roles: const <String>[])];

      final result = ContextValidator.validate(
        context: ctx,
        memberships: memberships,
      );

      expect(result.isValid, isTrue,
          reason:
              'Fase 2: roleCode vacío + roles[] vacío deben ser válidos.');
      expect(result.reasonCode, 'valid');
    });

    test(
        'membership en otra org → invalida con reasonCode no_active_membership_for_org',
        () {
      final ctx = _ctx(orgId: 'org_demo');
      final memberships = [_membership(orgId: 'org_otra')];

      final result = ContextValidator.validate(
        context: ctx,
        memberships: memberships,
      );

      expect(result.isValid, isFalse);
      expect(result.reasonCode, 'no_active_membership_for_org');
    });

    test('membership inactiva → invalida', () {
      final ctx = _ctx();
      final memberships = [_membership(estatus: 'inactivo')];

      final result = ContextValidator.validate(
        context: ctx,
        memberships: memberships,
      );

      expect(result.isValid, isFalse);
      expect(result.reasonCode, 'no_active_membership_for_org');
    });

    test('memberships vacío → invalida con no_memberships', () {
      final ctx = _ctx();
      final result = ContextValidator.validate(
        context: ctx,
        memberships: const [],
      );

      expect(result.isValid, isFalse);
      expect(result.reasonCode, 'no_memberships');
    });

    test('WorkspaceType.unknown → invalida estructuralmente', () {
      final ctx = _ctx(type: WorkspaceType.unknown);
      final memberships = [_membership()];

      final result = ContextValidator.validate(
        context: ctx,
        memberships: memberships,
      );

      expect(result.isValid, isFalse);
      expect(result.reasonCode, 'workspace_type_unknown');
    });
  });
}
