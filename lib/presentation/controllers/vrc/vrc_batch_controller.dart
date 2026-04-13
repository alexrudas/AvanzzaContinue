// ============================================================================
// lib/presentation/controllers/vrc/vrc_batch_controller.dart
// VRC BATCH CONTROLLER — Presentation Layer / GetX Controller
//
// QUÉ HACE:
// - Gestiona el estado reactivo de la consulta VRC multi-placa (batch).
// - Crea el batch via POST /v1/vrc-batches y guarda el batchId.
// - Implementa polling cada 3 s con backoff progresivo ante errores de red.
// - Actualiza el estado de cada placa individualmente a medida que el backend
//   procesa los ítems: consulting → success | failed.
// - Detiene el polling cuando el batch alcanza estado terminal o timeout (120 s).
// - Cancela el polling en onClose() para no dejar timers huérfanos.
//
// QUÉ NO HACE:
// - No registra activos — eso lo hace AssetRegistrationController por placa.
// - No persiste en Isar — el estado vive en memoria durante la sesión.
// - No configura el Dio ni el VrcService.
//
// PRINCIPIOS:
// - Polling interno: Timer.periodic cancelado en onClose() y en startBatch()
//   (por si el usuario reinicia una consulta sin cerrar el controller).
// - Backoff de errores: >3 errores consecutivos → stop + mensaje.
// - isCreating solo es true durante el POST inicial (no durante el polling).
// - orgId / requestedBy se resuelven internamente desde SessionContextController.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Multi-plate batch registration — Phase 1.
// Registrado en AssetRegistrationBinding con fenix:true.
// ACTUALIZADO (2026-04): Fail-fast por placa — _mapItemStatus() usa errorCode
//   y retryable del backend. retryable=false + errorCode → failed inmediato
//   sin esperar timeout global. errorCode propagado a VehiclePlateItem.
// ============================================================================

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/exceptions/api_exceptions.dart';
import '../../../data/vrc/models/vrc_batch_models.dart';
import '../../../data/vrc/models/vrc_models.dart';
import '../../../data/vrc/vrc_service.dart';
import '../../../domain/value/registration/vehicle_plate_item.dart';
import '../session_context_controller.dart';

/// Controller GetX para el flujo de consulta VRC batch (multi-placa).
class VrcBatchController extends GetxController {
  final VrcService _service;

  VrcBatchController(this._service);

  // ── Estado observable ──────────────────────────────────────────────────────

  /// ID del batch creado en el backend.
  ///
  /// Null antes de que el POST responda exitosamente.
  final batchId = RxnString();

  /// Estado global del batch: queued | running | completed |
  /// partially_completed | failed | cancelled.
  ///
  /// Vacío antes de la primera respuesta del backend.
  final overallStatus = ''.obs;

  /// Lista de placas con su estado individual de consulta.
  ///
  /// Se inicializa con status=consulting al invocar [startBatch].
  /// Se actualiza item-by-item durante el polling.
  final items = <VehiclePlateItem>[].obs;

  /// True durante el POST inicial de creación del batch.
  final isCreating = false.obs;

  /// Mensaje de error global (creación o polling fallido irrecuperablemente).
  ///
  /// Null cuando no hay error. Los errores por ítem viven en item.errorMessage.
  final errorMessage = RxnString();

  // ── Datos del propietario (cacheados, persona-céntrico) ────────────────────

  /// Datos completos del propietario extraídos del primer ítem succeeded.
  ///
  /// Se fija en el primer ítem con status=succeeded + context != null.
  /// Una vez fijado NUNCA se sobreescribe — ver [_ownerCached].
  /// Null mientras no haya ningún ítem succeeded (muestra placeholder).
  final ownerData = Rxn<VrcDataModel>();

  /// true cuando [ownerData] ya fue fijado — impide recalcular en cada poll.
  bool _ownerCached = false;

  /// Contextos VRC por placa (plate.toUpperCase() → VrcDataModel).
  ///
  /// Permite a los tiles de vehículo mostrar marca/línea/modelo/servicio
  /// sin necesidad de buscar en la lista de ítems del backend en cada build.
  /// Se pobla en [_applyItemUpdates] de forma no-observable (no dispara Obx).
  final Map<String, VrcDataModel> vehicleContexts = {};

