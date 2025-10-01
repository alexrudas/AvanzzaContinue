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

  final _requestTiles = <Widget>[]..clear();
  List<Widget> get requestTiles => _requestTiles;

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

  void _subscribeLocal() {
    try {
      loading.value = true;
      error.value = null;
      if (_orgId == null) return;

      _repo.watchRequestsByOrg(_orgId!).listen((list) {
        _requestTiles
          ..clear()
          ..addAll(list.map((r) => ListTile(
                title: Text(r.tipoRepuesto),
                subtitle: Text(
                    'Estado: ${r.estado} • Respuestas: ${r.respuestasCount}'),
              )));
        loading.value = false;
      });
    } catch (e) {
      error.value = 'Error cargando solicitudes';
      loading.value = false;
    }
  }

  void createRequest() async {
    final guard = EnsureRegisteredGuard();
    await guard.run(() async => Get.toNamed('/purchase'));
  }
}
