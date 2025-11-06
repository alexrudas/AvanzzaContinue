import 'package:get/get.dart';
import '../controllers/tenant/home/tenant_home_controller.dart';

/// Binding para la página de Home del Arrendatario.
/// Registra el TenantHomeController en GetX.
class TenantHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TenantHomeController>(() => TenantHomeController());
  }
}
