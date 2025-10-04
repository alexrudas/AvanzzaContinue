import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/error_state.dart';
import '../../controllers/accounting/base_accounting_controller.dart';

class AccountingPage extends GetView<BaseAccountingController> {
  const AccountingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null) return ErrorState(message: controller.error.value!);
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(controller.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Ingresos: ${controller.totalIngresos.toStringAsFixed(2)}'),
          Text('Egresos: ${controller.totalEgresos.toStringAsFixed(2)}'),
          Text('Neto: ${controller.neto.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          if (controller.entriesTiles.isNotEmpty)
            ...controller.entriesTiles
          else
            const Text('Sin movimientos'),
        ],
      );
    });
  }
}
