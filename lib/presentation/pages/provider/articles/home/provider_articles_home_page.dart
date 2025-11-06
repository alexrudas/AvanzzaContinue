import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/provider/articles/home/provider_articles_home_controller.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../widgets/error_state.dart';
import '../../../../widgets/loading_state.dart';

class ProviderArticlesHomePage extends StatelessWidget {
  const ProviderArticlesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProviderArticlesHomeController());

    // solo el contenido; el Scaffold superior mantiene el BottomNavigationBar
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Obx(() {
          if (controller.loading.value) return const LoadingState();
          final err = controller.error.value;
          if (err != null) return ErrorState(message: err);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              Text('Home Proveedor de Artículos'),
              SizedBox(height: 12),
              EmptyState(
                  title: 'Resumen de tienda', subtitle: 'Próximamente...'),
            ],
          );
        }),
      ),
    );
  }
}
