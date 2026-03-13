// ============================================================================
// lib/presentation/controllers/runt/runt_query_controller.dart
//
// RUNT QUERY CONTROLLER — Enterprise-grade Ultra Pro
//
// PROPÓSITO
// Controller de presentación para el flujo de consulta RUNT asíncrona dentro
// del wizard de registro de activos.
//
// RESPONSABILIDAD
// - Orquestar el flujo visible para la UI:
//   1. cargar draft existente
//   2. iniciar consulta
//   3. hacer polling del job
//   4. exponer progreso reactivo
//   5. persistir/restaurar el estado del wizard
//   6. soportar "Nueva consulta"
//
// NO RESPONSABILIDAD
// - No contiene detalles HTTP.
// - No contiene acceso directo a data sources.
// - No contiene modelos de persistencia.
// - No contiene lógica de infraestructura.
//
// DECISIÓN ARQUITECTÓNICA
// Este controller consume:
//
// - AssetRegistrationDraftRepository (domain)
// - RuntAsyncQueryGateway (application-facing abstraction)
//
// Con esto evitamos:
//   presentation → data/service
//
// y mantenemos una separación más limpia de capas.
//
// NOTA
// Para mantener este archivo autocontenido y utilizable de inmediato,
// se define aquí una abstracción liviana:
//
//   RuntAsyncQueryGateway
//
// La implementación concreta puede vivir en data/application y usar:
//   - RuntQueryService
//   - modelos de data
//   - mappers de integración
//
// ============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../application/runt/runt_async_query_gateway.dart';
import '../../../domain/entities/asset/asset_registration_draft_entity.dart';
import '../../../domain/repositories/asset_registration_draft_repository.dart';

// Re-exportamos los tipos de application para que el binding y las páginas
// que solo importan este controller sigan funcionando sin cambios de imports.
export '../../../application/runt/runt_async_query_gateway.dart'
    show
        RuntAsyncQueryGateway,
        RuntAsyncQueryStartResult,
        RuntAsyncQueryStatusResult,
        RuntQueryJobStatus,
        RuntQueryStepStatus,
        RuntQuerySteps;

// ─────────────────────────────────────────────────────────────────────────────
// Estado de presentation
// ─────────────────────────────────────────────────────────────────────────────

/// Estado observable de la consulta desde la perspectiva de la UI.
enum RuntViewState {
  idle,
  pending,
  running,
  completed,
  failed,
}

// ─────────────────────────────────────────────────────────────────────────────
// Mapper de integración de docType (presentation -> gateway/backend contract)
// ─────────────────────────────────────────────────────────────────────────────

