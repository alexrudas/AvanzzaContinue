import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/di/container.dart';
import '../../../../domain/repositories/purchase_repository.dart';
import '../../../common/ensure_registered_guard.dart';
import '../../../controllers/session_context_controller.dart';

class AdminPurchaseController extends GetxController {
  final loading = true.obs;
  final RxnString error = RxnString();
  bool get hasActiveOrg => _orgId != null;

  String? _orgId;
  late final PurchaseRepository _repo;

  final _requestTiles = <Widget>[];
  List<Widget> get requestTiles => _requestTiles;

  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    _repo = di.purchaseRepository;
    final session = Get.find<SessionContextController>();
    _orgId = session.user?.activeContext?.orgId;

    _subscribeLocal();
    // No bloquea UI.
    di.syncService.sync();
  }

  void _subscribeLocal() {
    loading.value = true;
    error.value = null;

    // Si no hay organización activa, corta y muestra EmptyState.
    if (_orgId == null) {
      _sub?.cancel();
      _requestTiles.clear();
      loading.value = false;
      return;
    }

    // Re-suscribe limpio.
    _sub?.cancel();
    _sub = _repo.watchRequestsByOrg(_orgId!).listen(
      (list) {
        _requestTiles
          ..clear()
          ..addAll(list.map((r) => ListTile(
                title: Text(r.tipoRepuesto),
                subtitle: Text(
                    'Estado: ${r.estado} • Respuestas: ${r.respuestasCount}'),
              )));
        loading.value = false; // Apaga spinner al primer batch.
      },
      onError: (e, __) {
        error.value = 'Error cargando solicitudes';
        loading.value = false;
      },
      onDone: () {
        // Si el stream se cierra, asegúrate de no dejar el spinner prendido.
        if (loading.value) loading.value = false;
      },
    );
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void createRequest() async {
    final guard = EnsureRegisteredGuard();
    await guard.run(() async => Get.toNamed('/purchase'));
  }

  // Permite al usuario seleccionar manualmente una organización activa.
// En producción, debes redirigir a la vista real del selector.
  void selectOrganization() async {
    // TODO: cambia la ruta según tu flujo real.
    await Get.toNamed('/select-organization');

    // Si el usuario selecciona una organización y el SessionContextController
    // actualiza el contexto activo, la suscripción se reactivará sola.
    // Si no tienes esa reactividad implementada aún, puedes forzarla:
    _orgId = Get.find<SessionContextController>().user?.activeContext?.orgId;
    _subscribeLocal();
  }
}
