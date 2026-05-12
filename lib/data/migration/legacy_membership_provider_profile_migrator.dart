// ============================================================================
// lib/data/migration/legacy_membership_provider_profile_migrator.dart
// LegacyMembershipProviderProfileMigrator — migra providerProfiles legacy
// (Membership) hacia capabilityProfiles (Workspace/Organization).
// ============================================================================
// NOTA SOBRE deprecated_member_use:
//   Este archivo es el ÚNICO consumidor legítimo de
//   `Membership.providerProfiles` en Fase 1. La anotación @Deprecated del
//   campo en MembershipEntity sirve para señalar al resto del código que
//   no lo use; el migrator existe precisamente para drenar ese campo
//   legacy hacia `Organization.capabilityProfiles`.
// ignore_for_file: deprecated_member_use
// ============================================================================
// QUÉ HACE:
//   - Convierte cada `Membership.providerProfiles[i]` (legacy ProviderProfile)
//     en un `CapabilityProfile(kind: provider, providerSpec: ...)` en
//     `Organization.capabilityProfiles`.
//   - Aplica el adapter tolerante (LegacyCapabilitySpecAdapter) para el
//     spec; el migrator se encarga de los campos comunes (assetTypeIds,
//     coverageCities, branchId).
//   - Deduplica por clave estable (kind + providerType + businessCategoryRef).
//   - Emite telemetría episódica vía LegacyMembershipMigrationTelemetry
//     en cada outcome (success / warning / error).
//   - Es STATELESS: método estático puro. No persiste — el caller decide
//     qué hacer con la organization actualizada.
//
// QUÉ NO HACE:
//   - NO infiere ni asigna owner/manager/renter/driver/tenant. Esas son
//     relaciones con activos (AssetActorLink) y pertenecen a otro ítem.
//   - NO modifica PortfolioEntity ni expectedRelationKind. NO toca
//     AssetActorLink ni cualquier relación con activos.
//   - NO usa providerProfiles para deducir relaciones con activos.
//   - NO mezcla dominios: CapabilityProfile (oferta del workspace) ≠
//     relación operativa con un activo concreto.
//   - NO elimina Membership.providerProfiles legacy (Fase 1: lectura dual).
//   - NO persiste cambios. Retorna `OrganizationEntity` actualizada y un
//     reporte estructurado; la persistencia la ejecuta el caller (use case).
//
// PRINCIPIOS:
//   - Pure mapping + dedup, sin side-effects fuera de telemetría.
//   - Cada outcome por providerProfile es independiente: errores en uno
//     NO afectan la migración de los demás.
//   - Datos parcialmente recuperables ⇒ se migran con warnings.
//   - Datos irrecuperables (spec sin providerType, etc.) ⇒ skip + telemetry.
// ============================================================================

import '../../core/telemetry/legacy_membership_migration_telemetry.dart';
import '../../domain/entities/org/organization_entity.dart';
import '../../domain/entities/user/membership_entity.dart';
import '../../domain/entities/user/provider_profile.dart';
import '../../domain/shared/enums/asset_type.dart';
import '../../domain/value/capability/capability_profile.dart';
import '../../domain/value/capability/profile_kind.dart';
import '../../domain/value/capability/provider_spec.dart';
import '../../domain/value/capability/provider_type.dart';
import '../../domain/value/capability/refs/coverage_city_path.dart';
import '../adapters/capability/legacy_capability_spec_adapter.dart';
import '../adapters/capability/legacy_migration_warning.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RESULT TYPES
// ─────────────────────────────────────────────────────────────────────────────

/// Estado individual de cada providerProfile procesado.
enum ProfileMigrationStatus {
  /// Migrado y añadido a capabilityProfiles.
  migrated,

  /// Se descartó porque ya existe un equivalente en la organización.
  duplicate,

  /// El providerProfile no era recuperable (spec irrecuperable, datos
  /// requeridos ausentes); se hizo skip y se emitió telemetry de error.
  error,
}

/// Outcome detallado por cada providerProfile legacy procesado.
class ProfileMigrationOutcome {
  /// Índice 0-based del providerProfile en `Membership.providerProfiles`.
  final int sourceIndex;

  final ProfileMigrationStatus status;

  /// Warnings emitidos durante la migración de este profile (campo a
  /// campo). Lista vacía cuando el outcome es limpio.
  final List<LegacyMigrationWarning> warnings;

  /// Mensaje legible cuando `status == error`. Null en otros casos.
  final String? errorMessage;

  const ProfileMigrationOutcome({
    required this.sourceIndex,
    required this.status,
    required this.warnings,
    this.errorMessage,
  });

  bool get hasWarnings => warnings.isNotEmpty;
}

