import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/loading_state.dart';
import '../../../../widgets/error_state.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../controllers/provider/articles/home/provider_articles_home_controller.dart';

class ProviderArticlesHomePage extends GetView<ProviderArticlesHomeController> {
  const ProviderArticlesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null) return ErrorState(message: controller.error.value!);
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Home Proveedor de Artículos'),
          SizedBox(height: 12),
          EmptyState(title: 'Resumen de tienda', subtitle: 'Próximamente...'),
        ],
      );
    });
  }
}
