// lib/domain/entities/workspace/workspace_context.dart

import 'workspace_type.dart';

/// Origen del [WorkspaceContext] durante la fase transicional.
///
/// Este enum permite auditar cómo fue resuelto el contexto activo:
/// - desde artefactos legacy,
/// - desde persistencia ligera,
/// - desde onboarding,
/// - o desde membresías activas.
///
/// IMPORTANTE:
/// Esto pertenece al dominio transicional de sesión/contexto.
/// No depende de UI, Flutter, Isar ni infraestructura.
enum WorkspaceContextSource {
  /// Contexto derivado desde el modelo legacy actual
  /// (por ejemplo: activeContext.rol, providerType, orgType).
  derivedFromLegacy,

  /// Contexto reconstruido desde persistencia ligera local
  /// (por ejemplo, el workspaceId previamente seleccionado).
  hydratedFromPersistence,

  /// Contexto emitido inmediatamente después de registro/onboarding.
  fromRegistration,

  /// Contexto resuelto explícitamente a partir de una membresía activa.
  resolvedFromMembership,
}

/// Contexto operativo activo del usuario durante la sesión.
///
/// Este objeto reemplaza el uso del `rol:String` como eje de bootstrap,
/// navegación y cambio de workspace durante la Fase 1 transicional.
///
/// REGLAS DE DISEÑO:
/// - Es un objeto de dominio/sesión, no de persistencia.
/// - NO debe persistirse completo en Isar.
/// - Solo debe persistirse una preferencia mínima, típicamente [workspaceId].
/// - Se reconstruye en cada hidratación desde estado legacy y/o membresías.
/// - [orgId] sigue siendo la partition key legacy durante la Fase 1.
/// - [workspaceId] es una clave UX/contextual transicional; NO es partition key.
/// - [roleCode], [providerType] y [orgType] existen por compatibilidad temporal.
/// - La navegación nueva debe depender de [type], no de [roleCode].
class WorkspaceContext {
  /// Identificador del contexto activo para UX y switching.
  ///
  /// En Fase 1 este ID puede ser sintético/transicional, pero debe ser:
  /// - estable,
  /// - determinista,
  /// - trazable.
  ///
  /// NO usar como partition key de Firestore/Isar.
  final String workspaceId;

  /// Identificador de la membresía que origina este contexto.
  ///
  /// Es clave para:
  /// - trazabilidad,
  /// - validación,
  /// - depuración,
  /// - evolución futura hacia multi-workspace real.
  final String membershipId;

  /// Partition key legacy actual del sistema.
  ///
  /// Durante la Fase 1, las queries de dominio siguen filtrando por [orgId].
  final String orgId;

  /// Nombre display de la organización/contexto legacy.
  final String orgName;

  /// Tipo canónico del workspace.
  ///
  /// Este campo reemplaza el uso de role strings como eje arquitectónico.
  final WorkspaceType type;

  /// Código de rol legacy normalizado.
  ///
  /// Se conserva solo para:
  /// - backward compatibility,
  /// - logs,
  /// - debugging,
  /// - derivación transicional.
  ///
  /// NO debe ser usado por navegación nueva.
  final String roleCode;

  /// Tipo de proveedor en el modelo legacy.
  ///
  /// Valores esperados:
  /// - 'articulos'
  /// - 'servicios'
  /// - null
  ///
  /// Campo temporal de compatibilidad.
  final String? providerType;

  /// Tipo de organización en el modelo legacy.
  ///
  /// Valores típicos:
  /// - 'personal'
  /// - 'empresa'
  ///
  /// Campo temporal de compatibilidad.
  final String orgType;

  /// Origen del contexto.
  final WorkspaceContextSource source;

  const WorkspaceContext({
    required this.workspaceId,
    required this.membershipId,
    required this.orgId,
    required this.orgName,
    required this.type,
    required this.roleCode,
    required this.source,
    this.providerType,
    this.orgType = 'personal',
  });

  // ────────────────────────────────────────────────────────────────────────────
  // Helpers semánticos
  // ────────────────────────────────────────────────────────────────────────────

  bool get isAssetAdmin => type.isAssetAdmin;
  bool get isOwner => type.isOwner;
  bool get isRenter => type.isRenter;
  bool get isExternalProvider => type.isExternalProvider;
  bool get isInvalid => type.isInvalid;

  /// Un contexto es utilizable si:
  /// - no es unknown
  /// - tiene identidad mínima válida
  bool get isValid => !isInvalid && _hasRequiredIdentityFields;

  /// Indica si este contexto aún depende de metadatos legacy.
  ///
  /// Útil para observabilidad, debugging y migración progresiva.
  bool get isLegacyBacked =>
      roleCode.trim().isNotEmpty || providerType != null || orgType.isNotEmpty;

  /// Clave estable para logs y telemetría.
  String get debugKey =>
      '${type.wireName}|org:$orgId|membership:$membershipId|ws:$workspaceId';

  bool get _hasRequiredIdentityFields =>
      workspaceId.trim().isNotEmpty &&
      membershipId.trim().isNotEmpty &&
      orgId.trim().isNotEmpty;

  // ────────────────────────────────────────────────────────────────────────────
  // Evolución segura
  // ────────────────────────────────────────────────────────────────────────────

  WorkspaceContext copyWith({
    String? workspaceId,
    String? membershipId,
    String? orgId,
    String? orgName,
    WorkspaceType? type,
    String? roleCode,
    String? providerType,
    String? orgType,
    WorkspaceContextSource? source,
  }) {
    return WorkspaceContext(
      workspaceId: workspaceId ?? this.workspaceId,
      membershipId: membershipId ?? this.membershipId,
      orgId: orgId ?? this.orgId,
      orgName: orgName ?? this.orgName,
      type: type ?? this.type,
      roleCode: roleCode ?? this.roleCode,
      providerType: providerType ?? this.providerType,
      orgType: orgType ?? this.orgType,
      source: source ?? this.source,
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Equality / Hashing
  // ────────────────────────────────────────────────────────────────────────────

  /// Equality semántica basada en identidad contextual.
  ///
  /// En Fase 1 es más robusto usar:
  /// - workspaceId
  /// - membershipId
  /// - orgId
  ///
  /// y no solo workspaceId, porque este último todavía es transicional.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkspaceContext &&
            runtimeType == other.runtimeType &&
            workspaceId == other.workspaceId &&
            membershipId == other.membershipId &&
            orgId == other.orgId;
  }

  @override
  int get hashCode => Object.hash(workspaceId, membershipId, orgId);

  @override
  String toString() {
    return 'WorkspaceContext('
        'workspaceId: $workspaceId, '
        'membershipId: $membershipId, '
        'orgId: $orgId, '
        'type: ${type.wireName}, '
        'roleCode: $roleCode, '
        'source: $source'
        ')';
  }
}
