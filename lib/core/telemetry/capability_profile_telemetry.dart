// ============================================================================
// lib/core/telemetry/capability_profile_telemetry.dart
// CapabilityProfileTelemetry — facade tipado para registrar errores de
// parse y warnings de migración de CapabilityProfile.
// ============================================================================
// QUÉ HACE:
//   - Expone dos eventos canónicos:
//       · 'capability_profiles_parse_error'        (lectura corrupta)
//       · 'capability_profiles_migration_warning'  (adapter legacy con warnings)
//   - En kDebugMode emite a debugPrint (legible en consola).
//   - Fuera de debug emite a Analytics.track (best-effort, jamás propaga).
//   - Sanitiza props antes de emitir: trunca strings largos y serializa
//     listas/maps a string corto para no inflar el backend.
//
// QUÉ NO HACE:
//   - NO mantiene contadores en memoria (los eventos son episódicos, no
//     métricas continuas; SyncTelemetry sí lo hace, este caso no lo amerita).
//   - NO decide políticas de negocio. Solo deja rastro.
//   - NO bloquea ni reintenta. Cualquier excepción se silencia.
//
// REGLAS:
//   - Nunca lanzar excepción desde estos métodos.
//   - Nunca silenciar el error original: el caller decide qué hacer
//     (típicamente fallback a [] o retorno de spec saneada).
//   - Toda degradación visible debe pasar por aquí.
//
// SEAM PARA TESTS:
//   - El emitter es reemplazable vía [debugSetEmitter] (anotado
//     @visibleForTesting). Restaurar con [resetEmitter] en tearDown.
// ============================================================================

import 'package:flutter/foundation.dart';

import 'analytics.dart';

/// Origen del parse fallido. Wire-stable (snake_case en .wireValue).
enum CapabilityParseSource {
  isar('isar'),
  firestore('firestore');

  const CapabilityParseSource(this.wireValue);

  final String wireValue;
}

/// Firma del emitter. Reemplazable en tests para capturar los eventos.
typedef CapabilityProfileTelemetryEmitter = void Function(
  String event,
  Map<String, dynamic> props,
);

class CapabilityProfileTelemetry {
  CapabilityProfileTelemetry._();

  // Eventos canónicos.
  static const String eventParseError = 'capability_profiles_parse_error';
  static const String eventMigrationWarning =
      'capability_profiles_migration_warning';

  // Truncate threshold para strings (rawValue, errorMessage). Evita inflar
  // el backend de analytics con payloads grandes.
  static const int _kMaxStringLength = 240;

  // ─────────────────────────────────────────────────────────────────────────
  // EMITTER (reemplazable solo desde tests)
  // ─────────────────────────────────────────────────────────────────────────

  static CapabilityProfileTelemetryEmitter _emitter = defaultEmitter;

  /// Emitter activo. En producción ⇒ [defaultEmitter]. En tests puede
  /// reemplazarse vía [debugSetEmitter] para capturar eventos.
  static CapabilityProfileTelemetryEmitter get emitter => _emitter;

  /// Reemplaza el emitter (uso exclusivo en tests). Restaurar con
  /// [resetEmitter] en tearDown.
  @visibleForTesting
  static void debugSetEmitter(CapabilityProfileTelemetryEmitter e) {
    _emitter = e;
  }

  /// Restaura el emitter por defecto. Llamar en tearDown de los tests.
  @visibleForTesting
  static void resetEmitter() {
    _emitter = defaultEmitter;
  }

  /// Emitter canónico:
  /// - kDebugMode ⇒ debugPrint (legible).
  /// - profile/release ⇒ Analytics.track (best-effort, never throws).
  static void defaultEmitter(String event, Map<String, dynamic> props) {
    if (kDebugMode) {
      debugPrint('[CapabilityProfileTelemetry] $event $props');
      return;
    }
    try {
      Analytics.track(event, props);
    } catch (_) {
      // Silencio intencional: la telemetría no puede romper el caller.
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // API PÚBLICA
  // ─────────────────────────────────────────────────────────────────────────

  /// Registra un error / degradación al parsear capability profiles desde
  /// una fuente persistida (Isar o Firestore).
  ///
  /// Casos canónicos:
  /// - JSON inválido (no parseable como JSON).
  /// - Estructura incorrecta (ej. raíz que no es array).
  /// - Items individuales malformados (kind desconocido, spec inconsistente).
  /// - Mezcla válida + inválida (fallback total a [] por política).
  ///
  /// El caller debe seguir devolviendo `[]` al consumidor — esta función
  /// SOLO deja rastro.
  static void recordParseError({
    required CapabilityParseSource source,
    required String errorMessage,
    String? orgId,
    Object? rawValue,
    String? errorType,
  }) {
    final props = <String, dynamic>{
      'source': source.wireValue,
      'errorMessage': _truncate(errorMessage),
      if (orgId != null) 'orgId': _truncate(orgId),
      if (errorType != null) 'errorType': _truncate(errorType),
      if (rawValue != null) 'rawValue': _stringifyRaw(rawValue),
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
    _safeEmit(eventParseError, props);
  }

  /// Registra warnings emitidos por LegacyCapabilitySpecAdapter durante
  /// migración tolerante. NO cambia el resultado del adapter (que sigue
  /// retornando la spec saneada).
  ///
  /// [warnings] es la lista cruda de [LegacyMigrationWarning.toMap()] del
  /// data layer (no se importa el tipo aquí para mantener telemetry libre
  /// de dependencias del adapter).
  static void recordMigrationWarnings({
    required List<Map<String, dynamic>> warnings,
    String? orgId,
    String? specKind, // 'provider' | 'insurer' | etc, contexto opcional
  }) {
    if (warnings.isEmpty) return; // No-op silencioso si no hay nada que reportar.
    final props = <String, dynamic>{
      'warningCount': warnings.length,
      'warnings': _stringifyRaw(warnings),
      if (orgId != null) 'orgId': _truncate(orgId),
      if (specKind != null) 'specKind': _truncate(specKind),
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
    _safeEmit(eventMigrationWarning, props);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS INTERNOS
  // ─────────────────────────────────────────────────────────────────────────

  static void _safeEmit(String event, Map<String, dynamic> props) {
    try {
      _emitter(event, props);
    } catch (_) {
      // Defensa adicional: si el emitter custom (un test) lanza, no romper
      // el caller. El default emitter ya tiene su propio try/catch.
    }
  }

  static String _truncate(String input) {
    if (input.length <= _kMaxStringLength) return input;
    return '${input.substring(0, _kMaxStringLength)}…[truncated]';
  }

  /// Convierte cualquier valor crudo a una representación String estable
  /// y truncada, para no enviar listas/maps gigantes al backend.
  static String _stringifyRaw(Object value) {
    if (value is String) return _truncate(value);
    return _truncate(value.toString());
  }
}
