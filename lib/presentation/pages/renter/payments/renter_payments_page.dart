import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/loading_state.dart';
import '../../../widgets/error_state.dart';
import '../../../widgets/empty_state.dart';
import '../../../controllers/renter/payments/renter_payments_controller.dart';

class RenterPaymentsPage extends GetView<RenterPaymentsController> {
  const RenterPaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null) return ErrorState(message: controller.error.value!);
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Pagos'),
          SizedBox(height: 12),
          EmptyState(title: 'Sin pagos'),
        ],
      );
    });
  }
}
