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
//   7. cold-start recovery: detectar job huérfano, ofrecer recuperación
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
// - SharedPreferences (recovery snapshot — simple KV, no Isar)
//
// Con esto evitamos:
//   presentation → data/service
//
// y mantenemos una separación más limpia de capas.
//
// COLD-START RECOVERY
// Al iniciar `startQuery()` exitosamente se graba un snapshot en
// SharedPreferences con {jobId, draftId, plate, timestampMs}.
// El snapshot se limpia en todos los estados terminales (completed,
// failed, partial, timeout, jobUnavailable).
// NO se limpia en `connectionInterrupted` — el job sigue vivo.
// `checkForOrphanedRuntJob()` lee el snapshot, hace UN check de backend
// y retorna un `RuntRecoveryOffer` tipado para que la UI ofrezca
// las opciones correctas.
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
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/runt/runt_async_query_gateway.dart';
import '../../../core/exceptions/api_exceptions.dart';
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

  /// Fallo total — sin datos utilizables.
  failed,

  /// Fallo parcial utilizable: backend reportó
  /// `failureReason == PARTIAL_EXTRACTION_ERROR` con `partialData != null`.
  /// Se navega a resultado igual que `completed`, pero con datos parciales.
  partial,

  /// Job confirmadamente no recuperable: backend respondió 404, JOB_NOT_FOUND
  /// o equivalente semántico — ese `jobId` ya no existe o expiró.
  ///
  /// Diferencia crítica respecto a [connectionInterrupted]:
  /// - `connectionInterrupted` = Flutter no pudo CONFIRMAR el estado (red caída).
  /// - `jobUnavailable` = backend CONFIRMÓ que el job ya no está disponible.
  ///
  /// En este estado:
  /// - El `jobId` se limpia en memoria.
  /// - El draft se marca para no volver a reanudar este job.
  /// - Se ofrece iniciar una nueva consulta.
  jobUnavailable,

  /// Conectividad interrumpida durante el polling.
  ///
  /// El job sigue vivo en el backend (TTL ~30 min). El `jobId` está preservado
  /// en el draft. El usuario puede reanudar el seguimiento con [resumePolling].
  /// NO debe tratarse como fallo real del job ni como timeout definitivo.
  connectionInterrupted,
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
// Cold-start recovery types
// ─────────────────────────────────────────────────────────────────────────────

/// Tipo de recuperación para un job RUNT huérfano detectado en cold-start.
///
/// Determina el copy y las acciones del bottom sheet de recuperación.
/// El tipo `unavailable` nunca llega a la UI — se limpia internamente.
enum RuntRecoveryType {
  /// Job completado con datos finales listos para registrar el activo.
  readyToRegister,

  /// Job fallido con datos parciales utilizables (PARTIAL_EXTRACTION_ERROR).
  partialToReview,

  /// Job todavía en ejecución en backend. Se puede retomar el seguimiento.
  runningRecoverable,
}

/// Oferta de recuperación de un job RUNT huérfano.
///
/// Construida por [RuntQueryController.checkForOrphanedRuntJob] después de
/// confirmar con el backend el estado real del job.
///
/// - [type] determina la acción de [RuntQueryController.acceptRecovery].
/// - [finalData] / [partialData] solo se populan según [type] para que
///   [acceptRecovery] no necesite un segundo round-trip al backend.
/// - [isPortfolioMismatch] indica que el job pertenece a un portafolio
///   distinto al contexto actual — la UI debe mostrar el flujo de
///   redirección, no el de recovery normal.
final class RuntRecoveryOffer {
  /// Tipo de recuperación disponible.
  final RuntRecoveryType type;

  /// jobId del job huérfano — necesario para retomar polling.
  final String jobId;

  /// draftId del draft de la sesión anterior — necesario para persistir.
  final String draftId;

  /// Placa consultada — se muestra en la UI del bottom sheet.
  final String plate;

  /// ID del portafolio donde se inició la consulta original.
  final String portfolioId;

  /// Nombre del portafolio donde se inició la consulta original.
  /// Se muestra en el bottom sheet de redirección.
  final String portfolioName;

  /// Momento en que se guardó el snapshot original (UTC).
  final DateTime snapshotTime;

  /// true si el job pertenece a un portafolio distinto al actual.
  ///
  /// Cuando es true la UI muestra [_CrossPortfolioBottomSheet] en lugar del
  /// flujo normal de recovery. El snapshot NO se limpia en este caso.
  final bool isPortfolioMismatch;

