// ============================================================================
// lib/data/sync/asset_firestore_adapter.dart
// ASSET FIRESTORE ADAPTER — Mapper AssetVehiculoModel ↔ Firestore / Outbox
//
// QUÉ HACE:
// - Convierte AssetVehiculoModel a payload JSON-safe para el outbox
//   (legacy schema plano).
// - Construye el documento Firestore v1.3.4 completo delegando a
//   AssetDocumentBuilder (buildFullDocument).
// - Convierte Map<String, dynamic> de Firestore a AssetVehiculoModel con
//   auto-detección de schema:
//     · si el doc contiene 'domains' → fromFullDocument() (v1.3.4)
//     · si no → fromFirestoreMap() legacy
//   La capa superior NUNCA bifurca por schema — siempre recibe AssetVehiculoModel.
// - Reconstruye AssetVehiculoModel desde documento v1.3.4 leyendo
//   rawSnapshots.vehicle (caso normal) o identity (fallback truncado).
// - Maneja serialización consistente de fechas.
// - Calcula fingerprint determinístico (SHA-256) del activo.
//
// QUÉ NO HACE:
// - No ejecuta sync.
// - No maneja colas ni retries.
// - No accede a Isar ni Firestore directamente.
// - No lee el feature flag (decisión del dispatcher).
// - No emite audit events (responsabilidad del caller de buildFullDocument).
//
// ─────────────────────────────────────────────────────────────────────────────
// AUTO-DETECCIÓN DE SCHEMA (LECTURA)
// ─────────────────────────────────────────────────────────────────────────────
//
//   if (firestoreDoc.containsKey('domains'))
//     → fromFullDocument()   ← schema v1.3.4
//   else
//     → AssetVehiculoModel.fromFirestore()  ← legacy plano
//
// SNAPSHOT TRUNCADO (rawSnapshots > 10 KB):
// - Detectado por rawSnapshots['snapshotSummary']['truncated'] == true.
// - Fallback: identity block (assetId, refCode, placa) + defaults para
//   campos no disponibles. Isar (fuente local) prevalece; no sobreescribir
//   si el modelo resultante parece degradado.
//
// ─────────────────────────────────────────────────────────────────────────────
// TIMESTAMP HANDLING (CRÍTICO)
// ─────────────────────────────────────────────────────────────────────────────
//
// LECTURA:
// - Legacy: delegado a AssetVehiculoModel.fromFirestore() con DateTimeTimestampConverter.
// - v1.3.4: rawSnapshots.vehicle almacena fechas como ISO-8601 UTC strings.
//
// ESCRITURA:
// - DateTime → ISO 8601 UTC String.
// - Nunca usar Timestamp en outbox (no es JSON-safe).
//
// ─────────────────────────────────────────────────────────────────────────────
// FINGERPRINT — CONTRATO
// ─────────────────────────────────────────────────────────────────────────────
//
// REGLAS:
// 1. Snapshot completo del activo.
// 2. Normalización recursiva.
// 3. Orden alfabético de keys.
// 4. jsonEncode determinístico.
// 5. SHA-256 final.
//
// ⚠️ PERFORMANCE (CRÍTICO — RESPONSABILIDAD DEL ENGINE):
// - NO recalcular fingerprint en cada frame o rebuild.
// - Calcular SOLO cuando cambie updatedAt o versión del asset.
// - En bootstrap masivo (miles de activos), ejecutar fuera del hilo UI.
//
// ⚠️ ESTABILIDAD:
// - _normalizeMap garantiza orden de keys.
// - jsonEncode de Dart respeta ese orden → serialización determinística.
//
// ENTERPRISE NOTES:
// ADAPTADO (2026-03): Fase 3 — Asset Schema v1.3.4. buildFullDocument,
//   fromFullDocument y auto-detección en fromFirestoreMap.
// ============================================================================

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import '../models/asset/special/asset_vehiculo_model.dart';
import '../models/insurance/insurance_policy_model.dart';
import 'asset_document_builder.dart';
import 'asset_sync_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ADAPTER
// ─────────────────────────────────────────────────────────────────────────────

class AssetFirestoreAdapter {
  const AssetFirestoreAdapter();

  // ==========================================================================
  // ESCRITURA — Model → Outbox
  // ==========================================================================

