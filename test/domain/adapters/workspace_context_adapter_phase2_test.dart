// ============================================================================
// test/domain/adapters/workspace_context_adapter_phase2_test.dart
//
// QUÉ HACE:
// - Verifica que `WorkspaceContextAdapter.fromMemberships` ya NO depende de
//   `m.roles[]` para producir contextos. Cada membership ACTIVE produce un
//   único contexto canónico de tipo `assetAdmin`.
// - Cubre el caso "usuario nuevo" tras Fase 2: un Membership con roles=[]
//   sigue produciendo un WorkspaceContext utilizable.
// ============================================================================
import 'package:flutter_test/flutter_test.dart';

import 'package:avanzza/domain/adapters/workspace_context_adapter.dart';
import 'package:avanzza/domain/entities/user/membership_entity.dart';
import 'package:avanzza/domain/entities/workspace/workspace_type.dart';

MembershipEntity _membership({
  String userId = 'user_demo',
  String orgId = 'org_demo',
  String estatus = 'activo',
  List<String> roles = const <String>[],
}) =>
    MembershipEntity(
      userId: userId,
      orgId: orgId,
      orgName: 'Org Demo',
      roles: roles,
      estatus: estatus,
      primaryLocation: const {'countryId': 'CO'},
    );

void main() {
  group('WorkspaceContextAdapter.fromMemberships — Fase 2', () {
    test('membership con roles=[] produce un contexto assetAdmin', () {
      final memberships = [_membership(roles: const <String>[])];

      final contexts = WorkspaceContextAdapter.fromMemberships(
        memberships: memberships,
      );

      expect(contexts.length, 1);
      expect(contexts.first.type, WorkspaceType.assetAdmin);
      expect(contexts.first.orgId, 'org_demo');
      expect(contexts.first.roleCode, '');
    });

    test('múltiples memberships activas producen N contextos (1 por org)', () {
      final memberships = [
        _membership(orgId: 'org_a'),
        _membership(orgId: 'org_b'),
      ];

      final contexts = WorkspaceContextAdapter.fromMemberships(
        memberships: memberships,
      );

      expect(contexts.length, 2);
      expect(contexts.map((c) => c.orgId).toSet(), {'org_a', 'org_b'});
      expect(
        contexts.every((c) => c.type == WorkspaceType.assetAdmin),
        isTrue,
        reason:
            'Fase 2: todos los contextos son assetAdmin por default; el shell '
            'de proveedor se decide aparte vía ProviderContextStore.',
      );
    });

    test('membership inactiva NO produce contexto', () {
      final memberships = [
        _membership(orgId: 'org_a', estatus: 'inactivo'),
      ];

      final contexts = WorkspaceContextAdapter.fromMemberships(
        memberships: memberships,
      );

      expect(contexts, isEmpty);
    });

    test(
        'roles legacy poblados (escenario migración) NO crean múltiples contextos',
        () {
      // Si un user legacy tenía m.roles=['admin','proveedor'], antes producía
      // 2 contextos. Tras Fase 2 produce 1 (assetAdmin) — el shell de
      // proveedor se decide aparte.
      final memberships = [
        _membership(roles: const ['admin_activos_ind', 'proveedor']),
      ];

      final contexts = WorkspaceContextAdapter.fromMemberships(
        memberships: memberships,
      );

      expect(contexts.length, 1);
      expect(contexts.first.type, WorkspaceType.assetAdmin);
    });
  });
}
