import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/renter/asset/renter_asset_controller.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_state.dart';
import '../../../widgets/loading_state.dart';

class RenterAssetPage extends GetView<RenterAssetController> {
  const RenterAssetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null)
        return ErrorState(message: controller.error.value!);
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Activo asignado'),
          SizedBox(height: 12),
          EmptyState(title: 'Sin activo vinculado'),
        ],
      );
    });
  }
}
