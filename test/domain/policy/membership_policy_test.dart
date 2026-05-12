// ============================================================================
// test/domain/policy/membership_policy_test.dart
// Tests del facade canónico MembershipPolicy.
// ============================================================================
// Verifica:
//   - isFounder respeta isOwner=true/false/null sin importar roles.
//   - hasRole normaliza case-insensitive (admin/Admin/ADMIN).
//   - hasRole NO consulta isOwner (es lookup puro de roles).
//   - hasAdminAccess: founder ⇒ true aún con roles=[] (BYPASS DE FUNDADOR).
//   - hasAdminAccess: no-founder con admin ⇒ true.
//   - hasAdminAccess: no-founder sin admin ⇒ false.
//   - hasAdminAccess: respeta normalización legacy (rol legacy 'ADMIN' ⇒ admin).
//   - parsedRoles: dedup + tipado + sin telemetría (hot path).
// ============================================================================

import 'package:avanzza/domain/entities/user/membership_entity.dart';
import 'package:avanzza/domain/policy/membership_policy.dart';
import 'package:avanzza/domain/value/membership_role.dart';
import 'package:avanzza/domain/value/membership_scope.dart';
import 'package:flutter_test/flutter_test.dart';

MembershipEntity _membership({
  List<String> roles = const [],
  bool? isOwner,
  MembershipScope? scope,
}) {
  return MembershipEntity(
    userId: 'uid-1',
    orgId: 'org-1',
    orgName: 'Acme',
    roles: roles,
    estatus: 'activo',
    primaryLocation: const {'countryId': 'CO'},
    isOwner: isOwner,
    scope: scope ?? const MembershipScope(),
  );
}

