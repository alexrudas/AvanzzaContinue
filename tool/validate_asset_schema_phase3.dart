// ============================================================================
// tool/validate_asset_schema_phase3.dart
// VALIDADOR OFFLINE — Asset Schema v1.3.4 — Fase 3
//
// QUÉ HACE:
// - Valida que AssetDocumentBuilder produce documentos v1.3.4 correctos.
// - Verifica estructura, hash, rawSnapshots, compliance, legal, governance
//   y priority usando los builders REALES del codebase.
// - Imprime PASS/FAIL por cada check y un resumen final.
// - Determina si la base de Fase 3 es sana antes de avanzar a Fase 4/5.
//
// QUÉ NO HACE:
// - No toca código de producción.
// - No abre Isar ni conecta a Firestore.
// - No valida dispatcher, OCC, audit service ni reconciliation worker.
//
// REGLA DE EJECUCIÓN:
// - Ejecutar con Flutter, no con dart run, porque el codebase usa dependencias
//   del ecosistema Flutter.
// - Comando oficial:
//
//   flutter test tool/validate_asset_schema_phase3.dart
//
// PRINCIPIOS:
// - Sin dependencias de test framework avanzado: usa solo test() como harness
//   de ejecución Flutter y print para reporte humano.
// - Fixtures inline.
// - Determinístico.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Validador Fase 3 — Asset Schema v1.3.4.
// ============================================================================

// ignore_for_file: avoid_print

import 'package:avanzza/data/models/asset/special/asset_vehiculo_model.dart';
import 'package:avanzza/data/models/insurance/insurance_policy_model.dart';
import 'package:avanzza/data/sync/asset_document_builder.dart';
import 'package:flutter_test/flutter_test.dart';

// ─────────────────────────────────────────────────────────────────────────────
// HARNESS
// ─────────────────────────────────────────────────────────────────────────────

int _passed = 0;
int _failed = 0;

