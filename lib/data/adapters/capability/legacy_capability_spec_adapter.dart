// ============================================================================
// lib/data/adapters/capability/legacy_capability_spec_adapter.dart
// LegacyCapabilitySpecAdapter — parse tolerante de ProviderSpec / InsurerSpec
// desde JSON legacy con campos potencialmente malformados.
// ============================================================================
// QUÉ HACE:
//   - Construye specs de capability desde JSON legacy salvando lo salvable.
//   - Campos OPCIONALES con sintaxis inválida (businessCategoryId,
//     regulatorLicense, market) se descartan emitiendo un warning tipado.
//   - InsurerSpec.insuranceLines: filtra elementos desconocidos (warning por
//     cada uno) y conserva los reconocidos. Si tras filtrado queda vacío,
//     lanza LegacyParseException — ese estado es irrecuperable.
//   - Campos REQUERIDOS estructurales (providerType, isCarrier) siguen siendo
//     estrictos — su ausencia o invalidez lanza ArgumentError o
//     LegacyParseException según el caso.
//
// QUÉ NO HACE:
//   - NO modifica ProviderSpec.fromJson ni InsurerSpec.fromJson; esos siguen
//     siendo el path estricto canónico para datos confiables.
//   - NO loguea warnings; los retorna en LegacyParseResult para que el
//     caller (migrador, telemetría) decida.
//   - NO persiste el resultado; solo lo construye en memoria.
//
// CUÁNDO USARLO:
//   - Migración de datos legacy de Membership.providerProfiles (v3 fase 1)
//     hacia Workspace.capabilityProfiles.
//   - Lectura de stores externos cuyo schema no está bajo nuestro control.
//   - Importación de datos de terceros donde el formato ha drifted.
//
// CUÁNDO NO USARLO:
//   - Lectura de datos recientes producidos por la app actual: usar
//     ProviderSpec.fromJson / InsurerSpec.fromJson directos. El adapter
//     legacy oculta corrupción reciente que debería detectarse.
// ============================================================================

import '../../../core/telemetry/capability_profile_telemetry.dart';
import '../../../domain/shared/enums/asset_type.dart';
import '../../../domain/value/capability/insurance_line.dart';
import '../../../domain/value/capability/insurer_spec.dart';
import '../../../domain/value/capability/provider_spec.dart';
import '../../../domain/value/capability/provider_type.dart';
import '../../../domain/value/capability/refs/business_category_ref.dart';
import '../../../domain/value/capability/refs/regulator_license_ref.dart';
import 'legacy_migration_warning.dart';

class LegacyCapabilitySpecAdapter {
  const LegacyCapabilitySpecAdapter._();

  /// Parse tolerante de ProviderSpec desde JSON legacy.
  ///
  /// Política:
  /// - `providerType` (requerido): ausencia o valor desconocido ⇒ throws
  ///   [ArgumentError] (igual que el path estricto). Sin él no hay spec.
  /// - `market` (opcional): wire name desconocido ⇒ descartado con warning
  ///   [LegacyMigrationWarningKind.unknownMarket].
  /// - `businessCategoryId` (opcional): sintaxis inválida ⇒ descartado con
  ///   warning [LegacyMigrationWarningKind.malformedBusinessCategory].
  ///
  /// Telemetría: si la migración produce warnings, se emite el evento
  /// `capability_profiles_migration_warning` (best-effort, never throws).
  /// El comportamiento de retorno NO cambia.
  static LegacyParseResult<ProviderSpec> providerSpecFromLegacyJson(
    Map<String, dynamic> json, {
    String? orgId,
  }) {
    final warnings = <LegacyMigrationWarning>[];

    final providerTypeRaw = json['providerType'];
    if (providerTypeRaw is! String) {
      throw ArgumentError(
        'LegacyCapabilitySpecAdapter.providerSpecFromLegacyJson: '
        'providerType requerido (String wire name)',
      );
    }
    // ProviderTypeX.fromWire ya lanza ArgumentError en wire desconocido,
    // que coincide con la política estricta para campo requerido.
    final providerType = ProviderTypeX.fromWire(providerTypeRaw);

    AssetRegistrationType? market;
    final marketRaw = json['market'];
    if (marketRaw is String) {
      // AssetRegistrationTypeWire.fromWire es tolerante por contrato del
      // archivo origen (cae a 'otro'). Para nuestro propósito legacy, si el
      // valor original era un wireName conocido (vehiculo/inmueble/...), el
      // resultado es fiel. Si era basura, vendrá 'otro' — y eso ya es una
      // forma legítima de "tipo desconocido" en el catálogo. NO emitimos
      // warning por este caso porque el catálogo lo cubre explícitamente.
      market = AssetRegistrationTypeWire.fromWire(marketRaw);
    }

    BusinessCategoryRef? categoryRef;
    final categoryRaw = json['businessCategoryId'];
    if (categoryRaw is String) {
      categoryRef = BusinessCategoryRef.tryParse(categoryRaw);
      if (categoryRef == null) {
        warnings.add(
          LegacyMigrationWarning(
            kind: LegacyMigrationWarningKind.malformedBusinessCategory,
            fieldPath: 'providerSpec.businessCategoryId',
            rawValue: categoryRaw,
            message:
                'businessCategoryId no cumple sintaxis snake_case ASCII; campo descartado',
          ),
        );
      }
    }

    final spec = ProviderSpec(
      providerType: providerType,
      market: market,
      businessCategoryRef: categoryRef,
    );

    _emitMigrationTelemetry(
      warnings: warnings,
      orgId: orgId,
      specKind: 'provider',
    );
    return LegacyParseResult(spec: spec, warnings: warnings);
  }

