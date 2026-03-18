// ============================================================================
// lib/application/services/workspace/context_switch_service.dart
// CONTEXT SWITCH SERVICE — Enterprise Ultra Pro Premium (Application Service)
//
// QUÉ HACE:
// - Orquesta el cambio de workspace activo del usuario en la sesión.
// - Valida el contexto objetivo antes de activarlo.
// - Persiste únicamente la preferencia ligera del workspace activo.
// - Actualiza el estado reactivo del SessionContextController.
// - Ejecuta bridge transicional hacia ActiveContext legacy cuando aplique.
// - Emite resultado explícito de éxito/error para evitar fallos silenciosos.
// - Permite observabilidad/telemetría sin bloquear el flujo principal.
//
// QUÉ NO HACE:
// - NO pertenece a la capa de dominio.
// - NO define el mapping roleCode → WorkspaceType (eso es WorkspaceContextAdapter).
// - NO evalúa permisos finos de features (eso es AccessPolicy / ProductAccessContext).
// - NO consulta Isar/Firestore directamente; depende de puertos/servicios.
// - NO construye rutas ni widgets.
// - NO persiste el WorkspaceContext completo.
//
// PRINCIPIOS:
// - APPLICATION ORCHESTRATION: coordina servicios y estado, no modela dominio.
// - FAIL-SAFE: si el contexto no es válido, no cambia el contexto activo.
// - NO SILENT FAILURE: retorna resultado explícito.
// - ANTI-REENTRADA: bloquea switches concurrentes.
// - LEGACY BRIDGE: soporta Fase 1 sin consolidar el modelo viejo.
// - TELEMETRÍA NO BLOQUEANTE: errores de logging nunca rompen el switch.
//
// DEPENDENCIAS ESPERADAS:
// - SessionContextController
// - ContextValidator
// - WorkspaceContextStateStore (preferencia ligera)
// - LegacyActiveContextBridge (opcional, transicional)
// - ContextSwitchTelemetry (opcional)
// ============================================================================

import 'package:get/get.dart';

import '../../../domain/entities/user/membership_entity.dart';
import '../../../domain/entities/workspace/workspace_context.dart';
import '../../../domain/services/workspace/context_validator.dart';
import '../../../presentation/controllers/session_context_controller.dart';

/// Puerto para persistir la preferencia ligera del contexto activo.
///
/// Implementación típica:
/// - WorkspaceStateModel en Isar
abstract class WorkspaceContextStateStore {
  Future<String?> readActiveWorkspaceId();

  Future<void> writeActiveWorkspaceId(String workspaceId);

  Future<void> clearActiveWorkspaceId();
}

/// Bridge transicional para actualizar el ActiveContext legacy.
///
/// Este puerto existe únicamente durante Fase 1.
/// En fases posteriores puede eliminarse cuando bootstrap y navegación
/// dependan exclusivamente de WorkspaceContext.
abstract class LegacyActiveContextBridge {
  Future<void> syncFromWorkspaceContext(WorkspaceContext context);
}

/// Telemetría opcional del cambio de contexto.
///
/// Nunca debe bloquear el flujo principal.
abstract class ContextSwitchTelemetry {
  Future<void> logSuccess({
    required WorkspaceContext previous,
    required WorkspaceContext current,
  });

  Future<void> logFailure({
    WorkspaceContext? previous,
    required WorkspaceContext attempted,
    required String reasonCode,
    String? detail,
  });
}

/// Resultado explícito del cambio de contexto.
class ContextSwitchResult {
  final bool isSuccess;
  final String reasonCode;
  final String? detail;
  final WorkspaceContext? previousContext;
  final WorkspaceContext? currentContext;

  const ContextSwitchResult._({
    required this.isSuccess,
    required this.reasonCode,
    this.detail,
    this.previousContext,
    this.currentContext,
  });

  factory ContextSwitchResult.success({
    required WorkspaceContext previousContext,
    required WorkspaceContext currentContext,
    String reasonCode = 'context_switch_success',
    String? detail,
  }) {
    return ContextSwitchResult._(
      isSuccess: true,
      reasonCode: reasonCode,
      detail: detail,
      previousContext: previousContext,
      currentContext: currentContext,
    );
  }

  factory ContextSwitchResult.failure({
    WorkspaceContext? previousContext,
    WorkspaceContext? attemptedContext,
    required String reasonCode,
    String? detail,
  }) {
    return ContextSwitchResult._(
      isSuccess: false,
      reasonCode: reasonCode,
      detail: detail,
      previousContext: previousContext,
      currentContext: attemptedContext,
    );
  }

  @override
  String toString() {
    return 'ContextSwitchResult('
        'isSuccess: $isSuccess, '
        'reasonCode: $reasonCode, '
        'detail: $detail'
        ')';
  }
}

/// Servicio de aplicación para cambio de contexto activo.
///
/// Este servicio NO navega.
/// La UI o el bootstrap reaccionan al cambio del SessionContextController.
class ContextSwitchService extends GetxService {
  ContextSwitchService({
    required SessionContextController sessionContextController,
    required WorkspaceContextStateStore stateStore,
    LegacyActiveContextBridge? legacyBridge,
    ContextSwitchTelemetry? telemetry,
  })  : _sessionContextController = sessionContextController,
        _stateStore = stateStore,
        _legacyBridge = legacyBridge,
        _telemetry = telemetry;