  // ── Polling internals ──────────────────────────────────────────────────────

  /// Intervalo entre polls.
  static const _pollInterval = Duration(seconds: 3);

  /// Máximo de intentos antes de declarar timeout (40 × 3 s = 120 s).
  static const _maxPollAttempts = 40;

  /// Errores consecutivos de red tolerable antes de abortar el polling.
  static const _maxConsecutiveErrors = 3;

  Timer? _pollingTimer;
  int _pollAttempts = 0;
  int _consecutiveErrors = 0;

  /// Timestamp epoch ms del inicio del batch activo.
  /// Usado exclusivamente para calcular elapsed en logs [BATCH_TIMING].
  /// Nunca se lee fuera de bloques if (kDebugMode) — costo cero en producción.
  int _batchStartMs = 0;

  // ── Computed ───────────────────────────────────────────────────────────────

  int get totalCount => items.length;
  int get processingCount =>
      items.where((i) => i.status == VehiclePlateStatus.consulting).length;
  int get succeededCount =>
      items.where((i) => i.status == VehiclePlateStatus.success).length;
  int get failedCount =>
      items.where((i) => i.status == VehiclePlateStatus.failed).length;

  /// True cuando no quedan ítems en estado consulting y no está creando.
  bool get isTerminal => processingCount == 0 && !isCreating.value;

  // ── Acción principal ───────────────────────────────────────────────────────