/// Reporte agregado de migrar UN membership.
class MembershipMigrationResult {
  /// Organización con `capabilityProfiles` posiblemente extendido. Cuando
  /// no hubo cambios, es la misma instancia recibida (reference-equal).
  final OrganizationEntity updatedOrganization;

  /// Cuántos providerProfiles intentamos migrar.
  /// Igual a `membership.providerProfiles.length`.
  final int profilesAttempted;

  /// Cuántos profiles se añadieron a `capabilityProfiles`.
  final int profilesMigrated;

  /// Cuántos profiles ya existían como duplicado (se conservó el existente).
  final int profilesSkippedDuplicate;

  /// Cuántos profiles se rechazaron por irrecuperables.
  final int profilesSkippedError;

  /// Outcome individual por cada profile, en el mismo orden que el input.
  final List<ProfileMigrationOutcome> outcomes;

  const MembershipMigrationResult({
    required this.updatedOrganization,
    required this.profilesAttempted,
    required this.profilesMigrated,
    required this.profilesSkippedDuplicate,
    required this.profilesSkippedError,
    required this.outcomes,
  });

  /// True si alguna capability fue añadida a la organización.
  bool get hasChanges => profilesMigrated > 0;

  /// True si la migración encontró al menos un caso degradado
  /// (warning o error). Útil para el caller que quiera alertar al admin.
  bool get hasIssues =>
      profilesSkippedError > 0 || outcomes.any((o) => o.hasWarnings);
}

// ─────────────────────────────────────────────────────────────────────────────
// MIGRATOR
// ─────────────────────────────────────────────────────────────────────────────

class LegacyMembershipProviderProfileMigrator {
  const LegacyMembershipProviderProfileMigrator._();

  /// Mapeo del catálogo legacy de assetTypeIds (que usaba plurales mezclados)
  /// hacia los wireName canónicos de `AssetRegistrationType`. Aceptamos las
  /// formas plurales y singulares que aparecieron en el código histórico.
  static const Map<String, AssetRegistrationType> _legacyAssetTypeMap = {
    // Plurales legacy
    'vehiculos': AssetRegistrationType.vehiculo,
    'inmuebles': AssetRegistrationType.inmueble,
    'maquinarias': AssetRegistrationType.maquinaria,
    'equipos': AssetRegistrationType.equipo,
    'otros': AssetRegistrationType.otro,
    // Singulares (por si el legacy ya migró parcialmente)
    'vehiculo': AssetRegistrationType.vehiculo,
    'inmueble': AssetRegistrationType.inmueble,
    'maquinaria': AssetRegistrationType.maquinaria,
    'equipo': AssetRegistrationType.equipo,
    'otro': AssetRegistrationType.otro,
  };

