import 'package:get/get.dart';

import '../../controllers/chat/renter_chat_controller.dart';
import '../../controllers/renter/asset/renter_asset_controller.dart';
import '../../controllers/renter/documents/renter_documents_controller.dart';
import '../../controllers/renter/home/renter_home_controller.dart';
import '../../controllers/renter/payments/renter_payments_controller.dart';
import '../../controllers/tenant/home/tenant_home_controller.dart';

class RenterBinding extends Bindings {
  @override
  void dependencies() {
    // TenantHomePage es GetView<TenantHomeController>. Debe registrarse aquí
    // porque WorkspaceShell instancia la página fuera del sistema de rutas
    // nombradas de GetX — TenantHomeBinding (acoplado a Routes.tenantHome)
    // nunca se activa en el flujo del workspace renter.
    Get.lazyPut<TenantHomeController>(() => TenantHomeController(), fenix: true);
    Get.lazyPut(() => RenterHomeController(), fenix: true);
    Get.lazyPut(() => RenterPaymentsController(), fenix: true);
    Get.lazyPut(() => RenterAssetController(), fenix: true);
    Get.lazyPut(() => RenterDocumentsController(), fenix: true);
    Get.lazyPut(() => RenterChatController(), fenix: true);
  }
}
