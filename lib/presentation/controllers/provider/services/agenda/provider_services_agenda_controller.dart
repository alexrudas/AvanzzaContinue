import 'package:get/get.dart';
import 'package:avanzza/core/platform/offline_sync_service.dart';

class ProviderServicesAgendaController extends GetxController {
  final loading = true.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    _loadLocal();
    Get.find<OfflineSyncService>().sync();
  }

  Future<void> _loadLocal() async {
    try {
      loading.value = true;
      error.value = null;
      await Future<void>.delayed(const Duration(milliseconds: 150));
    } catch (e) {
      error.value = 'Error cargando agenda';
    } finally {
      loading.value = false;
    }
  }
}
