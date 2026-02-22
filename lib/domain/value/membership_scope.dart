// ============================================================================
// lib/domain/value/membership_scope.dart
// MEMBERSHIP SCOPE — Enterprise Ultra Pro (Domain / Value Object)
//
// QUÉ HACE:
// - Define el alcance de acceso de un miembro a los activos de una org.
// - Provee enum ScopeType { global, restricted, none } con defaults seguros.
// - Expone canAccessAsset(id) para evaluación directa por asset ID.
// - Soporta asignación por asset individual y por grupo/portfolio.
// - Incluye campo granularOverrides con contrato de formato estable.
// - Expone isEffectivelyEmpty para detectar scopes sin acceso real.
//
// QUÉ NO HACE:
// - No resuelve grupo→activos (eso es responsabilidad de capa repositorio).
// - No hace enforcement de acceso (eso lo hará la siguiente fase en repos/UI).
// - No persiste por sí mismo (el Model lo serializa como JSON string).
// - No interactúa con ActiveContext, PolicyContextV2 ni RolePermissionEntity.
// - No valida formato de granularOverrides (eso se hará en la fase de enforcement).
// - No maneja JSON corrupto (eso lo maneja MembershipModel con try/catch en scopeJson).
//
// NOTAS:
// - Default seguro: ScopeType.restricted + listas vacías = sin acceso.
// - fromJson({}) aplica @Default de cada campo → retorna scope restricted vacío.
//   Sin embargo, JSON con tipos incorrectos (ej: type: 123 en vez de string)
//   puede lanzar excepciones de json_serializable. La protección contra JSON
//   corrupto o mal tipado debe implementarse en MembershipModel al deserializar
//   scopeJson, usando try/catch con fallback a MembershipScope() por defecto.
// - Freezed + JsonSerializable para consistencia con el resto del dominio.
// - granularOverrides: formato obligatorio "asset:<assetId>:perm:<permKey>".
//   Strings fuera de formato se consideran inválidas y se ignoran en enforcement.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership_scope.freezed.dart';
part 'membership_scope.g.dart';

/// Tipo de alcance de un miembro sobre los activos de la organización.
///
/// - [global]: acceso a TODOS los activos de la org (admin, owner).
/// - [restricted]: acceso SOLO a activos explícitamente asignados.
/// - [none]: sin acceso a activos (roles auxiliares, invitados pendientes).
enum ScopeType {
  @JsonValue('global')
  global,
  @JsonValue('restricted')
  restricted,
  @JsonValue('none')
  none,
}

/// Value Object que define el alcance de acceso de un miembro
/// a los activos de una organización.
///
/// Regla de default seguro: [ScopeType.restricted] con listas vacías
/// = sin acceso hasta que se asigne explícitamente.
///
/// **Sobre JSON corrupto**: [fromJson] delega a json_serializable, que aplica
/// `@Default` cuando el campo está ausente. Sin embargo, si un campo tiene
/// un tipo incorrecto (ej: `"type": 42`), json_serializable lanzará una
/// excepción. La capa que deserializa (MembershipModel.scopeJson) es
/// responsable de capturar esa excepción y retornar `MembershipScope()`
/// como fallback seguro.
@freezed
abstract class MembershipScope with _$MembershipScope {
  const MembershipScope._();

  const factory MembershipScope({
    /// Tipo de alcance. Default seguro: restricted (sin acceso hasta asignar).
    @Default(ScopeType.restricted) ScopeType type,

    /// IDs de activos asignados (solo aplica cuando type == restricted).
    @Default(<String>[]) List<String> assignedAssetIds,

    /// IDs de grupos/portfolios asignados (escalabilidad para >N activos).
    @Default(<String>[]) List<String> assignedGroupIds,

    /// Overrides granulares codificados como strings.
    ///
    /// **Contrato de formato obligatorio:**
    ///   `"asset:<assetId>:perm:<permKey>"`
    ///
    /// Ejemplos válidos:
    /// - `"asset:abc123:perm:readonly"`
    /// - `"asset:xyz999:perm:accounting_view"`
    /// - `"asset:veh001:perm:maintenance_rw"`
    ///
    /// Cualquier string que no siga el formato `asset:*:perm:*` se considera
    /// inválida y será ignorada silenciosamente por la capa de enforcement.
    /// Este Value Object no valida el formato; solo lo transporta.
    @Default(<String>[]) List<String> granularOverrides,
  }) = _MembershipScope;

  factory MembershipScope.fromJson(Map<String, dynamic> json) =>
      _$MembershipScopeFromJson(json);

  // ── Constructores de conveniencia ──

  /// Acceso total a todos los activos de la org (admin, owner).
  factory MembershipScope.global() =>
      const MembershipScope(type: ScopeType.global);

  /// Sin acceso a activos (invitado pendiente, rol auxiliar).
  factory MembershipScope.none() =>
      const MembershipScope(type: ScopeType.none);

  /// Acceso restringido a activos específicos.
  factory MembershipScope.restricted({
    List<String> assetIds = const [],
    List<String> groupIds = const [],
  }) =>
      MembershipScope(
        type: ScopeType.restricted,
        assignedAssetIds: assetIds,
        assignedGroupIds: groupIds,
      );

  // ── Queries ──

  /// Verifica si este scope permite acceso al activo con [assetId].
  ///
  /// - [global] → siempre true.
  /// - [restricted] → true si assetId está en assignedAssetIds.
  /// - [none] → siempre false.
  ///
  /// NOTA: No evalúa assignedGroupIds aquí; eso requiere resolver
  /// grupo→activos en capa repositorio.
  bool canAccessAsset(String assetId) {
    switch (type) {
      case ScopeType.global:
        return true;
      case ScopeType.restricted:
        return assignedAssetIds.contains(assetId);
      case ScopeType.none:
        return false;
    }
  }

  /// True si el scope otorga acceso total (global).
  bool get isGlobal => type == ScopeType.global;

  /// True si el scope restringe a activos específicos.
  bool get isRestricted => type == ScopeType.restricted;

  /// True si no hay acceso a activos.
  bool get isNone => type == ScopeType.none;

  /// True si tiene al menos un activo o grupo asignado (solo para restricted).
  bool get hasAssignments =>
      assignedAssetIds.isNotEmpty || assignedGroupIds.isNotEmpty;

  /// True si el scope no otorga acceso real a ningún activo.
  ///
  /// Un scope es "efectivamente vacío" cuando:
  /// - NO es global (global siempre tiene acceso), Y
  /// - NO tiene assets ni grupos asignados, Y
  /// - NO tiene overrides granulares.
  ///
  /// Útil para detectar memberships que existen pero no tienen acceso
  /// operativo a ningún activo — por ejemplo, un miembro recién invitado
  /// cuyo scope aún no ha sido configurado, o un restricted sin asignaciones
  /// pero con overrides pendientes.
  bool get isEffectivelyEmpty =>
      type != ScopeType.global &&
      !hasAssignments &&
      granularOverrides.isEmpty;
}
