import 'package:get/get.dart';
import '../../../../core/di/container.dart';
import '../../session_context_controller.dart' as scc;

class RenterPaymentsController extends GetxController {
  final loading = true.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    final session = Get.find<scc.SessionContextController>();
    final orgId = session.user?.activeContext?.orgId;
    _loadLocal(orgId);
    DIContainer().syncService.sync();
  }

  Future<void> _loadLocal(String? orgId) async {
    try {
      loading.value = true;
      error.value = null;
      await Future<void>.delayed(const Duration(milliseconds: 120));
    } catch (e) {
      error.value = 'Error cargando pagos';
    } finally {
      loading.value = false;
    }
  }
}
