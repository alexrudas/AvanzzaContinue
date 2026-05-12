// ============================================================================
// lib/core/telemetry/legacy_membership_migration_telemetry.dart
// Facade tipado para registrar el ciclo de vida de la migración de
// providerProfiles legacy (Membership) → capabilityProfiles (Workspace).
// ============================================================================
// QUÉ HACE:
//   - Define 3 eventos canónicos del migrator:
//       · 'legacy_membership_migration_success'   (profile migrado limpio)
//       · 'legacy_membership_migration_warning'   (profile migrado con warnings)
//       · 'legacy_membership_migration_error'     (profile irrecuperable, skip)
//   - Sigue el patrón de CapabilityProfileTelemetry: emitter reemplazable,
//     debugPrint en debug, Analytics.track en release, never-throws.
//   - Sanitiza payloads (truncado de strings, serialización de listas/maps).
//
// QUÉ NO HACE:
//   - NO mantiene contadores en memoria. El migrator devuelve su propio
//     reporte estructurado (MembershipMigrationResult); este facade solo
//     deja rastro observable a nivel de telemetry pipeline.
//   - NO decide políticas (skip vs. abort). El migrator decide y solo
//     informa al facade del outcome.
//   - NO infiere ni toca relaciones con activos (AssetActorLink, Portfolio):
//     fuera de alcance del ítem 6.
//
// PAYLOAD MÍNIMO POR EVENTO:
//   - orgId
//   - membershipId         (compound: '${userId}@${orgId}')
//   - sourceProfileIndex   (índice 0-based en membership.providerProfiles)
//   - sourceProfile        (snapshot serializado, truncado)
//   - warnings[]           (lista canónica LegacyMigrationWarning.toMap())
//   - error                (solo en evento error; razón legible)
//   - timestamp            (UTC ISO 8601)
// ============================================================================

import 'package:flutter/foundation.dart';

import 'analytics.dart';

/// Firma del emitter. Reemplazable en tests para capturar eventos.
typedef LegacyMembershipMigrationEmitter = void Function(
  String event,
  Map<String, dynamic> props,
);

class LegacyMembershipMigrationTelemetry {
  LegacyMembershipMigrationTelemetry._();

  // Eventos canónicos.
  static const String eventSuccess = 'legacy_membership_migration_success';
  static const String eventWarning = 'legacy_membership_migration_warning';
  static const String eventError = 'legacy_membership_migration_error';

  /// Evento emitido cuando el parser tolerante de roles legacy descarta
  /// strings (case desconocido tras normalización, blank, o no en catálogo).
  /// El facade abarca todo el ciclo de lectura legacy de Membership, no solo
  /// la migración de capabilityProfiles.
  static const String eventRolesWarning =
      'legacy_membership_roles_warning';

  /// Evento emitido cuando `mapIntentToCanonical` produce warnings durante
  /// onboarding (típicamente: businessCategoryId malformado en Q3 provider).
  /// Lo emite [CompleteOnboardingUC] tras invocar el mapper. NO duplica el
  /// path estricto: si el mapper se invocó en otro flujo (tests, dry-run),
  /// la telemetría solo se emite explícitamente desde el caller que lo desee.
  static const String eventIntentMappingWarning =
      'legacy_membership_intent_mapping_warning';

  static const int _kMaxStringLength = 240;

  // ─────────────────────────────────────────────────────────────────────────
  // EMITTER (reemplazable en tests)
  // ─────────────────────────────────────────────────────────────────────────

  static LegacyMembershipMigrationEmitter _emitter = defaultEmitter;

  static LegacyMembershipMigrationEmitter get emitter => _emitter;

  @visibleForTesting
  static void debugSetEmitter(LegacyMembershipMigrationEmitter e) {
    _emitter = e;
  }

  @visibleForTesting
  static void resetEmitter() {
    _emitter = defaultEmitter;
  }

