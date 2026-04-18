// ============================================================================
// lib/presentation/pages/portfolio/portfolio_asset_live_page.dart
// PORTFOLIO ASSET LIVE PAGE — Vista unificada activos registrados + batch VRC
//
// QUÉ HACE:
// - Unifica en una sola vista reactiva: activos registrados en Isar
//   (StreamBuilder) y activos en consulta batch VRC (Obx sobre VrcBatchController).
// - Muestra el propietario del lote (persona-céntrico) en el header.
//   Prioridad: (1) ownerData vivo del batch → _OwnerHeader completo con detalle;
//   (2) snapshot Isar (portfolio.ownerName != null) → _OwnerSnapshotBand de solo
//   lectura, cubre el caso en que VrcBatchController fue recreado (ownerData=null)
//   porque el usuario navegó a Home entre sesiones de batch.
// - Ordena la lista de forma estable: priority ASC (registrando→registrado→
//   fallido) + createdAt DESC (más recientes primero dentro del grupo).
// - Anima la aparición/desaparición de OwnerHeader y BatchStatusBar con
//   AnimatedSize + AnimatedSwitcher para que el scroll no salte.
// - FASE 4: registra progresivamente los vehículos exitosos del batch en Isar.
//   onTap en RegisteredAsset tiles navega a AssetDetailPage.
//   FAB "Registrar activo" equivalente al de portfolio_asset_list_page.dart.
//
// QUÉ NO HACE:
// - No ejecuta startBatch() — lo llamó AssetRegistrationPage antes de navegar.
// - No modifica portfolio_asset_list_page.dart ni vrc_batch_progress_page.dart.
// - No guard-registra dependencias — PortfolioAssetLiveBinding es el único punto
//   de DI; la página solo consume via Get.find().
// - No garantiza retorno a esta pantalla desde AssetDetailPage (back va a
//   portfolioAssets — comportamiento estándar de AppNavigator).
//
// PRINCIPIOS:
// - StreamBuilder (Isar) envuelve Obx (batch) — ningún setState en la lista.
// - buildUnifiedList() se llama UNA vez por rebuild, antes del ListView.builder.
// - _itemTimestamps en State con putIfAbsent — timestamp estable cross-rebuilds.
// - identity = plate.toUpperCase() para vehículos en TODOS los tipos sealed.
//   Garantía de continuidad visual: RegisteringAsset → RegisteredAsset no cambia
//   timestamp (puede cambiar de grupo en el sort, pero no reaparece como nuevo).
// - cancelPolling() es idempotente: _pollingTimer?.cancel() es null-safe.
//   Se llama desde PopScope Y desde dispose() sin riesgo de doble-cancel.
// - Doble guard de deduplicación (_registeredPlates + _isarPlates) previene
//   registros duplicados por carreras entre polling y escritura en Isar.
//
// LIFECYCLE TÁCTICA (permanent:true):
// - VrcBatchController se registra con permanent:true en los bindings para
//   sobrevivir el window de destrucción de Get.offNamed. Esto NO es la política
//   general del proyecto — es específico a este patrón de navegación.
// - dispose() DEBE llamar Get.delete<VrcBatchController>(force:true) como
//   contraparte obligatoria. Sin esa línea, el controller queda vivo para siempre.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Portfolio Asset Live — Phase 3.
// ACTUALIZADO (2026-04): Phase 4 — registro real, onTap, FAB.
// ACTUALIZADO (2026-04): Back navigation determinística → Home siempre.
//   AppBar leading + PopScope(canPop:false) ambos llaman _handleBackNavigation().
//   Batch completo → Home directo. Batch en curso → diálogo de confirmación.
// ACTUALIZADO (2026-04): Isar fallback _OwnerSnapshotBand — header de propietario
//   persiste cuando VrcBatchController es recreado (ownerData=null). Solución al
//   root cause definitivo: dispose() deleta el controller; AssetRegistrationBinding
//   crea uno nuevo; _portfolioRx (Rxn) provee el snapshot Isar como fallback reactivo.
// ACTUALIZADO (2026-04): Fix crash en back-navigation post-modal de fallos.
//   (1) dispose(): super.dispose() ANTES de Get.delete<VrcBatchController> — evita
//       cerrar Rx observables mientras los Obx hijos aún están suscritos.
//   (2) _terminalStatusWorker: showDialog() diferido con addPostFrameCallback —
//       evita llamar showDialog() dentro del ciclo reactivo de GetX.
// ACTUALIZADO (2026-04): UI — barra de progreso, cola de modales, modal final.
//   _BatchStatusBar: LinearProgressIndicator + "X de Y placas" (progresivo).
//   Cola de modales (_modalQueue): garantiza no-superposición FIFO — modal de
//   fallo por placa → modal "Registro finalizado". Worker _failedItemsWorker
//   detecta cada nueva placa fallida y la encola. _terminalStatusWorker siempre
//   encola el modal final (no solo cuando failedCount > 0).
//   _BatchCompletionDialog reemplaza _FailedBatchSummaryDialog — universal.
// ACTUALIZADO (2026-04): Fix navegación post-batch → Home definitivo.
//   Root cause real: carrera entre _persistOwnerSnapshot y _registerPlate cuando
//   el batch llega a 'completed' con 100% éxito. Ambos disparan casi simultáneamente:
//   _persistOwnerSnapshot leía DRAFT (antes de que _registerPlate completara
//   incrementAssetsCountTx), lo guardaba como DRAFT → Gate 3 veía activeCount==0.
//   Fix definitivo: updateOwnerSnapshot() hace read-modify-write dentro de una
//   writeTxn atómica. Isar serializa writeTxn: el que corre después siempre lee
//   el status correcto. NUNCA sobreescribe status ni assetsCount.
// CONTRACT: Get.offNamed(Routes.portfolioAssetLive, arguments: AssetRegistrationContext)
// ============================================================================

import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/di/container.dart';
import '../../../core/navigation/app_navigator.dart';
import '../../../core/utils/simit_freshness_policy.dart';
import '../../../data/vrc/models/vrc_models.dart';
import '../../../domain/entities/asset/asset_entity.dart';
import '../../../domain/entities/portfolio/portfolio_entity.dart';
import '../../../domain/errors/asset_creation_exception.dart';
import '../../../domain/shared/enums/asset_type.dart';
import '../../../domain/value/registration/asset_registration_context.dart';
import '../../../domain/value/registration/asset_runt_snapshot.dart';
import '../../../domain/value/registration/vehicle_plate_item.dart';
import '../../../routes/app_pages.dart';
import '../../controllers/session_context_controller.dart';
import '../../controllers/vrc/vrc_batch_controller.dart';
import '../../mappers/asset_summary_mapper.dart';
import '../../viewmodels/asset/asset_summary_vm.dart';
import '../../widgets/asset/portfolio_asset_operational_tile.dart';
import '../../widgets/asset/vehicle/plate_widget.dart';
import '../../widgets/portfolio/owner_snapshot_band.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODELO SEALED: UnifiedAssetItem
// ─────────────────────────────────────────────────────────────────────────────

/// Item sellado que representa un activo en la lista unificada.
///
/// [identity] = plate.toUpperCase() para vehículos en TODOS los subtipos →
/// garantiza continuidad visual cuando el mismo activo transiciona de estado.
/// [priority] determina el grupo en el sort: 1=Registrando, 2=Registrado, 3=Fallido.
/// [createdAt] asignado una sola vez via _itemTimestamps.putIfAbsent — estable.
sealed class UnifiedAssetItem {
  const UnifiedAssetItem({
    required this.identity,
    required this.priority,
    required this.createdAt,
  });

  /// Clave estable de identidad visual (plate.toUpperCase() para vehículos).
  final String identity;

  /// Grupo de sort: 1=Registrando, 2=Registrado, 3=Fallido.
  final int priority;

  /// Timestamp asignado una vez via putIfAbsent — no cambia entre rebuilds.
  final DateTime createdAt;
}

