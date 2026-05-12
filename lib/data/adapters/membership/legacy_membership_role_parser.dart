// ============================================================================
// lib/data/adapters/membership/legacy_membership_role_parser.dart
// LegacyMembershipRoleParser — lectura tolerante de Membership.roles legacy
// hacia el catálogo cerrado MembershipRole.
// ============================================================================
// QUÉ HACE:
//   - Normaliza strings legacy a MembershipRole con matching case-insensitive
//     y trim. Garantiza que un admin legacy almacenado como 'Admin', 'ADMIN',
//     '  admin  ', etc. NO pierda permisos por inconsistencia de formato.
//   - Acepta lista vacía (válida por contrato Fase 2 kill-switch).
//   - Strings desconocidos (post-normalización) se descartan con warning
//     tipado [LegacyMigrationWarningKind.unknownLegacyRole]; los reconocidos
//     se conservan.
//   - Strings vacíos / whitespace-only se descartan con
//     [LegacyMigrationWarningKind.blankLegacyRole].
//   - Duplicados post-normalización se eliminan silenciosamente
//     (saneamiento — el catálogo cerrado exige unicidad por rol).
//   - Emite telemetría episódica (`legacy_membership_roles_warning`)
//     SOLO cuando hay warnings; lista limpia ⇒ silencio.
//
// QUÉ NO HACE:
//   - NO infiere permisos a partir del contenido de roles. Roles solo
//     describen permisos internos (admin/sales_agent/...); el bypass de
//     fundador (isOwner=true) es independiente del catálogo y vive en la
//     capa de policy (regla base canónica).
//   - NO mapea valores legacy de Membership.providerProfiles ni hace
//     migración semántica de capabilities (eso lo hace
//     LegacyMembershipProviderProfileMigrator).
//   - NO toca AssetActorLink, Portfolio ni relaciones con activos.
//   - NO lanza por strings desconocidos. Política: lectura siempre robusta;
//     todo desconocido se reporta vía warning + telemetría.
//
// CONTRATO DE NORMALIZACIÓN:
//   raw → trim → toLowerCase → match contra wireName del catálogo.
//   - 'Admin', 'ADMIN', '  admin  ' → MembershipRole.admin
//   - 'Sales_Agent', 'SALES_AGENT' → MembershipRole.salesAgent
//   - 'admin ', ' admin', '\tadmin\n' → MembershipRole.admin
//   - 'super_admin', 'manager', '' → null + warning (drop del item)
// ============================================================================

import '../../../core/telemetry/legacy_membership_migration_telemetry.dart';
import '../../../domain/value/membership_role.dart';
import '../capability/legacy_migration_warning.dart';

/// Resultado del parse tolerante de la lista de roles legacy.
class LegacyRolesParseResult {
  /// Roles válidos parseados, sin duplicados, en el orden de aparición.
  final List<MembershipRole> roles;

  /// Warnings emitidos por items descartados.
  final List<LegacyMigrationWarning> warnings;

  const LegacyRolesParseResult({
    required this.roles,
    required this.warnings,
  });

  bool get hasWarnings => warnings.isNotEmpty;
}

class LegacyMembershipRoleParser {
  const LegacyMembershipRoleParser._();

  /// Normaliza un string legacy individual a [MembershipRole].
  ///
  /// Delega en [MembershipRoleX.tryParseFlexible] (domain) — esta función
  /// existe como punto de entrada del data layer; la lógica de
  /// normalización es lógica de catálogo y vive en domain.
  static MembershipRole? tryParseLegacy(String? raw) =>
      MembershipRoleX.tryParseFlexible(raw);

  /// Parse tolerante de una lista de roles legacy.
  ///
  /// - Items vacíos / whitespace-only ⇒ drop + warning `blankLegacyRole`.
  /// - Items no reconocidos (post-normalización) ⇒ drop + warning
  ///   `unknownLegacyRole`.
  /// - Duplicados post-normalización ⇒ deduplicados silenciosamente.
  /// - Lista vacía de entrada ⇒ resultado vacío sin warnings (contrato
  ///   Fase 2 kill-switch: roles=[] es válido).
  ///
  /// [orgId] y [membershipId] son contexto opcional para la telemetría.
  /// Si hay warnings y al menos uno es no-blank, se emite el evento
  /// `legacy_membership_roles_warning` (best-effort, never throws).
  ///
  /// **[emitTelemetry]** (default `true`):
  /// - `true`: emite el evento de warnings al telemetry facade. Comportamiento
  ///   estándar para el caller que parsea un membership puntual.
  /// - `false`: SUPRIME la emisión. Usar cuando el caller invoca el parser
  ///   en un loop masivo (ej: bulk migration, policy resolver iterando N
  ///   memberships) y prefiere agregar warnings y emitir UN solo evento al
  ///   final vía
  ///   [LegacyMembershipMigrationTelemetry.recordRolesWarning] manualmente.
  ///   Los warnings siguen disponibles en [LegacyRolesParseResult.warnings]
  ///   para que el caller los acumule.
  static LegacyRolesParseResult parseLegacyList(
    List<String> rawRoles, {
    String? orgId,
    String? membershipId,
    bool emitTelemetry = true,
  }) {
    if (rawRoles.isEmpty) {
      return const LegacyRolesParseResult(roles: [], warnings: []);
    }

    final warnings = <LegacyMigrationWarning>[];
    final result = <MembershipRole>[];
    final seen = <MembershipRole>{};

    for (var i = 0; i < rawRoles.length; i++) {
      final raw = rawRoles[i];
      // Distinguimos blank (vacío/whitespace) de unknown (no en catálogo).
      // tryParseFlexible colapsa ambos a null; reabrimos la distinción aquí
      // para emitir warnings tipados correctos.
      if (raw.trim().isEmpty) {
        warnings.add(LegacyMigrationWarning(
          kind: LegacyMigrationWarningKind.blankLegacyRole,
          fieldPath: 'membership.roles[$i]',
          rawValue: raw,
          message: 'rol legacy vacío o solo whitespace; descartado',
        ));
        continue;
      }
      final parsed = MembershipRoleX.tryParseFlexible(raw);
      if (parsed == null) {
        warnings.add(LegacyMigrationWarning(
          kind: LegacyMigrationWarningKind.unknownLegacyRole,
          fieldPath: 'membership.roles[$i]',
          rawValue: raw,
          message:
              'rol legacy no reconocido tras normalización (trim + lowercase); '
              'descartado. Roles válidos: ${MembershipRoleX.allWireNames}',
        ));
        continue;
      }
      if (seen.add(parsed)) {
        result.add(parsed);
      }
      // Duplicados se silencian: el catálogo cerrado exige unicidad y este
      // paso es saneamiento, no error de datos.
    }

    if (warnings.isNotEmpty && emitTelemetry) {
      LegacyMembershipMigrationTelemetry.recordRolesWarning(
        warnings: warnings.map((w) => w.toMap()).toList(growable: false),
        orgId: orgId,
        membershipId: membershipId,
      );
    }

    return LegacyRolesParseResult(
      roles: List.unmodifiable(result),
      warnings: List.unmodifiable(warnings),
    );
  }
}
