import 'package:get/get.dart';
import 'package:avanzza/core/platform/offline_sync_service.dart';
import '../../../../controllers/session_context_controller.dart';

class ProviderServicesOrdersController extends GetxController {
  final loading = true.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    final session = Get.find<SessionContextController>();
    final orgId = session.user?.activeContext?.orgId;
    _loadLocal(orgId);
    Get.find<OfflineSyncService>().sync();
  }

  Future<void> _loadLocal(String? orgId) async {
    try {
      loading.value = true;
      error.value = null;
      await Future<void>.delayed(const Duration(milliseconds: 150));
    } catch (e) {
      error.value = 'Error cargando órdenes';
    } finally {
      loading.value = false;
    }
  }
}
