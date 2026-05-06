// ============================================================================
// test/data/adapters/membership/legacy_membership_role_parser_test.dart
// Tests del LegacyMembershipRoleParser.
// ============================================================================
// Cubre:
//   - Normalización case-insensitive: 'admin'/'Admin'/'ADMIN'/'  admin  '
//     todos producen MembershipRole.admin.
//   - Variantes con underscore (sales_agent / SALES_AGENT / Sales_Agent).
//   - tryParseLegacy: null/empty/desconocido ⇒ null sin warning.
//   - parseLegacyList: lista vacía ⇒ resultado vacío sin warnings (válido
//     por contrato Fase 2 kill-switch).
//   - parseLegacyList: items vacíos ⇒ drop + warning blankLegacyRole.
//   - parseLegacyList: items desconocidos ⇒ drop + warning unknownLegacyRole.
//   - parseLegacyList: duplicados post-normalización ⇒ deduplicados.
//   - Telemetría recordRolesWarning emitida solo cuando hay warnings.
//   - Lista limpia ⇒ NO emite telemetría.
//   - Admin legacy NO pierde permisos por case/whitespace.
// ============================================================================

import 'package:avanzza/core/telemetry/legacy_membership_migration_telemetry.dart';
import 'package:avanzza/data/adapters/capability/legacy_migration_warning.dart';
import 'package:avanzza/data/adapters/membership/legacy_membership_role_parser.dart';
import 'package:avanzza/domain/value/membership_role.dart';
import 'package:flutter_test/flutter_test.dart';

class _Recorder {
  final List<({String event, Map<String, dynamic> props})> events = [];
  void call(String event, Map<String, dynamic> props) {
    events.add((event: event, props: Map<String, dynamic>.from(props)));
  }
}

