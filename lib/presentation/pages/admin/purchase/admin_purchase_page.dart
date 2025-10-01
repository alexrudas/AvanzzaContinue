import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_state.dart';
import '../../../widgets/loading_state.dart';
import '../../../controllers/admin/purchase/admin_purchase_controller.dart';

class AdminPurchasePage extends GetView<AdminPurchaseController> {
  const AdminPurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null) return ErrorState(message: controller.error.value!);
      if (!controller.hasActiveOrg) return const EmptyState(title: 'Selecciona tu organización');

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Solicitudes abiertas', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (controller.requestTiles.isNotEmpty) ...controller.requestTiles else const EmptyState(title: 'Sin solicitudes'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: controller.createRequest,
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Nueva solicitud'),
          ),
        ],
      );
    });
  }
}