void check(String name, bool condition) {
  if (condition) {
    print('[PASS] $name');
    _passed++;
  } else {
    print('[FAIL] $name');
    _failed++;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FIXTURES
// ─────────────────────────────────────────────────────────────────────────────

AssetVehiculoModel _makeVehicle({
  String assetId = 'asset-001',
  String placa = 'ABC123',
  String? propertyLiens,
  String? runtMetaJson,
}) {
  return AssetVehiculoModel(
    assetId: assetId,
    refCode: 'REF-001',
    placa: placa,
    marca: 'Toyota',
    modelo: 'Hilux',
    anio: 2020,
    propertyLiens: propertyLiens,
    runtMetaJson: runtMetaJson,
    createdAt: DateTime.utc(2024, 1, 1),
    updatedAt: DateTime.utc(2025, 6, 15),
  );
}

InsurancePolicyModel _makePolicy({
  required String assetId,
  required String tipo,
  required String estado,
  required DateTime fechaFin,
  DateTime? fechaInicio,
  String? policyId,
}) {
  return InsurancePolicyModel(
    id: 'policy-$tipo-$estado',
    assetId: assetId,
    tipo: tipo,
    aseguradora: 'Seguros SA',
    tarifaBase: 500000.0,
    currencyCode: 'COP',
    countryId: 'CO',
    fechaInicio: fechaInicio ?? DateTime.utc(2024, 1, 1),
    fechaFin: fechaFin,
    estado: estado,
    policyId: policyId ?? 'policy-$tipo-$estado',
  );
}

String _hash(Map<String, dynamic> document) {
  final meta = document['metadata'] as Map<String, dynamic>;
  return meta['payloadHash'] as String;
}

String _lastSyncedAt(Map<String, dynamic> document) {
  final meta = document['metadata'] as Map<String, dynamic>;
  return meta['lastSyncedAt'] as String;
}

Map<String, dynamic> _qi(Map<String, dynamic> document) {
  return document['queryIndexes'] as Map<String, dynamic>;
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  test('validator script phase 3', () {
    final now = DateTime.utc(2026, 3, 19, 12, 0, 0);

    // Resultado base
    final minVehicle = _makeVehicle();
    final baseResult = AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: minVehicle,
      policies: const [],
      now: now,
    );
    final doc = baseResult.document;

    // ── 1. ESTRUCTURA ───────────────────────────────────────────────────────

    check('identity existe', doc.containsKey('identity'));
    check('classification existe', doc.containsKey('classification'));
    check('domains existe', doc.containsKey('domains'));
    check('queryIndexes existe', doc.containsKey('queryIndexes'));
    check('governance existe', doc.containsKey('governance'));
    check('rawSnapshots existe', doc.containsKey('rawSnapshots'));
    check('metadata existe', doc.containsKey('metadata'));

    // ── 2. HASH ─────────────────────────────────────────────────────────────

    final r1 = AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: minVehicle,
      policies: const [],
      now: now,
    );
    final r2 = AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: minVehicle,
      policies: const [],
      now: now,
    );

    check('mismo input → mismo payloadHash',
        _hash(r1.document) == _hash(r2.document));

    final r3 = AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: minVehicle,
      policies: const [],
      now: now.add(const Duration(hours: 3)),
    );

    check(
      'distinto now → metadata.lastSyncedAt distinto',
      _lastSyncedAt(r1.document) != _lastSyncedAt(r3.document),
    );

    check(
      'distinto lastSyncedAt (sin pólizas) → mismo payloadHash',
      _hash(r1.document) == _hash(r3.document),
    );

    final vehicleDiffPlaca = _makeVehicle(placa: 'XYZ999');
    final rDiffPlaca = AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: vehicleDiffPlaca,
      policies: const [],
      now: now,
    );
    check(
      'cambio de placa → payloadHash distinto',
      _hash(r1.document) != _hash(rDiffPlaca.document),
    );

    final vehicleLiensChanged =
        _makeVehicle(propertyLiens: 'Prenda activa banco XYZ');
    final rLiensChanged = AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: vehicleLiensChanged,
      policies: const [],
      now: now,
    );
    check(
      'cambio de propertyLiens → payloadHash distinto',
      _hash(r1.document) != _hash(rLiensChanged.document),
    );

    check(
      'payloadHash tiene longitud SHA-256 (64 hex)',
      RegExp(r'^[0-9a-f]{64}$').hasMatch(_hash(r1.document)),
    );

    // ── 3. RAW SNAPSHOTS ────────────────────────────────────────────────────

    final smallVehicle = _makeVehicle(runtMetaJson: '{"runt_rtm": []}');
    final rSmall = AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: smallVehicle,
      policies: const [],
      now: now,
    );
    check(
      'snapshot pequeño → snapshotWasTruncated == false',
      !rSmall.wasSnapshotTruncated,
    );
    check(
      'snapshot pequeño → rawSnapshotsOriginalSizeBytes > 0',
      rSmall.rawSnapshotsOriginalSizeBytes > 0,
    );

    final rawSmall = rSmall.document['rawSnapshots'] as Map<String, dynamic>;
    final vehicleSmall = rawSmall['vehicle'] as Map<String, dynamic>?;
    check(
      'snapshot pequeño → rawSnapshots.vehicle incluye runtMetaJson',
      vehicleSmall?.containsKey('runtMetaJson') == true,
    );

    final longField = 'a' * 80;
    final bigEntries = List.generate(
      300,
      (i) => '{"id": $i, "data": "$longField", "label": "entry_$i"}',
    );
    final bigRuntMeta = '{"runt_rtm": [${bigEntries.join(',')}]}';

    final bigVehicle = _makeVehicle(runtMetaJson: bigRuntMeta);
    final rBig = AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: bigVehicle,
      policies: const [],
      now: now,
    );

    check(
      'snapshot grande → snapshotWasTruncated == true',
      rBig.wasSnapshotTruncated,
    );

    final rawBig = rBig.document['rawSnapshots'] as Map<String, dynamic>;
    check(
      'snapshot truncado → rawSnapshots incluye snapshotSummary',
      rawBig.containsKey('snapshotSummary'),
    );

    check(
      'snapshot truncado → persistedSize < originalSize',
      rBig.rawSnapshotsPersistedSizeBytes < rBig.rawSnapshotsOriginalSizeBytes,
    );

    // ── 4. COMPLIANCE ───────────────────────────────────────────────────────

    check(
      'sin pólizas → complianceStatus == OK',
      _qi(doc)['complianceStatus'] == 'OK',
    );

    final expiredPolicy = _makePolicy(
      assetId: 'asset-001',
      tipo: 'soat',
      estado: 'vencido',
      fechaFin: now.subtract(const Duration(days: 45)),
    );
    final rExpired = AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: minVehicle,
      policies: [expiredPolicy],
      now: now,
    );
    final qiExpired = _qi(rExpired.document);

    check(
      'póliza vencida → complianceStatus == EXPIRED',
      qiExpired['complianceStatus'] == 'EXPIRED',
    );
    check(
      'póliza vencida → leadingComplianceType == soat',
      qiExpired['leadingComplianceType'] == 'soat',
    );
    check(
      'póliza vencida 45 días → daysExpired > 0',
      (qiExpired['daysExpired'] as int) > 0,
    );

    // ── 5. LEGAL ────────────────────────────────────────────────────────────

    const judicialMeta =
        '{"runt_limitations": [{"tipoLimitacion": "embargo judicial",'
        '"entidadJuridica": "Juzgado 1 Civil",'
        '"fechaRegistro": "2025-01-01"}]}';

    final vehicleJudicial = _makeVehicle(runtMetaJson: judicialMeta);
    final rJudicial = AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: vehicleJudicial,
      policies: const [],
      now: now,
    );

    check(
      'limitación judicial → legalStatus == DISPUTED',
      _qi(rJudicial.document)['legalStatus'] == 'DISPUTED',
    );

    final vehicleEncumbered =
        _makeVehicle(propertyLiens: 'Prenda activa banco XYZ');
    final rEncumbered = AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: vehicleEncumbered,
      policies: const [],
      now: now,
    );
    check(
      'propertyLiens con novedad → legalStatus == ENCUMBERED',
      _qi(rEncumbered.document)['legalStatus'] == 'ENCUMBERED',
    );

    final vehicleNoRegistra = _makeVehicle(propertyLiens: 'NO REGISTRA');
    final rNoRegistra = AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: vehicleNoRegistra,
      policies: const [],
      now: now,
    );
    check(
      'propertyLiens == "NO REGISTRA" → legalStatus == CLEAR',
      _qi(rNoRegistra.document)['legalStatus'] == 'CLEAR',
    );

    // ── 6. GOVERNANCE ───────────────────────────────────────────────────────

    final governance = doc['governance'] as Map<String, dynamic>;
    check(
      'governance.schemaVersion existe',
      governance.containsKey('schemaVersion'),
    );
    check(
      'governance NO contiene historyWriteStatusByDomain',
      !governance.containsKey('historyWriteStatusByDomain'),
    );

    // ── 7. PRIORITY ─────────────────────────────────────────────────────────

    check(
      'score 0 → priorityReasonHuman == "Al día"',
      _qi(doc)['priorityReasonHuman'] == 'Al día',
    );

    check(
      'caso vencido → priorityReasonHuman no vacío',
      (qiExpired['priorityReasonHuman'] as String?)?.isNotEmpty == true,
    );

    final r4 = AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: minVehicle,
      policies: const [],
      now: now,
    );
    check(
      'mismo input → mismo priorityReasonHuman',
      _qi(r1.document)['priorityReasonHuman'] ==
          _qi(r4.document)['priorityReasonHuman'],
    );

    // ── RESUMEN ─────────────────────────────────────────────────────────────

    final total = _passed + _failed;
    print('');
    print('RESULT:');
    print('checks: $total');
    print('passed: $_passed');
    print('failed: $_failed');
    print('READY_FOR_PHASE_4_5: ${_failed == 0 ? 'YES' : 'NO'}');

    expect(_failed, equals(0),
        reason:
            'El validador de Fase 3 detectó fallos. No avanzar a Fase 4/5.');
  });
}