/// Activo cuya consulta VRC batch aún está en curso o acaba de completarse
/// pero aún no fue persistido en Isar (priority=1).
///
/// [isSucceeded] true cuando el backend reportó success pero Isar todavía no
/// emitió el activo registrado. Permite mostrar check en vez de spinner.
final class RegisteringAsset extends UnifiedAssetItem {
  final VehiclePlateItem plateItem;

  /// Datos del vehículo del backend VRC, disponibles una vez succeeded.
  /// Null mientras el ítem esté en consulting.
  final VrcVehicleModel? vehicleData;

  /// True cuando VRC respondió success pero el activo aún no está en Isar.
  /// Diferencia visual: check verde (success) vs spinner (consulting).
  final bool isSucceeded;

  const RegisteringAsset({
    required super.identity,
    required super.createdAt,
    required this.plateItem,
    this.vehicleData,
    this.isSucceeded = false,
  }) : super(priority: 1);
}

/// Activo ya persistido en Isar (priority=2).
final class RegisteredAsset extends UnifiedAssetItem {
  final AssetSummaryVM summary;

  const RegisteredAsset({
    required super.identity,
    required super.createdAt,
    required this.summary,
  }) : super(priority: 2);
}

/// Activo cuya consulta VRC falló (priority=3).
final class FailedAsset extends UnifiedAssetItem {
  final VehiclePlateItem plateItem;

  const FailedAsset({
    required super.identity,
    required super.createdAt,
    required this.plateItem,
  }) : super(priority: 3);
}

// ─────────────────────────────────────────────────────────────────────────────
// buildUnifiedList — Función pura, llamada UNA vez por rebuild
// ─────────────────────────────────────────────────────────────────────────────

/// Construye la lista unificada de activos en vuelo + registrados en Isar.
///
/// Reglas de deduplicación:
/// - Las placas ya presentes en Isar (VehicleSummaryVM) no se duplican
///   con los ítems del batch — Isar gana, el ítem batch se omite.
/// - Los registrados no-vehículo siempre se incluyen (no hay placa de batch).
///
/// Sort: priority ASC → createdAt DESC (más recientes primero por grupo).
///
/// [timestamps] es mutable y vive en State — putIfAbsent garantiza estabilidad.
List<UnifiedAssetItem> buildUnifiedList({
  required List<AssetSummaryVM> summaries,
  required List<VehiclePlateItem> batchItems,
  required Map<String, VrcDataModel> contexts,
  required Map<String, DateTime> timestamps,
  required bool batchIsTerminal,
}) {
  // Helper: timestamp estable por identity.
  DateTime ts(String id) => timestamps.putIfAbsent(id, DateTime.now);

  // Set O(1) de placas ya persistidas en Isar (solo VehicleSummaryVM tienen placa).
  final registeredPlates = <String>{
    for (final vm in summaries)
      if (vm is VehicleSummaryVM) vm.plate.toUpperCase(),
  };

  final result = <UnifiedAssetItem>[];

  // 1. Activos registrados en Isar.
  for (final vm in summaries) {
    final identity =
        (vm is VehicleSummaryVM) ? vm.plate.toUpperCase() : vm.assetId;
    result.add(RegisteredAsset(
      identity: identity,
      createdAt: ts(identity),
      summary: vm,
    ));
  }

  // 2. Ítems del batch que no están ya en Isar.
  for (final item in batchItems) {
    final id = item.plate.toUpperCase();
    if (registeredPlates.contains(id)) continue; // Isar gana → skip

    final vrcData = contexts[id];
    if (item.status == VehiclePlateStatus.failed) {
      // Solo visible mientras el batch corre — desaparece al terminar.
      // Cuando batchIsTerminal=true el modal resumen asume la notificación.
      if (!batchIsTerminal) {
        result
            .add(FailedAsset(plateItem: item, createdAt: ts(id), identity: id));
      }
    } else {
      // success y consulting van al mismo grupo (priority=1) pero con
      // isSucceeded diferenciado — el tile muestra check vs spinner.
      result.add(RegisteringAsset(
        plateItem: item,
        vehicleData: vrcData?.vehicle,
        createdAt: ts(id),
        identity: id,
        isSucceeded: item.status == VehiclePlateStatus.success,
      ));
    }
  }

  // Sort estable: priority ASC → createdAt DESC.
  result.sort((a, b) {
    final cmp = a.priority.compareTo(b.priority);
    if (cmp != 0) return cmp;
    return b.createdAt.compareTo(a.createdAt);
  });

  return result;
}

// ─────────────────────────────────────────────────────────────────────────────
// PortfolioAssetLivePage
// ─────────────────────────────────────────────────────────────────────────────

class PortfolioAssetLivePage extends StatefulWidget {
  const PortfolioAssetLivePage({super.key});

  @override
  State<PortfolioAssetLivePage> createState() => _PortfolioAssetLivePageState();
}

class _PortfolioAssetLivePageState extends State<PortfolioAssetLivePage> {
  late final VrcBatchController _batchCtrl;
  late final String _portfolioId;
  late final String _portfolioName;
  late final String _countryId;
  late final String? _cityId;
  late final Stream<List<AssetEntity>> _assetsStream;

  /// Timestamps de estabilidad visual de sesión — asignados UNA vez via putIfAbsent.
  ///
  /// IMPORTANTE: NO representan la fecha real de creación del activo en Isar.
  /// Su único propósito es garantizar un sort estable entre rebuilds:
  /// el mismo identity siempre recibe el mismo timestamp → no salta de posición.
  /// Los activos de sesiones anteriores reaparecen con un timestamp nuevo
  /// (primer momento en que fueron vistos en esta instancia de la pantalla).
  final Map<String, DateTime> _itemTimestamps = {};

  // ── Doble guard de deduplicación (Fase 4) ────────────────────────────────────

  /// Guard A — en memoria de sesión.
  /// Placa añadida optimistamente antes del await al repo.
  /// Si el repo falla con error no-duplicate, la placa se elimina para reintento.
  final Set<String> _registeredPlates = {};

  /// Guard B — proyección derivada de la última emisión de Isar.
  /// TÁCTICA: asignación directa dentro del builder del StreamBuilder.
  /// No dispara rebuild (no usa setState ni Observable).
  /// Es cache derivado de snapshot.data — no estado de presentación.
  Set<String> _isarPlates = {};

  // ── Suscripción al stream de ítems del batch ──────────────────────────────────
  StreamSubscription<List<VehiclePlateItem>>? _itemsSubscription;

  // ── PortfolioEntity — fetched una sola vez desde Isar en initState() ──────────
  /// Null los primeros ms hasta que el fetch local completa (típicamente < 10 ms).
  /// Habilita onTap en RegisteredAsset tiles y FAB principal.
  PortfolioEntity? _portfolio;

  /// Observable de PortfolioEntity para el Obx del header de propietario.
  ///
  /// Permite mostrar [_OwnerSnapshotBand] como fallback cuando
  /// [VrcBatchController.ownerData] es null (controller recreado tras navegar
  /// a Home entre batches). Se accede dentro del Obx → GetX registra la
  /// dependencia → el header se reconstruye al completar el fetch local.
  final _portfolioRx = Rxn<PortfolioEntity>();

  // ── Timestamp de consulta SIMIT (session-only) ───────────────────────────────
  /// Capturado set-once cuando ownerData llega por primera vez en esta sesión.
  /// Asignación directa sin setState — solo se usa para mostrar "última consulta"
  /// en _OwnerHeader y para el badge de frescura. No persiste entre sesiones.
  /// Si es null (sesión nueva), las páginas de detalle usan DateTime.now() como
  /// fallback conservador.
  DateTime? _simitCheckedAt;

  // ── Persistencia del snapshot del propietario ─────────────────────────────────
  /// Guard: true cuando el snapshot ya fue persistido en Isar para este batch.
  /// Impide escrituras repetidas por cambios reactivos intermedios en overallStatus.
  bool _ownerSnapshotPersisted = false;

