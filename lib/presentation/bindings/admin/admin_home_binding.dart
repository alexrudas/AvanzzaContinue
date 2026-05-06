import 'package:get/get.dart';

import '../../controllers/admin/home/admin_home_controller.dart';

class AdminHomeBinding extends Bindings {
  @override
  void dependencies() {
    // ActivationGateController retirado (2026-05): el gate de activación era
    // deuda zombie del modelo viejo de "obligar registro de primer activo".
    // Bajo el modelo nuevo (workspace abre siempre con activeContext.orgId),
    // el empty-state DENTRO del shell — `_EmptyState` en
    // `portfolio_asset_list_page` y `EmptyStateCard` en el home — cubre la
    // misma UX con CTA "Registrar activo" sin bloquear acceso al workspace.
    Get.lazyPut(() => AdminHomeController(), fenix: true);
  }
}