  static void defaultEmitter(String event, Map<String, dynamic> props) {
    if (kDebugMode) {
      debugPrint('[LegacyMembershipMigrationTelemetry] $event $props');
      return;
    }
    try {
      Analytics.track(event, props);
    } catch (_) {
      // Silencio intencional: la telemetría no puede romper al migrator.
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // API PÚBLICA
  // ─────────────────────────────────────────────────────────────────────────

  /// Profile migrado limpio (0 warnings).
  static void recordSuccess({
    required String orgId,
    required String membershipId,
    required int sourceProfileIndex,
    Object? sourceProfile,
  }) {
    _safeEmit(eventSuccess, {
      'orgId': _truncate(orgId),
      'membershipId': _truncate(membershipId),
      'sourceProfileIndex': sourceProfileIndex,
      if (sourceProfile != null)
        'sourceProfile': _stringifyRaw(sourceProfile),
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });
  }

  /// Profile migrado con warnings (datos parcialmente recuperados).
  static void recordWarning({
    required String orgId,
    required String membershipId,
    required int sourceProfileIndex,
    required List<Map<String, dynamic>> warnings,
    Object? sourceProfile,
  }) {
    if (warnings.isEmpty) return;
    _safeEmit(eventWarning, {
      'orgId': _truncate(orgId),
      'membershipId': _truncate(membershipId),
      'sourceProfileIndex': sourceProfileIndex,
      'warningCount': warnings.length,
      'warnings': _stringifyRaw(warnings),
      if (sourceProfile != null)
        'sourceProfile': _stringifyRaw(sourceProfile),
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });
  }

  /// Warning emitido por el parser de roles legacy. NO bloquea la lectura
  /// (los roles válidos se conservan). Sirve para detectar drift en datos
  /// legacy y planificar limpieza.
  ///
  /// [warnings] es la lista cruda de [LegacyMigrationWarning.toMap()] con
  /// kinds `unknownLegacyRole` o `blankLegacyRole`.
  static void recordRolesWarning({
    required List<Map<String, dynamic>> warnings,
    String? orgId,
    String? membershipId,
  }) {
    if (warnings.isEmpty) return;
    _safeEmit(eventRolesWarning, {
      'warningCount': warnings.length,
      'warnings': _stringifyRaw(warnings),
      if (orgId != null) 'orgId': _truncate(orgId),
      if (membershipId != null) 'membershipId': _truncate(membershipId),
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });
  }

  /// Warning emitido por CompleteOnboardingUC cuando `mapIntentToCanonical`
  /// produjo warnings durante el bootstrap del workspace. Sirve para detectar
  /// drift en datos del onboarding state (ej: businessCategoryId mal-formado
  /// capturado en Q3) y monitorear calidad del flujo demo.
  static void recordIntentMappingWarning({
    required List<Map<String, dynamic>> warnings,
    String? orgId,
    String? membershipId,
  }) {
    if (warnings.isEmpty) return;
    _safeEmit(eventIntentMappingWarning, {
      'warningCount': warnings.length,
      'warnings': _stringifyRaw(warnings),
      if (orgId != null) 'orgId': _truncate(orgId),
      if (membershipId != null) 'membershipId': _truncate(membershipId),
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });
  }

  /// Profile irrecuperable: el migrator hace skip y deja rastro detallado.
  static void recordError({
    required String orgId,
    required String membershipId,
    required int sourceProfileIndex,
    required String error,
    Object? sourceProfile,
    List<Map<String, dynamic>>? partialWarnings,
  }) {
    _safeEmit(eventError, {
      'orgId': _truncate(orgId),
      'membershipId': _truncate(membershipId),
      'sourceProfileIndex': sourceProfileIndex,
      'error': _truncate(error),
      if (sourceProfile != null)
        'sourceProfile': _stringifyRaw(sourceProfile),
      if (partialWarnings != null && partialWarnings.isNotEmpty) ...{
        'partialWarningCount': partialWarnings.length,
        'partialWarnings': _stringifyRaw(partialWarnings),
      },
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS INTERNOS
  // ─────────────────────────────────────────────────────────────────────────

  static void _safeEmit(String event, Map<String, dynamic> props) {
    try {
      _emitter(event, props);
    } catch (_) {
      // Defensa adicional contra emitters custom que lancen.
    }
  }

  static String _truncate(String input) {
    if (input.length <= _kMaxStringLength) return input;
    return '${input.substring(0, _kMaxStringLength)}…[truncated]';
  }

  static String _stringifyRaw(Object value) {
    if (value is String) return _truncate(value);
    return _truncate(value.toString());
  }
}
