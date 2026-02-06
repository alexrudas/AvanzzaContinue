import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/provider/services/home/provider_services_home_controller.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../widgets/error_state.dart';
import '../../../../widgets/loading_state.dart';

class ProviderServicesHomePage extends StatelessWidget {
  const ProviderServicesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProviderServicesHomeController());
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null) {
        return ErrorState(message: controller.error.value!);
      }
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Dashboard Proveedor de Servicios'),
          SizedBox(height: 12),
          EmptyState(title: 'KPIs próximos', subtitle: 'Próximamente...'),
        ],
      );
    });
  }
}