  /// Worker del ever() sobre overallStatus. Cancelado en dispose() para evitar
  /// callbacks sobre un State destruido.
  Worker? _overallStatusWorker;

  // ── Modal de fallos / Cola de modales ─────────────────────────────────────────

  /// Guard ligado al batchId actual: almacena el id del batch para el que ya
  /// se mostró el modal final de cierre. null = nunca mostrado.
  /// Al iniciar un nuevo batch, el batchId cambia → guard queda inválido
  /// automáticamente → modal puede mostrarse de nuevo sin reset manual.
  String? _failedModalShownForBatchId;

  /// Worker separado de _overallStatusWorker para mantener responsabilidades
  /// independientes: snapshot de propietario vs. notificación de fallos.
  Worker? _terminalStatusWorker;

  /// Worker que detecta nuevas placas fallidas durante el polling para
  /// encolarlas como modales individuales de notificación.
  Worker? _failedItemsWorker;

  // ── Cola de modales ────────────────────────────────────────────────────────────

  /// true mientras la cola de modales está despachando — evita re-entradas.
  bool _modalQueueRunning = false;

  /// Cola FIFO de funciones que muestran dialogs.
  /// Cada función se ejecuta solo cuando el dialog anterior se cierra.
  /// Garantía de no-superposición: plate-failure modals → completion modal.
  final List<Future<void> Function()> _modalQueue = [];

  /// Clave por placa para las que ya se encoló un modal individual de fallo.
  /// Formato: "{batchId}_{plate}" — se auto-invalida cuando cambia el batchId.
  final Set<String> _failedModalPlatesShown = {};