  /// Datos finales del job.
  /// Solo no-null cuando [type] == [RuntRecoveryType.readyToRegister].
  final Map<String, dynamic>? finalData;

  /// Datos parciales del job.
  /// Solo no-null cuando [type] == [RuntRecoveryType.partialToReview].
  final Map<String, dynamic>? partialData;

  const RuntRecoveryOffer({
    required this.type,
    required this.jobId,
    required this.draftId,
    required this.plate,
    required this.portfolioId,
    required this.portfolioName,
    required this.snapshotTime,
    this.isPortfolioMismatch = false,
    this.finalData,
    this.partialData,
  });
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

  /// Oferta de recuperación de un job RUNT huérfano detectado en cold-start.
  ///
  /// Solo no-null entre la llamada a [checkForOrphanedRuntJob] y la resolución
  /// del usuario vía [acceptRecovery] o [dismissRecovery].
  final recoveryOffer = Rx<RuntRecoveryOffer?>(null);

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

  /// portfolioId del job recuperado vía [acceptRecovery].
  ///
  /// Solo no-null cuando el usuario aceptó un recovery de job huérfano.
  /// Nil en consultas nuevas (se limpia en [_resetReactiveStateForNewQuery]).
  /// Usado como guardrail en [AssetRegistrationController.registerVehicle]
  /// para abortar si el portfolioId del recovery no coincide con el contexto.
  String? _recoveredPortfolioId;

  /// portfolioId del job recuperado más reciente.
  ///
  /// Expuesto para el guardrail final en [AssetRegistrationController].
  String? get recoveredPortfolioId => _recoveredPortfolioId;

  /// Bandera que indica que el job ya llegó a un estado terminal
  /// (completed / failed / timeout).
  ///
  /// Cuando es `true`, cualquier callback del Timer.periodic que todavía
  /// estuviera en vuelo (awaiting HTTP) debe ignorar su respuesta y no
  /// sobrescribir el estado final ya establecido.
  ///
  /// Se fija en `true` en [_handleCompleted], [_handleFailed] y
  /// [_failByTimeout]. Se resetea en [_resetReactiveStateForNewQuery],
  /// [_resetReactiveStateToIdle] y [resumePolling].
  bool _isTerminated = false;

  /// Contador de fallos de red consecutivos durante el polling.
  ///
  /// Se incrementa en cada tick que falla por error de red/HTTP.
  /// Se resetea a 0 en cada tick exitoso.
  /// Al superar [_kMaxConsecutiveNetworkErrors] → [_handleConnectionInterrupted].
  int _consecutiveNetworkErrors = 0;

  static const int _maxPollAttempts = 90;
  static const Duration _pollInterval = Duration(seconds: 2);

  /// Errores de red consecutivos tolerados antes de entrar a `connectionInterrupted`.
  /// 3 × 2s = 6s sin respuesta es señal suficiente de pérdida de conectividad.
  static const int _kMaxConsecutiveNetworkErrors = 3;

  /// Persistencia de progreso durante job en curso.
  ///
  /// Evita escribir en cada tick.
  static const int _persistEveryNPolls = 10;

  // ── Cold-start recovery ──────────────────────────────────────────────────

  /// Clave en SharedPreferences para el snapshot de recovery.
  static const String _kRecoverySnapshotKey = 'runt_recovery_snapshot';

  /// TTL del job en backend (~30 min). Snapshots más antiguos se descartan
  /// sin contactar al backend — el job ya expiró.
  static const Duration _kJobTtl = Duration(minutes: 30);

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
    required String portfolioId,
    required String portfolioName,
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

