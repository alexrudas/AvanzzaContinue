// ============================================================================
// test/sync/asset_document_builder_test.dart
// ASSET DOCUMENT BUILDER TESTS — Enterprise Ultra Pro Premium 10/10
//
// QUÉ HACE:
// - Verifica la estructura completa del documento Firestore v1.3.4.
// - Verifica determinismo de payloadHash.
// - Verifica que lastSyncedAt NO contamine el hash.
// - Verifica que cambios reales de contenido SÍ cambien el hash.
// - Verifica truncamiento de rawSnapshots.
// - Verifica presencia de runtMetaJson en rawSnapshots cuando NO hay truncamiento.
// - Verifica estados derivados de compliance, legal y financial.
// - Verifica reasonHuman y reglas de governance.
//
// QUÉ NO HACE:
// - No prueba Firestore ni Isar reales.
// - No re-prueba en profundidad los builders internos de cada dominio.
// - No prueba OCC ni dispatcher.
//
// NOTAS:
// - Este test asume el contrato actual de:
//   * AssetVehiculoModel
//   * InsurancePolicyModel
//   * AssetDocumentBuilder
// - Si cambia el constructor de InsurancePolicyModel, ajustar solo el helper
//   `policyModel(...)` de este archivo.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 3 — Asset Schema v1.3.4.
// ============================================================================

import 'dart:convert';