void main() {
  late _Recorder rec;

  setUp(() {
    rec = _Recorder();
    LegacyMembershipMigrationTelemetry.debugSetEmitter(rec.call);
  });

  tearDown(() {
    LegacyMembershipMigrationTelemetry.resetEmitter();
  });

  group('tryParseLegacy — normalización case-insensitive', () {
    test('admin lowercase ⇒ MembershipRole.admin', () {
      expect(
        LegacyMembershipRoleParser.tryParseLegacy('admin'),
        MembershipRole.admin,
      );
    });

    test('Admin (capitalize) ⇒ MembershipRole.admin', () {
      expect(
        LegacyMembershipRoleParser.tryParseLegacy('Admin'),
        MembershipRole.admin,
      );
    });

    test('ADMIN (uppercase) ⇒ MembershipRole.admin', () {
      expect(
        LegacyMembershipRoleParser.tryParseLegacy('ADMIN'),
        MembershipRole.admin,
      );
    });

    test('  admin   (whitespace) ⇒ MembershipRole.admin', () {
      expect(
        LegacyMembershipRoleParser.tryParseLegacy('  admin   '),
        MembershipRole.admin,
      );
    });

    test('mixed case con underscore: Sales_Agent ⇒ MembershipRole.salesAgent',
        () {
      expect(
        LegacyMembershipRoleParser.tryParseLegacy('Sales_Agent'),
        MembershipRole.salesAgent,
      );
    });

    test('SALES_AGENT (uppercase) ⇒ MembershipRole.salesAgent', () {
      expect(
        LegacyMembershipRoleParser.tryParseLegacy('SALES_AGENT'),
        MembershipRole.salesAgent,
      );
    });

    test('PURCHASE_MANAGER ⇒ MembershipRole.purchaseManager', () {
      expect(
        LegacyMembershipRoleParser.tryParseLegacy('PURCHASE_MANAGER'),
        MembershipRole.purchaseManager,
      );
    });

    test('todos los wireName del catálogo se reconocen tras normalizar', () {
      for (final r in MembershipRole.values) {
        expect(
          LegacyMembershipRoleParser.tryParseLegacy(r.wireName.toUpperCase()),
          r,
          reason: '${r.wireName.toUpperCase()} debe normalizarse a $r',
        );
      }
    });
  });

  group('tryParseLegacy — casos null / vacíos / desconocidos', () {
    test('null ⇒ null', () {
      expect(LegacyMembershipRoleParser.tryParseLegacy(null), isNull);
    });

    test('string vacío ⇒ null', () {
      expect(LegacyMembershipRoleParser.tryParseLegacy(''), isNull);
    });

    test('whitespace solo ⇒ null', () {
      expect(LegacyMembershipRoleParser.tryParseLegacy('   '), isNull);
      expect(LegacyMembershipRoleParser.tryParseLegacy('\t\n'), isNull);
    });

    test('rol desconocido ⇒ null sin lanzar', () {
      expect(
        LegacyMembershipRoleParser.tryParseLegacy('super_admin'),
        isNull,
      );
      expect(
        LegacyMembershipRoleParser.tryParseLegacy('manager'),
        isNull,
      );
      expect(
        LegacyMembershipRoleParser.tryParseLegacy('owner'),
        isNull,
        reason: 'owner es AssetActorRole, NO MembershipRole',
      );
    });

    test('tryParseLegacy NO emite telemetría (es solo lookup)', () {
      LegacyMembershipRoleParser.tryParseLegacy('unknown');
      LegacyMembershipRoleParser.tryParseLegacy('');
      expect(rec.events, isEmpty);
    });
  });

  group('parseLegacyList — lista vacía y casos felices', () {
    test('lista vacía ⇒ resultado vacío sin warnings (Fase 2 kill-switch)',
        () {
      final r = LegacyMembershipRoleParser.parseLegacyList(const []);
      expect(r.roles, isEmpty);
      expect(r.warnings, isEmpty);
      expect(rec.events, isEmpty);
    });

    test('1 rol válido ⇒ 1 enum, sin warnings, sin telemetría', () {
      final r = LegacyMembershipRoleParser.parseLegacyList(['admin']);
      expect(r.roles, [MembershipRole.admin]);
      expect(r.warnings, isEmpty);
      expect(rec.events, isEmpty);
    });

    test('múltiples roles válidos ⇒ orden preservado', () {
      final r = LegacyMembershipRoleParser.parseLegacyList([
        'admin',
        'sales_agent',
        'viewer',
      ]);
      expect(r.roles, [
        MembershipRole.admin,
        MembershipRole.salesAgent,
        MembershipRole.viewer,
      ]);
      expect(r.warnings, isEmpty);
    });

    test('mismo rol con distinto case ⇒ dedup silencioso', () {
      final r = LegacyMembershipRoleParser.parseLegacyList([
        'admin',
        'ADMIN',
        '  Admin  ',
      ]);
      expect(r.roles, [MembershipRole.admin]);
      expect(r.warnings, isEmpty);
    });
  });

  group('parseLegacyList — items malformados (warnings)', () {
    test('item vacío ⇒ drop + warning blankLegacyRole', () {
      final r = LegacyMembershipRoleParser.parseLegacyList([
        'admin',
        '',
        'viewer',
      ]);
      expect(r.roles, [MembershipRole.admin, MembershipRole.viewer]);
      expect(r.warnings.length, 1);
      expect(r.warnings.first.kind,
          LegacyMigrationWarningKind.blankLegacyRole);
      expect(r.warnings.first.fieldPath, 'membership.roles[1]');
    });

    test('item whitespace-only ⇒ drop + warning blankLegacyRole', () {
      final r =
          LegacyMembershipRoleParser.parseLegacyList(['admin', '   ', 'viewer']);
      expect(r.roles, [MembershipRole.admin, MembershipRole.viewer]);
      expect(r.warnings.length, 1);
      expect(r.warnings.first.kind,
          LegacyMigrationWarningKind.blankLegacyRole);
    });

    test('item desconocido ⇒ drop + warning unknownLegacyRole', () {
      final r = LegacyMembershipRoleParser.parseLegacyList([
        'admin',
        'super_admin',
        'viewer',
      ]);
      expect(r.roles, [MembershipRole.admin, MembershipRole.viewer]);
      expect(r.warnings.length, 1);
      expect(r.warnings.first.kind,
          LegacyMigrationWarningKind.unknownLegacyRole);
      expect(r.warnings.first.rawValue, 'super_admin');
    });

    test('mezcla blank + unknown + válidos ⇒ warnings por cada item descartado',
        () {
      final r = LegacyMembershipRoleParser.parseLegacyList([
        'admin',
        '',
        'super_admin',
        'sales_agent',
        '   ',
        'OWNER', // owner es AssetActorRole, NO MembershipRole
      ]);
      expect(r.roles, [MembershipRole.admin, MembershipRole.salesAgent]);
      expect(r.warnings.length, 4);
      final blanks = r.warnings.where(
        (w) => w.kind == LegacyMigrationWarningKind.blankLegacyRole,
      );
      final unknowns = r.warnings.where(
        (w) => w.kind == LegacyMigrationWarningKind.unknownLegacyRole,
      );
      expect(blanks.length, 2);
      expect(unknowns.length, 2);
    });
  });

  group('parseLegacyList — telemetría', () {
    test('lista limpia ⇒ NO emite telemetría', () {
      LegacyMembershipRoleParser.parseLegacyList(['admin', 'viewer']);
      expect(rec.events, isEmpty);
    });

    test('lista con warnings ⇒ emite recordRolesWarning con count', () {
      LegacyMembershipRoleParser.parseLegacyList(
        ['admin', 'super_admin', 'unknown_role'],
        orgId: 'org-1',
        membershipId: 'uid@org-1',
      );
      expect(rec.events.length, 1);
      final e = rec.events.first;
      expect(
        e.event,
        LegacyMembershipMigrationTelemetry.eventRolesWarning,
      );
      expect(e.props['warningCount'], 2);
      expect(e.props['orgId'], 'org-1');
      expect(e.props['membershipId'], 'uid@org-1');
      expect(e.props['warnings'], isA<String>());
    });

    test('payload del evento omite orgId/membershipId si no se proveen', () {
      LegacyMembershipRoleParser.parseLegacyList(['unknown']);
      final e = rec.events.first;
      expect(e.props.containsKey('orgId'), isFalse);
      expect(e.props.containsKey('membershipId'), isFalse);
    });

    test('lista vacía ⇒ NO emite telemetría', () {
      LegacyMembershipRoleParser.parseLegacyList(const []);
      expect(rec.events, isEmpty);
    });

    test('emitTelemetry=false ⇒ NO emite, warnings siguen en el resultado',
        () {
      final r = LegacyMembershipRoleParser.parseLegacyList(
        ['admin', 'unknown_role'],
        orgId: 'org-batch',
        membershipId: 'uid@org-batch',
        emitTelemetry: false,
      );
      // Comportamiento del resultado preservado:
      expect(r.roles, [MembershipRole.admin]);
      expect(r.warnings.length, 1);
      // Pero el evento NO se emitió: el caller (loop masivo) controla.
      expect(rec.events, isEmpty);
    });

    test('emitTelemetry=true (default) sigue emitiendo cuando hay warnings',
        () {
      LegacyMembershipRoleParser.parseLegacyList(
        ['admin', 'unknown_role'],
        emitTelemetry: true,
      );
      expect(rec.events.length, 1);
    });

    test('caller batch puede agregar warnings y emitir UN evento manualmente',
        () {
      // Simulación: 5 memberships con drift legacy. Suprimimos telemetría
      // por-call y emitimos UN solo evento agregado al final.
      final accumulated = <Map<String, dynamic>>[];
      for (var i = 0; i < 5; i++) {
        final r = LegacyMembershipRoleParser.parseLegacyList(
          ['admin', 'unknown_role_$i'],
          orgId: 'org-$i',
          membershipId: 'uid@org-$i',
          emitTelemetry: false,
        );
        accumulated
            .addAll(r.warnings.map((w) => w.toMap()).toList(growable: false));
      }
      // El loop NO disparó eventos.
      expect(rec.events, isEmpty);

      // El caller emite el agregado.
      LegacyMembershipMigrationTelemetry.recordRolesWarning(
        warnings: accumulated,
        orgId: 'batch-aggregated',
      );
      expect(rec.events.length, 1);
      expect(rec.events.first.props['warningCount'], 5);
    });
  });

  group('Garantía: admin legacy NO pierde permisos por formato', () {
    test('todas las variantes de "admin" producen el mismo enum', () {
      const variants = [
        'admin',
        'Admin',
        'ADMIN',
        '  admin',
        'admin  ',
        '  Admin  ',
        'aDmIn',
        '\tADMIN\n',
      ];
      for (final v in variants) {
        expect(
          LegacyMembershipRoleParser.tryParseLegacy(v),
          MembershipRole.admin,
          reason: '"$v" debe normalizarse a admin',
        );
      }
    });

    test('lista que solo contiene "ADMIN" ⇒ resultado [admin] sin warnings',
        () {
      final r = LegacyMembershipRoleParser.parseLegacyList(['ADMIN']);
      expect(r.roles, [MembershipRole.admin]);
      expect(r.warnings, isEmpty);
      expect(rec.events, isEmpty);
    });
  });
}