  /// Migra UN membership. Función pura: no persiste, no muta inputs.
  /// Emite telemetría episódica por cada profile procesado.
  ///
  /// Si `membership.providerProfiles` está vacío, retorna sin cambios y
  /// sin emitir telemetría (no hay nada que migrar).
  static MembershipMigrationResult migrateMembership({
    required MembershipEntity membership,
    required OrganizationEntity organization,
  }) {
    final attempted = membership.providerProfiles.length;
    if (attempted == 0) {
      return MembershipMigrationResult(
        updatedOrganization: organization,
        profilesAttempted: 0,
        profilesMigrated: 0,
        profilesSkippedDuplicate: 0,
        profilesSkippedError: 0,
        outcomes: const [],
      );
    }

    final orgId = organization.id;
    final membershipId = '${membership.userId}@${membership.orgId}';

    // Lista mutable local para construir el resultado.
    final newCapabilities = <CapabilityProfile>[
      ...organization.capabilityProfiles,
    ];

    // Índice de dedup: claves estables de las capabilities ya presentes.
    final dedupKeys = <String>{
      for (final c in newCapabilities) _dedupKey(c),
    };

    final outcomes = <ProfileMigrationOutcome>[];
    int migratedCount = 0;
    int duplicateCount = 0;
    int errorCount = 0;

    for (var i = 0; i < membership.providerProfiles.length; i++) {
      final legacy = membership.providerProfiles[i];
      final perProfileWarnings = <LegacyMigrationWarning>[];

      // 1. Adapter tolerante para el spec (providerType + businessCategoryRef).
      ProviderSpec providerSpec;
      try {
        final adapterResult =
            LegacyCapabilitySpecAdapter.providerSpecFromLegacyJson(
          legacy.toJson(),
          orgId: orgId,
        );
        perProfileWarnings.addAll(adapterResult.warnings);
        providerSpec = adapterResult.spec;
      } on ArgumentError catch (e) {
        // providerType ausente o desconocido: irrecuperable.
        outcomes.add(_recordError(
          orgId: orgId,
          membershipId: membershipId,
          sourceIndex: i,
          legacy: legacy,
          warnings: perProfileWarnings,
          error: e.toString(),
        ));
        errorCount++;
        continue;
      }

      // 2. Mapear campos comunes.
      final assetTypeIds =
          _mapAssetTypeIds(legacy.assetTypeIds, perProfileWarnings);
      final coverageCities =
          _mapCoverageCities(legacy.coverageCities, perProfileWarnings);
      final branchId =
          _normalizeBranchId(legacy.branchId, perProfileWarnings);

      // 3. Reportar campos del legacy que no son representables en v3.
      if (legacy.assetSegmentIds.isNotEmpty) {
        perProfileWarnings.add(LegacyMigrationWarning(
          kind: LegacyMigrationWarningKind.unmigrableAssetSegmentIds,
          fieldPath: 'membership.providerProfiles[$i].assetSegmentIds',
          rawValue: legacy.assetSegmentIds.toString(),
          message:
              'assetSegmentIds no se representan en v3; ${legacy.assetSegmentIds.length} valores descartados',
        ));
      }
      if (legacy.offeringLineIds.isNotEmpty) {
        perProfileWarnings.add(LegacyMigrationWarning(
          kind: LegacyMigrationWarningKind.unmigrableOfferingLineIds,
          fieldPath: 'membership.providerProfiles[$i].offeringLineIds',
          rawValue: legacy.offeringLineIds.toString(),
          message:
              'offeringLineIds no se representan en v3; ${legacy.offeringLineIds.length} valores descartados',
        ));
      }

      // 4. Construir CapabilityProfile (kind=provider siempre — el legacy
      //    no discrimina advisor/broker/legal/insurer).
      final CapabilityProfile capability;
      try {
        capability = CapabilityProfile(
          kind: ProfileKind.provider,
          assetTypeIds: assetTypeIds,
          coverageCities: coverageCities,
          branchId: branchId,
          providerSpec: providerSpec,
        );
      } on ArgumentError catch (e) {
        // Validación de invariantes del CapabilityProfile (debería ser
        // imposible llegar aquí dado que normalizamos antes, pero defensa
        // robusta).
        outcomes.add(_recordError(
          orgId: orgId,
          membershipId: membershipId,
          sourceIndex: i,
          legacy: legacy,
          warnings: perProfileWarnings,
          error: e.toString(),
        ));
        errorCount++;
        continue;
      }

      // 5. Dedup.
      final key = _dedupKey(capability);
      if (dedupKeys.contains(key)) {
        outcomes.add(ProfileMigrationOutcome(
          sourceIndex: i,
          status: ProfileMigrationStatus.duplicate,
          warnings: List.unmodifiable(perProfileWarnings),
        ));
        duplicateCount++;
        // Si hubo warnings durante el match con un duplicado, los emitimos
        // de todos modos (señal observable de drift en datos legacy).
        if (perProfileWarnings.isNotEmpty) {
          LegacyMembershipMigrationTelemetry.recordWarning(
            orgId: orgId,
            membershipId: membershipId,
            sourceProfileIndex: i,
            warnings:
                perProfileWarnings.map((w) => w.toMap()).toList(growable: false),
            sourceProfile: legacy.toJson(),
          );
        }
        continue;
      }

      // 6. Aceptar la nueva capability.
      dedupKeys.add(key);
      newCapabilities.add(capability);
      outcomes.add(ProfileMigrationOutcome(
        sourceIndex: i,
        status: ProfileMigrationStatus.migrated,
        warnings: List.unmodifiable(perProfileWarnings),
      ));
      migratedCount++;

      // 7. Telemetría según el outcome.
      if (perProfileWarnings.isEmpty) {
        LegacyMembershipMigrationTelemetry.recordSuccess(
          orgId: orgId,
          membershipId: membershipId,
          sourceProfileIndex: i,
          sourceProfile: legacy.toJson(),
        );
      } else {
        LegacyMembershipMigrationTelemetry.recordWarning(
          orgId: orgId,
          membershipId: membershipId,
          sourceProfileIndex: i,
          warnings: perProfileWarnings
              .map((w) => w.toMap())
              .toList(growable: false),
          sourceProfile: legacy.toJson(),
        );
      }
    }

    // Construir organization actualizada solo si hubo cambios.
    final updatedOrg = migratedCount > 0
        ? organization.copyWith(
            capabilityProfiles: List.unmodifiable(newCapabilities),
            updatedAt: organization.updatedAt,
          )
        : organization;

    return MembershipMigrationResult(
      updatedOrganization: updatedOrg,
      profilesAttempted: attempted,
      profilesMigrated: migratedCount,
      profilesSkippedDuplicate: duplicateCount,
      profilesSkippedError: errorCount,
      outcomes: List.unmodifiable(outcomes),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS DE MAPEO
  // ─────────────────────────────────────────────────────────────────────────

  /// Mapea `assetTypeIds` legacy (mezcla de plurales y singulares) al
  /// catálogo cerrado v3. Items desconocidos: warning + drop. Duplicados
  /// (post-mapeo) se eliminan silenciosamente.
  static List<AssetRegistrationType> _mapAssetTypeIds(
    List<String> legacyIds,
    List<LegacyMigrationWarning> sink,
  ) {
    final result = <AssetRegistrationType>[];
    final seen = <AssetRegistrationType>{};
    for (var i = 0; i < legacyIds.length; i++) {
      final raw = legacyIds[i];
      final mapped = _legacyAssetTypeMap[raw];
      if (mapped == null) {
        sink.add(LegacyMigrationWarning(
          kind: LegacyMigrationWarningKind.unknownLegacyAssetType,
          fieldPath: 'providerProfile.assetTypeIds[$i]',
          rawValue: raw,
          message: 'wire desconocido para AssetRegistrationType; descartado',
        ));
        continue;
      }
      if (seen.add(mapped)) {
        result.add(mapped);
      }
    }
    return List.unmodifiable(result);
  }

  /// Mapea `coverageCities` legacy a `CoverageCityPath`. Items con sintaxis
  /// inválida: warning + drop. Duplicados post-mapeo se eliminan.
  static List<CoverageCityPath> _mapCoverageCities(
    List<String> legacy,
    List<LegacyMigrationWarning> sink,
  ) {
    final result = <CoverageCityPath>[];
    final seen = <String>{};
    for (var i = 0; i < legacy.length; i++) {
      final raw = legacy[i];
      final parsed = CoverageCityPath.tryParse(raw);
      if (parsed == null) {
        sink.add(LegacyMigrationWarning(
          kind: LegacyMigrationWarningKind.malformedCoverageCity,
          fieldPath: 'providerProfile.coverageCities[$i]',
          rawValue: raw,
          message:
              'coverageCity no cumple formato PAIS/REGION/CIUDAD; descartado',
        ));
        continue;
      }
      if (seen.add(parsed.value)) {
        result.add(parsed);
      }
    }
    return List.unmodifiable(result);
  }

  /// Normaliza `branchId` legacy. Whitespace-only ⇒ warning + drop (null).
  /// Null ⇒ null silencioso (ausencia legítima).
  static String? _normalizeBranchId(
    String? raw,
    List<LegacyMigrationWarning> sink,
  ) {
    if (raw == null) return null;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      sink.add(LegacyMigrationWarning(
        kind: LegacyMigrationWarningKind.malformedBranchId,
        fieldPath: 'providerProfile.branchId',
        rawValue: raw,
        message: 'branchId presente pero vacío/whitespace; descartado',
      ));
      return null;
    }
    return trimmed;
  }

  /// Clave estable de dedup. Dos CapabilityProfile son considerados
  /// duplicados cuando comparten esta clave.
  ///
  /// Estrategia: identidad operativa = (kind, providerType, businessCategoryId).
  /// Las propiedades secundarias (assetTypeIds, coverageCities, branchId)
  /// son enriquecimiento — la duplicación a nivel de "qué ofrece" se evalúa
  /// solo por la triada anterior. Esto evita inflar la lista cuando dos
  /// providerProfiles legacy describen el mismo negocio con datos parciales
  /// distintos.
  static String _dedupKey(CapabilityProfile c) {
    final spec = c.providerSpec;
    final providerType = spec == null ? '__none__' : spec.providerType.wireName;
    final categoryId = spec?.businessCategoryRef?.value ?? '__none__';
    return '${c.kind.wireName}|$providerType|$categoryId';
  }

  /// Helper: registra error en telemetría y construye el outcome correspondiente.
  static ProfileMigrationOutcome _recordError({
    required String orgId,
    required String membershipId,
    required int sourceIndex,
    required ProviderProfile legacy,
    required List<LegacyMigrationWarning> warnings,
    required String error,
  }) {
    LegacyMembershipMigrationTelemetry.recordError(
      orgId: orgId,
      membershipId: membershipId,
      sourceProfileIndex: sourceIndex,
      error: error,
      sourceProfile: legacy.toJson(),
      partialWarnings:
          warnings.map((w) => w.toMap()).toList(growable: false),
    );
    return ProfileMigrationOutcome(
      sourceIndex: sourceIndex,
      status: ProfileMigrationStatus.error,
      warnings: List.unmodifiable(warnings),
      errorMessage: error,
    );
  }
}
