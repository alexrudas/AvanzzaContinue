// ============================================================================
// test/data/models/org/organization_model_telemetry_test.dart
// Verifica que OrganizationModel emite telemetría en TODOS los paths de
// parse degradado de capabilityProfiles, sin cambiar el comportamiento
// (sigue cayendo a [] sin lanzar).
// ============================================================================

import 'dart:convert';

import 'package:avanzza/core/telemetry/capability_profile_telemetry.dart';
import 'package:avanzza/data/models/org/organization_model.dart';
import 'package:avanzza/domain/entities/org/organization_entity.dart';
import 'package:avanzza/domain/value/capability/advisor_spec.dart';
import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/domain/value/capability/capability_profile.dart';
import 'package:avanzza/domain/value/capability/profile_kind.dart';
import 'package:flutter_test/flutter_test.dart';

class _Recorder {
  final List<({String event, Map<String, dynamic> props})> events = [];
  void call(String event, Map<String, dynamic> props) {
    events.add((event: event, props: Map<String, dynamic>.from(props)));
  }
}

OrganizationEntity _baseEntity({
  List<CapabilityProfile> capabilityProfiles = const [],
}) {
  return OrganizationEntity(
    id: 'org-tel-1',
    nombre: 'Telemetry Test Org',
    tipo: 'empresa',
    countryId: 'CO',
    capabilityProfiles: capabilityProfiles,
  );
}

CapabilityProfile _advisor() => CapabilityProfile(
      kind: ProfileKind.advisor,
      advisorSpec: const AdvisorSpec(market: AssetRegistrationType.vehiculo),
    );

void main() {
  late _Recorder recorder;

  setUp(() {
    recorder = _Recorder();
    CapabilityProfileTelemetry.debugSetEmitter(recorder.call);
  });

  tearDown(() {
    CapabilityProfileTelemetry.resetEmitter();
  });

  group('OrganizationModel.parsedCapabilityProfiles — telemetría Isar', () {
    test('JSON inválido ⇒ retorna [] + emite parse_error (errorType=json_decode)',
        () {
      final model = OrganizationModel(
        id: 'org-corrupt',
        nombre: 'X',
        tipo: 'empresa',
        countryId: 'CO',
        capabilityProfilesJson: '{not valid json',
      );

      final result = model.parsedCapabilityProfiles;

      expect(result, isEmpty); // comportamiento preservado
      expect(recorder.events.length, 1);
      final e = recorder.events.first;
      expect(e.event, CapabilityProfileTelemetry.eventParseError);
      expect(e.props['source'], 'isar');
      expect(e.props['orgId'], 'org-corrupt');
      expect(e.props['errorType'], 'json_decode');
      expect(e.props['rawValue'], contains('{not valid json'));
    });

    test('JSON válido pero no-array ⇒ [] + parse_error (structure_invalid)',
        () {
      final model = OrganizationModel(
        id: 'org-bad-shape',
        nombre: 'X',
        tipo: 'empresa',
        countryId: 'CO',
        capabilityProfilesJson: '{"kind":"provider"}',
      );

      final result = model.parsedCapabilityProfiles;

      expect(result, isEmpty);
      expect(recorder.events.length, 1);
      expect(recorder.events.first.props['errorType'], 'structure_invalid');
      expect(recorder.events.first.props['orgId'], 'org-bad-shape');
    });

    test('Item malformado en array ⇒ fallback total [] + parse_error (item_invalid)',
        () {
      // 1 item válido + 1 con kind desconocido. Política: descartar todos.
      final model = OrganizationModel(
        id: 'org-mixed',
        nombre: 'X',
        tipo: 'empresa',
        countryId: 'CO',
        capabilityProfilesJson:
            '[{"kind":"provider","providerSpec":{"providerType":"servicios"}},'
            '{"kind":"underwriter"}]',
      );

      final result = model.parsedCapabilityProfiles;

      expect(result, isEmpty);
      expect(recorder.events.length, 1);
      expect(recorder.events.first.props['errorType'], 'item_invalid');
      expect(recorder.events.first.props['orgId'], 'org-mixed');
    });

    test('JSON válido con datos íntegros ⇒ NO emite telemetría', () {
      final entity = _baseEntity(capabilityProfiles: [_advisor()]);
      final model = OrganizationModel.fromEntity(entity);

      final result = model.parsedCapabilityProfiles;

      expect(result.length, 1);
      expect(recorder.events, isEmpty);
    });

    test('JSON null ⇒ [] sin emitir telemetría (ausencia legítima)', () {
      final model = OrganizationModel(
        id: 'org-empty',
        nombre: 'X',
        tipo: 'empresa',
        countryId: 'CO',
      );
      expect(model.parsedCapabilityProfiles, isEmpty);
      expect(recorder.events, isEmpty);
    });

    test('JSON vacío ⇒ [] sin telemetría', () {
      final model = OrganizationModel(
        id: 'org-empty2',
        nombre: 'X',
        tipo: 'empresa',
        countryId: 'CO',
        capabilityProfilesJson: '',
      );
      expect(model.parsedCapabilityProfiles, isEmpty);
      expect(recorder.events, isEmpty);
    });
  });

  group('OrganizationModel.fromIsar/toIsar regression con telemetría', () {
    test('roundtrip íntegro ⇒ ningún parse_error', () {
      final entity = _baseEntity(capabilityProfiles: [_advisor()]);
      final model = OrganizationModel.fromEntity(entity);
      // Forzar lectura via getter (path que dispara telemetry si falla).
      final restored = model.toEntity();

      expect(restored.capabilityProfiles.length, 1);
      expect(recorder.events, isEmpty);
    });
  });

  group('OrganizationModel — orgId siempre se incluye en telemetry', () {
    test('parse error trae el id del modelo', () {
      final model = OrganizationModel(
        id: 'org-with-id-context',
        nombre: 'X',
        tipo: 'empresa',
        countryId: 'CO',
        capabilityProfilesJson: 'not json at all',
      );

      // ignore: unused_local_variable
      final _ = model.parsedCapabilityProfiles;

      expect(recorder.events.first.props['orgId'], 'org-with-id-context');
    });
  });

  group('Sanity — entity → JSON → roundtrip no dispara telemetría', () {
    test('jsonEncode + fromJson directo (estricto, datos válidos)', () {
      final entity = _baseEntity(capabilityProfiles: [_advisor()]);
      final encoded = jsonEncode(entity.toJson());
      final restored = OrganizationEntity.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
      expect(restored.capabilityProfiles.length, 1);
      // Este path NO usa el parser tolerante del modelo, pasa por el
      // converter del domain (estricto). No debe emitir telemetría.
      expect(recorder.events, isEmpty);
    });
  });
}
