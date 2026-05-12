// ============================================================================
// lib/domain/policy/membership_policy.dart
// MembershipPolicy — punto de entrada CANÓNICO para preguntas de policy
// sobre Membership. Cualquier lógica de permisos DEBE pasar por aquí.
// ============================================================================
// QUÉ HACE:
//   - Centraliza las preguntas comunes de autorización: ¿es fundador?,
//     ¿tiene tal rol?, ¿tiene acceso de administrador?
//   - Normaliza roles legacy vía MembershipRoleX.tryParseFlexible:
//     case-insensitive, trim, lookup contra catálogo cerrado.
//   - Implementa el BYPASS DE FUNDADOR (isOwner=true) como capa
//     ortogonal al catálogo de roles. Un fundador conserva acceso total
//     aunque sus roles queden vacíos o pierdan `admin` por error/bug.
//
// QUÉ NO HACE:
//   - NO consulta scope/granularOverrides/MembershipScope: esas son
//     preguntas de scope-on-asset (qué activo puede ver), no de policy
//     general (qué puede hacer en el workspace). Si la pregunta de
//     permiso depende de un asset concreto, se compone con MembershipScope
//     fuera de este policy.
//   - NO emite telemetría en hot path. Las consultas de permisos suelen
//     correrse N veces por render — telemetría aquí inundaría el backend.
//     Si el caller necesita rastrear drift de roles, debe usar el parser
//     directamente (`LegacyMembershipRoleParser.parseLegacyList(...)`).
//   - NO toca AssetActorRole, Portfolio, AssetActorLink. La policy de
//     membership es independiente de la relación operativa con activos.
//
// ────────────────────────────────────────────────────────────────────────
// REGLA CANÓNICA: isOwner ES EL BYPASS, scope ES LA REPRESENTACIÓN
// ────────────────────────────────────────────────────────────────────────
//
// `MembershipEntity.isOwner=true` y `MembershipEntity.scope=global()` son
// CONCEPTOS DISTINTOS que NO deben confundirse en ninguna decisión de
// policy:
//
//   - `isOwner`     ⇒ identidad: "esta membership pertenece al fundador
//                                 del workspace". Bypass canónico.
//                                 Independiente de roles, scope, capabilities.
//
//   - `scope.global` ⇒ alcance: "esta membership tiene acceso a TODOS los
//                                assets de la org" (representación de
//                                asset-access). Compatible con cualquier
//                                rol o origen de la membership.
//
// CompleteOnboardingUC persiste AMBOS para fundadores (correcta
// representación coherente). Pero la policy NO debe usarlos como
// sinónimos.
//
// ORDEN OBLIGATORIO en cualquier futuro `canAccessAsset(m, assetId)` u
// otra pregunta similar de scope-on-asset:
//
//     1. if (isFounder(m)) return true;      ← bypass canónico
//     2. return m.scope.canAccessAsset(...); ← scope normal
//
// Razón: si un fundador pierde `scope=global` por bug, migración, o
// kill-switch, su `isOwner=true` debe seguir rescatando el acceso. Si
// la policy solo mira `scope`, el creador del workspace queda bloqueado
// silenciosamente — bug catastrófico.
//
// `hasAdminAccess` (definido abajo) ya cumple este contrato:
// `isFounder` se evalúa ANTES que `hasRole(admin)`. Cualquier método
// nuevo debe seguir el mismo patrón.
//
// REGLA OBLIGATORIA (regla base canónica de Avanzza 2.0):
//   Está PROHIBIDO leer `MembershipEntity.roles` directamente para tomar
//   decisiones de permiso. Cualquier consumidor (controller, use case,
//   repository policy gate) DEBE preguntar a este policy. Razones:
//
//   1. `roles` es `List<String>` legacy en Fase 1; comparar strings sin
//      normalizar produce bugs case-sensitive (`'admin' != 'Admin'`).
//   2. Strings desconocidos no se detectan; un drift en datos legacy
//      pasa silencioso si no se canaliza por el parser.
//   3. El BYPASS DE FUNDADOR (`isOwner=true`) es independiente del
//      catálogo. Lecturas directas que solo miran `roles` pueden negar
//      acceso al creador del workspace por accidente.
//
//   Code review debe rechazar cualquier `membership.roles.contains(...)`
//   o `membership.roles.any(...)` en lógica de permisos. Para listar /
//   mostrar roles en UI, usar también este policy
//   (`parsedRoles(membership)`).
// ============================================================================

import '../entities/user/membership_entity.dart';
import '../value/membership_role.dart';

class MembershipPolicy {
  const MembershipPolicy._();

  /// True si la membership pertenece al fundador del workspace.
  /// El fundador conserva acceso total independientemente de sus roles.
  ///
  /// [MembershipEntity.isOwner] es el "seguro de vida" del creador.
  static bool isFounder(MembershipEntity m) => m.isOwner == true;

  /// True si la membership tiene el [role] indicado tras normalizar
  /// (case-insensitive, trim). Incluye roles legacy almacenados con
  /// case mixto.
  ///
  /// NO consulta `isOwner`: para preguntas de "puede administrar?"
  /// usar [hasAdminAccess], que combina el bypass de fundador con la
  /// presencia del rol `admin`.
  static bool hasRole(MembershipEntity m, MembershipRole role) {
    for (final raw in m.roles) {
      if (MembershipRoleX.tryParseFlexible(raw) == role) return true;
    }
    return false;
  }

  /// True si la membership puede ejercer poder de administrador en el
  /// workspace. La regla canónica:
  ///
  ///   `isFounder(m) || hasRole(m, MembershipRole.admin)`
  ///
  /// Garantiza que el creador del workspace NUNCA pierda acceso de admin
  /// aunque sus roles queden vacíos por bug, kill-switch o error humano.
  static bool hasAdminAccess(MembershipEntity m) {
    if (isFounder(m)) return true;
    return hasRole(m, MembershipRole.admin);
  }

  /// Roles parseados al catálogo tipado, sin duplicados, sin emitir
  /// telemetría. Útil para UI que liste los roles del miembro.
  /// Strings desconocidos se descartan silenciosamente — para detección
  /// de drift, usar `LegacyMembershipRoleParser.parseLegacyList`
  /// directamente con `emitTelemetry: true`.
  static List<MembershipRole> parsedRoles(MembershipEntity m) {
    final result = <MembershipRole>[];
    final seen = <MembershipRole>{};
    for (final raw in m.roles) {
      final parsed = MembershipRoleX.tryParseFlexible(raw);
      if (parsed != null && seen.add(parsed)) {
        result.add(parsed);
      }
    }
    return List.unmodifiable(result);
  }
}
