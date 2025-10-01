import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_state.dart';
import '../../../widgets/loading_state.dart';
import '../../../controllers/admin/accounting/admin_accounting_controller.dart';

class AdminAccountingPage extends GetView<AdminAccountingController> {
  const AdminAccountingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null) return ErrorState(message: controller.error.value!);
      if (!controller.hasActiveOrg) return const EmptyState(title: 'Selecciona tu organización');

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Resumen mensual', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Ingresos: ${controller.totalIngresos.toStringAsFixed(2)}'),
          Text('Egresos: ${controller.totalEgresos.toStringAsFixed(2)}'),
          Text('Neto: ${controller.neto.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          Text('Asientos del mes', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (controller.entryTiles.isNotEmpty) ...controller.entryTiles else const EmptyState(title: 'Sin asientos'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: controller.quickAddEntry,
            icon: const Icon(Icons.add),
            label: const Text('Agregar ingreso/egreso'),
          ),
        ],
      );
    });
  }
}
