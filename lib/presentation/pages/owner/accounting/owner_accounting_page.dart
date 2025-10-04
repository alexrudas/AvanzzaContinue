import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/loading_state.dart';
import '../../../widgets/error_state.dart';
import '../../../widgets/empty_state.dart';
import '../../../controllers/owner/accounting/owner_accounting_controller.dart';

class OwnerAccountingPage extends GetView<OwnerAccountingController> {
  const OwnerAccountingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null) return ErrorState(message: controller.error.value!);
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Contabilidad (Propietario)'),
          SizedBox(height: 12),
          EmptyState(title: 'Sin movimientos del mes'),
        ],
      );
    });
  }
}