  final SessionContextController _sessionContextController;
  final WorkspaceContextStateStore _stateStore;
  final LegacyActiveContextBridge? _legacyBridge;
  final ContextSwitchTelemetry? _telemetry;

  /// True mientras un switch está en progreso.
  final RxBool isSwitching = false.obs;

  bool _switchInProgress = false;

  /// Cambia al contexto indicado si:
  /// - existe entre los contextos disponibles
  /// - pasa validación estructural + membership
  Future<ContextSwitchResult> switchTo(
    WorkspaceContext nextContext, {
    required List<MembershipEntity> memberships,
  }) async {
    if (_switchInProgress) {
      return ContextSwitchResult.failure(
        previousContext: _sessionContextController.current,
        attemptedContext: nextContext,
        reasonCode: 'context_switch_already_in_progress',
      );
    }

    _switchInProgress = true;
    isSwitching.value = true;

    final previousContext = _sessionContextController.current;

    try {
      final existsInSession = _sessionContextController
          .availableWorkspaceContexts
          .any((ctx) => ctx == nextContext);

      if (!existsInSession) {
        final result = ContextSwitchResult.failure(
          previousContext: previousContext,
          attemptedContext: nextContext,
          reasonCode: 'context_not_available_in_session',
          detail:
              'El contexto objetivo no existe dentro de los contextos disponibles de la sesión.',
        );
        await _logFailure(result, attempted: nextContext);
        return result;
      }

      final validation = ContextValidator.validate(
        context: nextContext,
        memberships: memberships,
      );

      if (!validation.isValid) {
        final result = ContextSwitchResult.failure(
          previousContext: previousContext,
          attemptedContext: nextContext,
          reasonCode: validation.reasonCode,
          detail: validation.detail,
        );
        await _logFailure(result, attempted: nextContext);
        return result;
      }

      if (previousContext == nextContext) {
        await _stateStore.writeActiveWorkspaceId(nextContext.workspaceId);

        final result = ContextSwitchResult.success(
          previousContext: previousContext ?? nextContext,
          currentContext: nextContext,
          reasonCode: 'context_switch_noop_same_context',
        );
        await _logSuccess(
          previous: previousContext ?? nextContext,
          current: nextContext,
        );
        return result;
      }

      // 1. Persistencia ligera
      await _stateStore.writeActiveWorkspaceId(nextContext.workspaceId);

      // 2. Bridge legacy transicional
      if (_legacyBridge != null) {
        await _legacyBridge.syncFromWorkspaceContext(nextContext);
      }

      // 3. Estado reactivo principal
      _sessionContextController.activeWorkspaceContext.value = nextContext;

      final result = ContextSwitchResult.success(
        previousContext: previousContext ?? nextContext,
        currentContext: nextContext,
      );
      await _logSuccess(
        previous: previousContext ?? nextContext,
        current: nextContext,
      );
      return result;
    } catch (e) {
      final result = ContextSwitchResult.failure(
        previousContext: previousContext,
        attemptedContext: nextContext,
        reasonCode: 'context_switch_unhandled_exception',
        detail: e.toString(),
      );
      await _logFailure(result, attempted: nextContext);
      return result;
    } finally {
      isSwitching.value = false;
      _switchInProgress = false;
    }
  }

  /// Cambia de contexto por workspaceId.
  Future<ContextSwitchResult> switchToWorkspaceId(
    String workspaceId, {
    required List<MembershipEntity> memberships,
  }) async {
    final normalized = workspaceId.trim();

    if (normalized.isEmpty) {
      return ContextSwitchResult.failure(
        previousContext: _sessionContextController.current,
        reasonCode: 'workspace_id_empty',
      );
    }

    final target = _sessionContextController.availableWorkspaceContexts
        .firstWhereOrNull((ctx) => ctx.workspaceId == normalized);

    if (target == null) {
      return ContextSwitchResult.failure(
        previousContext: _sessionContextController.current,
        reasonCode: 'workspace_id_not_found',
        detail: 'No existe un contexto disponible con workspaceId=$normalized',
      );
    }

    return switchTo(target, memberships: memberships);
  }

  Future<void> _logSuccess({
    required WorkspaceContext previous,
    required WorkspaceContext current,
  }) async {
    if (_telemetry == null) return;

    try {
      await _telemetry.logSuccess(
        previous: previous,
        current: current,
      );
    } catch (_) {
      // non-blocking
    }
  }

  Future<void> _logFailure(
    ContextSwitchResult result, {
    required WorkspaceContext attempted,
  }) async {
    if (_telemetry == null) return;

    try {
      await _telemetry.logFailure(
        previous: result.previousContext,
        attempted: attempted,
        reasonCode: result.reasonCode,
        detail: result.detail,
      );
    } catch (_) {
      // non-blocking
    }
  }
}
