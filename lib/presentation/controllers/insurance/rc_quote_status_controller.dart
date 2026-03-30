// ============================================================================
// lib/presentation/controllers/insurance/rc_quote_status_controller.dart
// RC QUOTE STATUS CONTROLLER — Gestión híbrida del lead SRCE.
//
// QUÉ HACE:
// - Lee el lead inicial recibido vía Get.arguments.
// - Soporta contrato nuevo tipado (RcQuoteStatusArgs) y compatibilidad legacy
//   con InsuranceOpportunityLead directo.
// - Expone el lead como observable para que la UI renderice estado actual.
// - Permite refresh manual o silencioso desde backend.
// - Permite acciones de negocio opcionales (interested / rejectedByUser)
//   cuando el flujo de entrada lo habilita explícitamente.
//
// QUÉ NO HACE:
// - No navega. La UI decide la navegación.
// - No persiste en Isar (MVP HTTP only).
// - No hace polling automático continuo.
// - No redefine orgId del recurso desde la sesión.
//
// PRINCIPIOS:
// - El recurso SIEMPRE se lee/escribe con current.id + current.orgId.
// - La sesión solo valida contexto autenticado para acciones de negocio.
// - isRefreshing y isActionLoading están separados para evitar UX tosca.
// - Error de args inválidos se distingue del error operativo.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 monetización SRCE — estado post-solicitud con
// posibilidad de refresh y, opcionalmente, acciones de decisión comercial.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../domain/entities/insurance/insurance_opportunity_lead.dart';
import '../../../domain/repositories/insurance_lead_repository.dart';
import '../session_context_controller.dart';

/// Contrato recomendado para abrir la pantalla de estado del lead SRCE.
///
/// Mantiene capacidad de:
/// - pintar instantáneamente con el lead inicial
/// - refrescar en background si se desea
/// - habilitar o no acciones de negocio según el flujo de entrada
class RcQuoteStatusArgs {
  final InsuranceOpportunityLead lead;
  final bool autoRefreshOnInit;
  final bool allowDecisionActions;
  final String? sourceRoute;

  const RcQuoteStatusArgs({
    required this.lead,
    this.autoRefreshOnInit = true,
    this.allowDecisionActions = false,
    this.sourceRoute,
  });
}

class RcQuoteStatusController extends GetxController {
  // ───────────────────────────────────────────────────────────────────────────
  // Dependencias explícitas
  // ───────────────────────────────────────────────────────────────────────────

  final InsuranceLeadRepository _repo;
  final SessionContextController _session;

  RcQuoteStatusController(this._repo, this._session);

  // ───────────────────────────────────────────────────────────────────────────
  // Estado observable
  // ───────────────────────────────────────────────────────────────────────────

  final lead = Rxn<InsuranceOpportunityLead>();
  final isRefreshing = false.obs;
  final isActionLoading = false.obs;
  final errorMessage = Rxn<String>();

  // ───────────────────────────────────────────────────────────────────────────
  // Estado interno de contrato
  // ───────────────────────────────────────────────────────────────────────────

  bool _hasInvalidArgs = false;
  bool _allowDecisionActions = false;
  String? _sourceRoute;

  // ───────────────────────────────────────────────────────────────────────────
  // Getters derivados para la UI
  // ───────────────────────────────────────────────────────────────────────────

  bool get hasLead => lead.value != null;
  bool get hasInvalidArgs => _hasInvalidArgs;

  bool get canRefresh =>
      hasLead &&
      !_hasInvalidArgs &&
      !isRefreshing.value &&
      !isActionLoading.value;

  bool get canPerformDecisionActions =>
      _allowDecisionActions &&
      hasLead &&
      !_hasInvalidArgs &&
      !isActionLoading.value &&
      !isRefreshing.value;

  String? get sourceRoute => _sourceRoute;

  // ───────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ───────────────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _initFlow();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Inicialización desde argumentos de ruta
  // ───────────────────────────────────────────────────────────────────────────

