// ============================================================================
// lib/presentation/controllers/admin/purchase/admin_purchase_controller.dart
// ADMIN PURCHASE CONTROLLER — Estado reactivo del módulo de compras (Admin)
//
// QUÉ HACE:
// - Expone lista reactiva de PurchaseRequestEntity desde PurchaseRepository.
// - Provee KPIs computados (total, abiertas, asignadas, cerradas, con respuestas).
// - Resuelve orgId desde SessionContextController al iniciar.
// - Ofrece acción createRequest() que navega a Routes.purchase (wizard Fase 2).
//
// QUÉ NO HACE:
// - NO construye widgets ni estructuras de UI — solo datos puros.
// - NO resuelve nombres de assets ni proveedores — responsabilidad de la UI/VM.
// - NO persiste estado propio — delega al repositorio.
//
// PRINCIPIOS:
// - Data-only: sin Widgets, sin BuildContext, sin formateo visual.
// - Reactividad vía RxList: la UI observa con Obx() sin polling.
// - Offline-first: watchRequestsByOrg() lee Isar primero, sync en background.
//
// ENTERPRISE NOTES:
// - CREADO: Módulo de compras v1 (sin fecha registrada).
// - MODIFICADO (2026-04): Fase 1 — refactorizado para exponer entidades puras.
//   Eliminada generación de List<Widget> (violación de Clean Architecture).
// ============================================================================

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../core/di/container.dart';
import '../../../../domain/entities/purchase/purchase_request_entity.dart';
import '../../../../domain/repositories/purchase_repository.dart';
import '../../../../routes/app_pages.dart';
import '../../../common/ensure_registered_guard.dart';
import '../../session_context_controller.dart';

class AdminPurchaseController extends GetxController {
  // ── STATE ────────────────────────────────────────────────────────────────
  final loading = true.obs;
  final RxnString error = RxnString();

  /// Lista reactiva de solicitudes de compra de la org activa.
  /// Alimentada por PurchaseRepository.watchRequestsByOrg().
  final requests = <PurchaseRequestEntity>[].obs;

  // ── KPIs COMPUTADOS ──────────────────────────────────────────────────────
  // Status wire-stable backend: sent | partially_responded | responded | closed.
  bool get hasActiveOrg => _orgId != null;
  int get totalCount => requests.length;
  int get openCount => requests.where((r) => r.status != 'closed').length;
  int get respondedCount =>
      requests.where((r) => r.status == 'responded').length;
  int get closedCount => requests.where((r) => r.status == 'closed').length;
  int get withResponsesCount =>
      requests.where((r) => r.respuestasCount > 0).length;

  // ── PRIVATE ──────────────────────────────────────────────────────────────
  String? _orgId;
  late final PurchaseRepository _repo;
  StreamSubscription<List<PurchaseRequestEntity>>? _sub;

  // ── LIFECYCLE ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    _repo = di.purchaseRepository;
    final session = Get.find<SessionContextController>();
    _orgId = session.user?.activeContext?.orgId;

    _subscribeLocal();
    di.syncService.sync();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  // ── DATA ─────────────────────────────────────────────────────────────────

  void _subscribeLocal() {
    loading.value = true;
    error.value = null;

    if (_orgId == null) {
      _sub?.cancel();
      requests.clear();
      loading.value = false;
      return;
    }

    _sub?.cancel();
    _sub = _repo.watchRequestsByOrg(_orgId!).listen(
      (list) {
        requests.assignAll(list);
        loading.value = false;
      },
      onError: (e, __) {
        debugPrint('[AdminPurchaseCtrl] watchRequestsByOrg error: $e');
        error.value = 'Error cargando solicitudes';
        loading.value = false;
      },
      onDone: () {
        if (loading.value) loading.value = false;
      },
    );
  }

  // ── ACTIONS ──────────────────────────────────────────────────────────────

  /// Navega al flujo de creación de solicitud (wizard Fase 2).
  void createRequest() async {
    final guard = EnsureRegisteredGuard();
    await guard.run(() async => Get.toNamed(Routes.purchase));
  }
}