      // Guarda snapshot para cold-start recovery.
      // Se limpia cuando el job llega a un estado terminal.
      // NO se limpia en connectionInterrupted — el job sigue vivo en backend.
      await _saveRecoverySnapshot(
        jobId: _currentJobId!,
        draftId: normalizedDraftId,
        plate: normalizedPlate,
        portfolioId: portfolioId,
        portfolioName: portfolioName,
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
    _recoveredPortfolioId = null;
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

      // Tick exitoso — resetear contador de errores de red consecutivos.
      _consecutiveNetworkErrors = 0;

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
      // Clasificación taxonómica de errores de polling:
      // - job no recuperable (404 / JOB_NOT_FOUND) → jobUnavailable inmediato
      // - error de conectividad (red caída, socket, timeout) → contador → connectionInterrupted
      // - error incierto (parsing, server) → conservador: cuenta como red

      if (_isJobNotFound(e)) {
        _log('polling', 'JOB NOT FOUND — jobId=$_currentJobId ya no recuperable: $e');
        await _handleJobNotFound();
        return;
      }

      _consecutiveNetworkErrors++;
      _log('polling',
          'error de red consecutivo=$_consecutiveNetworkErrors intento=$_pollAttempts: $e');

      if (_consecutiveNetworkErrors >= _kMaxConsecutiveNetworkErrors) {
        await _handleConnectionInterrupted();
      }
    }
  }

  /// Conectividad interrumpida durante el polling.
  ///
  /// Detiene el timer de polling, persiste el estado en el draft (conservando
  /// el `jobId`) y emite `connectionInterrupted` a la UI.
  ///
  /// NO marca `_isTerminated = true` — el job sigue vivo en backend.
  /// El usuario puede reanudar con [resumePolling].
  Future<void> _handleConnectionInterrupted() async {
    _stopPolling();

    viewState.value = RuntViewState.connectionInterrupted;

    // Persiste status sin tocar runtJobId — es la clave para recuperar.
    await _persistPartial(
      runtStatus: RuntViewState.connectionInterrupted.name,
    );

    _log('polling',
        'CONNECTION INTERRUPTED — jobId=$_currentJobId conservado para recuperación');
  }

  /// Reanuda el polling del job activo después de una interrupción de red.
  ///
  /// Llamado desde la UI cuando el usuario toca "Reintentar seguimiento".
  /// Requiere que `_currentJobId` esté todavía disponible en memoria.
  void resumePolling() {
    final jobId = _currentJobId;
    if (jobId == null || jobId.trim().isEmpty) {
      _log('resumePolling', '⚠️ jobId no disponible — no se puede reanudar');
      return;
    }

    _isTerminated = false;
    _consecutiveNetworkErrors = 0;
    viewState.value = RuntViewState.running;

    _log('resumePolling', 'reanudando polling — jobId=$jobId');
    _startPolling();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Clasificación taxonómica de errores de polling
  // ───────────────────────────────────────────────────────────────────────────

  /// Retorna `true` si el error confirma que el job ya no existe en backend.
  ///
  /// Criterios (en orden de confiabilidad):
  /// - HTTP 404 explícito.
  /// - Mensaje del backend que incluye `JOB_NOT_FOUND` o equivalente.
  ///
  /// Diferencia clave con errores de red: este error tiene RESPUESTA semántica
  /// del servidor, no silencio de transporte.
  ///
  /// TODO(TECH-DEBT): el clasificador cubre 404 y keywords en mensaje.
  /// Si backend evoluciona a responder 410 Gone, 422, o un campo semántico
  /// estructurado (ej. `errorCode: "JOB_NOT_FOUND"` en el body), ampliar
  /// este método. El único punto de cambio necesario es aquí.
  /// Ref: RuntApiException.statusCode + RuntApiException.message.
  bool _isJobNotFound(Object e) {
    if (e is! RuntApiException) return false;
    if (e.statusCode == 404) return true;
    final msg = e.message.toUpperCase();
    return msg.contains('JOB_NOT_FOUND') ||
        msg.contains('JOB NOT FOUND') ||
        (msg.contains('NOT FOUND') && msg.contains('JOB'));
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Handlers terminales y de recuperación
  // ───────────────────────────────────────────────────────────────────────────

  /// Job confirmadamente no recuperable: backend respondió 404 o JOB_NOT_FOUND.
  ///
  /// - Limpia `_currentJobId` en memoria para impedir reintentos.
  /// - Marca `_isTerminated = true`.
  /// - Persiste `jobUnavailable` en el draft (sin tocar el jobId del draft
  ///   porque `_shouldResumePolling` ya no reconoce este estado como activo).
  /// - Emite `jobUnavailable` a la UI para mostrar "nueva consulta".
  Future<void> _handleJobNotFound() async {
    _stopPolling();
    _isTerminated = true;
    await _clearRecoverySnapshot();
    _currentJobId = null; // Impide que resumePolling() vuelva a intentarlo.

    viewState.value = RuntViewState.jobUnavailable;

    await _persistPartial(
      runtStatus: RuntViewState.jobUnavailable.name,
    );

    _log('polling', 'JOB UNAVAILABLE — draft marcado, jobId limpiado en memoria');
  }

  Future<void> _handleCompleted(RuntAsyncQueryStatusResult status) async {
    _stopPolling();
    _isTerminated = true;
    await _clearRecoverySnapshot();

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
    await _clearRecoverySnapshot();

    // Fallo parcial utilizable: backend indica extracción parcial con datos.
    // NO tratar como error total — navegar a resultado con datos parciales.
    final isPartial = status.failureReason == 'PARTIAL_EXTRACTION_ERROR' &&
        status.hasPartialData;

    if (isPartial) {
      vehicleData.value = status.partialData;
      viewState.value = RuntViewState.partial;

      await _persistPartial(
        runtStatus: RuntViewState.partial.name,
        runtProgressJson: _encodeMap(status.steps.toJson()),
        runtPartialDataJson: _encodeMap(status.partialData),
        runtVehicleDataJson: _encodeMap(status.partialData),
        runtUpdatedAt: status.updatedAt,
      );

      _log('polling', 'PARTIAL — datos parciales disponibles');
      return;
    }

    // Fallo total: priorizar failureMessage > failureReason > error (legacy).
    final msg = status.failureMessage ??
        status.failureReason ??
        status.error ??
        'No fue posible completar la consulta oficial.';

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
    await _clearRecoverySnapshot();

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
    // `connectionInterrupted` también se reactiva: el job puede seguir vivo
    // en backend (TTL ~30 min). El primer tick del polling resolverá el estado real.
    final isActive = draft.runtStatus == RuntViewState.pending.name ||
        draft.runtStatus == RuntViewState.running.name ||
        draft.runtStatus == RuntViewState.connectionInterrupted.name;

    final hasJob =
        draft.runtJobId != null && draft.runtJobId!.trim().isNotEmpty;

    return isActive && hasJob;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Helpers de estado
  // ───────────────────────────────────────────────────────────────────────────

  void _resetReactiveStateForNewQuery() {
    _isTerminated = false;
    _consecutiveNetworkErrors = 0;
    _recoveredPortfolioId = null; // Nueva consulta — sin recovery activo.
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
      case 'partial':
        return RuntViewState.partial;
      case 'connectionInterrupted':
        return RuntViewState.connectionInterrupted;
      case 'jobUnavailable':
        return RuntViewState.jobUnavailable;
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

  // ───────────────────────────────────────────────────────────────────────────
  // Cold-start recovery — API pública
  // ───────────────────────────────────────────────────────────────────────────

  /// Verifica si existe un job RUNT huérfano de la sesión anterior.
  ///
  /// [currentPortfolioId] es el portafolio del contexto actual (del entry
  /// point que abre el flujo de registro). Se compara con el portfolioId
  /// grabado en el snapshot para detectar uso cruzado de portafolios.
  ///
  /// Flujo:
  /// 1. Lee el snapshot de SharedPreferences.
  /// 2. Descarta si le faltan campos de portafolio (snapshot legacy sin
  ///    portfolioId — no se puede validar contexto → descarte seguro).
  /// 3. Descarta si es más antiguo que [_kJobTtl] (30 min).
  /// 4. Hace UN solo check de status con el backend.
  /// 5a. Si hay mismatch de portafolio → retorna oferta con
  ///    [isPortfolioMismatch]=true. NO limpia snapshot (el job sigue siendo
  ///    válido en el portafolio correcto).
  /// 5b. Sin mismatch → retorna oferta tipada normal, o `null` si el job
  ///    no es recuperable.
  ///
  /// Nota: no muta el estado del controller. La mutación ocurre en
  /// [acceptRecovery] cuando el usuario confirma.
  Future<RuntRecoveryOffer?> checkForOrphanedRuntJob(
    String currentPortfolioId,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kRecoverySnapshotKey);
      if (raw == null) return null;

      final map = _decodeJsonMap(raw);
      if (map == null) {
        await _clearRecoverySnapshot();
        return null;
      }

      final jobId = map['jobId'] as String?;
      final draftId = map['draftId'] as String?;
      final plate = map['plate'] as String?;
      final timestampMs = map['timestampMs'] as int?;
      final snapshotPortfolioId = map['portfolioId'] as String?;
      final snapshotPortfolioName = map['portfolioName'] as String?;

      if (jobId == null ||
          draftId == null ||
          plate == null ||
          timestampMs == null) {
        await _clearRecoverySnapshot();
        return null;
      }

      // Snapshot legacy (sin portfolioId): no se puede validar contexto.
      // Descartar silenciosamente — es más seguro que permitir uso cruzado.
      if (snapshotPortfolioId == null || snapshotPortfolioName == null) {
        _log('recovery', 'snapshot legacy sin portfolioId — descartando');
        await _clearRecoverySnapshot();
        return null;
      }

      // TTL check — si el job expiró en backend no vale la pena contactarlo.
      final snapshotTime =
          DateTime.fromMillisecondsSinceEpoch(timestampMs, isUtc: true);
      if (DateTime.now().toUtc().difference(snapshotTime) > _kJobTtl) {
        _log('recovery', 'snapshot expirado (>30 min) — limpiando');
        await _clearRecoverySnapshot();
        return null;
      }

      // ── PUNTO ÚNICO DE CONTROL DE PORTAFOLIO ─────────────────────────────
      // Si hay mismatch, retornamos la oferta con isPortfolioMismatch=true
      // SIN limpiar el snapshot — el job pertenece al portafolio correcto
      // y debe poder recuperarse desde allí.
      final isMismatch = snapshotPortfolioId != currentPortfolioId;

      // Un solo check de estado al backend.
      final RuntAsyncQueryStatusResult status;
      try {
        status = await _queryGateway.getJobStatus(jobId);
      } catch (e) {
        if (_isJobNotFound(e)) {
          _log('recovery', 'jobId=$jobId ya no existe en backend — limpiando');
          await _clearRecoverySnapshot();
          return null;
        }
        // Error de red — no podemos confirmar el estado.
        // No molestamos al usuario con una oferta incierta.
        _log('recovery', 'error de red al verificar jobId=$jobId: $e');
        return null;
      }

      // Job completado con datos finales.
      if (status.isCompleted && status.hasFinalData) {
        return RuntRecoveryOffer(
          type: RuntRecoveryType.readyToRegister,
          jobId: jobId,
          draftId: draftId,
          plate: plate,
          portfolioId: snapshotPortfolioId,
          portfolioName: snapshotPortfolioName,
          snapshotTime: snapshotTime,
          isPortfolioMismatch: isMismatch,
          finalData: isMismatch ? null : status.finalData,
        );
      }

      // Job fallido — puede tener datos parciales utilizables.
      if (status.isFailed) {
        if (status.failureReason == 'PARTIAL_EXTRACTION_ERROR' &&
            status.hasPartialData) {
          return RuntRecoveryOffer(
            type: RuntRecoveryType.partialToReview,
            jobId: jobId,
            draftId: draftId,
            plate: plate,
            portfolioId: snapshotPortfolioId,
            portfolioName: snapshotPortfolioName,
            snapshotTime: snapshotTime,
            isPortfolioMismatch: isMismatch,
            partialData: isMismatch ? null : status.partialData,
          );
        }
        // Fallo sin datos recuperables — limpia silenciosamente.
        _log('recovery', 'job fallido sin datos recuperables — limpiando');
        await _clearRecoverySnapshot();
        return null;
      }

      // Job todavía en ejecución (pending o running) — se puede retomar.
      return RuntRecoveryOffer(
        type: RuntRecoveryType.runningRecoverable,
        jobId: jobId,
        draftId: draftId,
        plate: plate,
        portfolioId: snapshotPortfolioId,
        portfolioName: snapshotPortfolioName,
        snapshotTime: snapshotTime,
        isPortfolioMismatch: isMismatch,
      );
    } catch (e) {
      _log('recovery', 'error inesperado en checkForOrphanedRuntJob: $e');
      return null;
    }
  }

  /// Acepta la oferta de recuperación y prepara el controller para continuar.
  ///
  /// - [readyToRegister]: restaura datos finales, emite `completed`.
  /// - [partialToReview]: restaura datos parciales, emite `partial`.
  /// - [runningRecoverable]: restablece el jobId y reanuda el polling.
  ///
  /// Después de este método la página navegante debe llamar al destino
  /// correspondiente (runtQueryResult para los dos primeros, runtQueryProgress
  /// para `runningRecoverable`).
  Future<void> acceptRecovery(RuntRecoveryOffer offer) async {
    recoveryOffer.value = null;

    // Guardar portfolioId del job recuperado para el guardrail final.
    // Solo se llama cuando NO hay mismatch (la UI no invoca acceptRecovery
    // en flujo cross-portfolio). El guardrail en registerVehicle verifica esto.
    _recoveredPortfolioId = offer.portfolioId;

    switch (offer.type) {
      case RuntRecoveryType.readyToRegister:
        _currentDraftId = offer.draftId;
        _currentJobId = offer.jobId;
        _isTerminated = true;
        vehicleData.value = offer.finalData;
        viewState.value = RuntViewState.completed;
        progressPercent.value = 100;
        steps.value = const RuntQuerySteps(
          vehicle: RuntQueryStepStatus.done,
          soat: RuntQueryStepStatus.done,
          rtm: RuntQueryStepStatus.done,
          history: RuntQueryStepStatus.done,
        );
        await _persistPartial(
          runtStatus: RuntViewState.completed.name,
          runtProgressPercent: 100,
          runtVehicleDataJson: _encodeMap(offer.finalData),
          runtCompletedAt: DateTime.now().toUtc(),
        );
        await _clearRecoverySnapshot();

      case RuntRecoveryType.partialToReview:
        _currentDraftId = offer.draftId;
        _currentJobId = offer.jobId;
        _isTerminated = true;
        vehicleData.value = offer.partialData;
        partialData.value = offer.partialData;
        viewState.value = RuntViewState.partial;
        await _persistPartial(
          runtStatus: RuntViewState.partial.name,
          runtVehicleDataJson: _encodeMap(offer.partialData),
          runtPartialDataJson: _encodeMap(offer.partialData),
        );
        await _clearRecoverySnapshot();

      case RuntRecoveryType.runningRecoverable:
        _currentDraftId = offer.draftId;
        _currentJobId = offer.jobId;
        _isTerminated = false;
        _consecutiveNetworkErrors = 0;
        viewState.value = RuntViewState.running;
        await _persistPartial(
          runtStatus: RuntViewState.running.name,
          runtJobId: offer.jobId,
        );
        _startPolling();
    }

    _log('recovery', 'acceptRecovery(${offer.type.name}) — draftId=${offer.draftId}');
  }

  /// Descarta la oferta de recuperación y limpia el snapshot.
  ///
  /// Llamado cuando el usuario elige iniciar una consulta nueva en lugar
  /// de recuperar el job huérfano.
  void dismissRecovery() {
    recoveryOffer.value = null;
    _recoveredPortfolioId = null;
    _clearRecoverySnapshot();
    _log('recovery', 'oferta descartada — snapshot limpiado');
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Cold-start recovery — helpers privados
  // ───────────────────────────────────────────────────────────────────────────

  /// Graba el snapshot de recovery en SharedPreferences.
  ///
  /// Llamado justo después de confirmar el jobId en [startQuery].
  /// Silencia errores para no bloquear el flujo principal.
  Future<void> _saveRecoverySnapshot({
    required String jobId,
    required String draftId,
    required String plate,
    required String portfolioId,
    required String portfolioName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final snapshot = jsonEncode({
        'jobId': jobId,
        'draftId': draftId,
        'plate': plate,
        'portfolioId': portfolioId,
        'portfolioName': portfolioName,
        'timestampMs': DateTime.now().toUtc().millisecondsSinceEpoch,
      });
      await prefs.setString(_kRecoverySnapshotKey, snapshot);
      _log('recovery', 'snapshot guardado — jobId=$jobId plate=$plate portfolioId=$portfolioId');
    } catch (e) {
      _log('recovery', 'error al guardar snapshot: $e');
    }
  }

  /// Limpia el snapshot de recovery de SharedPreferences.
  ///
  /// Llamado en todos los estados terminales: completed, failed, partial,
  /// timeout y jobUnavailable. NO se llama en connectionInterrupted.
  /// Silencia errores — si falla, el TTL garantiza expiración natural.
  Future<void> _clearRecoverySnapshot() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kRecoverySnapshotKey);
    } catch (e) {
      _log('recovery', 'error al limpiar snapshot: $e');
    }
  }

  /// Deserializa un string JSON a `Map<String, dynamic>`.
  /// Retorna `null` si el string es inválido o no es un objeto JSON.
  Map<String, dynamic>? _decodeJsonMap(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  void _log(String action, String message) {
    if (kDebugMode) {
      debugPrint('[RuntQueryCtrl][$action] $message');
    }
  }
}