  Map<String, dynamic> toOutboxPayload(AssetVehiculoModel model) {
    final payload = <String, dynamic>{
      'assetId': model.assetId,
      'refCode': model.refCode,
      'placa': model.placa,
      'marca': model.marca,
      'modelo': model.modelo,
      'anio': model.anio,
      'color': model.color,
      'engineDisplacement': model.engineDisplacement,
      'vin': model.vin,
      'engineNumber': model.engineNumber,
      'chassisNumber': model.chassisNumber,
      'line': model.line,
      'serviceType': model.serviceType,
      'vehicleClass': model.vehicleClass,
      'bodyType': model.bodyType,
      'fuelType': model.fuelType,
      'passengerCapacity': model.passengerCapacity,
      'loadCapacityKg': model.loadCapacityKg,
      'grossWeightKg': model.grossWeightKg,
      'axles': model.axles,
      'transitAuthority': model.transitAuthority,
      'initialRegistrationDate': model.initialRegistrationDate,
      'propertyLiens': model.propertyLiens,
      'runtMetaJson': model.runtMetaJson,
      'createdAt': _dateToIso(model.createdAt),
      'updatedAt': _dateToIso(model.updatedAt),
    };

    assertPayloadIsJsonSafe(payload);
    return payload;
  }

  // ==========================================================================
  // ESCRITURA v1.3.4 — Model → Firestore documento completo
  // ==========================================================================

  /// Construye el documento Firestore v1.3.4 completo delegando a
  /// [AssetDocumentBuilder]. El dispatcher recibe [AssetDocumentResult]
  /// con `metadata.payloadHash` ya inyectado — no recalcula el hash.
  AssetDocumentResult buildFullDocument({
    required AssetVehiculoModel vehiculoModel,
    required List<InsurancePolicyModel> policies,
    required DateTime now,
    int domainVersion = 1,
  }) {
    return AssetDocumentBuilder.buildFullDocument(
      vehiculoModel: vehiculoModel,
      policies: policies,
      now: now,
      domainVersion: domainVersion,
    );
  }

  // ==========================================================================
  // LECTURA — Firestore → Model
  // ==========================================================================

  /// Auto-detecta schema y delega al parser correcto.
  /// - Contiene 'domains' → [fromFullDocument] (v1.3.4)
  /// - Sin 'domains' → legacy [AssetVehiculoModel.fromFirestore]
  ///
  /// La capa superior SIEMPRE recibe [AssetVehiculoModel] — sin bifurcación.
  AssetVehiculoModel fromFirestoreMap(
    String assetId,
    Map<String, dynamic> data,
  ) {
    if (data.containsKey('domains')) {
      return fromFullDocument(assetId, data);
    }
    return AssetVehiculoModel.fromFirestore(assetId, data);
  }

  /// Reconstruye [AssetVehiculoModel] desde un documento v1.3.4.
  ///
  /// Estrategia:
  /// - Caso normal: lee `rawSnapshots.vehicle` (snapshot completo).
  /// - Caso truncado: detectado por `rawSnapshots.snapshotSummary.truncated == true`.
  ///   Fallback a `identity` (assetId, refCode, placa) con defaults para
  ///   campos no disponibles. Isar (fuente local) prevalece — este modelo
  ///   degradado no debe sobreescribir el local.
  AssetVehiculoModel fromFullDocument(
    String assetId,
    Map<String, dynamic> data,
  ) {
    final rawSnapshots = data['rawSnapshots'];

    // ── Detectar truncamiento ────────────────────────────────────────────────
    final isTruncated = rawSnapshots is Map &&
        rawSnapshots['snapshotSummary'] is Map &&
        rawSnapshots['snapshotSummary']['truncated'] == true;

    if (!isTruncated && rawSnapshots is Map) {
      final vehicle = rawSnapshots['vehicle'];
      if (vehicle is Map<String, dynamic>) {
        // Caso normal: snapshot completo disponible.
        return AssetVehiculoModel.fromFirestore(assetId, vehicle);
      }
    }

    // ── Fallback truncado: modelo degradado con campos mínimos ───────────────
    // NO usar fromFirestore() / fromJson() aquí: el mapa incompleto causa
    // TypeCastError en los campos required (marca, modelo, anio) del
    // generado fromJson. Construir directamente con defaults seguros.
    //
    // INVARIANTE: Isar (fuente local) prevalece sobre este modelo degradado.
    // El dispatcher NO debe persistir este resultado en Isar; solo sirve para
    // actualizar el fingerprint en memoria vía markAsApplied().
    final identity = data['identity'];
    final refCode =
        identity is Map ? (identity['refCode'] as String?) ?? '' : '';
    final placa = identity is Map ? (identity['placa'] as String?) ?? '' : '';

    if (kDebugMode) {
      debugPrint(
        '[AssetFirestoreAdapter][WARN] fromFullDocument: rawSnapshots truncado. '
        'Modelo degradado para assetId=$assetId placa=$placa. '
        'Fuente Isar local prevalece — NO sobreescribir.',
      );
    }

    return AssetVehiculoModel(
      assetId: assetId,
      refCode: refCode,
      placa: placa,
      marca: '',
      modelo: '',
      anio: 0,
    );
  }