abstract final class RuntOwnerDocumentTypeMapper {
  static String toGatewayCode(String uiDocType) {
    switch (uiDocType.trim().toUpperCase()) {
      case 'CC':
        return 'C';
      case 'CE':
        return 'E';
      case 'NIT':
        return 'C';
      default:
        return 'C';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────────────────────────────────────

class RuntQueryController extends GetxController {
  final RuntAsyncQueryGateway _queryGateway;
  final AssetRegistrationDraftRepository _draftRepo;

  RuntQueryController(
    this._queryGateway,
    this._draftRepo,
  );

  // ───────────────────────────────────────────────────────────────────────────
  // Estado público reactivo
  // ───────────────────────────────────────────────────────────────────────────

  final viewState = RuntViewState.idle.obs;
  final progressPercent = 0.obs;
  final steps = Rx<RuntQuerySteps>(RuntQuerySteps.allPending());
  final errorMessage = RxnString();
  final partialData = Rx<Map<String, dynamic>?>(null);
  final vehicleData = Rx<Map<String, dynamic>?>(null);
  final isPolling = false.obs;

  /// Tipo de documento ingresado por el usuario en el formulario.
  ///
  /// Se persiste aquí para mostrarlo en la pantalla de resultado sin depender
  /// de que el backend scraper lo devuelva en el payload.
  final ownerDocumentType = RxnString();

  /// Número de documento ingresado por el usuario en el formulario.
  ///
  /// Mismo propósito que [ownerDocumentType].
  final ownerDocumentNumber = RxnString();

  // ───────────────────────────────────────────────────────────────────────────
  // Estado interno
  // ───────────────────────────────────────────────────────────────────────────

  String? _currentDraftId;
  String? _currentJobId;
  Timer? _pollingTimer;
  int _pollAttempts = 0;

  /// Bandera que indica que el job ya llegó a un estado terminal
  /// (completed / failed / timeout).
  ///
  /// Cuando es `true`, cualquier callback del Timer.periodic que todavía
  /// estuviera en vuelo (awaiting HTTP) debe ignorar su respuesta y no
  /// sobrescribir el estado final ya establecido.
  ///
  /// Se fija en `true` en [_handleCompleted], [_handleFailed] y
  /// [_failByTimeout]. Se resetea en [_resetReactiveStateForNewQuery] y
  /// [_resetReactiveStateToIdle].
  bool _isTerminated = false;

  static const int _maxPollAttempts = 90;
  static const Duration _pollInterval = Duration(seconds: 2);

  /// Persistencia de progreso durante job en curso.
  ///
  /// Evita escribir en cada tick.
  static const int _persistEveryNPolls = 10;

  @override
  void onClose() {
    // [DIAG-F] Controller destruido — polling cancelado
    debugPrint('[DIAG][onClose] ⚠️ RuntQueryController DESTRUIDO — pollingTimer=$_pollingTimer jobId=$_currentJobId');
    _stopPolling();
    super.onClose();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Carga / restauración
  // ───────────────────────────────────────────────────────────────────────────

  /// Carga un draft persistido y restaura el estado reactivo del controller.
  ///
  /// Si el draft tenía un job activo, reanuda polling automáticamente.
  Future<AssetRegistrationDraftEntity?> loadDraft(String draftId) async {
    final normalizedDraftId = draftId.trim();
    if (normalizedDraftId.isEmpty) return null;

    _currentDraftId = normalizedDraftId;

    final draft = await _draftRepo.getDraft(normalizedDraftId);
    if (draft == null) {
      _log('loadDraft', 'draft no encontrado — draftId=$normalizedDraftId');
      return null;
    }

    _restoreStateFromDraft(draft);

    if (_shouldResumePolling(draft)) {
      _currentJobId = draft.runtJobId;
      _startPolling();
    }

    return draft;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Inicio de consulta
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> startQuery({
    required String draftId,
    required String plate,
    required String documentType,
    required String documentNumber,
  }) async {
    final normalizedDraftId = draftId.trim();
    final normalizedPlate = plate.trim().toUpperCase();
    final normalizedDocumentType = documentType.trim().toUpperCase();
    final normalizedDocumentNumber = documentNumber.trim();

    if (normalizedDraftId.isEmpty ||
        normalizedPlate.isEmpty ||
        normalizedDocumentType.isEmpty ||
        normalizedDocumentNumber.isEmpty) {
      return;
    }

    _currentDraftId = normalizedDraftId;
    _stopPolling();
    _resetReactiveStateForNewQuery();

    // Persiste en el controller para reutilizar en la pantalla de resultado
    // sin depender del backend scraper.
    ownerDocumentType.value = normalizedDocumentType;
    ownerDocumentNumber.value = normalizedDocumentNumber;

    viewState.value = RuntViewState.pending;

    await _persistPartial(
      plate: normalizedPlate,
      documentType: normalizedDocumentType,
      documentNumber: normalizedDocumentNumber,
      runtStatus: RuntViewState.pending.name,
      runtJobId: null,
      runtErrorMessage: null,
    );

    try {
      // [DIAG-A1] Antes de llamar al gateway
      debugPrint('[DIAG][startQuery] >>> llamando _queryGateway.startQuery plate=$normalizedPlate docType=$normalizedDocumentType');

      final result = await _queryGateway.startQuery(
        plate: normalizedPlate,
        ownerDocument: normalizedDocumentNumber,
        ownerDocumentType:
            RuntOwnerDocumentTypeMapper.toGatewayCode(normalizedDocumentType),
      );

      // [DIAG-A2] jobId recibido del gateway
      debugPrint('[DIAG][startQuery] <<< result.jobId=${result.jobId}');

      _currentJobId = result.jobId;

      // [DIAG-A3] jobId asignado a _currentJobId
      debugPrint('[DIAG][startQuery] _currentJobId asignado: $_currentJobId');

      viewState.value = RuntViewState.running;

      await _persistPartial(
        runtStatus: RuntViewState.running.name,
        runtJobId: _currentJobId,
      );

      // [DIAG-A4] Antes de llamar _startPolling
      debugPrint('[DIAG][startQuery] >>> llamando _startPolling()');
      _startPolling();
    } catch (e) {
      final msg = _extractErrorMessage(e);
      viewState.value = RuntViewState.failed;
      errorMessage.value = msg;

      await _persistPartial(
        runtStatus: RuntViewState.failed.name,
        runtErrorMessage: msg,
      );

      _log('startQuery', 'FAILED: $e');
      // [DIAG-A-ERR] Error en startQuery — polling nunca inicia
      debugPrint('[DIAG][startQuery] EXCEPTION — polling NO iniciado: $e');
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Nueva consulta / limpieza RUNT
  // ───────────────────────────────────────────────────────────────────────────

  /// Limpia solo el bloque RUNT del draft.
  ///
  /// Conserva:
  /// - Step 1
  /// - documentType
  /// - documentNumber
  ///
  /// Limpia:
  /// - runtJobId
  /// - runt state
  /// - runt progress
  /// - runt partial/final data
  ///
  /// Por UX, la placa también se limpia aquí para una nueva consulta limpia.
  Future<void> clearQueryState() async {
    _stopPolling();
    _currentJobId = null;
    _pollAttempts = 0;
    _resetReactiveStateToIdle();

    final draftId = _currentDraftId;
    if (draftId == null) return;

    final existing = await _draftRepo.getDraft(draftId);
    if (existing == null) return;

    final cleared = AssetRegistrationDraftEntity(
      draftId: existing.draftId,
      orgId: existing.orgId,
      assetType: existing.assetType,
      portfolioName: existing.portfolioName,
      countryId: existing.countryId,
      regionId: existing.regionId,
      cityId: existing.cityId,
      documentType: existing.documentType,
      documentNumber: existing.documentNumber,
      plate: null,
      runtJobId: null,
      runtStatus: RuntViewState.idle.name,
      runtProgressPercent: 0,
      runtErrorMessage: null,
      runtProgressJson: null,
      runtPartialDataJson: null,
      runtVehicleDataJson: null,
      runtUpdatedAt: null,
      runtCompletedAt: null,
      updatedAt: DateTime.now().toUtc(),
    );

    await _draftRepo.saveDraft(cleared);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Polling
  // ───────────────────────────────────────────────────────────────────────────

  void _startPolling() {
    _stopPolling();
    _pollAttempts = 0;
    isPolling.value = true;

    // [DIAG-B1] Polling iniciado
    debugPrint('[DIAG][_startPolling] POLLING STARTED — jobId=$_currentJobId interval=${_pollInterval.inSeconds}s');

    _pollingTimer = Timer.periodic(
      _pollInterval,
      (_) => _pollJobStatus(),
    );

    // [DIAG-B2] Timer creado
    debugPrint('[DIAG][_startPolling] Timer.periodic creado — timer=$_pollingTimer');

    _log('polling', 'iniciado — jobId=$_currentJobId');
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    isPolling.value = false;
  }

  Future<void> _pollJobStatus() async {
    // Guard: si ya llegamos a un estado terminal, descarta este tick.
    // Protege contra la race condition de Timer.periodic cuando la respuesta
    // HTTP de un tick anterior llega DESPUÉS de que _handleCompleted ya
    // estableció viewState=completed.
    if (_isTerminated) {
      _stopPolling();
      return;
    }

    // [DIAG-C1/D1] Tick del timer
    debugPrint('[DIAG][_pollJobStatus] TICK #${_pollAttempts + 1} — _currentJobId=$_currentJobId');

    final jobId = _currentJobId;
    if (jobId == null || jobId.trim().isEmpty) {
      // [DIAG-D2] jobId nulo o vacío — polling se detiene
      debugPrint('[DIAG][_pollJobStatus] ⚠️ jobId es NULL o vacío — DETENIENDO polling');
      _stopPolling();
      return;
    }

    _pollAttempts++;

    if (_pollAttempts > _maxPollAttempts) {
      await _failByTimeout();
      return;
    }

    // [DIAG-D3] Antes de llamar getJobStatus
    debugPrint('[DIAG][_pollJobStatus] intento=$_pollAttempts >>> llamando getJobStatus(jobId=$jobId)');

    try {
      final status = await _queryGateway.getJobStatus(jobId);

      // Guard post-await: otro tick pudo haber completado el job mientras
      // este estaba esperando la respuesta HTTP. Si ya terminamos, ignora.
      if (_isTerminated) return;

      steps.value = _normalizeSteps(status.steps);
      progressPercent.value = status.progressPercent;

      if (status.hasPartialData) {
        partialData.value = status.partialData;
      }

      if (status.isCompleted) {
        await _handleCompleted(status);
        return;
      }

      if (status.isFailed) {
        await _handleFailed(status);
        return;
      }

      viewState.value = _mapViewStateFromJob(status.status);

      if (_pollAttempts % _persistEveryNPolls == 0) {
        await _persistPartial(
          runtStatus: viewState.value.name,
          runtProgressPercent: status.progressPercent,
          // Persiste el estado ya normalizado, no el crudo del gateway.
          runtProgressJson: _encodeMap(steps.value.toJson()),
          runtPartialDataJson: _encodeMap(status.partialData),
          runtUpdatedAt: status.updatedAt,
        );
      }
    } catch (e) {
      _log('polling', 'error transitorio intento=$_pollAttempts: $e');
      // Intencionalmente no detenemos el polling por fallos transitorios.
    }
  }

  Future<void> _handleCompleted(RuntAsyncQueryStatusResult status) async {
    _stopPolling();
    _isTerminated = true;

    // Fuerza todos los bloques a "done" explícitamente al completar.
    // El backend puede reportar steps en estado "loading" en el último tick
    // antes de marcar el job como completado. Forzar "done" aquí garantiza
    // que la UI siempre muestre el checkmark / "Verificado" correcto.
    steps.value = const RuntQuerySteps(
      vehicle: RuntQueryStepStatus.done,
      soat: RuntQueryStepStatus.done,
      rtm: RuntQueryStepStatus.done,
      history: RuntQueryStepStatus.done,
    );

    viewState.value = RuntViewState.completed;
    progressPercent.value = 100;

    if (status.hasFinalData) {
      vehicleData.value = status.finalData;
    }

    await _persistPartial(
      runtStatus: RuntViewState.completed.name,
      runtProgressPercent: 100,
      // Persiste el estado ya normalizado (todos done), no el crudo del gateway.
      runtProgressJson: _encodeMap(steps.value.toJson()),
      runtPartialDataJson: _encodeMap(status.partialData),
      runtVehicleDataJson: _encodeMap(status.finalData),
      runtUpdatedAt: status.updatedAt,
      runtCompletedAt: status.completedAt ?? DateTime.now().toUtc(),
    );

    _log('polling', 'COMPLETED');
  }

  Future<void> _handleFailed(RuntAsyncQueryStatusResult status) async {
    _stopPolling();
    _isTerminated = true;

    final msg = status.error ?? 'Error en consulta RUNT.';
    viewState.value = RuntViewState.failed;
    errorMessage.value = msg;

    await _persistPartial(
      runtStatus: RuntViewState.failed.name,
      runtErrorMessage: msg,
      runtProgressJson: _encodeMap(status.steps.toJson()),
      runtUpdatedAt: status.updatedAt,
    );

    _log('polling', 'FAILED: $msg');
  }

  Future<void> _failByTimeout() async {
    _stopPolling();
    _isTerminated = true;

    const timeoutMsg = 'La consulta RUNT tardó demasiado. Intente nuevamente.';
    viewState.value = RuntViewState.failed;
    errorMessage.value = timeoutMsg;

    await _persistPartial(
      runtStatus: RuntViewState.failed.name,
      runtErrorMessage: timeoutMsg,
    );

    _log('polling', 'TIMEOUT after $_pollAttempts intents');
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Persistencia parcial del draft
  // ───────────────────────────────────────────────────────────────────────────

  Future<void> _persistPartial({
    String? plate,
    String? documentType,
    String? documentNumber,
    String? runtStatus,
    String? runtJobId,
    int? runtProgressPercent,
    String? runtErrorMessage,
    String? runtProgressJson,
    String? runtPartialDataJson,
    String? runtVehicleDataJson,
    DateTime? runtUpdatedAt,
    DateTime? runtCompletedAt,
  }) async {
    final draftId = _currentDraftId;
    if (draftId == null) return;

    final existing = await _draftRepo.getDraft(draftId);
    if (existing == null) {
      _log('_persistPartial', 'draft no encontrado — draftId=$draftId');
      return;
    }

    final updated = existing.copyWith(
      plate: plate,
      documentType: documentType,
      documentNumber: documentNumber,
      runtStatus: runtStatus,
      runtJobId: runtJobId,
      runtProgressPercent: runtProgressPercent,
      runtErrorMessage: runtErrorMessage,
      runtProgressJson: runtProgressJson,
      runtPartialDataJson: runtPartialDataJson,
      runtVehicleDataJson: runtVehicleDataJson,
      runtUpdatedAt: runtUpdatedAt,
      runtCompletedAt: runtCompletedAt,
      updatedAt: DateTime.now().toUtc(),
    );

    await _draftRepo.saveDraft(updated);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Restauración desde draft
  // ───────────────────────────────────────────────────────────────────────────

  void _restoreStateFromDraft(AssetRegistrationDraftEntity draft) {
    viewState.value = _viewStateFromString(draft.runtStatus);
    progressPercent.value = draft.runtProgressPercent ?? 0;
    errorMessage.value = draft.runtErrorMessage;

    // Restaura los datos del formulario para que el resultado los muestre
    // incluso si el controller fue recreado (ej.: después de hot restart).
    ownerDocumentType.value = draft.documentType;
    ownerDocumentNumber.value = draft.documentNumber;

    if (draft.runtProgressJson != null &&
        draft.runtProgressJson!.trim().isNotEmpty) {
      try {
        steps.value = RuntQuerySteps.fromJson(
          jsonDecode(draft.runtProgressJson!) as Map<String, dynamic>,
        );
      } catch (_) {
        steps.value = RuntQuerySteps.allPending();
      }
    } else {
      steps.value = RuntQuerySteps.allPending();
    }

    if (draft.runtPartialDataJson != null &&
        draft.runtPartialDataJson!.trim().isNotEmpty) {
      try {
        partialData.value =
            jsonDecode(draft.runtPartialDataJson!) as Map<String, dynamic>;
      } catch (_) {
        partialData.value = null;
      }
    } else {
      partialData.value = null;
    }

    if (draft.runtVehicleDataJson != null &&
        draft.runtVehicleDataJson!.trim().isNotEmpty) {
      try {
        vehicleData.value =
            jsonDecode(draft.runtVehicleDataJson!) as Map<String, dynamic>;
      } catch (_) {
        vehicleData.value = null;
      }
    } else {
      vehicleData.value = null;
    }
  }

  bool _shouldResumePolling(AssetRegistrationDraftEntity draft) {
    final isActive = draft.runtStatus == RuntViewState.pending.name ||
        draft.runtStatus == RuntViewState.running.name;

    final hasJob =
        draft.runtJobId != null && draft.runtJobId!.trim().isNotEmpty;

    return isActive && hasJob;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Helpers de estado
  // ───────────────────────────────────────────────────────────────────────────

  void _resetReactiveStateForNewQuery() {
    _isTerminated = false;
    progressPercent.value = 0;
    steps.value = RuntQuerySteps.allPending();
    errorMessage.value = null;
    partialData.value = null;
    vehicleData.value = null;
    isPolling.value = false;
    // ownerDocumentType/Number se establecen en startQuery() después de
    // este reset, así que NO los limpiamos aquí.
  }

  void _resetReactiveStateToIdle() {
    _isTerminated = false;
    viewState.value = RuntViewState.idle;
    progressPercent.value = 0;
    steps.value = RuntQuerySteps.allPending();
    errorMessage.value = null;
    partialData.value = null;
    vehicleData.value = null;
    isPolling.value = false;
    ownerDocumentType.value = null;
    ownerDocumentNumber.value = null;
  }

  RuntViewState _mapViewStateFromJob(RuntQueryJobStatus status) {
    switch (status) {
      case RuntQueryJobStatus.pending:
        return RuntViewState.pending;
      case RuntQueryJobStatus.running:
        return RuntViewState.running;
      case RuntQueryJobStatus.completed:
        return RuntViewState.completed;
      case RuntQueryJobStatus.failed:
        return RuntViewState.failed;
    }
  }

  RuntViewState _viewStateFromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'pending':
        return RuntViewState.pending;
      case 'running':
        return RuntViewState.running;
      case 'completed':
        return RuntViewState.completed;
      case 'failed':
        return RuntViewState.failed;
      default:
        return RuntViewState.idle;
    }
  }

  String? _encodeMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return null;
    try {
      return jsonEncode(map);
    } catch (_) {
      return null;
    }
  }

  String _extractErrorMessage(Object e) {
    final raw = e.toString();
    if (raw.startsWith('Exception: ')) {
      return raw.substring('Exception: '.length);
    }
    return raw;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Normalización de pasos — regla voraz hacia atrás
  // ───────────────────────────────────────────────────────────────────────────

  /// Normaliza los steps recibidos del backend para garantizar progreso
  /// siempre hacia adelante: si un bloque posterior está activo (loading,
  /// done o failed), todos los bloques anteriores deben estar en done.
  ///
  /// Orden canónico: vehicle(0) → soat(1) → rtm(2) → history(3)
  ///
  /// Ejemplos:
  /// - soat loading   → vehicle=done, soat=loading, resto=pending
  /// - rtm failed     → vehicle=done, soat=done, rtm=failed, history=pending
  /// - todos done     → sin cambio
  RuntQuerySteps _normalizeSteps(RuntQuerySteps raw) {
    final rawList = <RuntQueryStepStatus>[
      raw.vehicle,
      raw.soat,
      raw.rtm,
      raw.history,
    ];

    // Busca el índice más alto con estado no-pending (el frente de avance).
    int highestActive = -1;
    for (int i = rawList.length - 1; i >= 0; i--) {
      if (rawList[i] != RuntQueryStepStatus.pending) {
        highestActive = i;
        break;
      }
    }

    // Nada ha iniciado aún — devuelve sin cambios.
    if (highestActive == -1) return raw;

    // Todos los bloques ANTES del frente de avance deben quedar en done.
    final normalized = List<RuntQueryStepStatus>.from(rawList);
    for (int i = 0; i < highestActive; i++) {
      normalized[i] = RuntQueryStepStatus.done;
    }

    return RuntQuerySteps(
      vehicle: normalized[0],
      soat: normalized[1],
      rtm: normalized[2],
      history: normalized[3],
    );
  }

  void _log(String action, String message) {
    if (kDebugMode) {
      debugPrint('[RuntQueryCtrl][$action] $message');
    }
  }
}
