// ============================================================================
// test/core/telemetry/capability_profile_telemetry_test.dart
// Tests del facade de telemetría para CapabilityProfile.
// ============================================================================
// Cubre:
//   - Eventos emitidos con nombres canónicos (parse_error, migration_warning).
//   - Props incluyen los campos requeridos por el contrato.
//   - Truncado de strings largos (rawValue, errorMessage).
//   - Sanitización de listas/maps a string en rawValue.
//   - debugSetEmitter + resetEmitter (seam de tests).
//   - recordMigrationWarnings con lista vacía ⇒ no-op (no emite).
//   - Resilencia: emitter custom que lanza no propaga al caller.
// ============================================================================

import 'package:avanzza/core/telemetry/capability_profile_telemetry.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingEmitter {
  final List<({String event, Map<String, dynamic> props})> events = [];

  void call(String event, Map<String, dynamic> props) {
    events.add((event: event, props: Map<String, dynamic>.from(props)));
  }
}

void main() {
  late _RecordingEmitter recorder;

  setUp(() {
    recorder = _RecordingEmitter();
    CapabilityProfileTelemetry.debugSetEmitter(recorder.call);
  });

  tearDown(() {
    CapabilityProfileTelemetry.resetEmitter();
  });

  group('CapabilityProfileTelemetry — recordParseError', () {
    test('emite evento canónico parse_error con campos requeridos', () {
      CapabilityProfileTelemetry.recordParseError(
        source: CapabilityParseSource.isar,
        errorMessage: 'unexpected character',
        orgId: 'org-1',
        rawValue: '{not valid json',
        errorType: 'json_decode',
      );

      expect(recorder.events.length, 1);
      final e = recorder.events.first;
      expect(e.event, CapabilityProfileTelemetry.eventParseError);
      expect(e.props['source'], 'isar');
      expect(e.props['errorMessage'], 'unexpected character');
      expect(e.props['orgId'], 'org-1');
      expect(e.props['rawValue'], '{not valid json');
      expect(e.props['errorType'], 'json_decode');
      expect(e.props['timestamp'], isA<String>());
    });

    test('omite campos opcionales no provistos', () {
      CapabilityProfileTelemetry.recordParseError(
        source: CapabilityParseSource.firestore,
        errorMessage: 'structure invalid',
      );

      final e = recorder.events.first;
      expect(e.props.containsKey('orgId'), isFalse);
      expect(e.props.containsKey('rawValue'), isFalse);
      expect(e.props.containsKey('errorType'), isFalse);
      expect(e.props['source'], 'firestore');
    });

    test('source.wireValue se serializa correctamente', () {
      CapabilityProfileTelemetry.recordParseError(
        source: CapabilityParseSource.firestore,
        errorMessage: 'x',
      );
      expect(recorder.events.first.props['source'], 'firestore');

      CapabilityProfileTelemetry.recordParseError(
        source: CapabilityParseSource.isar,
        errorMessage: 'y',
      );
      expect(recorder.events[1].props['source'], 'isar');
    });

    test('trunca rawValue largo (>240 chars) con marcador', () {
      final huge = 'a' * 500;
      CapabilityProfileTelemetry.recordParseError(
        source: CapabilityParseSource.isar,
        errorMessage: 'big',
        rawValue: huge,
      );
      final raw = recorder.events.first.props['rawValue'] as String;
      expect(raw.length, lessThan(huge.length));
      expect(raw, endsWith('…[truncated]'));
    });

    test('trunca errorMessage largo', () {
      final long = 'e' * 500;
      CapabilityProfileTelemetry.recordParseError(
        source: CapabilityParseSource.isar,
        errorMessage: long,
      );
      final msg = recorder.events.first.props['errorMessage'] as String;
      expect(msg, endsWith('…[truncated]'));
    });

    test('rawValue como List ⇒ se serializa a String corto', () {
      final list = List.generate(100, (i) => 'item_$i');
      CapabilityProfileTelemetry.recordParseError(
        source: CapabilityParseSource.firestore,
        errorMessage: 'x',
        rawValue: list,
      );
      final raw = recorder.events.first.props['rawValue'];
      expect(raw, isA<String>());
      // Debe estar truncado.
      expect((raw as String).length, lessThanOrEqualTo(260));
    });
  });

  group('CapabilityProfileTelemetry — recordMigrationWarnings', () {
    test('emite evento canónico migration_warning con count + warnings', () {
      final warnings = [
        {
          'kind': 'malformedBusinessCategory',
          'fieldPath': 'providerSpec.businessCategoryId',
          'message': 'syntax error',
          'rawValue': 'Lubricentro',
        },
      ];
      CapabilityProfileTelemetry.recordMigrationWarnings(
        warnings: warnings,
        orgId: 'org-2',
        specKind: 'provider',
      );

      expect(recorder.events.length, 1);
      final e = recorder.events.first;
      expect(e.event, CapabilityProfileTelemetry.eventMigrationWarning);
      expect(e.props['warningCount'], 1);
      expect(e.props['orgId'], 'org-2');
      expect(e.props['specKind'], 'provider');
      expect(e.props['warnings'], isA<String>());
      expect(e.props['timestamp'], isA<String>());
    });

    test('warnings vacía ⇒ no-op (no emite)', () {
      CapabilityProfileTelemetry.recordMigrationWarnings(
        warnings: const [],
        orgId: 'org-x',
        specKind: 'insurer',
      );
      expect(recorder.events, isEmpty);
    });

    test('omite orgId/specKind si no se proveen', () {
      CapabilityProfileTelemetry.recordMigrationWarnings(
        warnings: [
          {'kind': 'unknownInsuranceLine', 'fieldPath': 'x', 'message': 'm'},
        ],
      );
      final e = recorder.events.first;
      expect(e.props.containsKey('orgId'), isFalse);
      expect(e.props.containsKey('specKind'), isFalse);
      expect(e.props['warningCount'], 1);
    });
  });

  group('CapabilityProfileTelemetry — seam de tests', () {
    test('debugSetEmitter reemplaza el emitter activo', () {
      final captured = <String>[];
      CapabilityProfileTelemetry.debugSetEmitter(
        (event, props) => captured.add(event),
      );

      CapabilityProfileTelemetry.recordParseError(
        source: CapabilityParseSource.isar,
        errorMessage: 'x',
      );

      expect(captured, [CapabilityProfileTelemetry.eventParseError]);
    });

    test('resetEmitter restaura el default', () {
      CapabilityProfileTelemetry.debugSetEmitter((_, __) {});
      CapabilityProfileTelemetry.resetEmitter();
      expect(
        CapabilityProfileTelemetry.emitter,
        same(CapabilityProfileTelemetry.defaultEmitter),
      );
    });
  });

  group('CapabilityProfileTelemetry — resilencia', () {
    test('emitter custom que lanza ⇒ no propaga al caller', () {
      CapabilityProfileTelemetry.debugSetEmitter((event, props) {
        throw StateError('boom');
      });

      // No debe lanzar:
      expect(
        () => CapabilityProfileTelemetry.recordParseError(
          source: CapabilityParseSource.isar,
          errorMessage: 'x',
        ),
        returnsNormally,
      );
      expect(
        () => CapabilityProfileTelemetry.recordMigrationWarnings(
          warnings: [
            {'kind': 'x', 'fieldPath': 'y', 'message': 'z'},
          ],
        ),
        returnsNormally,
      );
    });
  });
}