  // ==========================================================================
  // FINGERPRINT — SHA-256 determinístico
  // ==========================================================================

  /// MANTENIMIENTO: si se añade un campo a [AssetVehiculoModel], añadirlo
  /// aquí también. El test de fingerprint fallará si se omite un campo nuevo.
  AssetPayloadFingerprint computeFingerprint(AssetVehiculoModel model) {
    final rawMap = <String, dynamic>{
      'anio': model.anio,
      'assetId': model.assetId,
      'axles': model.axles,
      'bodyType': model.bodyType,
      'chassisNumber': model.chassisNumber,
      'color': model.color,
      'engineDisplacement': model.engineDisplacement,
      'engineNumber': model.engineNumber,
      'fuelType': model.fuelType,
      'grossWeightKg': model.grossWeightKg,
      'initialRegistrationDate': model.initialRegistrationDate,
      'line': model.line,
      'loadCapacityKg': model.loadCapacityKg,
      'marca': model.marca,
      'modelo': model.modelo,
      'passengerCapacity': model.passengerCapacity,
      'placa': model.placa,
      'propertyLiens': model.propertyLiens,
      'refCode': model.refCode,
      'runtMetaJson': model.runtMetaJson,
      'serviceType': model.serviceType,
      'transitAuthority': model.transitAuthority,
      'updatedAt': _dateToIso(model.updatedAt),
      'vehicleClass': model.vehicleClass,
      'vin': model.vin,
    };

    final normalized = _normalizeMap(rawMap);

    /// jsonEncode mantiene el orden del mapa → determinismo garantizado
    final jsonString = jsonEncode(normalized);

    final hash = sha256.convert(utf8.encode(jsonString)).toString();

    return AssetPayloadFingerprint(hash);
  }

  // ==========================================================================
  // FECHAS
  // ==========================================================================

  String? _dateToIso(DateTime? dt) => dt?.toUtc().toIso8601String();

  // ==========================================================================
  // NORMALIZACIÓN
  // ==========================================================================

  Map<String, dynamic> _normalizeMap(Map<String, dynamic> input) {
    final keys = input.keys.toList()..sort();

    final result = <String, dynamic>{};
    for (final key in keys) {
      result[key] = _normalizeValue(input[key]);
    }

    return result;
  }

  dynamic _normalizeValue(dynamic value) {
    if (value == null) return '';

    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    }

    if (value is Timestamp) {
      return value.toDate().toUtc().toIso8601String();
    }

    if (value is Map) {
      final casted = <String, dynamic>{};
      for (final e in value.entries) {
        casted[e.key.toString()] = e.value;
      }
      return _normalizeMap(casted);
    }

    if (value is List) {
      return value.map(_normalizeValue).toList();
    }

    if (value is num || value is bool) {
      return value.toString();
    }

    if (value is String) {
      return value;
    }

    return value.toString();
  }

  // ==========================================================================
  // GUARDRAILS
  // ==========================================================================

  void assertPayloadIsJsonSafe(Map<String, dynamic> payload) {
    if (!kDebugMode) return;
    _assertJsonSafe(payload, path: 'root');
  }

  void _assertJsonSafe(dynamic value, {required String path}) {
    if (value == null || value is String || value is num || value is bool) {
      return;
    }

    assert(
      value is! Timestamp,
      '[AssetFirestoreAdapter] $path contiene Timestamp (NO JSON-safe)',
    );

    if (value is Map) {
      for (final e in value.entries) {
        _assertJsonSafe(e.value, path: '$path.${e.key}');
      }
      return;
    }

    if (value is List) {
      for (int i = 0; i < value.length; i++) {
        _assertJsonSafe(value[i], path: '$path[$i]');
      }
      return;
    }

    assert(
      false,
      '[AssetFirestoreAdapter] $path contiene tipo no JSON-safe: ${value.runtimeType}',
    );
  }
}
