// ============================================================================
// lib/domain/value/registration/resolved_registration_workspace.dart
// RESOLVED REGISTRATION WORKSPACE — Enterprise Ultra Pro Premium (Domain / Value / Registration)
//
// QUÉ HACE:
// - Define el output contract canónico del flujo de registro tipado (Fase 2).
// - Agrupa en un único objeto inmutable todos los artefactos producidos por
//   RegistrationWorkspaceResolver.
// - Expone validación de consistencia cruzada entre el contrato plano y el
//   WorkspaceContextSeed derivado.
// - Sirve como puente limpio entre la resolución de dominio y la doble escritura
//   transicional ejecutada por controllers/capas de aplicación.
//
// QUÉ NO HACE:
// - NO persiste nada directamente.
// - NO navega ni decide rutas.
// - NO importa Flutter, GetX, Isar ni infraestructura.
// - NO contiene lógica de resolución de negocio.
// - NO conoce repositorios, datasources ni bindings.
//
// PRINCIPIOS:
// - IMMUTABLE OUTPUT CONTRACT: una vez producido, no se modifica.
// - COMPLETE: contiene todo lo necesario para persistencia transicional y
//   bootstrap del contexto inicial.
// - COHERENT: valida alineación real entre contrato y seed.
// - PURE DOMAIN: cero dependencias de infraestructura.
// - FAIL-FAST BY STATE: si isConsistent es false, el caller no debe continuar
//   con doble escritura ni bootstrap.
//
// FLUJO DE FASE 2:
//   RegistrationWorkspaceIntent
//   → RegistrationWorkspaceResolver.resolve()
//   → ResolvedRegistrationWorkspace   ← este archivo
//   → doble escritura transicional
//   → workspaceContextSeed serializable
//   → SplashBootstrapController Gate 4
//
// DEPENDENCIAS:
// - WorkspaceType (domain/entities/workspace)
// - BusinessMode (domain/value/workspace)
// - WorkspaceContextSeed (domain/value/workspace)
// ============================================================================

import '../../entities/workspace/workspace_type.dart';
import '../workspace/business_mode.dart';
import '../workspace/workspace_context_seed.dart';

/// Output contract canónico del registro tipado (Fase 2).
///
/// Producido por RegistrationWorkspaceResolver y consumido por capas superiores
/// para:
/// - ejecutar la doble escritura transicional
/// - transportar el seed serializable del contexto inicial
/// - habilitar bootstrap basado en WorkspaceContext tipado
class ResolvedRegistrationWorkspace {
  /// Tipo canónico del workspace resuelto.
  ///
  /// Nunca debe ser [WorkspaceType.unknown] en una instancia válida.
  final WorkspaceType workspaceType;

  /// Modo operativo canónico del usuario, declarado en el intent de registro.
  final BusinessMode businessMode;

  /// Identificador determinístico del workspace.
  ///
  /// Regla contractual:
  /// deterministic(orgId, membershipId, workspaceType)
  final String workspaceId;

  /// Partition key del tenant SaaS.
  final String orgId;

  /// Tipo de organización.
  ///
  /// Valores esperados:
  /// - 'personal'
  /// - 'empresa'
  final String orgType;

  /// Identificador de la membership creada o utilizada.
  ///
  /// Transicional Fase 2:
  /// '${userId}_${orgId}'
  final String membershipId;

  /// Código de rol legacy canónico derivado de la matriz formal.
  ///
  /// Escrito transicionalmente en:
  /// - Membership.roles[]
  /// - UserEntity.activeContext.rol
  final String legacyRoleCode;

  /// workspaceId que debe persistirse como contexto activo.
  ///
  /// Invariante:
  /// activeWorkspaceId == workspaceId
  final String activeWorkspaceId;

  /// Seed serializable para construir el WorkspaceContext inicial.
  ///
  /// Serializable para persistencia transicional.
  final WorkspaceContextSeed workspaceContextSeed;

  /// Tipo de proveedor, cuando aplica.
  ///
  /// Valores esperados:
  /// - 'articulos'
  /// - 'servicios'
  /// - null
  final String? providerType;

