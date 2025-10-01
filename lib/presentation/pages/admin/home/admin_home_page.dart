import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../controllers/admin/home/admin_home_controller.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_state.dart';
import '../../../widgets/loading_state.dart';

class AdminHomePage extends GetView<AdminHomeController> {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null)
        return ErrorState(message: controller.error.value!);

      if (!controller.hasActiveOrg) {
        return EmptyState(
          title: 'Selecciona tu organización',
          subtitle: 'Necesitas un contexto activo para ver datos.',
          onAction: () => Get.toNamed(Routes.orgSelect),
          actionLabel: 'Elegir organización',
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('KPIs', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(spacing: 12, runSpacing: 12, children: controller.kpiChips),
            const SizedBox(height: 24),
            Text('Últimos eventos',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (controller.eventTiles.isNotEmpty)
              ...controller.eventTiles
            else
              const EmptyState(title: 'Sin eventos'),
            const SizedBox(height: 24),
            Text('Acciones rápidas',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(spacing: 12, children: controller.quickActionButtons(context)),
          ],
        ),
      );
    });
  }
}
