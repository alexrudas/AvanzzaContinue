// ============================================================================
// test/core/telemetry/legacy_membership_migration_telemetry_test.dart
// Tests del facade LegacyMembershipMigrationTelemetry.
// ============================================================================

import 'package:avanzza/core/telemetry/legacy_membership_migration_telemetry.dart';
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

  group('recordSuccess', () {
    test('emite evento canónico con campos requeridos', () {
      LegacyMembershipMigrationTelemetry.recordSuccess(
        orgId: 'org-1',
        membershipId: 'uid-1@org-1',
        sourceProfileIndex: 0,
        sourceProfile: {'providerType': 'servicios'},
      );
      expect(rec.events.length, 1);
      final e = rec.events.first;
      expect(e.event, LegacyMembershipMigrationTelemetry.eventSuccess);
      expect(e.props['orgId'], 'org-1');
      expect(e.props['membershipId'], 'uid-1@org-1');
      expect(e.props['sourceProfileIndex'], 0);
      expect(e.props['sourceProfile'], isA<String>());
      expect(e.props['timestamp'], isA<String>());
    });

    test('omite sourceProfile si null', () {
      LegacyMembershipMigrationTelemetry.recordSuccess(
        orgId: 'org-1',
        membershipId: 'uid@org',
        sourceProfileIndex: 2,
      );
      expect(rec.events.first.props.containsKey('sourceProfile'), isFalse);
    });
  });

  group('recordWarning', () {
    test('emite evento warning con count', () {
      LegacyMembershipMigrationTelemetry.recordWarning(
        orgId: 'org-2',
        membershipId: 'uid-2@org-2',
        sourceProfileIndex: 1,
        warnings: [
          {'kind': 'malformedBusinessCategory', 'fieldPath': 'x', 'message': 'm'},
          {'kind': 'unknownLegacyAssetType', 'fieldPath': 'y', 'message': 'n'},
        ],
        sourceProfile: {'providerType': 'articulos'},
      );
      final e = rec.events.first;
      expect(e.event, LegacyMembershipMigrationTelemetry.eventWarning);
      expect(e.props['warningCount'], 2);
      expect(e.props['warnings'], isA<String>());
    });

    test('warnings vacía ⇒ no-op', () {
      LegacyMembershipMigrationTelemetry.recordWarning(
        orgId: 'org-x',
        membershipId: 'uid@org-x',
        sourceProfileIndex: 0,
        warnings: const [],
      );
      expect(rec.events, isEmpty);
    });
  });

  group('recordError', () {
    test('emite evento error con razón legible', () {
      LegacyMembershipMigrationTelemetry.recordError(
        orgId: 'org-3',
        membershipId: 'uid-3@org-3',
        sourceProfileIndex: 0,
        error: 'providerType desconocido',
        sourceProfile: {'providerType': 'productos'},
      );
      final e = rec.events.first;
      expect(e.event, LegacyMembershipMigrationTelemetry.eventError);
      expect(e.props['error'], 'providerType desconocido');
      expect(e.props['orgId'], 'org-3');
      expect(e.props['membershipId'], 'uid-3@org-3');
    });

    test('partialWarnings se incluye cuando se provee', () {
      LegacyMembershipMigrationTelemetry.recordError(
        orgId: 'org-4',
        membershipId: 'uid@org-4',
        sourceProfileIndex: 0,
        error: 'spec irrecuperable',
        partialWarnings: [
          {'kind': 'unknownLegacyAssetType', 'fieldPath': 'a', 'message': 'b'},
        ],
      );
      final e = rec.events.first;
      expect(e.props['partialWarningCount'], 1);
      expect(e.props['partialWarnings'], isA<String>());
    });

    test('partialWarnings vacía u ausente ⇒ keys omitidas', () {
      LegacyMembershipMigrationTelemetry.recordError(
        orgId: 'org-5',
        membershipId: 'uid@org-5',
        sourceProfileIndex: 0,
        error: 'x',
      );
      final e = rec.events.first;
      expect(e.props.containsKey('partialWarningCount'), isFalse);
      expect(e.props.containsKey('partialWarnings'), isFalse);
    });
  });

  group('seam de tests', () {
    test('debugSetEmitter reemplaza emitter', () {
      final captured = <String>[];
      LegacyMembershipMigrationTelemetry.debugSetEmitter(
        (event, props) => captured.add(event),
      );
      LegacyMembershipMigrationTelemetry.recordSuccess(
        orgId: 'o',
        membershipId: 'm',
        sourceProfileIndex: 0,
      );
      expect(captured, [LegacyMembershipMigrationTelemetry.eventSuccess]);
    });

    test('resetEmitter restaura default', () {
      LegacyMembershipMigrationTelemetry.debugSetEmitter((_, __) {});
      LegacyMembershipMigrationTelemetry.resetEmitter();
      expect(
        LegacyMembershipMigrationTelemetry.emitter,
        same(LegacyMembershipMigrationTelemetry.defaultEmitter),
      );
    });
  });

  group('resilencia', () {
    test('emitter custom que lanza ⇒ no propaga', () {
      LegacyMembershipMigrationTelemetry.debugSetEmitter(
        (_, __) => throw StateError('boom'),
      );
      expect(
        () => LegacyMembershipMigrationTelemetry.recordSuccess(
          orgId: 'o',
          membershipId: 'm',
          sourceProfileIndex: 0,
        ),
        returnsNormally,
      );
    });
  });
}
