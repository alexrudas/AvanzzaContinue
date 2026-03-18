// ============================================================================
// lib/domain/value/workspace/workspace_context_seed.dart
// WORKSPACE CONTEXT SEED — Enterprise Ultra Pro Premium (Domain / Value / Workspace)
//
// QUÉ HACE:
// - DTO serializable que transporta los datos necesarios para construir un
//   WorkspaceContext inicial inmediatamente después del registro.
// - Puede serializarse a/desde Map<String, dynamic> para persistirse de forma
//   ligera (ej. como campo JSON en RegistrationProgressModel).
// - Provee toContext() para materializarse como WorkspaceContext.
//
// QUÉ NO HACE:
// - NO contiene lógica de resolución del contrato de registro.
// - NO calcula roles ni decide qué workspaceType usar.
// - NO importa Flutter, GetX, Isar ni infraestructura.
// - NO es una entidad persistible independiente.
//
// PRINCIPIOS:
// - VALUE DTO: inmutable, sin identidad propia, transportable.
// - WIRE-STABLE: las claves del mapa JSON no deben cambiar una vez en producción.
// - PURE DOMAIN: cero dependencias de infraestructura.
// - FUENTE DE VERDAD TRANSITORIA: existe entre la creación de entidades y la
//   primera hidratación del SessionContextController.
// - FALLO SILENCIOSO: fromMap() retorna null intencionalmente cuando los datos
//   no son válidos o están corruptos. El caller (SplashBootstrapController)
//   es responsable de loguear y redirigir a login/onboarding sin crash.
//
// FLUJO DE FASE 2:
//   RegistrationWorkspaceIntent  → captura intención del usuario
//   RegistrationWorkspaceResolver → aplica la matriz de negocio
//   ResolvedRegistrationWorkspace → contrato de salida del registro
//   WorkspaceContextSeed          → transporta el resultado hacia el bootstrap
//   WorkspaceContext              → contexto activo de sesión
//
// DEPENDENCIAS:
// - WorkspaceType y su API centralizada de wire serialization/deserialization
// - WorkspaceContext + WorkspaceContextSource
// ============================================================================

import '../../entities/workspace/workspace_context.dart';
import '../../entities/workspace/workspace_type.dart';

/// DTO serializable que transporta el seed inicial de un WorkspaceContext.
///
/// Producido por [RegistrationWorkspaceResolver] como parte de
/// [ResolvedRegistrationWorkspace]. Consumido por [SplashBootstrapController]
/// para construir el [WorkspaceContext] activo sin re-resolver desde legacy.
class WorkspaceContextSeed {
  /// Identificador determinístico del workspace.
  ///
  /// Derivado según el contrato §7:
  ///
  ///   workspaceId = deterministic(orgId, membershipId, workspaceType)
  ///
  /// REGLA: workspaceId NO depende estructuralmente de roleCode.
  /// roleCode existe como dato del seed por compatibilidad transicional,
  /// pero no es componente del identificador.
  final String workspaceId;

  /// Identificador de la membresía de origen.
  ///
  /// Transicional Fase 2: `'${userId}_${orgId}'`
  final String membershipId;

  /// Partition key del tenant SaaS.
  final String orgId;

  /// Nombre display de la organización.
  final String orgName;

  /// Tipo de organización.
  ///
  /// Valores válidos: `'personal'` | `'empresa'`
  final String orgType;

  /// Tipo canónico del workspace.
  ///
  /// Producido por el resolver; nunca es [WorkspaceType.unknown] en un seed válido.
  final WorkspaceType workspaceType;

  /// Código de rol legacy canónico (resultado de la matriz de resolución §4).
  ///
  /// Ejemplos: `'propietario'`, `'administrador'`, `'arrendatario'`,
  /// `'proveedor_servicios'`, `'proveedor_articulos'`
  ///
  /// Campo de compatibilidad transicional. NO forma parte del cálculo de workspaceId.
  final String roleCode;

  /// Tipo de proveedor, cuando aplica (workshop o supplier).
  ///
  /// Valores: `'articulos'` | `'servicios'` | null
  final String? providerType;

  const WorkspaceContextSeed({
    required this.workspaceId,
    required this.membershipId,
    required this.orgId,
    required this.orgName,
    required this.orgType,
    required this.workspaceType,
    required this.roleCode,
    this.providerType,
  });

  // ==========================================================================
  // SERIALIZACIÓN — wire-stable
  // ==========================================================================