  const ResolvedRegistrationWorkspace({
    required this.workspaceType,
    required this.businessMode,
    required this.workspaceId,
    required this.orgId,
    required this.orgType,
    required this.membershipId,
    required this.legacyRoleCode,
    required this.activeWorkspaceId,
    required this.workspaceContextSeed,
    this.providerType,
  });

  // ==========================================================================
  // VALIDACIÓN DE INVARIANTES
  // ==========================================================================

  /// True cuando el contrato cumple invariantes mínimas de seguridad y además
  /// el WorkspaceContextSeed está completamente alineado con este resultado.
  ///
  /// Si retorna false, el caller debe tratar este objeto como inválido y no
  /// continuar con persistencia/bootstrap.
  bool get isConsistent {
    // ------------------------------------------------------------------------
    // Invariantes del contrato plano
    // ------------------------------------------------------------------------
    if (workspaceType == WorkspaceType.unknown) return false;
    if (workspaceId.trim().isEmpty) return false;
    if (orgId.trim().isEmpty) return false;
    if (orgType.trim().isEmpty) return false;
    if (!_isValidOrgType(orgType)) return false;
    if (membershipId.trim().isEmpty) return false;
    if (legacyRoleCode.trim().isEmpty) return false;
    if (activeWorkspaceId.trim().isEmpty) return false;
    if (activeWorkspaceId != workspaceId) return false;

    // ------------------------------------------------------------------------
    // Invariantes internas del seed
    // ------------------------------------------------------------------------
    if (!workspaceContextSeed.isValid) return false;

    // ------------------------------------------------------------------------
    // Coherencia cruzada contrato ↔ seed
    // ------------------------------------------------------------------------
    if (workspaceContextSeed.workspaceId != workspaceId) return false;
    if (workspaceContextSeed.membershipId != membershipId) return false;
    if (workspaceContextSeed.orgId != orgId) return false;
    if (workspaceContextSeed.orgType != orgType) return false;
    if (workspaceContextSeed.workspaceType != workspaceType) return false;
    if (workspaceContextSeed.roleCode != legacyRoleCode) return false;

    // ------------------------------------------------------------------------
    // Coherencia de providerType
    // ------------------------------------------------------------------------
    if (providerType != workspaceContextSeed.providerType) return false;

    final requiresProviderType = workspaceType == WorkspaceType.workshop ||
        workspaceType == WorkspaceType.supplier;

    if (requiresProviderType) {
      if (providerType == null || providerType!.trim().isEmpty) return false;
      if (providerType != 'articulos' && providerType != 'servicios') {
        return false;
      }
    } else {
      if (providerType != null) return false;
    }

    return true;
  }

  /// Alias semántico útil para callers más expresivos.
  bool get canBootstrap => isConsistent;

  // ==========================================================================
  // SEMÁNTICA
  // ==========================================================================

  /// Descripción compacta para logs y telemetría.
  String get debugDescription {
    return 'ResolvedRegistrationWorkspace('
        'type=${workspaceType.wireName}, '
        'mode=${businessMode.wireName}, '
        'orgId=$orgId, '
        'workspaceId=$workspaceId, '
        'legacyRole=$legacyRoleCode, '
        'providerType=${providerType ?? "none"}, '
        'consistent=$isConsistent'
        ')';
  }

  @override
  String toString() => debugDescription;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ResolvedRegistrationWorkspace &&
            other.workspaceType == workspaceType &&
            other.businessMode == businessMode &&
            other.workspaceId == workspaceId &&
            other.orgId == orgId &&
            other.orgType == orgType &&
            other.membershipId == membershipId &&
            other.legacyRoleCode == legacyRoleCode &&
            other.activeWorkspaceId == activeWorkspaceId &&
            other.workspaceContextSeed == workspaceContextSeed &&
            other.providerType == providerType;
  }

  @override
  int get hashCode => Object.hash(
        workspaceType,
        businessMode,
        workspaceId,
        orgId,
        orgType,
        membershipId,
        legacyRoleCode,
        activeWorkspaceId,
        workspaceContextSeed,
        providerType,
      );

  // ==========================================================================
  // HELPERS PRIVADOS
  // ==========================================================================

  static bool _isValidOrgType(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'personal' || normalized == 'empresa';
  }
}