void main() {
  group('MembershipPolicy.isFounder', () {
    test('isOwner=true ⇒ true', () {
      expect(MembershipPolicy.isFounder(_membership(isOwner: true)), isTrue);
    });

    test('isOwner=false ⇒ false', () {
      expect(
          MembershipPolicy.isFounder(_membership(isOwner: false)), isFalse);
    });

    test('isOwner=null ⇒ false (default conservador)', () {
      expect(MembershipPolicy.isFounder(_membership()), isFalse);
    });

    test('isOwner=true ignora roles (independencia)', () {
      // Founder sin roles ni 'admin' explícito — sigue siendo founder.
      expect(
        MembershipPolicy.isFounder(_membership(roles: const [], isOwner: true)),
        isTrue,
      );
      // Founder con roles desconocidos — sigue siendo founder.
      expect(
        MembershipPolicy.isFounder(
          _membership(roles: const ['unknown_role'], isOwner: true),
        ),
        isTrue,
      );
    });
  });

  group('MembershipPolicy.hasRole — case-insensitive', () {
    test('rol exacto ⇒ true', () {
      expect(
        MembershipPolicy.hasRole(
          _membership(roles: const ['admin']),
          MembershipRole.admin,
        ),
        isTrue,
      );
    });

    test('case mixto ⇒ true (Admin/ADMIN/  admin  )', () {
      for (final raw in const ['Admin', 'ADMIN', '  admin  ', 'aDmIn']) {
        expect(
          MembershipPolicy.hasRole(
            _membership(roles: [raw]),
            MembershipRole.admin,
          ),
          isTrue,
          reason: '"$raw" debe matchear MembershipRole.admin',
        );
      }
    });

    test('roles con underscore (sales_agent / SALES_AGENT)', () {
      expect(
        MembershipPolicy.hasRole(
          _membership(roles: const ['SALES_AGENT']),
          MembershipRole.salesAgent,
        ),
        isTrue,
      );
    });

    test('rol no presente ⇒ false', () {
      expect(
        MembershipPolicy.hasRole(
          _membership(roles: const ['admin']),
          MembershipRole.viewer,
        ),
        isFalse,
      );
    });

    test('roles vacíos ⇒ false sin lanzar', () {
      expect(
        MembershipPolicy.hasRole(
          _membership(roles: const []),
          MembershipRole.admin,
        ),
        isFalse,
      );
    });

    test('roles desconocidos ⇒ false (no crash)', () {
      expect(
        MembershipPolicy.hasRole(
          _membership(roles: const ['unknown_role', 'super_admin']),
          MembershipRole.admin,
        ),
        isFalse,
      );
    });

    test('hasRole NO consulta isOwner (independencia explícita)', () {
      // Founder SIN admin en roles ⇒ hasRole(admin) sigue siendo false.
      // hasAdminAccess es el que combina founder + admin.
      expect(
        MembershipPolicy.hasRole(
          _membership(roles: const [], isOwner: true),
          MembershipRole.admin,
        ),
        isFalse,
      );
    });
  });

  group('MembershipPolicy.hasAdminAccess — BYPASS DE FUNDADOR', () {
    test('founder con roles=[] ⇒ true (seguro de vida)', () {
      expect(
        MembershipPolicy.hasAdminAccess(
          _membership(roles: const [], isOwner: true),
        ),
        isTrue,
      );
    });

    test('founder con roles desconocidos ⇒ true (bypass)', () {
      expect(
        MembershipPolicy.hasAdminAccess(
          _membership(
            roles: const ['unknown_legacy_role'],
            isOwner: true,
          ),
        ),
        isTrue,
      );
    });

    test('founder con roles=[admin] ⇒ true', () {
      expect(
        MembershipPolicy.hasAdminAccess(
          _membership(roles: const ['admin'], isOwner: true),
        ),
        isTrue,
      );
    });

    test('no-founder con roles=[admin] ⇒ true', () {
      expect(
        MembershipPolicy.hasAdminAccess(
          _membership(roles: const ['admin'], isOwner: false),
        ),
        isTrue,
      );
    });

    test('no-founder con roles=[ADMIN] (case mixto) ⇒ true', () {
      expect(
        MembershipPolicy.hasAdminAccess(
          _membership(roles: const ['ADMIN'], isOwner: false),
        ),
        isTrue,
      );
    });

    test('no-founder con roles=[] ⇒ false', () {
      expect(
        MembershipPolicy.hasAdminAccess(
          _membership(roles: const [], isOwner: false),
        ),
        isFalse,
      );
    });

    test('no-founder con roles=[viewer] ⇒ false', () {
      expect(
        MembershipPolicy.hasAdminAccess(
          _membership(roles: const ['viewer'], isOwner: false),
        ),
        isFalse,
      );
    });

    test('no-founder con isOwner=null y sin admin ⇒ false', () {
      expect(
        MembershipPolicy.hasAdminAccess(
          _membership(roles: const ['viewer']),
        ),
        isFalse,
      );
    });

    test('admin legacy almacenado como "  Admin  " (whitespace) ⇒ true', () {
      // Caso de drift legacy: la regla del usuario es que admin no debe
      // perder permisos por inconsistencias de formato.
      expect(
        MembershipPolicy.hasAdminAccess(
          _membership(roles: const ['  Admin  '], isOwner: false),
        ),
        isTrue,
      );
    });
  });

  group('MembershipPolicy.parsedRoles', () {
    test('lista vacía ⇒ []', () {
      expect(MembershipPolicy.parsedRoles(_membership()), isEmpty);
    });

    test('roles válidos ⇒ enums tipados en orden', () {
      expect(
        MembershipPolicy.parsedRoles(
          _membership(roles: const ['admin', 'sales_agent']),
        ),
        [MembershipRole.admin, MembershipRole.salesAgent],
      );
    });

    test('case mixto ⇒ normalizado al enum', () {
      expect(
        MembershipPolicy.parsedRoles(
          _membership(roles: const ['ADMIN', 'Sales_Agent']),
        ),
        [MembershipRole.admin, MembershipRole.salesAgent],
      );
    });

    test('duplicados post-normalización ⇒ deduplicados', () {
      expect(
        MembershipPolicy.parsedRoles(
          _membership(roles: const ['admin', 'ADMIN', '  Admin  ']),
        ),
        [MembershipRole.admin],
      );
    });

    test('strings desconocidos ⇒ silenciosamente descartados', () {
      expect(
        MembershipPolicy.parsedRoles(
          _membership(roles: const ['admin', 'unknown', 'viewer']),
        ),
        [MembershipRole.admin, MembershipRole.viewer],
      );
    });

    test('strings vacíos ⇒ silenciosamente descartados', () {
      expect(
        MembershipPolicy.parsedRoles(
          _membership(roles: const ['admin', '', '  ']),
        ),
        [MembershipRole.admin],
      );
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // Invariante isOwner vs MembershipScope (regla canónica)
  // ──────────────────────────────────────────────────────────────────────
  // CompleteOnboardingUC persiste fundadores con AMBOS:
  //   - isOwner=true (bypass canónico)
  //   - scope=MembershipScope.global() (alcance asset-access)
  //
  // Estos campos son CONCEPTOS DISTINTOS. La policy debe consultar
  // isOwner como bypass principal — NUNCA inferir founder desde scope.
  // Cualquier futuro `canAccessAsset(m, assetId)` debe respetar el orden:
  //   1. if (isFounder(m)) return true;
  //   2. return m.scope.canAccessAsset(...);
  //
  // Estos tests fijan el contrato como invariante: si un fundador pierde
  // su scope por bug/migración, isOwner sigue rescatando acceso.
  group('Invariante isOwner-vs-scope (regla canónica)', () {
    test('founder con scope=restricted SIN assets ⇒ hasAdminAccess=true '
        '(bypass de isOwner sobre scope vacío)', () {
      // Caso de drift: founder cuyo scope quedó restricted vacío por bug.
      // isOwner=true debe rescatarlo. Si la policy mirase solo scope,
      // el creador del workspace quedaría bloqueado silenciosamente.
      final m = _membership(
        roles: const [],
        isOwner: true,
        scope: MembershipScope.restricted(), // sin asset assignments
      );
      expect(MembershipPolicy.hasAdminAccess(m), isTrue);
    });

    test('founder con scope=none ⇒ hasAdminAccess=true (bypass total)', () {
      // Caso extremo: scope explícitamente "none". isOwner sigue rescatando.
      final m = _membership(
        roles: const [],
        isOwner: true,
        scope: MembershipScope.none(),
      );
      expect(MembershipPolicy.hasAdminAccess(m), isTrue);
    });

    test('no-founder con scope=global ⇒ hasAdminAccess=false sin rol admin',
        () {
      // scope.global NO es bypass de admin: sin rol admin y sin isOwner,
      // hasAdminAccess es false. scope solo afecta asset-access (futuro
      // canAccessAsset), NO bypass de policy general.
      final m = _membership(
        roles: const ['viewer'],
        isOwner: false,
        scope: MembershipScope.global(),
      );
      expect(MembershipPolicy.hasAdminAccess(m), isFalse);
    });

    test('isFounder consulta SOLO isOwner — scope no influye', () {
      // Founder con scope cualquiera (none/restricted/global) sigue siendo
      // founder. isFounder NO mira scope.
      for (final scope in [
        MembershipScope.global(),
        MembershipScope.none(),
        MembershipScope.restricted(),
      ]) {
        final m = _membership(isOwner: true, scope: scope);
        expect(
          MembershipPolicy.isFounder(m),
          isTrue,
          reason: 'isFounder debe ignorar scope (${scope.type})',
        );
      }
    });

    test('no-founder con isOwner=false NO se rescata por scope.global', () {
      // Confirma que scope.global NO se confunde con bypass de fundador.
      final m = _membership(
        roles: const [],
        isOwner: false,
        scope: MembershipScope.global(),
      );
      expect(MembershipPolicy.isFounder(m), isFalse);
      expect(MembershipPolicy.hasAdminAccess(m), isFalse);
    });
  });

  group('MembershipPolicy — independencia respecto al catálogo', () {
    test('roles legacy con valores NO de MembershipRole no afectan policy',
        () {
      // owner es AssetActorRole, NO MembershipRole.
      final m = _membership(
        roles: const ['owner', 'manager', 'tenant'],
        isOwner: false,
      );
      expect(MembershipPolicy.hasAdminAccess(m), isFalse);
      expect(MembershipPolicy.parsedRoles(m), isEmpty);
    });

    test('isOwner=true rescata acceso aunque roles sean basura', () {
      final m = _membership(
        roles: const ['owner', 'manager', 'tenant'], // todos AssetActorRole
        isOwner: true,
      );
      // Pese a que ningún string es MembershipRole válido, el founder
      // bypass garantiza acceso.
      expect(MembershipPolicy.hasAdminAccess(m), isTrue);
    });
  });
}
