// ============================================================================
// lib/domain/entities/asset/asset_snapshot.dart
// CAPTURA INMUTABLE DE DATOS EXTERNOS (RUNT, CATASTRO, etc.)
//
// - Preserva datos RAW sin transformacion
// - Para auditoria y trazabilidad
// - Hash determinista para deteccion de cambios
//
// PERSISTENCIA:
// - NO es @Collection Isar (no se persiste directamente).
// - Se embebe como JSON dentro de AssetDraft (DraftSnapshotConverter).
// - Si en el futuro se requiere persistir snapshots independientes,
//   agregar @isar.Collection con isarId = fastHash(id).
//
// JSON-SAFE:
// - payloadRaw y payloadNormalized SOLO pueden contener:
//   null, bool, num, String, List, Map<String, dynamic>.
// - La sanitizacion ocurre en Infra (Repository/DataSource) antes de
//   construir AssetSnapshot. Este modelo asume datos ya limpios.
// ============================================================================

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../converters/safe_datetime_converter.dart';

part 'asset_snapshot.freezed.dart';
part 'asset_snapshot.g.dart';

// ============================================================================
// SNAPSHOT SOURCE
// ============================================================================

/// Fuente del snapshot.
enum SnapshotSource {
  @JsonValue('RUNT')
  runt,

  @JsonValue('CATASTRO')
  catastro,

  @JsonValue('MANUAL')
  manual,

  @JsonValue('API_EXTERNA')
  apiExterna,

  @JsonValue('IMPORT')
  import_,
}

// ============================================================================
// CANONICALIZACION PARA HASH DETERMINISTA
// ============================================================================

/// Canonicaliza un valor JSON para garantizar hash determinista.
///
/// Reglas:
/// - Map: valida que TODAS las llaves sean String (lanza FormatException si no).
///   Ordena llaves lexicograficamente, canonicaliza valores recursivamente.
/// - List: mantiene orden original, canonicaliza cada elemento.
/// - Primitivo/null: retorna sin cambios.
/// - Cualquier otro tipo: lanza FormatException (no JSON-safe).
///
/// Precondicion: El payload debe ser JSON-safe (sanitizado en Infra).
dynamic _canonicalize(dynamic input) {
  if (input == null) return null;

  if (input is Map) {
    // Validar que todas las llaves sean String
    for (final key in input.keys) {
      if (key is! String) {
        throw FormatException(
          'Non-string key in payload: $key (${key.runtimeType})',
        );
      }
    }

    // Ordenar llaves lexicograficamente
    final sortedKeys = input.keys.cast<String>().toList()..sort();

    // Construir nuevo Map en orden
    final result = <String, dynamic>{};
    for (final key in sortedKeys) {
      result[key] = _canonicalize(input[key]);
    }
    return result;
  }

  if (input is List) {
    return input.map(_canonicalize).toList();
  }

  // Primitivos JSON-safe: solo bool, num, String
  if (input is bool || input is num || input is String) {
    return input;
  }

  throw FormatException('Non-JSON-safe value in payload: ${input.runtimeType}');
}

// ============================================================================
// ASSET SNAPSHOT
// ============================================================================

/// Captura inmutable de datos externos.
///
/// - payloadRaw: JSON crudo de la fuente (sin transformar)
/// - payloadNormalized: Datos normalizados para crear AssetContent
/// - hash: SHA-256 canonicalizado para deteccion de cambios
@Freezed()
abstract class AssetSnapshot with _$AssetSnapshot {
  const AssetSnapshot._();

  const factory AssetSnapshot({
    /// ID unico del snapshot (UUID v4)
    required String id,

    /// ID del asset asociado (null si es pre-registro)
    String? assetId,

    /// Fuente de los datos
    required SnapshotSource source,

    /// Payload RAW de la fuente (JSON crudo sin transformar).
    /// JSON-SAFE: solo null, bool, num, String, List, Map.
    required Map<String, dynamic> payloadRaw,

    /// Payload normalizado (listo para crear AssetContent).
    /// JSON-SAFE: solo null, bool, num, String, List, Map.
    required Map<String, dynamic> payloadNormalized,

    /// Version del schema de normalizacion
    @Default('1.0') String schemaVersion,

    /// Fecha de obtencion (UTC)
    @SafeDateTimeConverter() required DateTime fetchedAt,

    /// Hash SHA-256 del payloadRaw canonicalizado (para deteccion de cambios)
    required String hash,

    /// Metadatos adicionales (requestId, durationMs, etc.)
    @Default(<String, dynamic>{}) Map<String, dynamic> metadata,
  }) = _AssetSnapshot;

  factory AssetSnapshot.fromJson(Map<String, dynamic> json) =>
      _$AssetSnapshotFromJson(json);

  // ==========================================================================
  // FACTORY: Crear con hash automatico
  // ==========================================================================

  /// Crea un snapshot calculando el hash automaticamente.
  factory AssetSnapshot.create({
    required String id,
    String? assetId,
    required SnapshotSource source,
    required Map<String, dynamic> payloadRaw,
    required Map<String, dynamic> payloadNormalized,
    String schemaVersion = '1.0',
    Map<String, dynamic> metadata = const {},
  }) {
    return AssetSnapshot(
      id: id,
      assetId: assetId,
      source: source,
      payloadRaw: payloadRaw,
      payloadNormalized: payloadNormalized,
      schemaVersion: schemaVersion,
      fetchedAt: DateTime.now().toUtc(),
      hash: _computeHash(payloadRaw),
      metadata: metadata,
    );
  }

  /// Calcula SHA-256 del payload canonicalizado para deteccion de cambios.
  static String _computeHash(Map<String, dynamic> payload) {
    final canonicalized = _canonicalize(payload) as Object?;
    final jsonStr = jsonEncode(canonicalized);
    final bytes = utf8.encode(jsonStr);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // ==========================================================================
  // METODOS
  // ==========================================================================

  /// Verifica si otro payload es diferente (cambio desde esta captura).
  bool hasChanged(Map<String, dynamic> newPayload) {
    final newHash = _computeHash(newPayload);
    return newHash != hash;
  }
}