  /// Parse tolerante de InsurerSpec desde JSON legacy.
  ///
  /// Política:
  /// - `insuranceLines` (requerido): debe ser List. Wire names desconocidos
  ///   se filtran con warning [LegacyMigrationWarningKind.unknownInsuranceLine]
  ///   por elemento. Duplicados se eliminan silenciosamente (preservando el
  ///   primer ocurrente). Si tras filtrado queda vacío ⇒ throws
  ///   [LegacyParseException] (irrecuperable). En el path irrecuperable,
  ///   los warnings parciales se emiten también vía telemetría antes
  ///   del throw.
  /// - `isCarrier` (requerido): ausencia o tipo incorrecto ⇒ throws
  ///   [ArgumentError]. Sin él no hay spec con semántica clara.
  /// - `market` (opcional): wire name desconocido ⇒ se conserva como `otro`
  ///   por contrato del enum origen (sin warning).
  /// - `regulatorLicense` (opcional): sintaxis inválida ⇒ descartado con
  ///   warning [LegacyMigrationWarningKind.malformedRegulatorLicense].
  ///
  /// Telemetría: si hay warnings (camino feliz o irrecuperable), se emite
  /// `capability_profiles_migration_warning` antes de retornar/lanzar.
  static LegacyParseResult<InsurerSpec> insurerSpecFromLegacyJson(
    Map<String, dynamic> json, {
    String? orgId,
  }) {
    final warnings = <LegacyMigrationWarning>[];

    final linesRaw = json['insuranceLines'];
    if (linesRaw is! List) {
      throw ArgumentError(
        'LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson: '
        'insuranceLines requerida (List)',
      );
    }

    final lines = <InsuranceLine>[];
    final seen = <InsuranceLine>{};
    for (var i = 0; i < linesRaw.length; i++) {
      final raw = linesRaw[i];
      if (raw is! String) {
        warnings.add(
          LegacyMigrationWarning(
            kind: LegacyMigrationWarningKind.unknownInsuranceLine,
            fieldPath: 'insurerSpec.insuranceLines[$i]',
            rawValue: raw?.toString(),
            message:
                'elemento de insuranceLines no es String; descartado',
          ),
        );
        continue;
      }
      final parsed = InsuranceLineX.tryFromWire(raw);
      if (parsed == null) {
        warnings.add(
          LegacyMigrationWarning(
            kind: LegacyMigrationWarningKind.unknownInsuranceLine,
            fieldPath: 'insurerSpec.insuranceLines[$i]',
            rawValue: raw,
            message:
                'wire name de InsuranceLine desconocido; elemento descartado',
          ),
        );
        continue;
      }
      if (seen.add(parsed)) {
        lines.add(parsed);
      }
      // Duplicados silenciados — el InsurerSpec exige unicidad y este
      // adapter la garantiza limpiando.
    }

    if (lines.isEmpty) {
      // Antes de lanzar, dejar rastro de los warnings parciales.
      _emitMigrationTelemetry(
        warnings: warnings,
        orgId: orgId,
        specKind: 'insurer',
      );
      throw LegacyParseException(
        'insurerSpecFromLegacyJson: tras filtrar wire names desconocidos, '
        'insuranceLines quedó vacío. Spec irrecuperable.',
        partialWarnings: List.unmodifiable(warnings),
      );
    }

    final isCarrierRaw = json['isCarrier'];
    if (isCarrierRaw is! bool) {
      throw ArgumentError(
        'LegacyCapabilitySpecAdapter.insurerSpecFromLegacyJson: '
        'isCarrier requerido (bool)',
      );
    }

    final marketRaw = json['market'];
    final AssetRegistrationType? market = marketRaw is String
        ? AssetRegistrationTypeWire.fromWire(marketRaw)
        : null;

    RegulatorLicenseRef? licenseRef;
    final licenseRaw = json['regulatorLicense'];
    if (licenseRaw is String) {
      licenseRef = RegulatorLicenseRef.tryParse(licenseRaw);
      if (licenseRef == null) {
        warnings.add(
          LegacyMigrationWarning(
            kind: LegacyMigrationWarningKind.malformedRegulatorLicense,
            fieldPath: 'insurerSpec.regulatorLicense',
            rawValue: licenseRaw,
            message:
                'regulatorLicense no cumple sintaxis (uppercase A-Z 0-9 . -, ≤32 chars); campo descartado',
          ),
        );
      }
    }

    final spec = InsurerSpec(
      insuranceLines: lines,
      isCarrier: isCarrierRaw,
      market: market,
      regulatorLicenseRef: licenseRef,
    );

    _emitMigrationTelemetry(
      warnings: warnings,
      orgId: orgId,
      specKind: 'insurer',
    );
    return LegacyParseResult(spec: spec, warnings: warnings);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS INTERNOS
  // ─────────────────────────────────────────────────────────────────────────

  /// Emite telemetría si la lista de [warnings] no está vacía. No-op en el
  /// caso feliz (sin warnings) — ese path es el éxito y no debe inundar el
  /// backend de analytics.
  static void _emitMigrationTelemetry({
    required List<LegacyMigrationWarning> warnings,
    required String specKind,
    String? orgId,
  }) {
    if (warnings.isEmpty) return;
    CapabilityProfileTelemetry.recordMigrationWarnings(
      warnings: warnings.map((w) => w.toMap()).toList(growable: false),
      orgId: orgId,
      specKind: specKind,
    );
  }
}
