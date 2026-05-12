// ============================================================================
// lib/domain/value/migration/legacy_migration_warning.dart
// Value objects de dominio para reportar incidencias en parse / mapping
// tolerante de datos legacy (capability specs, roles, intents).
// ============================================================================
// QUÉ HACE:
//   - Define warnings tipados con discriminator cerrado.
//   - Define LegacyParseResult<T> que envuelve un valor recuperado + lista de
//     warnings emitidos durante el parse/mapping.
//   - Define LegacyParseException para casos catastróficos donde NO se puede
//     recuperar un mínimo válido (ej: insuranceLines tras filtrado queda vacío).
//
// QUÉ NO HACE:
//   - NO loguea ni persiste warnings; ese es trabajo del caller (telemetría,
//     audit trail, alerta a admin).
//   - NO modifica los VOs ni los specs; solo describe lo que se descartó.
//
// PRINCIPIO:
//   - Salvar lo salvable, reportar lo descartado, fallar fuerte cuando no
//     queda nada salvable.
//
// HISTORIA:
//   Originalmente vivía en `lib/data/adapters/capability/legacy_migration_warning.dart`
//   por accidente histórico (creado junto al adapter de capability). Movido
//   a domain en 2026-05 para que el mapper de onboarding (domain) pueda
//   reusarlo sin violar la regla de capas (domain no importa data).
//   El path antiguo se mantiene como re-export shim por backward-compat.
// ============================================================================

/// Tipo discriminado de warning emitido durante parse legacy o intent mapping.
enum LegacyMigrationWarningKind {
  /// businessCategoryId presente pero con sintaxis inválida (no parseable
  /// como BusinessCategoryRef). Campo descartado.
  malformedBusinessCategory,

  /// regulatorLicense presente pero con sintaxis inválida (no parseable
  /// como RegulatorLicenseRef). Campo descartado.
  malformedRegulatorLicense,

  /// insuranceLines contenía un wire name desconocido (no en el catálogo
  /// vigente de InsuranceLine). Elemento descartado; el resto se conservó.
  unknownInsuranceLine,

  /// market presente pero con wire name desconocido. Campo descartado.
  /// Aplica a ProviderSpec.market e InsurerSpec.market.
  unknownMarket,

  /// assetTypeIds legacy contenía un wire desconocido (no mapeable a
  /// AssetRegistrationType). Elemento descartado; el resto se conservó.
  unknownLegacyAssetType,

  /// coverageCities legacy contenía un path con sintaxis inválida (no
  /// parseable como CoverageCityPath). Elemento descartado; el resto
  /// se conservó.
  malformedCoverageCity,

  /// branchId legacy estaba presente pero quedaba vacío tras trim
  /// (whitespace-only / blanco). Campo descartado.
  malformedBranchId,

  /// El providerProfile legacy declaraba `assetSegmentIds` no-vacío.
  /// El modelo v3 no representa este nivel de granularidad; los valores
  /// se descartan en migración.
  unmigrableAssetSegmentIds,

  /// El providerProfile legacy declaraba `offeringLineIds` no-vacío.
  /// El modelo v3 no representa este nivel de granularidad; los valores
  /// se descartan en migración.
  unmigrableOfferingLineIds,

  /// Un string en `Membership.roles` legacy no coincide con ningún
  /// MembershipRole conocido (post-normalización case-insensitive y trim).
  /// El item se descarta de la lista parseada; los reconocidos se conservan.
  unknownLegacyRole,

  /// Un string en `Membership.roles` legacy era vacío o solo whitespace.
  /// Item descartado.
  blankLegacyRole,
}

/// Warning estructurado emitido por un adapter legacy o por el mapper de
/// intent. Contiene el origen del problema (campo) y el valor crudo
/// descartado, para diagnóstico.
class LegacyMigrationWarning {
  final LegacyMigrationWarningKind kind;

  /// Path del campo afectado, formato dot-notation. Ej:
  /// 'providerSpec.businessCategoryId', 'insurerSpec.insuranceLines[2]'.
  final String fieldPath;

  /// Valor crudo (como vino en el JSON legacy) que se descartó. Útil para
  /// soporte y telemetría. Puede ser null si el problema es ausencia.
  final String? rawValue;

  /// Mensaje legible orientado a operador / admin.
  final String message;

  const LegacyMigrationWarning({
    required this.kind,
    required this.fieldPath,
    required this.message,
    this.rawValue,
  });

  Map<String, dynamic> toMap() => {
        'kind': kind.name,
        'fieldPath': fieldPath,
        'message': message,
        if (rawValue != null) 'rawValue': rawValue,
      };

  @override
  String toString() =>
      'LegacyMigrationWarning(${kind.name} @ $fieldPath: $message'
      '${rawValue != null ? ' [raw="$rawValue"]' : ''})';
}

/// Resultado del parse tolerante: el valor recuperado + warnings emitidos.
/// El caller decide qué hacer con los warnings (loggear, persistir,
/// notificar al admin, ignorar si la cantidad es aceptable).
class LegacyParseResult<T> {
  final T spec;
  final List<LegacyMigrationWarning> warnings;

  const LegacyParseResult({
    required this.spec,
    required this.warnings,
  });

  bool get hasWarnings => warnings.isNotEmpty;
  int get warningCount => warnings.length;
}

/// Lanzada cuando el dato legacy es irrecuperable: tras descartar campos
/// malformados, lo que queda no satisface las invariantes mínimas del spec
/// (ej: insuranceLines vacía tras filtrado, providerType ausente).
class LegacyParseException implements Exception {
  final String reason;

  /// Warnings parciales acumulados antes del fallo. Útiles para diagnóstico.
  final List<LegacyMigrationWarning> partialWarnings;

  const LegacyParseException(
    this.reason, {
    this.partialWarnings = const [],
  });

  @override
  String toString() =>
      'LegacyParseException: $reason '
      '(${partialWarnings.length} warnings parciales)';
}
