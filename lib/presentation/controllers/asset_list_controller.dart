// ============================================================================
// lib/presentation/controllers/asset_list_controller.dart
// ASSET LIST CONTROLLER — Enterprise Ultra Pro Premium (Presentation / Controllers)
//
// QUÉ HACE:
// - Gestiona el estado reactivo de la lista de activos del usuario.
// - Observa el orgId del contexto activo vía SessionContextController.
// - Re-suscribe automáticamente al stream de activos cuando cambia la org.
// - Evita re-suscripciones innecesarias si el orgId no cambió realmente.
//
// QUÉ NO HACE:
// - NO modifica el repositorio de activos ni el dominio.
// - NO afecta portfolio, Home, bootstrap ni otros módulos.
// - NO introduce nuevos modelos ni capas.
//
// PRINCIPIOS:
// - REACTIVE: reacciona a cambios de orgId mediante ever().
// - NO LEAKS: StreamSubscription y Worker se liberan en onClose().
// - FAIL-SAFE: orgId nulo/vacío → lista vacía sin error ni consulta.
// - STABLE SUBSCRIPTION: no reabre el stream si el orgId efectivo no cambió.
//
// ENTERPRISE NOTES:
// - FIX (2026-03): elimina hardcode 'org_mock'.
// - Fuente de verdad: SessionContextController.activeWorkspaceContext.value?.orgId
// ============================================================================

import 'dart:async';

import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../domain/entities/asset/asset_entity.dart';
import 'session_context_controller.dart';

class AssetListController extends GetxController {
  final RxList<AssetEntity> _assets = <AssetEntity>[].obs;
  List<AssetEntity> get assets => _assets;

  StreamSubscription<List<AssetEntity>>? _assetsSub;
  Worker? _workspaceWorker;
  late final SessionContextController _session;

  String? _currentOrgId;

  @override
  void onInit() {
    super.onInit();
    _session = Get.find<SessionContextController>();

    // Suscripción inicial con el orgId ya disponible en sesión.
    _subscribeToOrg(_session.activeWorkspaceContext.value?.orgId);

    // Reaccionar a cambios de workspace/org activo.
    // Guardamos el Worker para liberarlo explícitamente en onClose().
    _workspaceWorker = ever(
      _session.activeWorkspaceContext,
      (ctx) => _subscribeToOrg(ctx?.orgId),
    );
  }

  /// Cancela la suscripción anterior y abre una nueva para el [orgId] dado.
  ///
  /// Reglas:
  /// - Si [orgId] es null o vacío, limpia la lista y no consulta.
  /// - Si el orgId efectivo no cambió, no reabre el stream.
  void _subscribeToOrg(String? orgId) {
    final normalizedOrgId = orgId?.trim();

    // Evitar re-suscripciones innecesarias si el orgId no cambió realmente.
    if (_currentOrgId == normalizedOrgId) {
      return;
    }

    _currentOrgId = normalizedOrgId;

    _assetsSub?.cancel();
    _assetsSub = null;

    if (normalizedOrgId == null || normalizedOrgId.isEmpty) {
      _assets.clear();
      return;
    }

    _assetsSub = DIContainer()
        .assetRepository
        .watchAssetsByOrg(normalizedOrgId)
        .listen((list) {
      _assets.assignAll(list);
    });
  }

  Future<void> addAsset(AssetEntity asset) async {
    await DIContainer().assetRepository.upsertAsset(asset);
  }

  Future<void> deleteAsset(AssetEntity asset) async {
    // TODO: Implementar delete en repositories cuando el contrato esté disponible.
  }

  @override
  void onClose() {
    _assetsSub?.cancel();
    _workspaceWorker?.dispose();
    super.onClose();
  }
}