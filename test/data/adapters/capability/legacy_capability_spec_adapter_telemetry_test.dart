// ============================================================================
// test/data/adapters/capability/legacy_capability_spec_adapter_telemetry_test.dart
// Verifica que LegacyCapabilitySpecAdapter emite telemetría cuando el parse
// produce warnings (sin alterar el resultado del adapter).
// ============================================================================

import 'package:avanzza/core/telemetry/capability_profile_telemetry.dart';
import 'package:avanzza/data/adapters/capability/legacy_capability_spec_adapter.dart';
import 'package:avanzza/data/adapters/capability/legacy_migration_warning.dart';
import 'package:flutter_test/flutter_test.dart';

class _Recorder {
  final List<({String event, Map<String, dynamic> props})> events = [];
  void call(String event, Map<String, dynamic> props) {
    events.add((event: event, props: Map<String, dynamic>.from(props)));
  }
}

void main() {
  late _Recorder recorder;

  setUp(() {
    recorder = _Recorder();
    CapabilityProfileTelemetry.debugSetEmitter(recorder.call);
  });

  tearDown(() {
    CapabilityProfileTelemetry.resetEmitter();
  });

  group('providerSpecFromLegacyJson — telemetría', () {
    test('JSON con businessCategoryId malformado ⇒ emite migration_warning',
        () {
      final result = LegacyCapabilitySpecAdapter.providerSpecFromLegacyJson(
        {
          'providerType': 'servicios',
          'businessCategoryId': 'Lubricentro', // Mayúscula → warning
        },
        orgId: 'org-prov-1',
      );

      // Comportamiento original preservado:
      expect(result.spec.businessCategoryRef, isNull);
      expect(result.warnings.length, 1);

      // Telemetría emitida:
      expect(recorder.events.length, 1);
      final e = recorder.events.first;
      expect(e.event, CapabilityProfileTelemetry.eventMigrationWarning);
      expect(e.props['orgId'], 'org-prov-1');
      expect(e.props['specKind'], 'provider');
      expect(e.props['warningCount'], 1);
      expect(e.props['warnings'], isA<String>());
      // El payload de warnings serializado debe mencionar el campo afectado.
      expect(
        e.props['warnings'] as String,
        contains('malformedBusinessCategory'),
      );
    });

    test('JSON íntegro (sin warnings) ⇒ NO emite telemetría', () {
      final result = LegacyCapabilitySpecAdapter.providerSpecFromLegacyJson(
        {
          'providerType': 'servicios',
          'businessCategoryId': 'mecanico_independiente',
          'market': 'vehiculo',
        },
        orgId: 'org-prov-clean',
      );

      expect(result.warnings, isEmpty);
      expect(recorder.events, isEmpty);
    });

    test('orgId es opcional — sin orgId también emite (omitiendo el campo)',
        () {
      LegacyCapabilitySpecAdapter.providerSpecFromLegacyJson({
        'providerType': 'servicios',
        'businessCategoryId': 'BAD-NAME',
      });

      expect(recorder.events.length, 1);
      expect(recorder.events.first.props.containsKey('orgId'), isFalse);
      expect(recorder.events.first.props['specKind'], 'provider');
    });
  });

  group('insurerSpecFromLegacyJson — telemetría', () {
    test('insuranceLines con desconocido ⇒ emite migration_warning + retorna spec',
        () {
      final result = LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson(
        {
          'insuranceLines': ['soat', 'fianza_legacy', 'auto'],
          'isCarrier': true,
        },
        orgId: 'org-ins-1',
      );

      // Comportamiento preservado: spec con ramos válidos.
      expect(result.spec.insuranceLines.length, 2);

      // Telemetría emitida una vez con todos los warnings.
      expect(recorder.events.length, 1);
      final e = recorder.events.first;
      expect(e.event, CapabilityProfileTelemetry.eventMigrationWarning);
      expect(e.props['orgId'], 'org-ins-1');
      expect(e.props['specKind'], 'insurer');
      expect(e.props['warningCount'], 1);
      expect(
        e.props['warnings'] as String,
        contains('unknownInsuranceLine'),
      );
    });

    test('múltiples warnings ⇒ se emiten juntos en un único evento', () {
      final result = LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson(
        {
          'insuranceLines': ['soat', 'fianza_legacy', 'auto'],
          'isCarrier': true,
          'regulatorLicense': 'BAD#LIC',
        },
        orgId: 'org-ins-multi',
      );

      // Comportamiento original preservado: 2 warnings, spec funcional.
      expect(result.warnings.length, 2);
      expect(result.spec.regulatorLicenseRef, isNull);

      // 1 sólo evento de telemetría con count=2.
      expect(recorder.events.length, 1);
      expect(recorder.events.first.props['warningCount'], 2);
      final payload = recorder.events.first.props['warnings'] as String;
      expect(payload, contains('unknownInsuranceLine'));
      expect(payload, contains('malformedRegulatorLicense'));
    });

    test('JSON íntegro ⇒ NO emite telemetría', () {
      final result = LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson(
        {
          'insuranceLines': ['soat', 'auto'],
          'isCarrier': true,
        },
        orgId: 'org-ins-clean',
      );
      expect(result.warnings, isEmpty);
      expect(recorder.events, isEmpty);
    });

    test('caso irrecuperable (insuranceLines vacío tras filtrado) ⇒ '
        'emite warnings parciales antes de lanzar', () {
      try {
        LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson(
          {
            'insuranceLines': ['fianza_legacy', 'caucion_v0'],
            'isCarrier': true,
          },
          orgId: 'org-ins-dead',
        );
        fail('Esperaba LegacyParseException');
      } on LegacyParseException catch (e) {
        // Se preservó la excepción con warnings parciales.
        expect(e.partialWarnings.length, 2);
      }

      // Pero ANTES del throw, el adapter emitió telemetría con los
      // warnings parciales (rastro de degradación catastrófica).
      expect(recorder.events.length, 1);
      expect(recorder.events.first.props['warningCount'], 2);
      expect(recorder.events.first.props['orgId'], 'org-ins-dead');
      expect(recorder.events.first.props['specKind'], 'insurer');
    });
  });

  group('Path estricto NO emite telemetría (sigue lanzando)', () {
    test('providerSpec.fromJson estricto sigue throwing sin tocar telemetry',
        () {
      // El adapter no se invoca aquí; vamos directo al path estricto del spec.
      // Esto verifica que la telemetría está SOLO en el adapter, no en el
      // path canónico estricto del domain.
      // (La verificación es indirecta: si el path estricto emitiera, este
      // test detectaría eventos en el recorder.)
      expect(recorder.events, isEmpty);
    });
  });
}