  void _initFlow() {
    final args = Get.arguments;

    // Contrato nuevo recomendado.
    if (args is RcQuoteStatusArgs) {
      _sourceRoute = args.sourceRoute;
      _allowDecisionActions = args.allowDecisionActions;

      if (!_isLeadUsable(args.lead)) {
        _handleInvalidArgs(
          'No se recibió un lead válido de cotización. Regresa e intenta de nuevo.',
          debugDetails: 'RcQuoteStatusArgs.lead inválido',
        );
        return;
      }

      lead.value = args.lead;
      errorMessage.value = null;

      if (kDebugMode) {
        debugPrint(
          '[RcQuoteStatusController] args loaded | '
          'sourceRoute: ${args.sourceRoute} | '
          'allowDecisionActions: ${args.allowDecisionActions} | '
          'autoRefreshOnInit: ${args.autoRefreshOnInit}',
        );
      }

      if (args.autoRefreshOnInit) {
        Future.microtask(() => refreshLead(silent: true));
      }
      return;
    }

    // Compatibilidad legacy: lead directo.
    if (args is InsuranceOpportunityLead) {
      if (!_isLeadUsable(args)) {
        _handleInvalidArgs(
          'No se recibió un lead válido de cotización. Regresa e intenta de nuevo.',
          debugDetails: 'InsuranceOpportunityLead directo inválido',
        );
        return;
      }

      lead.value = args;
      errorMessage.value = null;
      _allowDecisionActions = false;

      if (kDebugMode) {
        debugPrint(
          '[RcQuoteStatusController] legacy args loaded | '
          'allowDecisionActions: false',
        );
      }

      Future.microtask(() => refreshLead(silent: true));
      return;
    }

    _handleInvalidArgs(
      'No se encontró información válida del lead.',
      debugDetails: 'Get.arguments=${args.runtimeType}',
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Caso de uso: refresh manual o silencioso
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> refreshLead({bool silent = false}) async {
    if (_hasInvalidArgs) return;
    if (isRefreshing.value) return;
    if (isActionLoading.value) return;

    final current = lead.value;
    if (current == null) return;

    final leadId = current.id.trim();
    final resourceOrgId = current.orgId.trim();

    if (leadId.isEmpty || resourceOrgId.isEmpty) {
      if (!silent) {
        _setOperationalError(
          'El lead actual no tiene identificadores válidos para sincronizar.',
        );
      }
      return;
    }

    if (!silent) {
      isRefreshing.value = true;
      errorMessage.value = null;
    }

    try {
      final updated = await _repo.getLead(
        id: leadId,
        orgId: resourceOrgId,
      );
      lead.value = updated;
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[RcQuoteStatusController] refresh error: $e');
        debugPrint('$st');
      }

      if (!silent) {
        _setOperationalError(_mapRefreshError(e));
      }
    } finally {
      if (!silent) {
        isRefreshing.value = false;
      }
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Acciones de negocio opcionales
  // ───────────────────────────────────────────────────────────────────────────

  /// El usuario marca que le interesa la cotización.
  Future<void> markAsInterested({String? notes}) async {
    await _updateStatus(
      InsuranceLeadStatus.interested,
      notes: notes,
    );
  }

  /// El usuario descarta la cotización.
  Future<void> markAsRejected({String? notes}) async {
    await _updateStatus(
      InsuranceLeadStatus.rejectedByUser,
      notes: notes,
    );
  }

  Future<void> _updateStatus(
    InsuranceLeadStatus status, {
    String? notes,
  }) async {
    if (_hasInvalidArgs) return;

    if (!_allowDecisionActions) {
      _setOperationalError(
        'Esta pantalla no permite acciones sobre la cotización en este flujo.',
      );
      return;
    }

    if (isActionLoading.value || isRefreshing.value) return;

    final current = lead.value;
    if (current == null) {
      _setOperationalError('No hay un lead cargado para actualizar.');
      return;
    }

    final leadId = current.id.trim();
    final resourceOrgId = current.orgId.trim();

    if (leadId.isEmpty || resourceOrgId.isEmpty) {
      _setOperationalError(
        'El lead actual no tiene identificadores válidos para actualizar.',
      );
      return;
    }

    // La sesión se valida para garantizar usuario autenticado.
    // El orgId del recurso NO se reemplaza con el org activo de sesión.
    final activeOrgId = _session.user?.activeContext?.orgId.trim();
    final userId = _session.user?.uid.trim();

    if (!_isNotBlank(userId) || !_isNotBlank(activeOrgId)) {
      _setOperationalError('Sesión no disponible o expirada.');
      return;
    }

    // Guardrail: evita operar sobre un recurso abierto en otra org activa.
    if (activeOrgId != resourceOrgId) {
      _setOperationalError(
        'La organización activa cambió. Reabre esta solicitud desde la organización correcta.',
      );
      return;
    }

    isActionLoading.value = true;
    errorMessage.value = null;

    try {
      await _repo.updateStatus(
        id: leadId,
        orgId: resourceOrgId,
        status: status,
        notes: notes?.trim().isNotEmpty == true
            ? notes!.trim()
            : 'Actualizado desde App Móvil',
      );

      // Tras una acción, refrescamos silenciosamente para obtener la versión
      // canónica del backend sin meter spinner general.
      await refreshLead(silent: true);
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('[RcQuoteStatusController] updateStatus error: $e');
        debugPrint('$st');
      }
      _setOperationalError(_mapActionError(e));
    } finally {
      isActionLoading.value = false;
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Helpers
  // ───────────────────────────────────────────────────────────────────────────

  bool _isLeadUsable(InsuranceOpportunityLead candidate) {
    return candidate.id.trim().isNotEmpty && candidate.orgId.trim().isNotEmpty;
  }

  bool _isNotBlank(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  void _handleInvalidArgs(
    String message, {
    String? debugDetails,
  }) {
    _hasInvalidArgs = true;
    lead.value = null;
    errorMessage.value = message;

    if (kDebugMode) {
      debugPrint(
        '[RcQuoteStatusController] invalid args | ${debugDetails ?? 'sin detalles'}',
      );
    }
  }

  void _setOperationalError(String message) {
    errorMessage.value = message;
  }

  String _mapRefreshError(Object error) {
    final raw = error.toString().toLowerCase();

    if (raw.contains('not found') || raw.contains('404')) {
      return 'La solicitud ya no fue encontrada en el servidor.';
    }

    if (raw.contains('forbidden') ||
        raw.contains('permission') ||
        raw.contains('403')) {
      return 'No tienes permisos para consultar esta solicitud.';
    }

    if (raw.contains('timeout') ||
        raw.contains('network') ||
        raw.contains('socket') ||
        raw.contains('connection')) {
      return 'No se pudo sincronizar por un problema de conexión.';
    }

    return 'No se pudo actualizar el estado. Intenta de nuevo.';
  }

  String _mapActionError(Object error) {
    final raw = error.toString().toLowerCase();

    if (raw.contains('forbidden') ||
        raw.contains('permission') ||
        raw.contains('403')) {
      return 'No tienes permisos para actualizar esta solicitud.';
    }

    if (raw.contains('not found') || raw.contains('404')) {
      return 'La solicitud ya no existe o cambió en el servidor.';
    }

    if (raw.contains('timeout') ||
        raw.contains('network') ||
        raw.contains('socket') ||
        raw.contains('connection')) {
      return 'No se pudo actualizar la solicitud por un problema de conexión.';
    }

    return 'No se pudo actualizar el estado de la solicitud.';
  }
}