  /// Claves canónicas del mapa serializado.
  ///
  /// CONTRATO DE WIRE: nunca renombrar estas claves una vez en producción.
  static const _kWorkspaceId = 'workspaceId';
  static const _kMembershipId = 'membershipId';
  static const _kOrgId = 'orgId';
  static const _kOrgName = 'orgName';
  static const _kOrgType = 'orgType';
  static const _kWorkspaceType = 'workspaceType';
  static const _kRoleCode = 'roleCode';
  static const _kProviderType = 'providerType';

  /// Serializa el seed como mapa JSON-compatible.
  ///
  /// Solo incluye `providerType` si no es null.
  Map<String, dynamic> toMap() {
    return {
      _kWorkspaceId: workspaceId,
      _kMembershipId: membershipId,
      _kOrgId: orgId,
      _kOrgName: orgName,
      _kOrgType: orgType,
      _kWorkspaceType: workspaceType.wireName,
      _kRoleCode: roleCode,
      if (providerType != null) _kProviderType: providerType,
    };
  }

  /// Deserializa desde mapa JSON.
  ///
  /// FALLO SILENCIOSO POR DISEÑO:
  /// Retorna null si el mapa está ausente, incompleto o contiene un
  /// workspaceType no reconocido. No lanza excepciones.
  ///
  /// El caller (SplashBootstrapController) es responsable de:
  /// - loguear el resultado null
  /// - redirigir a login/onboarding como fallback seguro
  ///
  /// Esta tolerancia protege contra datos corruptos en persistencia legacy
  /// o seeds de versiones anteriores del formato.
  static WorkspaceContextSeed? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    final workspaceId = map[_kWorkspaceId] as String?;
    final membershipId = map[_kMembershipId] as String?;
    final orgId = map[_kOrgId] as String?;
    final orgName = map[_kOrgName] as String?;
    final orgType = map[_kOrgType] as String?;
    final workspaceTypeName = map[_kWorkspaceType] as String?;
    final roleCode = map[_kRoleCode] as String?;

    if (workspaceId == null ||
        workspaceId.isEmpty ||
        membershipId == null ||
        membershipId.isEmpty ||
        orgId == null ||
        orgId.isEmpty ||
        orgName == null ||
        orgType == null ||
        orgType.isEmpty ||
        roleCode == null ||
        roleCode.isEmpty) {
      return null;
    }

    // WorkspaceTypeX.fromWireName retorna WorkspaceType.unknown si el valor
    // no se reconoce. Un seed con tipo unknown no es materializable.
    final workspaceType = WorkspaceTypeX.fromWireName(workspaceTypeName);
    if (workspaceType == WorkspaceType.unknown) return null;

    return WorkspaceContextSeed(
      workspaceId: workspaceId,
      membershipId: membershipId,
      orgId: orgId,
      orgName: orgName,
      orgType: orgType,
      workspaceType: workspaceType,
      roleCode: roleCode,
      providerType: map[_kProviderType] as String?,
    );
  }

  // ==========================================================================
  // MATERIALIZACIÓN
  // ==========================================================================

  /// Construye el [WorkspaceContext] activo inicial a partir de este seed.
  ///
  /// Source por defecto: [WorkspaceContextSource.fromRegistration].
  /// Al rehidratar desde persistencia usar [WorkspaceContextSource.hydratedFromPersistence].
  WorkspaceContext toContext({
    WorkspaceContextSource source = WorkspaceContextSource.fromRegistration,
  }) {
    return WorkspaceContext(
      workspaceId: workspaceId,
      membershipId: membershipId,
      orgId: orgId,
      orgName: orgName,
      type: workspaceType,
      roleCode: roleCode,
      providerType: providerType,
      orgType: orgType,
      source: source,
    );
  }

  // ==========================================================================
  // SEMÁNTICA
  // ==========================================================================

  /// True si el seed tiene los campos mínimos para materializarse como contexto.
  bool get isValid =>
      workspaceId.trim().isNotEmpty &&
      membershipId.trim().isNotEmpty &&
      orgId.trim().isNotEmpty &&
      workspaceType != WorkspaceType.unknown;

  /// Descripción compacta para logs y telemetría.
  String get debugDescription => 'WorkspaceContextSeed('
      'type=${workspaceType.wireName}, '
      'orgId=$orgId, '
      'ws=$workspaceId, '
      'role=$roleCode, '
      'providerType=${providerType ?? "none"}'
      ')';

  @override
  String toString() => debugDescription;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkspaceContextSeed &&
            other.workspaceId == workspaceId &&
            other.membershipId == membershipId &&
            other.orgId == orgId;
  }

  @override
  int get hashCode => Object.hash(workspaceId, membershipId, orgId);
}