import 'package:avanzza/data/models/asset/special/asset_vehiculo_model.dart';
import 'package:avanzza/data/models/insurance/insurance_policy_model.dart';
import 'package:avanzza/data/sync/asset_document_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ==========================================================================
  // FIXTURES BASE
  // ==========================================================================

  final kNow = DateTime.utc(2026, 3, 15, 12, 0, 0);

  AssetVehiculoModel baseModel({
    String assetId = 'asset-001',
    String refCode = 'VH-001',
    String placa = 'ABC123',
    String? propertyLiens,
    String? runtMetaJson,
  }) {
    return AssetVehiculoModel(
      assetId: assetId,
      refCode: refCode,
      placa: placa,
      marca: 'Toyota',
      modelo: 'Hilux',
      anio: 2022,
      propertyLiens: propertyLiens,
      runtMetaJson: runtMetaJson,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 3, 1),
    );
  }

  InsurancePolicyModel policyModel({
    required String id,
    required String tipo,
    required String estado,
    required DateTime fechaFin,
    String? policyId,
    String assetId = 'asset-001',
  }) {
    return InsurancePolicyModel(
      id: id,
      assetId: assetId,
      tipo: tipo,
      aseguradora: 'Aseguradora XYZ',
      tarifaBase: 500000,
      currencyCode: 'COP',
      countryId: 'CO',
      fechaInicio: DateTime.utc(2025, 1, 1),
      fechaFin: fechaFin,
      estado: estado,
      policyId: policyId ?? id,
    );
  }

  String runtMetaJsonWithJudicialLimitation() {
    return jsonEncode({
      'runt_limitations': [
        {
          'tipoLimitacion': 'Embargo judicial',
          'entidadJuridica': 'Juzgado Primero Civil',
          'fechaRegistro': '2026-01-15',
        },
      ],
      'runt_warranties': [],
    });
  }

  String runtMetaJsonLarge() {
    final huge = 'X' * 11000;
    return jsonEncode({
      'runt_limitations': [],
      'runt_warranties': [],
      'big_data': huge,
    });
  }

  String extractHash(AssetDocumentResult result) {
    return ((result.document['metadata'] as Map<String, dynamic>)['payloadHash']
            as String)
        .trim();
  }

  String extractLastSyncedAt(AssetDocumentResult result) {
    return ((result.document['metadata']
            as Map<String, dynamic>)['lastSyncedAt'] as String)
        .trim();
  }

  // ==========================================================================
  // ESTRUCTURA GENERAL DEL DOCUMENTO
  // ==========================================================================

  group('AssetDocumentBuilder — estructura general', () {
    test('construye todos los bloques de primer nivel requeridos', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: const [],
        now: kNow,
      );

      final doc = result.document;

      expect(doc.containsKey('identity'), isTrue);
      expect(doc.containsKey('classification'), isTrue);
      expect(doc.containsKey('domains'), isTrue);
      expect(doc.containsKey('queryIndexes'), isTrue);
      expect(doc.containsKey('governance'), isTrue);
      expect(doc.containsKey('rawSnapshots'), isTrue);
      expect(doc.containsKey('metadata'), isTrue);
    });

    test('identity contiene assetId, refCode, placa y assetType', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(assetId: 'asset-xyz', refCode: 'VH-999'),
        policies: const [],
        now: kNow,
      );

      final identity = result.document['identity'] as Map<String, dynamic>;

      expect(identity['assetId'], equals('asset-xyz'));
      expect(identity['refCode'], equals('VH-999'));
      expect(identity['placa'], equals('ABC123'));
      expect(identity['assetType'], equals('VEHICLE'));
    });

    test('classification no duplica schemaVersion', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: const [],
        now: kNow,
      );

      final classification =
          result.document['classification'] as Map<String, dynamic>;

      expect(classification['schemaFamily'], equals('ASSET_VEHICLE'));
      expect(classification.containsKey('schemaVersion'), isFalse);
    });

    test(
        'metadata contiene schemaVersion, documentType, lastSyncedAt y payloadHash',
        () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: const [],
        now: kNow,
      );

      final metadata = result.document['metadata'] as Map<String, dynamic>;

      expect(metadata['schemaVersion'], equals('1.3.4'));
      expect(metadata['documentType'], equals('asset_vehicle'));
      expect(metadata['lastSyncedAt'], isA<String>());
      expect(metadata['payloadHash'], isA<String>());
      expect((metadata['payloadHash'] as String).length, equals(64));
    });

    test('domains contiene compliance, legal y financial', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: const [],
        now: kNow,
      );

      final domains = result.document['domains'] as Map<String, dynamic>;

      expect(domains.containsKey('compliance'), isTrue);
      expect(domains.containsKey('legal'), isTrue);
      expect(domains.containsKey('financial'), isTrue);
    });

    test('queryIndexes contiene todas las keys públicas requeridas', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: const [],
        now: kNow,
      );

      final qi = result.document['queryIndexes'] as Map<String, dynamic>;

      expect(qi.containsKey('priorityScore'), isTrue);
      expect(qi.containsKey('priorityReason'), isTrue);
      expect(qi.containsKey('priorityReasonHuman'), isTrue);
      expect(qi.containsKey('complianceStatus'), isTrue);
      expect(qi.containsKey('leadingComplianceType'), isTrue);
      expect(qi.containsKey('daysExpired'), isTrue);
      expect(qi.containsKey('activeComplianceTypes'), isTrue);
      expect(qi.containsKey('expiredComplianceTypes'), isTrue);
      expect(qi.containsKey('legalStatus'), isTrue);
      expect(qi.containsKey('financialStatus'), isTrue);
    });
  });

  // ==========================================================================
  // HASH — DETERMINISMO Y DEDUPLICATION
  // ==========================================================================

  group('AssetDocumentBuilder — payloadHash', () {
    test('mismo input produce mismo hash', () {
      final model = baseModel();
      final policies = <InsurancePolicyModel>[];

      final r1 = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: model,
        policies: policies,
        now: kNow,
      );

      final r2 = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: model,
        policies: policies,
        now: kNow,
      );

      expect(extractHash(r1), equals(extractHash(r2)));
    });

    test('lastSyncedAt cambia entre builds pero el hash permanece igual', () {
      final model = baseModel();

      final r1 = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: model,
        policies: const [],
        now: DateTime.utc(2026, 3, 15, 8, 0, 0),
      );

      final r2 = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: model,
        policies: const [],
        now: DateTime.utc(2026, 3, 15, 22, 0, 0),
      );

      expect(extractLastSyncedAt(r1), isNot(equals(extractLastSyncedAt(r2))));
      expect(extractHash(r1), equals(extractHash(r2)),
          reason: 'lastSyncedAt no debe contaminar payloadHash');
    });

    test('cambio real en contenido relevante cambia el hash (placa)', () {
      final r1 = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(placa: 'ABC123'),
        policies: const [],
        now: kNow,
      );

      final r2 = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(placa: 'XYZ987'),
        policies: const [],
        now: kNow,
      );

      expect(extractHash(r1), isNot(equals(extractHash(r2))));
    });

    test('cambio real en contenido relevante cambia el hash (propertyLiens)',
        () {
      final r1 = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(propertyLiens: 'NO REGISTRA'),
        policies: const [],
        now: kNow,
      );

      final r2 = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(propertyLiens: 'PRENDA A FAVOR DE BANCO XYZ'),
        policies: const [],
        now: kNow,
      );

      expect(extractHash(r1), isNot(equals(extractHash(r2))));
    });

    test('payloadHash tiene formato SHA-256 hexadecimal de 64 caracteres', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: const [],
        now: kNow,
      );

      final hash = extractHash(result);

      expect(hash.length, equals(64));
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(hash), isTrue);
    });
  });

  // ==========================================================================
  // RAW SNAPSHOTS — TAMAÑO Y TRUNCAMIENTO
  // ==========================================================================

  group('AssetDocumentBuilder — rawSnapshots', () {
    test('snapshot pequeño no se trunca', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel:
            baseModel(runtMetaJson: jsonEncode({'runt_limitations': []})),
        policies: const [],
        now: kNow,
      );

      expect(result.wasSnapshotTruncated, isFalse);
      expect(result.rawSnapshotsOriginalSizeBytes, greaterThan(0));
      expect(result.rawSnapshotsPersistedSizeBytes,
          equals(result.rawSnapshotsOriginalSizeBytes));
    });

    test('snapshot pequeño conserva runtMetaJson dentro de rawSnapshots', () {
      final rawJson = jsonEncode({
        'runt_limitations': [],
        'runt_warranties': [],
      });

      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(runtMetaJson: rawJson),
        policies: const [],
        now: kNow,
      );

      final raw = result.document['rawSnapshots'] as Map<String, dynamic>;
      final vehicle = raw['vehicle'] as Map<String, dynamic>;

      expect(vehicle.containsKey('runtMetaJson'), isTrue);
      expect(vehicle['runtMetaJson'], equals(rawJson));
    });

    test('snapshot grande > 10KB sí se trunca', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(runtMetaJson: runtMetaJsonLarge()),
        policies: const [],
        now: kNow,
      );

      expect(result.wasSnapshotTruncated, isTrue);
      expect(result.rawSnapshotsOriginalSizeBytes, greaterThan(10 * 1024));
      expect(result.rawSnapshotsPersistedSizeBytes,
          lessThan(result.rawSnapshotsOriginalSizeBytes));
    });

    test('snapshot truncado contiene snapshotSummary', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(runtMetaJson: runtMetaJsonLarge()),
        policies: const [],
        now: kNow,
      );

      final raw = result.document['rawSnapshots'] as Map<String, dynamic>;
      final summary = raw['snapshotSummary'] as Map<String, dynamic>;

      expect(summary['truncated'], isTrue);
      expect(summary['strategy'], equals('keys_only'));
      expect(summary['originalSizeBytes'], greaterThan(10 * 1024));
    });

    test('snapshot truncado conserva estructura de keys del bloque vehicle',
        () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(runtMetaJson: runtMetaJsonLarge()),
        policies: const [],
        now: kNow,
      );

      final raw = result.document['rawSnapshots'] as Map<String, dynamic>;
      final vehicle = raw['vehicle'] as Map<String, dynamic>;

      expect(vehicle.isNotEmpty, isTrue);
      for (final value in vehicle.values) {
        expect(value, isTrue);
      }
    });
  });

  // ==========================================================================
  // QUERY INDEXES — COMPLIANCE
  // ==========================================================================

  group('AssetDocumentBuilder — queryIndexes/compliance', () {
    test('sin pólizas => complianceStatus OK, priorityScore 0, daysExpired 0',
        () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: const [],
        now: kNow,
      );

      final qi = result.document['queryIndexes'] as Map<String, dynamic>;

      expect(qi['complianceStatus'], equals('OK'));
      expect(qi['priorityScore'], equals(0));
      expect(qi['daysExpired'], equals(0));
      expect(qi['priorityReasonHuman'], equals('Al día'));
    });

    test(
        'póliza vencida => complianceStatus EXPIRED y leadingComplianceType correcto',
        () {
      final expiredPolicy = policyModel(
        id: 'pol-soat-001',
        tipo: 'soat',
        estado: 'vencido',
        fechaFin: kNow.subtract(const Duration(days: 30)),
      );

      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: [expiredPolicy],
        now: kNow,
      );

      final qi = result.document['queryIndexes'] as Map<String, dynamic>;

      expect(qi['complianceStatus'], equals('EXPIRED'));
      expect(qi['priorityScore'], greaterThan(0));
      expect(qi['daysExpired'], greaterThan(0));
      expect(qi['leadingComplianceType'], equals('soat'));
      expect((qi['expiredComplianceTypes'] as List), contains('soat'));
    });

    test('póliza vigente => activeComplianceTypes contiene el tipo', () {
      final activePolicy = policyModel(
        id: 'pol-soat-002',
        tipo: 'soat',
        estado: 'vigente',
        fechaFin: kNow.add(const Duration(days: 90)),
      );

      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: [activePolicy],
        now: kNow,
      );

      final qi = result.document['queryIndexes'] as Map<String, dynamic>;

      expect((qi['activeComplianceTypes'] as List), contains('soat'));
      expect(qi['expiredComplianceTypes'] as List, isEmpty);
    });
  });

  // ==========================================================================
  // QUERY INDEXES — LEGAL
  // ==========================================================================

  group('AssetDocumentBuilder — queryIndexes/legal', () {
    test('sin datos jurídicos => legalStatus CLEAR', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: const [],
        now: kNow,
      );

      final qi = result.document['queryIndexes'] as Map<String, dynamic>;

      expect(qi['legalStatus'], equals('CLEAR'));
    });

    test('limitación judicial => legalStatus DISPUTED', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(
          runtMetaJson: runtMetaJsonWithJudicialLimitation(),
        ),
        policies: const [],
        now: kNow,
      );

      final qi = result.document['queryIndexes'] as Map<String, dynamic>;

      expect(qi['legalStatus'], equals('DISPUTED'));
    });

    test('propertyLiens con novedad => legalStatus ENCUMBERED', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(
          propertyLiens: 'PRENDA A FAVOR DE BANCO XYZ',
        ),
        policies: const [],
        now: kNow,
      );

      final qi = result.document['queryIndexes'] as Map<String, dynamic>;

      expect(qi['legalStatus'], equals('ENCUMBERED'));
    });

    test('propertyLiens "NO REGISTRA" => legalStatus CLEAR', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(propertyLiens: 'NO REGISTRA'),
        policies: const [],
        now: kNow,
      );

      final qi = result.document['queryIndexes'] as Map<String, dynamic>;

      expect(qi['legalStatus'], equals('CLEAR'));
    });
  });

  // ==========================================================================
  // QUERY INDEXES — FINANCIAL
  // ==========================================================================

  group('AssetDocumentBuilder — queryIndexes/financial', () {
    test('sin datos financieros => financialStatus NO_DATA', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: const [],
        now: kNow,
      );

      final qi = result.document['queryIndexes'] as Map<String, dynamic>;

      expect(qi['financialStatus'], equals('NO_DATA'));
    });
  });

  // ==========================================================================
  // GOVERNANCE
  // ==========================================================================

  group('AssetDocumentBuilder — governance', () {
    test('governance contiene schemaVersion', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: const [],
        now: kNow,
      );

      final governance = result.document['governance'] as Map<String, dynamic>;

      expect(governance['schemaVersion'], equals('1.3.4'));
    });

    test('governance propaga createdAt y updatedAt del modelo', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: const [],
        now: kNow,
      );

      final governance = result.document['governance'] as Map<String, dynamic>;

      expect(governance.containsKey('createdAt'), isTrue);
      expect(governance.containsKey('updatedAt'), isTrue);
    });

    test('governance NO inicializa historyWriteStatusByDomain por defecto', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: const [],
        now: kNow,
      );

      final governance = result.document['governance'] as Map<String, dynamic>;

      expect(governance.containsKey('historyWriteStatusByDomain'), isFalse);
    });
  });

  // ==========================================================================
  // PRIORITY REASON HUMAN
  // ==========================================================================

  group('AssetDocumentBuilder — priorityReasonHuman', () {
    test('sin problemas => "Al día"', () {
      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: const [],
        now: kNow,
      );

      final qi = result.document['queryIndexes'] as Map<String, dynamic>;

      expect(qi['priorityReasonHuman'], equals('Al día'));
    });

    test('póliza vencida => reasonHuman no vacío y distinto de "Al día"', () {
      final expiredPolicy = policyModel(
        id: 'pol-001',
        tipo: 'soat',
        estado: 'vencido',
        fechaFin: kNow.subtract(const Duration(days: 45)),
      );

      final result = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: [expiredPolicy],
        now: kNow,
      );

      final qi = result.document['queryIndexes'] as Map<String, dynamic>;
      final reasonHuman = qi['priorityReasonHuman'] as String;

      expect(reasonHuman.isNotEmpty, isTrue);
      expect(reasonHuman, isNot(equals('Al día')));
    });

    test('reasonHuman es determinístico para el mismo input', () {
      final expiredPolicy = policyModel(
        id: 'pol-001',
        tipo: 'soat',
        estado: 'vencido',
        fechaFin: kNow.subtract(const Duration(days: 45)),
      );

      final r1 = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: [expiredPolicy],
        now: kNow,
      );

      final r2 = AssetDocumentBuilder.buildFullDocument(
        vehiculoModel: baseModel(),
        policies: [expiredPolicy],
        now: kNow,
      );

      final reason1 = ((r1.document['queryIndexes']
          as Map<String, dynamic>)['priorityReasonHuman'] as String);
      final reason2 = ((r2.document['queryIndexes']
          as Map<String, dynamic>)['priorityReasonHuman'] as String);

      expect(reason1, equals(reason2));
    });
  });
}
