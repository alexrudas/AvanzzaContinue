// ============================================================================
// lib/infrastructure/workspace/context_switch_adapters.dart
// CONTEXT SWITCH ADAPTERS — Enterprise Ultra Pro Premium (Infrastructure)
//
// QUÉ HACE:
// - Implementa WorkspaceContextStateStore usando DIContainer().workspaceRepository.
// - Implementa LegacyActiveContextBridge usando SessionContextController.setActiveContext().
// - Provee los puentes concretos que ContextSwitchService necesita para operar
//   sobre el stack real del proyecto en Fase 1.
// - Mantiene compatibilidad con el modelo legacy basado en ActiveContext.
//
// QUÉ NO HACE:
// - NO define lógica de dominio ni de switching (eso es ContextSwitchService).
// - NO construye WorkspaceContext (eso es WorkspaceContextAdapter).
// - NO valida contexto ni memberships (eso es ContextValidator).
// - NO navega ni decide rutas.
// - NO toca Firestore/Isar directamente; delega al WorkspaceRepository.
// - NO persiste WorkspaceContext completo; solo la preferencia ligera.
//
// PRINCIPIOS:
// - THIN ADAPTERS: solo traducen entre puertos del servicio y dependencias reales.
// - FASE 1 COMPAT: LegacyActiveContextBridgeImpl mantiene vivo ActiveContext
//   mientras bootstrap/routing legacy siguen leyéndolo.
// - MINIMAL PERSISTENCE: solo se persiste activeWorkspaceId.
// - NON-INVASIVE: no introduce cambios destructivos sobre el modelo actual.
//
// NOTAS ENTERPRISE:
// - clearActiveWorkspaceId() usa fallback legacy con setActiveWorkspace('')
//   porque el repositorio actual no expone un clear formal.
// - Cuando WorkspaceRepository exponga un método explícito de limpieza,
//   este adapter debe migrar a esa API sin afectar ContextSwitchService.
// - LegacyActiveContextBridgeImpl es transicional y debe eliminarse cuando
//   SessionContextController + bootstrap + shell dependan solo de WorkspaceContext.
//
// DEPENDENCIAS:
// - DIContainer().workspaceRepository
// - SessionContextController
// - ActiveContext
// - WorkspaceContext
// - WorkspaceContextStateStore / LegacyActiveContextBridge
// ============================================================================

import 'package:avanzza/domain/services/workspace/context_switch_service.dart';

import '../../core/di/container.dart';
import '../../domain/entities/user/active_context.dart';
import '../../domain/entities/workspace/workspace_context.dart';
import '../../presentation/controllers/session_context_controller.dart';

/// Implementación concreta de [WorkspaceContextStateStore]
/// usando el WorkspaceRepository real del proyecto.
///
/// Persiste únicamente:
/// - activeWorkspaceId
///
/// NO persiste:
/// - WorkspaceContext completo
/// - memberships
/// - metadata adicional de sesión
class WorkspaceContextStateStoreImpl implements WorkspaceContextStateStore {
  WorkspaceContextStateStoreImpl();

  @override
  Future<String?> readActiveWorkspaceId() async {
    return DIContainer().workspaceRepository.getActiveWorkspaceId();
  }

  @override
  Future<void> writeActiveWorkspaceId(String workspaceId) async {
    await DIContainer().workspaceRepository.setActiveWorkspace(workspaceId);
  }

  @override
  Future<void> clearActiveWorkspaceId() async {
    // Fallback transicional de Fase 1:
    // el repositorio actual no expone un método clear formal.
    // Usamos string vacío para limpiar el valor persistido.
    await DIContainer().workspaceRepository.setActiveWorkspace('');
  }
}

/// Implementación concreta de [LegacyActiveContextBridge].
///
/// Traduce un [WorkspaceContext] canónico/transicional hacia [ActiveContext]
/// para mantener compatibilidad con el flujo legacy actual del proyecto.
///
/// IMPORTANTE:
/// Este adapter existe únicamente mientras partes del sistema todavía leen:
/// - user.activeContext
/// - activeContext.rol
/// - activeContext.providerType
///
/// Cuando el sistema opere 100% sobre WorkspaceContext, este bridge debe
/// eliminarse.
class LegacyActiveContextBridgeImpl implements LegacyActiveContextBridge {
  const LegacyActiveContextBridgeImpl(this._session);

  final SessionContextController _session;

  @override
  Future<void> syncFromWorkspaceContext(WorkspaceContext context) async {
    final currentLegacyContext = _session.user?.activeContext;

    final legacyContext = ActiveContext(
      orgId: context.orgId,
      orgName: context.orgName.isNotEmpty
          ? context.orgName
          : (currentLegacyContext?.orgName ?? ''),
      rol: context.roleCode,
      providerType: context.providerType,
    );

    await _session.setActiveContext(legacyContext);
  }
}