  /// Crea el batch VRC e inicia el polling.
  ///
  /// 1. Cancela cualquier polling previo (por si el usuario reinicia).
  /// 2. Inicializa [items] con status=consulting.
  /// 3. POST /vrc-batches → obtiene [batchId].
  /// 4. Inicia polling periódico.
  ///
  /// Los errores quedan expuestos en [errorMessage] y en [items[].errorMessage].
  Future<void> startBatch({
    required List<VehiclePlateItem> plates,
    required String ownerDocumentType,
    required String ownerDocument,
  }) async {
    // T=0 para logs BATCH_TIMING — capturar antes de cualquier operación.
    if (kDebugMode) _batchStartMs = DateTime.now().millisecondsSinceEpoch;

    // Cancelar polling anterior (usuario reinicia la consulta).
    _stopPolling();

    // Reset de estado.
    // ownerData NO se limpia — el último contexto válido permanece visible
    // en la UI mientras el nuevo batch entrega sus primeros resultados.
    // _ownerCached = false permite que el nuevo batch sobreescriba ownerData
    // cuando llegue el primer ítem succeeded. Ver: _applyItemUpdates().
    batchId.value = null;
    overallStatus.value = '';
    errorMessage.value = null;
    _ownerCached = false;
    vehicleContexts.clear();
    _pollAttempts = 0;
    _consecutiveErrors = 0;

    // Todos los ítems arrancan en "consultando".
    items.assignAll(
      plates
          .map((p) => p.copyWith(status: VehiclePlateStatus.consulting))
          .toList(),
    );

    // ── [BATCH_TIMING] PUNTO 1 — START ───────────────────────────────────────
    if (kDebugMode) {
      final t = _batchStartMs;
      for (final p in plates) {
        debugPrint(
          '[BATCH_TIMING][START] plate=${p.plate} t=$t elapsed=0ms '
          'status=consulting batchId=pending',
        );
      }
    }

    isCreating.value = true;

    try {
      final orgId = _resolveOrgId();
      final requestedBy = _resolveUid();

      final response = await _service.createBatch(
        ownerDocumentType: ownerDocumentType,
        ownerDocument: ownerDocument,
        plates: plates.map((p) => p.plate).toList(),
        orgId: orgId,
        requestedBy: requestedBy,
      );

      if (!response.ok || response.batchId == null) {
        throw VrcApiException(
          message: response.errorMessage ??
              'El servidor no pudo iniciar la consulta batch.',
        );
      }

      batchId.value = response.batchId;
      overallStatus.value = response.status ?? 'queued';
      _startPolling();
    } on VrcApiException catch (e) {
      if (kDebugMode) {
        debugPrint('[VRC_BATCH_CTRL] createBatch error: ${e.message}');
      }
      errorMessage.value = e.message;
      _failAllItems(e.message);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[VRC_BATCH_CTRL] createBatch unexpected: $e');
      }
      const msg = 'Error inesperado al iniciar la consulta.';
      errorMessage.value = msg;
      _failAllItems(msg);
    } finally {
      isCreating.value = false;
    }
  }

  /// Detiene el polling activo sin resetear el estado.
  ///
  /// Llamado desde la página cuando el usuario navega hacia atrás,
  /// evitando timers huérfanos cuando el controller sobrevive en GetX.
  void cancelPolling() => _stopPolling();

  // ── Polling ────────────────────────────────────────────────────────────────

  void _startPolling() {
    _stopPolling();
    _pollingTimer = Timer.periodic(_pollInterval, (_) => _pollBatchStatus());
  }

  Future<void> _pollBatchStatus() async {
    final id = batchId.value;
    if (id == null) {
      _stopPolling();
      return;
    }

    _pollAttempts++;

    if (_pollAttempts > _maxPollAttempts) {
      // ── [BATCH_TIMING] PUNTO 5 — GLOBAL_TIMEOUT ──────────────────────────
      if (kDebugMode) {
        final t = DateTime.now().millisecondsSinceEpoch;
        final elapsed = t - _batchStartMs;
        for (final item in items) {
          debugPrint(
            '[BATCH_TIMING][GLOBAL_TIMEOUT] ts=$t elapsed=${elapsed}ms '
            'plate=${item.plate} '
            'status=${item.status.name} '
            'alreadyFailed=${item.status == VehiclePlateStatus.failed} '
            'errorCode=${item.errorCode ?? "null"} '
            'attempt=$_pollAttempts',
          );
        }
      }
      _stopPolling();
      _failRemainingItems(
        'La consulta superó el tiempo máximo de espera. Intenta de nuevo.',
      );
      errorMessage.value =
          'Tiempo agotado. Algunos vehículos no pudieron consultarse.';
      return;
    }

    try {
      final response = await _service.pollBatch(id);
      _consecutiveErrors = 0;

      // Items primero — overallStatus último.
      // El ever() de la página observa overallStatus; si disparara antes de
      // _applyItemUpdates, isTerminal y failedCount devuelven valores stale
      // (items todavía en consulting) y el modal nunca se muestra.
      _applyItemUpdates(response.items);
      overallStatus.value = response.status;

      if (response.isTerminal) {
        _stopPolling();
        if (kDebugMode) {
          debugPrint(
            '[VRC_BATCH_CTRL] batch terminal → status=${response.status} '
            'succeeded=$succeededCount failed=$failedCount',
          );
        }
      }
    } on VrcApiException catch (e) {
      _consecutiveErrors++;
      if (kDebugMode) {
        debugPrint(
          '[VRC_BATCH_CTRL] poll error #$_consecutiveErrors: ${e.message}',
        );
      }
      if (_consecutiveErrors >= _maxConsecutiveErrors) {
        _stopPolling();
        // Los ítems que siguen en consulting deben quedar failed — sin esto,
        // processingCount > 0 e isTerminal == false para siempre (barra
        // de progreso congelada y spinners eternos en los tiles).
        const msg = 'Consulta interrumpida por errores de red.';
        _failRemainingItems(msg);
        errorMessage.value =
            'Error de red al consultar el estado: ${e.message}';
      }
    } catch (e) {
      _consecutiveErrors++;
      if (kDebugMode) {
        debugPrint('[VRC_BATCH_CTRL] poll unexpected #$_consecutiveErrors: $e');
      }
      if (_consecutiveErrors >= _maxConsecutiveErrors) {
        _stopPolling();
        // Igual que el caso VrcApiException — garantizar estado terminal.
        const msg = 'Consulta interrumpida por error inesperado.';
        _failRemainingItems(msg);
        errorMessage.value = 'Error inesperado durante la consulta.';
      }
    }
  }

  /// Determina el [VehiclePlateStatus] de un ítem a partir del modelo del backend.
  ///
  /// Orden de evaluación:
  /// 1. status='succeeded' → success (caso normal).
  /// 2. status='failed'    → failed (backend ya marcó definitivamente).
  /// 3. retryable=false + errorCode presente → failed inmediato (fail-fast).
  ///    El backend ya conoce el error (ej. RUNT_OWNER_MISMATCH) aunque el status
  ///    del ítem aún sea 'pending'. Flutter no debe esperar al timeout global.
  /// 4. Cualquier otro caso → consulting (sigue procesando).
  VehiclePlateStatus _mapItemStatus(VrcBatchItemModel backend) {
    if (backend.status == 'succeeded') return VehiclePlateStatus.success;
    if (backend.status == 'failed') return VehiclePlateStatus.failed;
    // Fail-fast: error ya conocido y definitivo — no esperar timeout global.
    // retryable=false + errorCode presente = error de negocio confirmado.
    if (!backend.retryable && backend.errorCode != null) {
      return VehiclePlateStatus.failed;
    }
    return VehiclePlateStatus.consulting;
  }

  void _applyItemUpdates(List<VrcBatchItemModel> backendItems) {
    // ── 1. Poblar vehicleContexts y cachear ownerData ─────────────────────
    // Se hace ANTES de assignAll para que los tiles lean datos consistentes
    // en el mismo frame reactivo.
    if (kDebugMode) {
      debugPrint('[VRC_BATCH] _applyItemUpdates: ${backendItems.length} items recibidos');
    }

    for (final backend in backendItems) {
      final rawContext = backend.context;

      // ── [BATCH_TIMING] PUNTO 3 — RAW_RESPONSE: datos backend tal como llegan ─
      if (kDebugMode) {
        final t = DateTime.now().millisecondsSinceEpoch;
        debugPrint(
          '[BATCH_TIMING][RAW_RESPONSE] ts=$t '
          'elapsed=${t - _batchStartMs}ms '
          'plate=${backend.plate} '
          'backendStatus=${backend.status} '
          'errorCode=${backend.errorCode ?? "null"} '
          'retryable=${backend.retryable} '
          'contextNull=${rawContext == null} '
          'attempt=$_pollAttempts',
        );
      }

      if (rawContext == null) continue;

      // Parsear el context del backend como VrcDataModel.
      VrcDataModel? vrcData;
      try {
        vrcData = VrcDataModel.fromJson(rawContext);
      } catch (e, st) {
        // LOG CRÍTICO: este catch silenciaba excepciones de parseo.
        // Si aparece en los logs, indica un bug en fromJson que impide
        // asignar ownerData y mostrar los grids de Licencia/SIMIT.
        if (kDebugMode) {
          debugPrint('[VRC_BATCH] ⚠️ ERROR parseando context de ${backend.plate}: $e');
          debugPrint('[VRC_BATCH] StackTrace: $st');
        }
        continue;
      }

      if (kDebugMode) {
        debugPrint(
          '[VRC_BATCH] VrcDataModel ok para ${backend.plate} — '
          'owner=${vrcData.owner != null} '
          'ownerName=${vrcData.owner?.name} '
          'runt=${vrcData.owner?.runt != null} '
          'simit=${vrcData.owner?.simit != null} '
          '_ownerCached=$_ownerCached',
        );
      }

      // Guardar contexto por placa para que los tiles muestren marca/línea/modelo.
      vehicleContexts[backend.plate.toUpperCase()] = vrcData;

      // Cachear el owner del primer item succeeded — nunca sobreescribir.
      if (!_ownerCached && backend.isSucceeded && vrcData.owner != null) {
        ownerData.value = vrcData;
        _ownerCached = true;
        if (kDebugMode) {
          debugPrint(
            '[VRC_BATCH] ✅ ownerData ASIGNADO desde ${backend.plate} — '
            'name=${vrcData.owner?.name} '
            'licenses=${vrcData.owner?.runt?.licenses?.length ?? 0} '
            'simitSummary=${vrcData.owner?.simit?.summary != null}',
          );
        }
      } else if (kDebugMode && !_ownerCached && backend.isSucceeded) {
        debugPrint(
          '[VRC_BATCH] ⚠️ item succeeded (${backend.plate}) pero '
          'vrcData.owner == null → ownerData NO asignado',
        );
      }
    }

    // ── 2. Actualizar estados de placas ───────────────────────────────────
    final updated = items.map((item) {
      final match = _findBackendItem(backendItems, item.plate);
      if (match == null) return item; // backend aún no tiene este ítem

      final newStatus = _mapItemStatus(match);

      // ── [BATCH_TIMING] PUNTO 3 — MAPPED + PUNTO 4 — STATE_TRANSITION ────────
      if (kDebugMode) {
        final t = DateTime.now().millisecondsSinceEpoch;
        final elapsed = t - _batchStartMs;

        // MAPPED: resultado del mapeo para este item en este poll
        debugPrint(
          '[BATCH_TIMING][MAPPED] ts=$t elapsed=${elapsed}ms '
          'plate=${match.plate} '
          'backendStatus=${match.status} '
          'mappedStatus=${newStatus.name} '
          'errorCode=${match.errorCode ?? "null"} '
          'retryable=${match.retryable} '
          'attempt=$_pollAttempts',
        );

        // STATE_TRANSITION: solo cuando el estado realmente cambia
        if (item.status != newStatus) {
          final reason = (!match.retryable &&
                  match.errorCode != null &&
                  match.status != 'failed')
              ? 'non_retryable_error'
              : (match.status == 'failed')
                  ? 'backend_failed_status'
                  : (match.status == 'succeeded')
                      ? 'backend_succeeded'
                      : 'other';
          debugPrint(
            '[BATCH_TIMING][STATE_TRANSITION] ts=$t elapsed=${elapsed}ms '
            'plate=${match.plate} '
            'from=${item.status.name} to=${newStatus.name} '
            'reason=$reason '
            'errorCode=${match.errorCode ?? "null"} '
            'attempt=$_pollAttempts',
          );
        }

        // FAILFAST: cuando el estado pasa a failed (reemplaza el log anterior)
        if (newStatus == VehiclePlateStatus.failed) {
          debugPrint(
            '[BATCH_TIMING][FAILFAST] ts=$t elapsed=${elapsed}ms '
            'plate=${match.plate} '
            'trigger=${match.status == "failed" ? "backend_failed_status" : "non_retryable_error"} '
            'backendStatus=${match.status} '
            'errorCode=${match.errorCode ?? "null"} '
            'retryable=${match.retryable} '
            'attempt=$_pollAttempts',
          );
        }

        // CASO CRÍTICO: errorCode presente pero retryable=true → sin fail-fast
        // Si este log aparece, es la señal directa del Escenario B
        if (match.errorCode != null &&
            match.retryable &&
            newStatus == VehiclePlateStatus.consulting) {
          debugPrint(
            '[BATCH_TIMING][WARN_NO_FAILFAST] ts=$t elapsed=${elapsed}ms '
            'plate=${match.plate} '
            'errorCode=${match.errorCode} '
            'retryable=true → item SIGUE en consulting sin fail-fast '
            'attempt=$_pollAttempts',
          );
        }
      }

      return item.copyWith(
        status: newStatus,
        errorCode: match.errorCode,
        errorMessage: match.errorMessage,
      );
    }).toList();

    items.assignAll(updated);
  }

  VrcBatchItemModel? _findBackendItem(
    List<VrcBatchItemModel> list,
    String plate,
  ) {
    final plateUpper = plate.toUpperCase();
    for (final item in list) {
      if (item.plate.toUpperCase() == plateUpper) return item;
    }
    return null;
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void _failAllItems(String? message) {
    items.assignAll(
      items
          .map(
            (p) => p.copyWith(
              status: VehiclePlateStatus.failed,
              errorMessage: message,
            ),
          )
          .toList(),
    );
  }

  void _failRemainingItems(String message) {
    items.assignAll(
      items
          .map(
            (p) => p.status == VehiclePlateStatus.consulting
                ? p.copyWith(
                    status: VehiclePlateStatus.failed,
                    errorMessage: message,
                  )
                : p,
          )
          .toList(),
    );
  }

  // ── Helpers de sesión ──────────────────────────────────────────────────────

  String _resolveOrgId() {
    try {
      if (Get.isRegistered<SessionContextController>()) {
        final orgId = Get.find<SessionContextController>()
            .user
            ?.activeContext
            ?.orgId;
        if (orgId != null && orgId.isNotEmpty) return orgId;
      }
    } catch (_) {}
    return '';
  }

  String _resolveUid() {
    try {
      if (Get.isRegistered<SessionContextController>()) {
        final uid = Get.find<SessionContextController>().user?.uid;
        if (uid != null && uid.isNotEmpty) return uid;
      }
    } catch (_) {}
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  // ── Ciclo de vida ──────────────────────────────────────────────────────────

  @override
  void onClose() {
    _stopPolling();
    super.onClose();
  }
}