  @override
  void initState() {
    super.initState();

    // Binding ya resolvió VrcBatchController. La página solo consume.
    _batchCtrl = Get.find<VrcBatchController>();

    // Argumentos: AssetRegistrationContext pasado desde AssetRegistrationPage.
    final ctx = Get.arguments as AssetRegistrationContext;
    _portfolioId = ctx.portfolioId;
    if (kDebugMode) {
      debugPrint('🔥 LIVE PORTFOLIO ID: $_portfolioId');
    }
    _portfolioName = ctx.portfolioName;
    _countryId = ctx.countryId;
    _cityId = ctx.cityId;

    // Stream de activos registrados en Isar para este portafolio.
    _assetsStream =
        DIContainer().assetRepository.watchAssetsByPortfolio(_portfolioId);

    // TÁCTICA FASE 4: suscribirse a cambios de ítems para registrar placas exitosas.
    // El doble guard (_registeredPlates + _isarPlates) previene duplicados.
    // Ver _onBatchItemsChanged para el detalle completo.
    _itemsSubscription = _batchCtrl.items.listen(_onBatchItemsChanged);

    // Fetch PortfolioEntity desde Isar local (< 10 ms) para habilitar onTap y FAB.
    // _portfolioRx se actualiza para que el Obx del header reaccione al fetch:
    // si ownerData=null pero portfolio.ownerName!=null → muestra _OwnerSnapshotBand.
    DIContainer().portfolioRepository.getPortfolioById(_portfolioId).then((p) {
      if (mounted) {
        setState(() => _portfolio = p);
        _portfolioRx.value =
            p; // activa el fallback en Obx si ownerData es null
      }
    });

    // Detectar batch terminal para persistir snapshot del propietario en Isar.
    // Solo disparar en 'completed' o 'partially_completed' — 'failed' excluido:
    // un batch fallido puede no tener ownerData válido y sobrescribiría datos buenos.
    // _ownerSnapshotPersisted actúa como guard: una sola escritura por sesión.
    _overallStatusWorker = ever(_batchCtrl.overallStatus, (String status) {
      if (!_ownerSnapshotPersisted &&
          (status == 'completed' || status == 'partially_completed')) {
        _persistOwnerSnapshot();
      }
    });

    // Detectar batch terminal para mostrar modal final "Registro finalizado".
    // Worker separado de _overallStatusWorker — responsabilidades independientes.
    // Guard _failedModalShownForBatchId previene double-show; se auto-invalida
    // cuando cambia el batchId (nuevo batch), sin reset manual.
    // Se encola mediante _enqueueModal para que drene después de los modales
    // individuales de fallo por placa (también encolados).
    _terminalStatusWorker = ever(_batchCtrl.overallStatus, (_) {
      if (_batchCtrl.isTerminal) {
        final bid = _batchCtrl.batchId.value;
        if (bid != null && _failedModalShownForBatchId != bid) {
          // Guard ANTES del gap asíncrono — previene double-show si
          // overallStatus emite varias veces el mismo estado terminal.
          _failedModalShownForBatchId = bid;
          // addPostFrameCallback: difiere el encolado al siguiente frame.
          // El ever() corre DENTRO del ciclo reactivo de GetX — llamar
          // showDialog() aquí puede coincidir con un build en curso → crash.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _enqueueModal(_showBatchCompletionModal);
          });
        }
      }
    });

    // Detectar nuevas placas fallidas durante el polling para mostrar
    // modales individuales de notificación, encolados en orden FIFO.
    // La clave "{batchId}_{plate}" previene duplicados por re-emisión de la
    // misma placa fallida en múltiples polls.
    _failedItemsWorker = ever(
      _batchCtrl.items,
      (List<VehiclePlateItem> currentItems) {
        for (final item in currentItems) {
          if (item.status != VehiclePlateStatus.failed) continue;
          final key = '${_batchCtrl.batchId.value ?? ""}_${item.plate}';
          if (_failedModalPlatesShown.contains(key)) continue;
          _failedModalPlatesShown.add(key);
          // Captura local del item — el ever puede dispararse varias veces.
          final captured = item;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _enqueueModal(() => _showPlateFailureModal(captured));
          });
        }
      },
    );
  }

  @override
  void dispose() {
    // LOG: detectar si dispose() se llama prematuramente (ej. navegación inesperada).
    // Si aparece en los logs mientras el batch aún corre, indica destrucción
    // del widget antes de que el usuario realmente salga de la pantalla.
    if (kDebugMode) {
      debugPrint(
        '[LIVE_PAGE] ⚠️ dispose() llamado — '
        'ownerDataWasSet=${_batchCtrl.ownerData.value != null} '
        'isTerminal=${_batchCtrl.isTerminal} '
        'succeededCount=${_batchCtrl.succeededCount}',
      );
    }
    _itemsSubscription?.cancel();
    // Workers del ever() — cancelar antes de destruir el State.
    _overallStatusWorker?.dispose();
    _terminalStatusWorker?.dispose();
    _failedItemsWorker?.dispose();
    // cancelPolling() es idempotente — seguro llamarlo aquí Y en PopScope.
    _batchCtrl.cancelPolling();
    // ORDEN CRÍTICO: super.dispose() VA PRIMERO que Get.delete.
    // super.dispose() cancela las suscripciones de todos los Obx hijos.
    // Si Get.delete va antes, cierra los Rx observables del controller mientras
    // los Obx aún están suscritos → GetX despacha eventos de cierre → los Obx
    // intentan reconstruir un widget en proceso de disposición →
    // "setState() called after dispose()" / crash en el árbol de widgets.
    super.dispose();
    // TÁCTICA: VrcBatchController fue registrado con permanent:true para sobrevivir
    // el window de destrucción de Get.offNamed. Esta línea es su contraparte obligatoria.
    // Sin ella, el controller quedará vivo hasta que la app se cierre.
    // Se llama DESPUÉS de super.dispose() para que ningún Obx esté activo al cerrar
    // los Rx streams del controller.
    Get.delete<VrcBatchController>(force: true);
  }

  // ── Persistencia del snapshot del propietario VRC ─────────────────────────────

  /// Persiste el snapshot del propietario en PortfolioEntity (Isar) al completar
  /// el batch con estado terminal válido (completed | partially_completed).
  ///
  /// Guard [_ownerSnapshotPersisted] garantiza una sola escritura por sesión,
  /// incluso si overallStatus emite múltiples veces el mismo valor terminal.
  ///
  /// NO persiste en caso de batch 'failed': un fallo completo puede implicar
  /// ownerData ausente o parcial, lo que sobreescribiría datos buenos de
  /// sesiones anteriores.
  ///
  /// Usa updateOwnerSnapshot() en lugar de updatePortfolio() para evitar la
  /// carrera con _registerPlate(): cuando el batch llega a 'completed' con
  /// 100% de placas exitosas, _persistOwnerSnapshot y _registerPlate corren
  /// casi simultáneamente. updateOwnerSnapshot hace read-modify-write dentro
  /// de un writeTxn — Isar serializa las transacciones, así el que corre
  /// después siempre lee el status correcto (ACTIVE si ya corrió
  /// incrementAssetsCountTx). Nunca puede sobreescribir ACTIVE con DRAFT.
  Future<void> _persistOwnerSnapshot() async {
    if (_ownerSnapshotPersisted) return;

    final owner = _batchCtrl.ownerData.value?.owner;
    if (owner == null) return; // Sin propietario identificado — no persistir

    // Marcar antes del await para evitar concurrencia si ever() dispara de nuevo.
    _ownerSnapshotPersisted = true;

    final simitModel = _batchCtrl.ownerData.value?.owner?.simit;
    final simit = simitModel?.summary;
    final licenses = owner.runt?.licenses;
    final licStatus =
        licenses?.isNotEmpty == true ? licenses!.first.status : null;
    final licExpiryDate =
        licenses?.isNotEmpty == true ? licenses!.first.expiryDate : null;

    // Serializar el bloque SIMIT completo (summary + fines[]) como JSON blob.
    // Se deserializa bajo demanda en OwnerSnapshotBand al navegar al detalle.
    // Si simitModel es null, no se persiste blob (campo queda null en Isar).
    final String? simitBlob =
        simitModel != null ? jsonEncode(simitModel.toJson()) : null;

    try {
      await DIContainer().portfolioRepository.updateOwnerSnapshot(
            _portfolioId,
            ownerName: owner.name,
            ownerDocument: owner.document,
            ownerDocumentType: owner.documentType,
            licenseStatus: licStatus,
            licenseExpiryDate: licExpiryDate,
            simitHasFines: simit?.hasFines,
            simitFinesCount: simit?.finesCount,
            simitComparendosCount:
                simit?.byType?.comparendos?.count ?? simit?.comparendos,
            simitMultasCount: simit?.byType?.multas?.count ?? simit?.multas,
            simitFormattedTotal: simit?.formattedTotal,
            simitCheckedAt: _simitCheckedAt,
            licenseCheckedAt: _simitCheckedAt, // mismo timestamp del batch VRC
            simitDetailJson: simitBlob,
          );

      // Leer de vuelta para sincronizar el cache en memoria.
      // El estado en Isar es autoritativo: puede ser ACTIVE si
      // incrementAssetsCountTx ya completó, o DRAFT si aún no terminó
      // (en ese caso _registerPlate lo transitará a ACTIVE después).
      final saved = await DIContainer()
          .portfolioRepository
          .getPortfolioById(_portfolioId);
      if (mounted && saved != null) {
        setState(() => _portfolio = saved);
      }
      _portfolioRx.value = saved;

      if (kDebugMode) {
        debugPrint(
          '[LIVE_PAGE] ✅ ownerSnapshot persistido — '
          'owner=${owner.name} license=$licStatus '
          'status=${saved?.status} '
          'simitHasFines=${simit?.hasFines} '
          'comparendos=${simit?.byType?.comparendos?.count ?? simit?.comparendos} '
          'multas=${simit?.byType?.multas?.count ?? simit?.multas}',
        );
      }
    } catch (e) {
      _ownerSnapshotPersisted = false; // permitir reintento en próxima sesión
      if (kDebugMode) {
        debugPrint('[LIVE_PAGE] ⚠️ ownerSnapshot error al persistir: $e');
      }
    }
  }

  // ── Cola de modales ────────────────────────────────────────────────────────────

  /// Encola una función modal y despacha la cola si está libre.
  ///
  /// Garantiza no-superposición: el siguiente dialog solo se abre cuando el
  /// anterior se cierra. Orden FIFO: plate-failure modals → completion modal.
  void _enqueueModal(Future<void> Function() fn) {
    _modalQueue.add(fn);
    _drainModalQueue();
  }

  /// Despacha la cola modal en serie.
  ///
  /// Re-entradas bloqueadas por [_modalQueueRunning]. Si el widget se destruye
  /// durante el dispatch, el loop termina en el mounted-guard de cada modal.
  Future<void> _drainModalQueue() async {
    if (_modalQueueRunning || _modalQueue.isEmpty) return;
    _modalQueueRunning = true;
    while (_modalQueue.isNotEmpty) {
      final fn = _modalQueue.removeAt(0);
      await fn();
    }
    _modalQueueRunning = false;
  }

  // ── Modales individuales de fallo por placa ────────────────────────────────

  /// Modal individual que notifica el fallo de una placa concreta.
  ///
  /// Lanzado por [_failedItemsWorker] al detectar una nueva placa en estado
  /// failed. Encolado — no se superpone con otros dialogs.
  Future<void> _showPlateFailureModal(VehiclePlateItem item) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final cs = theme.colorScheme;
        return AlertDialog(
          title: const Text('Vehículo no registrado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.plate,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _mapBatchErrorToMessage(
                  item.errorCode,
                  fallbackText: item.errorMessage,
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }

  // ── Modal final de cierre del proceso ─────────────────────────────────────────

  /// Modal "Registro finalizado" — se muestra siempre al alcanzar estado terminal.
  ///
  /// Encolado DESPUÉS de los plate-failure modals → garantiza que el usuario
  /// ve cada fallo individual antes del resumen global.
  /// Muestra variante limpia si no hay fallos.
  Future<void> _showBatchCompletionModal() async {
    if (!mounted) return;
    final failedItems = _batchCtrl.items
        .where((i) => i.status == VehiclePlateStatus.failed)
        .toList();
    final succeededCount = _batchCtrl.succeededCount;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _BatchCompletionDialog(
        succeededCount: succeededCount,
        failedItems: failedItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return PopScope(
      // canPop:false intercepta el botón de sistema (Android back) para que
      // _handleBackNavigation decida si salir directo o pedir confirmación.
      // La navegación efectiva (Get.offAllNamed) dispara dispose() →
      // cancelPolling() + Get.delete — la limpieza sigue ocurriendo.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBackNavigation();
      },
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          // Leading explícito: siempre va a Home, nunca depende del stack.
          // Batch completo → directo. Batch en curso → diálogo de confirmación.
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: _handleBackNavigation,
            tooltip: 'Ir al inicio',
          ),
          title: Text(
            _portfolioName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // FAB visible solo cuando _portfolio esté disponible (fetch Isar local).
        floatingActionButton: _portfolio != null
            ? FloatingActionButton.extended(
                onPressed: () => _goToRegisterAsset(_portfolio!),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Registrar activo'),
              )
            : null,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── OwnerHeader — aparece con AnimatedSize cuando ownerData llega.
            //
            // Prioridad de display:
            // 1. ownerData vivo (batch activo o reutilizado) → _OwnerHeader completo
            // 2. portfolio.ownerName != null (snapshot Isar) → _OwnerSnapshotBand
            //    Cubre el caso: dispose() deletó el controller → AssetRegistrationBinding
            //    creó uno nuevo → ownerData=null. El snapshot Isar actúa de fallback.
            // 3. Sin datos → SizedBox.shrink (header colapsado)
            //
            // _portfolioRx registrado como dependencia del Obx → el bloque se
            // reconstruye cuando el fetch local completa, sin setState adicional.
            Obx(() {
              final ownerData = _batchCtrl.ownerData.value;
              final portfolio = _portfolioRx.value; // dependencia reactiva

              if (kDebugMode) {
                debugPrint(
                  '[LIVE_PAGE] Obx ownerData rebuild — '
                  'ownerData=${ownerData != null} '
                  'name=${ownerData?.owner?.name} '
                  'snapshotName=${portfolio?.ownerName} '
                  'simitNull=${ownerData?.owner?.simit == null} '
                  'runtNull=${ownerData?.owner?.runt == null}',
                );
              }

              // set-once: captura el timestamp cuando el primer ownerData llega.
              // Asignación directa sin setState — no dispara rebuild.
              if (ownerData != null && _simitCheckedAt == null) {
                _simitCheckedAt = DateTime.now();
              }

              // Resolver qué child mostrar en el AnimatedSwitcher.
              final Widget headerChild;
              if (ownerData != null) {
                headerChild = _OwnerHeader(
                  key: const ValueKey('owner-content'),
                  data: ownerData,
                  simitCheckedAt: _simitCheckedAt,
                );
              } else if (OwnerSnapshotBand.isAvailable(portfolio)) {
                // Fallback: snapshot persistido en Isar (ownerData=null porque
                // el controller fue recreado al regresar desde Home).
                // Contrato canónico centralizado en OwnerSnapshotBand.isAvailable
                // — mismo criterio que portfolio_asset_list_page.
                headerChild = OwnerSnapshotBand(
                  key: const ValueKey('owner-snapshot'),
                  portfolio: portfolio!,
                );
              } else {
                headerChild =
                    const SizedBox.shrink(key: ValueKey('owner-empty'));
              }

              return AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: headerChild,
                ),
              );
            }),

            // ── BatchStatusBar — desaparece con AnimatedSize cuando isTerminal.
            Obx(() {
              final isTerminal = _batchCtrl.isTerminal;
              final isCreating = _batchCtrl.isCreating.value;
              final overallStatus = _batchCtrl.overallStatus.value;
              final total = _batchCtrl.totalCount;
              final processing = _batchCtrl.processingCount;
              final succeeded = _batchCtrl.succeededCount;
              final failed = _batchCtrl.failedCount;

              return AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: !isTerminal
                      ? _BatchStatusBar(
                          key: const ValueKey('batch-bar-content'),
                          isCreating: isCreating,
                          overallStatus: overallStatus,
                          total: total,
                          processing: processing,
                          succeeded: succeeded,
                          failed: failed,
                        )
                      : const SizedBox.shrink(key: ValueKey('batch-bar-empty')),
                ),
              );
            }),

            // ── ErrorBanner global — visible solo cuando hay errorMessage.
            Obx(() {
              final msg = _batchCtrl.errorMessage.value;
              if (msg == null) return const SizedBox.shrink();
              return _GlobalErrorBanner(message: msg);
            }),

            // ── Lista unificada: StreamBuilder (Isar) + Obx (batch).
            Expanded(
              child: StreamBuilder<List<AssetEntity>>(
                stream: _assetsStream,
                builder: (context, snapshot) {
                  // Error explícito de Isar — no puede mostrarse como lista vacía.
                  if (snapshot.hasError) {
                    return _IsarErrorState(error: snapshot.error);
                  }

                  // IMPORTANTE: no hay spinner de espera para Isar.
                  // Los ítems del batch deben ser visibles de inmediato aunque
                  // Isar aún no haya emitido su primer evento (assets = []).
                  // Un spinner aquí ocultaría el Obx entero y el batch parecería
                  // congelado aunque el controller esté corriendo correctamente.
                  final assets = snapshot.data ?? [];

                  if (kDebugMode) {
                    debugPrint('======== ISAR CHECK ========');
                    debugPrint('portfolioId=$_portfolioId');
                    debugPrint('assets count=${assets.length}');
                    for (final a in assets) {
                      debugPrint(
                          'assetId=${a.id} portfolioId=${a.portfolioId}');
                    }
                  }

                  // Guard B (deduplicación): cache derivado táctico de las placas ya
                  // en Isar. Asignación directa sin setState — no es estado de UI,
                  // solo un cache de guardia para _onBatchItemsChanged.
                  // El source of truth es Isar; este set es una proyección desechable.
                  final summaries = assets.map((e) => e.toSummaryVM()).toList();
                  _isarPlates = {
                    for (final vm in summaries)
                      if (vm is VehicleSummaryVM) vm.plate.toUpperCase(),
                  };

                  return Obx(() {
                    // buildUnifiedList() se llama UNA vez por rebuild (antes del itemBuilder).
                    final unified = buildUnifiedList(
                      summaries: summaries, // ya computados arriba
                      batchItems: _batchCtrl.items.toList(),
                      contexts: _batchCtrl.vehicleContexts,
                      timestamps: _itemTimestamps,
                      batchIsTerminal: _batchCtrl.isTerminal,
                    );

                    if (unified.isEmpty) {
                      return const _EmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                      itemCount: unified.length,
                      itemBuilder: (_, i) => _buildTile(unified[i]),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(UnifiedAssetItem item) {
    return switch (item) {
      RegisteringAsset it => _RegisteringVehicleTile(item: it),
      // onTap disponible cuando _portfolio esté fetched. El back desde AssetDetailPage
      // va a portfolioAssets vía AppNavigator.backFromAssetDetail — no regresa aquí.
      RegisteredAsset it => PortfolioAssetOperationalTile(
          key: ValueKey(it.identity),
          summary: it.summary,
          onTap: _portfolio != null
              ? () => AppNavigator.openAssetDetail(
                    assetId: it.summary.assetId,
                    portfolio: _portfolio!,
                    // fromLiveBatch=true: el back en AssetDetailPage usa Get.back()
                    // en lugar de Get.offAllNamed — preserva este batch en curso.
                    fromLiveBatch: true,
                  )
              : null,
        ),
      FailedAsset it => _FailedAssetTile(item: it),
    };
  }

  // ── Back navigation ─────────────────────────────────────────────────────────

  /// Maneja el back del AppBar y el botón de sistema (Android).
  ///
  /// Destino único: Home. Esta página no tiene un "atrás" legítimo — es un
  /// punto terminal del flujo de registro batch. Home siempre es la pantalla
  /// correcta después de finalizar (o abandonar) el batch.
  ///
  /// Comportamiento según el estado del batch:
  /// - Batch completado ([VrcBatchController.isTerminal] == true) → Home directo.
  /// - Batch en curso → diálogo de confirmación antes de salir.
  ///
  /// [AppNavigator.goToHome] usa Get.offAllNamed, lo que dispara dispose() →
  /// cancelPolling() + Get.delete<VrcBatchController>(force:true). La cadena
  /// de limpieza existente funciona sin cambios adicionales.
  Future<void> _handleBackNavigation() async {
    if (_batchCtrl.isTerminal) {
      // Batch finalizado — no hay nada en curso que perder.
      AppNavigator.goToHome();
      return;
    }

    // Batch en curso — confirmar antes de abandonar.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Salir del registro?'),
        content: const Text(
          'Hay vehículos que aún están procesándose. '
          'Si sales ahora se perderá el progreso de los que no han terminado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Continuar aquí'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    // mounted-guard: el widget puede haberse desmontado durante el await.
    if (confirmed == true && mounted) {
      AppNavigator.goToHome();
    }
  }

  // ── FAB navigation ──────────────────────────────────────────────────────────

  /// Navega al formulario de registro de activo.
  /// Idéntico al de portfolio_asset_list_page.dart — reutiliza el mismo flujo.
  void _goToRegisterAsset(PortfolioEntity portfolio) {
    HapticFeedback.lightImpact();
    final ctx = AssetRegistrationContext(
      portfolioId: portfolio.id,
      portfolioName: _portfolioName,
      countryId: portfolio.countryId,
      cityId: portfolio.cityId,
      assetType: AssetRegistrationType.vehiculo,
      registrationSessionId: const Uuid().v4(),
    );
    Get.toNamed(Routes.assetRegister, arguments: ctx);
  }

  // ── TÁCTICA FASE 4: orquestación de persistencia desde la vista ────────────
  //
  // Esta responsabilidad pertenece idealmente a un use case (BatchRegistrationOrchestrator).
  // Se encapsula aquí temporalmente porque AssetRegistrationController está destruido
  // después del Get.offNamed. Fase 5 debe mover esto a la capa de dominio.
  //
  // TODO (Fase 5): extraer a BatchRegistrationOrchestrator use case.

  /// Detecta nuevas placas exitosas en el batch y dispara su registro.
  ///
  /// Doble guard obligatorio:
  /// - Guard A [_registeredPlates]: evita disparos repetidos en la misma sesión.
  /// - Guard B [_isarPlates]: evita duplicados cuando la placa ya existe en Isar.
  void _onBatchItemsChanged(List<VehiclePlateItem> items) {
    for (final item in items) {
      if (item.status != VehiclePlateStatus.success) continue;
      final plate = item.plate.toUpperCase();
      if (_registeredPlates.contains(plate)) continue; // Guard A
      if (_isarPlates.contains(plate)) continue; // Guard B
      _registeredPlates.add(plate); // Guard A: optimista — antes del await
      _registerPlate(plate); // fire-and-forget
    }
  }

  /// Persiste un vehículo exitoso del batch en Isar vía el repositorio real.
  ///
  /// Guards mínimos de datos: si vrcData o vehicle son null (context incompleto
  /// del backend), se omite el registro y se loggea el motivo. Es preferible
  /// no persistir a persistir un registro vacío difícil de depurar.
  Future<void> _registerPlate(String plate) async {
    if (plate.isEmpty) {
      if (kDebugMode) {
        debugPrint('[LIVE_PAGE][_registerPlate] ⚠ placa vacía — skip');
      }
      return;
    }

    final vrcData = _batchCtrl.vehicleContexts[plate];
    if (vrcData == null) {
      if (kDebugMode) {
        debugPrint(
          '[LIVE_PAGE][_registerPlate] ⚠ vrcData null para plate=$plate — skip',
        );
      }
      _registeredPlates
          .remove(plate); // permitir reintento si el contexto llega tarde
      return;
    }

    final vehicle = vrcData.vehicle;
    if (vehicle == null) {
      if (kDebugMode) {
        debugPrint(
          '[LIVE_PAGE][_registerPlate] ⚠ vehicle null para plate=$plate — skip',
        );
      }
      _registeredPlates.remove(plate); // permitir reintento
      return;
    }

    if (kDebugMode) {
      debugPrint(
        '[LIVE_PAGE][_registerPlate] → plate=$plate orgId=${_resolveOrgId()}',
      );
    }

    try {
      await DIContainer().assetRepository.createAssetFromRuntAndLinkToPortfolio(
            portfolioId: _portfolioId,
            orgId: _resolveOrgId(),
            plate: plate,
            marca: vehicle.make ??
                '', // vehicle != null garantizado por guard previo
            modelo: vehicle.line ?? '',
            anio: vehicle.modelYear ??
                0, // 0 = sentinel "año desconocido" — convención existente
            countryId: _countryId,
            cityId: _cityId ?? '',
            createdBy: _resolveUid(),
            runtSnapshot: _buildRuntSnapshot(vrcData),
          );
      if (kDebugMode) {
        debugPrint('[LIVE_PAGE][_registerPlate] ✓ plate=$plate persistido');
      }
      // StreamBuilder detecta la nueva entrada en Isar automáticamente.
      // buildUnifiedList deduplica: RegisteringAsset desaparece, RegisteredAsset aparece.
    } on AssetCreationException catch (e) {
      if (e.code == AssetCreationExceptionCode.duplicatePlate) {
        // Ya existe en Isar — Guard B debería haberlo prevenido, pero la carrera es posible.
        // No eliminar de _registeredPlates: no reintentar.
        if (kDebugMode) {
          debugPrint(
            '[LIVE_PAGE][_registerPlate] duplicado plate=$plate — ignorado',
          );
        }
        return;
      }
      if (kDebugMode) {
        debugPrint(
          '[LIVE_PAGE][_registerPlate] error creación plate=$plate: ${e.message}',
        );
      }
      _registeredPlates.remove(plate); // permitir reintento en próximo poll
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
            '[LIVE_PAGE][_registerPlate] error inesperado plate=$plate: $e');
      }
      _registeredPlates.remove(plate); // permitir reintento
    }
  }

  /// Construye el snapshot de datos RUNT/VRC para persistencia.
  ///
  /// Mismo campo-a-campo que asset_registration_page.dart:520-547.
  /// Si [vrcData] es null retorna AssetRuntSnapshot.empty — el repo acepta
  /// el empty y persiste el activo con datos técnicos vacíos.
  AssetRuntSnapshot _buildRuntSnapshot(VrcDataModel? vrcData) {
    if (vrcData == null) return AssetRuntSnapshot.empty;
    final vehicle = vrcData.vehicle;
    final owner = vrcData.owner;
    final legal = vrcData.legal;
    return AssetRuntSnapshot(
      line: vehicle?.line,
      serviceType: vehicle?.service,
      vehicleClass: vehicle?.vehicleClass,
      color: vehicle?.color,
      engineNumber: vehicle?.engineNumber,
      chassisNumber: vehicle?.chassisNumber,
      vin: vehicle?.vin,
      engineDisplacement: vehicle?.engineDisplacement,
      bodyType: vehicle?.bodyType,
      fuelType: vehicle?.fuelType,
      transitAuthority: vehicle?.transitAuthority,
      initialRegistrationDate: vehicle?.initialRegistrationDate,
      passengerCapacity: vehicle?.passengerCapacity,
      grossWeightKg: vehicle?.grossWeightKg,
      axles: vehicle?.axles,
      ownerName: owner?.name,
      ownerDocumentType: owner?.documentType,
      ownerDocument: owner?.document,
      soatRecords: vrcData.soat,
      rcRecords: vrcData.rc,
      rtmRecords: vrcData.rtm,
      limitations: legal?.limitations,
      warranties: legal?.warranties,
      propertyLiens: legal?.propertyLiens,
    );
  }

  // ── DEUDA TÉCNICA: helpers de sesión ────────────────────────────────────────
  // Replican VrcBatchController._resolveOrgId / _resolveUid.
  // TODO (Fase 5): extraer a SessionHelper (core/utils) cuando se cree
  // BatchRegistrationOrchestrator use case.

  String _resolveOrgId() {
    try {
      if (Get.isRegistered<SessionContextController>()) {
        final orgId =
            Get.find<SessionContextController>().user?.activeContext?.orgId;
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
}

// ─────────────────────────────────────────────────────────────────────────────
// _OwnerHeader — Encabezado persona-céntrico del propietario del lote
// ─────────────────────────────────────────────────────────────────────────────

class _OwnerHeader extends StatelessWidget {
  final VrcDataModel data;
  final DateTime? simitCheckedAt;

  const _OwnerHeader({super.key, required this.data, this.simitCheckedAt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final owner = data.owner;
    final decision = data.businessDecision;

    final name = owner?.name ?? 'Propietario';
    final docDisplay = _formatDoc(owner);
    final licenseStatus = _resolveLicenseStatus(owner);
    final licenseExpiry = _resolveLicenseExpiry(owner);
    final simitSummary = owner?.simit?.summary;

    return Container(
      color: cs.surfaceContainerLow,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre + badge de riesgo
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (decision?.riskLevel != null) ...[
                const SizedBox(width: 8),
                _RiskBadge(riskLevel: decision!.riskLevel!),
              ],
            ],
          ),
          if (docDisplay != null) ...[
            const SizedBox(height: 2),
            Text(
              docDisplay,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 8),
          // Grid 2-up: Licencia y SIMIT como cards visuales independientes
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _LicenseCard(
                  licenseStatus: licenseStatus,
                  licenseColor: _licenseColor(context, licenseStatus),
                  expiryDate: licenseExpiry,
                  // Condición relajada: basta con que runt exista.
                  // La página de detalle maneja el caso de licenses vacía.
                  onTap: (owner?.runt != null)
                      ? () => Get.toNamed(
                            Routes.driverLicenseDetail,
                            arguments: {
                              'data': data,
                              'checkedAt': simitCheckedAt,
                            },
                          )
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SimitCard(
                  summary: simitSummary,
                  checkedAt: simitCheckedAt,
                  // Condición relajada: basta con que simit exista.
                  // La página de detalle maneja el caso de summary null.
                  onTap: (owner?.simit != null)
                      ? () => Get.toNamed(
                            Routes.simitPersonDetail,
                            arguments: {
                              'data': data,
                              'checkedAt': simitCheckedAt,
                            },
                          )
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _formatDoc(VrcOwnerModel? owner) {
    final type = owner?.documentType?.trim().toUpperCase();
    final number = owner?.document?.trim();
    if (type == null || type.isEmpty || number == null || number.isEmpty) {
      return null;
    }
    return '$type $number';
  }

  String? _resolveLicenseStatus(VrcOwnerModel? owner) {
    final licenses = owner?.runt?.licenses;
    if (licenses == null || licenses.isEmpty) return null;
    return licenses.first.status;
  }

  /// Fecha de vencimiento derivada de la categoría con fecha más tardía.
  /// Ya calculada por VrcLicenseModel.fromJson — solo se expone aquí.
  String? _resolveLicenseExpiry(VrcOwnerModel? owner) {
    final licenses = owner?.runt?.licenses;
    if (licenses == null || licenses.isEmpty) return null;
    return licenses.first.expiryDate;
  }

  Color? _licenseColor(BuildContext context, String? status) {
    if (status == null) return null;
    final cs = Theme.of(context).colorScheme;
    final norm = status.toLowerCase();
    if (norm.contains('vig') || norm.contains('activ')) {
      return Colors.green.shade600;
    }
    if (norm.contains('venc') || norm.contains('suspend')) return cs.error;
    return cs.onSurfaceVariant;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _OwnerSnapshotBand ELIMINADO (2026-04).
// Unificado en OwnerSnapshotBand (widgets/portfolio/owner_snapshot_band.dart)
// para contrato único de visibilidad y render compartido con list page.
// ─────────────────────────────────────────────────────────────────────────────

// ── _RiskBadge ───────────────────────────────────────────────────────────────

class _RiskBadge extends StatelessWidget {
  final String riskLevel;

  const _RiskBadge({required this.riskLevel});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = _style(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  (String, Color, Color) _style(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return switch (riskLevel.toUpperCase()) {
      'LOW' => ('BAJO', Colors.green.shade100, Colors.green.shade800),
      'MEDIUM' => ('MEDIO', Colors.orange.shade100, Colors.orange.shade800),
      'HIGH' => ('ALTO', cs.errorContainer, cs.onErrorContainer),
      _ => ('DESCONOCIDO', cs.surfaceContainerHighest, cs.onSurface),
    };
  }
}

// ── _LicenseCard ──────────────────────────────────────────────────────────────
// Card visual de Licencia de conducción en el header del propietario.
// Muestra estado de la licencia con su color semántico.
// onTap null → sin chevron, sin efecto ripple (datos insuficientes).

class _LicenseCard extends StatelessWidget {
  final String? licenseStatus;
  final Color? licenseColor;
  final String? expiryDate;
  final VoidCallback? onTap;

  const _LicenseCard({
    this.licenseStatus,
    this.licenseColor,
    this.expiryDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surfaceContainer,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.credit_card_outlined,
                    size: 13,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Licencia',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  if (onTap != null) ...[
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: cs.primary.withValues(alpha: 0.75),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                licenseStatus ?? 'Sin información',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: licenseColor ?? cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (expiryDate != null) ...[
                const SizedBox(height: 2),
                Text(
                  'Vence $expiryDate',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── _SimitCard ────────────────────────────────────────────────────────────────
// Card visual de SIMIT en el header del propietario.
// Muestra valor total + conteo de infracciones + badge de frescura.
// El desglose completo (comparendos/multas) vive en SimitPersonDetailPage.
// onTap null → sin chevron. onTap != null → chevron visible + ripple,
// independientemente de si summary es null (InkWell siempre presente).

class _SimitCard extends StatelessWidget {
  final VrcSimitSummaryModel? summary;
  final DateTime? checkedAt;
  final VoidCallback? onTap;

  const _SimitCard({this.summary, this.checkedAt, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Determinar el contenido según disponibilidad de datos.
    // El InkWell siempre envuelve — onTap null desactiva ripple silenciosamente.
    final Widget bodyContent;

    if (summary == null) {
      // Sin datos: card vacía con chevron si hay onTap.
      bodyContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_outlined,
                  size: 13, color: cs.onSurfaceVariant),
              const SizedBox(width: 4),
              Text('SIMIT',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: cs.onSurfaceVariant)),
              if (onTap != null) ...[
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: cs.primary.withValues(alpha: 0.75),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text('Sin información',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      );
    } else {
      final hasFines = summary!.hasFines ?? false;
      // Valor total: preferir formattedTotal, luego formatear total numérico
      final totalText = hasFines
          ? (summary!.formattedTotal ??
              (summary!.total != null ? _formatCop(summary!.total!) : null) ??
              'Ver detalle')
          : 'Sin multas';

      // Conteo total de infracciones
      final finesCount = summary!.finesCount ??
          ((summary!.byType?.comparendos?.count ?? 0) +
              (summary!.byType?.multas?.count ?? 0) +
              (summary!.byType?.acuerdosDePago?.count ?? 0));
      final countText = hasFines
          ? '$finesCount infraccion${finesCount != 1 ? 'es' : ''}'
          : null;

      // Frescura — solo si hay timestamp de sesión
      SimitFreshnessLevel? freshnessLevel;
      if (checkedAt != null) {
        freshnessLevel = shouldRefreshSimit(
          ownerVehicleCount: 0,
          comparendosCount:
              summary!.byType?.comparendos?.count ?? summary!.comparendos ?? 0,
          multasCount: summary!.byType?.multas?.count ?? summary!.multas ?? 0,
          lastCheckedAt: checkedAt!,
        ).level;
      }

      bodyContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 13,
                color: hasFines ? cs.error : cs.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                'SIMIT',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
              if (onTap != null) ...[
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: cs.primary.withValues(alpha: 0.75),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            totalText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: hasFines ? cs.error : cs.onSurface,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Conteo + badge de frescura en segunda línea
          if (countText != null || freshnessLevel != null) ...[
            const SizedBox(height: 2),
            Row(
              children: [
                if (countText != null)
                  Text(
                    countText,
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                if (freshnessLevel != null) ...[
                  if (countText != null) const SizedBox(width: 5),
                  _FreshnessBadge(level: freshnessLevel),
                ],
              ],
            ),
          ],
        ],
      );
    }

    return Material(
      color: cs.surfaceContainer,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: bodyContent,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS — formateo monetario COP (compartido por _SimitCard y _OwnerInfoTile)
// ─────────────────────────────────────────────────────────────────────────────

/// Formato monetario colombiano (COP): $1.787.641
String _formatCop(num amount) {
  final str = amount.toInt().abs().toString();
  final formatted = str.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]}.',
  );
  return '\$$formatted';
}

// ── _FreshnessBadge ───────────────────────────────────────────────────────────

class _FreshnessBadge extends StatelessWidget {
  final SimitFreshnessLevel level;
  const _FreshnessBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (color, label) = switch (level) {
      SimitFreshnessLevel.fresh => (Colors.green.shade600, 'Actualizado'),
      SimitFreshnessLevel.stale => (Colors.orange.shade600, 'Por actualizar'),
      SimitFreshnessLevel.expired => (cs.error, 'Desactualizado'),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _BatchStatusBar — Barra compacta de progreso del batch
// ─────────────────────────────────────────────────────────────────────────────

class _BatchStatusBar extends StatelessWidget {
  final bool isCreating;
  final String overallStatus;
  final int total;
  final int processing;
  final int succeeded;
  final int failed;

  const _BatchStatusBar({
    super.key,
    required this.isCreating,
    required this.overallStatus,
    required this.total,
    required this.processing,
    required this.succeeded,
    required this.failed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final statusLabel =
        isCreating ? 'Iniciando consulta...' : _statusLabel(overallStatus);

    // Progreso: placas que ya terminaron (éxito o fallo) sobre el total.
    final done = succeeded + failed;
    final progressFraction = (!isCreating && total > 0) ? done / total : null;

    return Container(
      color: cs.secondaryContainer,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Fila superior: spinner + etiqueta + chips de conteo
          Row(
            children: [
              if (processing > 0 || isCreating) ...[
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: cs.onSecondaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  statusLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSecondaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatChip(
                  label: 'Total', value: total, color: cs.onSecondaryContainer),
              const SizedBox(width: 8),
              _StatChip(
                  label: 'OK', value: succeeded, color: Colors.green.shade700),
              const SizedBox(width: 8),
              _StatChip(label: 'Fallo', value: failed, color: cs.error),
            ],
          ),
          // Barra de progreso + texto "X de Y placas" — visible una vez inicia
          if (progressFraction != null) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progressFraction,
                minHeight: 3,
                backgroundColor: cs.onSecondaryContainer.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(cs.onSecondaryContainer),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              total == 1 ? '1 placa' : '$done de $total placas',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSecondaryContainer.withValues(alpha: 0.75),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _statusLabel(String status) => switch (status.toLowerCase()) {
        'queued' => 'En cola...',
        'running' => total == 1 ? 'Consultando vehículo...' : 'Consultando vehículos...',
        'completed' => 'Consulta completada',
        'partially_completed' => 'Consulta parcial',
        'failed' => 'Consulta fallida',
        'cancelled' => 'Consulta cancelada',
        _ => 'Procesando...',
      };
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label: $value',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _GlobalErrorBanner — Banner de error global del batch
// ─────────────────────────────────────────────────────────────────────────────

class _GlobalErrorBanner extends StatelessWidget {
  final String message;

  const _GlobalErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.errorContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded,
              size: 16, color: cs.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.onErrorContainer,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _RegisteringVehicleTile — Tile para activos en consulta batch (priority=1)
// ─────────────────────────────────────────────────────────────────────────────

class _RegisteringVehicleTile extends StatelessWidget {
  final RegisteringAsset item;

  const _RegisteringVehicleTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final plate = item.plateItem.plate;
    final vehicle = item.vehicleData;

    final subtitle = _buildSubtitle(vehicle);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              PlateWidget(
                plate: plate,
                serviceType: vehicle?.service,
                vehicleType: vehicle?.vehicleClass,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      Text(
                        'Consultando...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Text(
                      'En consulta VRC',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // success → check verde; consulting → spinner.
              if (item.isSucceeded)
                Icon(Icons.check_circle_rounded,
                    color: Colors.green.shade700, size: 20)
              else
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: cs.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String? _buildSubtitle(VrcVehicleModel? v) {
    if (v == null) return null;
    final parts = <String>[
      if (v.make != null && v.make!.isNotEmpty) v.make!,
      if (v.line != null && v.line!.isNotEmpty) v.line!,
      if (v.modelYear != null) '${v.modelYear}',
      if (v.service != null && v.service!.isNotEmpty) v.service!,
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _FailedAssetTile — Tile para consultas que fallaron (priority=3)
// ─────────────────────────────────────────────────────────────────────────────

class _FailedAssetTile extends StatelessWidget {
  final FailedAsset item;

  const _FailedAssetTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final plate = item.plateItem.plate;
    // Usar errorCode como fuente de verdad; fallback al texto libre del backend.
    final errorText = _mapBatchErrorToMessage(
      item.plateItem.errorCode,
      fallbackText: item.plateItem.errorMessage,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: cs.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              PlateWidget(plate: plate),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consulta fallida',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onErrorContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      errorText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onErrorContainer.withValues(alpha: 0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.cancel_outlined, size: 20, color: cs.error),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _IsarErrorState — Error real de la base de datos local (no "sin datos")
// ─────────────────────────────────────────────────────────────────────────────

class _IsarErrorState extends StatelessWidget {
  final Object? error;

  const _IsarErrorState({this.error});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: cs.error),
            const SizedBox(height: 16),
            Text(
              'Error al cargar los activos',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No se pudo leer la base de datos local. '
              'El activo sigue procesándose.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _mapBatchErrorToMessage — Mapeo defensivo de códigos de error del backend VRC
// ─────────────────────────────────────────────────────────────────────────────

/// Convierte un código de error del backend VRC a un mensaje legible para el usuario.
///
/// [errorCode] es la fuente de verdad (campo tipado del backend).
/// [fallbackText] es el texto libre del backend — solo se muestra cuando no
/// existe un mapeo canónico para [errorCode] y el texto está disponible.
///
/// Defensivo: errorCode null/vacío + fallbackText null → mensaje genérico.
/// No inferir semántica por texto libre: si el código cambia en backend,
/// actualizar este switch, no comparar strings de descripción.
String _mapBatchErrorToMessage(String? errorCode, {String? fallbackText}) {
  return switch (errorCode?.trim().toUpperCase()) {
    'RUNT_OWNER_MISMATCH' => 'No corresponde al propietario del vehículo',
    'RUNT_VEHICLE_FAILED' => 'No corresponde al documento del propietario',
    'RUNT_NOT_FOUND' => 'Vehículo no encontrado en el RUNT',
    'RUNT_NO_DATA' => 'Sin datos disponibles en el RUNT',
    'RUNT_NAV_TIMEOUT' => 'Consulta no disponible en este momento',
    'RUNT_TIMEOUT' => 'Consulta no disponible en este momento',
    'RUNT_CAPTCHA_FAIL' => 'Consulta bloqueada temporalmente',
    'OCR_NO_RESULT' => 'No se pudo leer la información del vehículo',
    _ => fallbackText ?? 'No se pudo registrar el vehículo',
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// _BatchCompletionDialog — Modal universal de cierre del proceso batch
// ─────────────────────────────────────────────────────────────────────────────

/// Dialog "Registro finalizado" — aparece siempre al alcanzar estado terminal.
///
/// Muestra cuántos vehículos quedaron registrados y, si los hay, la lista de
/// placas no registradas con su error. Variante limpia cuando [failedItems]
/// está vacío. El usuario debe pulsar "Aceptar" para cerrar (barrierDismissible: false).
class _BatchCompletionDialog extends StatelessWidget {
  final int succeededCount;
  final List<VehiclePlateItem> failedItems;

  const _BatchCompletionDialog({
    required this.succeededCount,
    required this.failedItems,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hasFailed = failedItems.isNotEmpty;

    return AlertDialog(
      title: const Text('Registro finalizado'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehículos registrados exitosamente
            Text(
              succeededCount == 1
                  ? '1 vehículo registrado'
                  : '$succeededCount vehículos registrados',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (hasFailed) ...[
              const SizedBox(height: 12),
              Divider(height: 1, color: cs.outlineVariant),
              const SizedBox(height: 12),
              // Vehículos no registrados
              Text(
                failedItems.length == 1
                    ? '1 vehículo no registrado'
                    : '${failedItems.length} vehículos no registrados',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...failedItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.cancel_outlined, size: 16, color: cs.error),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.plate,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              _mapBatchErrorToMessage(
                                item.errorCode,
                                fallbackText: item.errorMessage,
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Las placas no registradas no quedan guardadas en el sistema.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _EmptyState — Estado vacío cuando no hay activos ni ítems en batch
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: cs.primary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'Sin activos registrados',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Los vehículos consultados aparecerán aquí a medida que se registren.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
