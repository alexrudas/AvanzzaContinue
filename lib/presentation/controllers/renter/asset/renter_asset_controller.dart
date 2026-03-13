import 'package:get/get.dart';
import 'package:avanzza/core/platform/offline_sync_service.dart';
import '../../session_context_controller.dart' as scc;

class RenterAssetController extends GetxController {
  final loading = true.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    final session = Get.find<scc.SessionContextController>();
    final orgId = session.user?.activeContext?.orgId;
    _loadLocal(orgId);
    Get.find<OfflineSyncService>().sync();
  }

  Future<void> _loadLocal(String? orgId) async {
    try {
      loading.value = true;
      error.value = null;
      await Future<void>.delayed(const Duration(milliseconds: 120));
    } catch (e) {
      error.value = 'Error cargando activo';
    } finally {
      loading.value = false;
    }
  }
}
