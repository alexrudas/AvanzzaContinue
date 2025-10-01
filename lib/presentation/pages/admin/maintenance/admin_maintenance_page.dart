import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_state.dart';
import '../../../widgets/loading_state.dart';
import '../../../controllers/admin/maintenance/admin_maintenance_controller.dart';

class AdminMaintenancePage extends GetView<AdminMaintenanceController> {
  const AdminMaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null) return ErrorState(message: controller.error.value!);
      if (!controller.hasActiveOrg) {
        return const EmptyState(title: 'Selecciona tu organización');
      }

      return Column(
        children: [
          TabBar(
            controller: controller.tabController,
            tabs: const [
              Tab(text: 'Incidencias'),
              Tab(text: 'Programación'),
              Tab(text: 'En Proceso'),
              Tab(text: 'Finalizados'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: controller.tabViews,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: controller.createIncidentOrSchedule,
              icon: const Icon(Icons.add),
              label: const Text('Crear incidencia / Programar'),
            ),
          ),
        ],
      );
    });
  }
}
