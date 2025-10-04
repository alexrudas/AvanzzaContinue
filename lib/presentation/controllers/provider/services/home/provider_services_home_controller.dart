import 'package:get/get.dart';
import '../../../../../core/di/container.dart';
import '../../../../controllers/session_context_controller.dart';

class ProviderServicesHomeController extends GetxController {
  final loading = true.obs;
  final RxnString error = RxnString();

  String? _orgId;
  String? _providerType;

  @override
  void onInit() {
    super.onInit();
    final session = Get.find<SessionContextController>();
    _orgId = session.user?.activeContext?.orgId;
    _providerType = session.user?.activeContext?.providerType;

    _loadLocal();
    DIContainer().syncService.sync();
  }

  Future<void> _loadLocal() async {
    try {
      loading.value = true;
      error.value = null;
      await Future<void>.delayed(const Duration(milliseconds: 150));
    } catch (e) {
      error.value = 'Error cargando datos';
    } finally {
      loading.value = false;
    }
  }
}
