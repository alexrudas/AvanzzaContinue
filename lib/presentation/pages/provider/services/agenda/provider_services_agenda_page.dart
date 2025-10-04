import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/loading_state.dart';
import '../../../../widgets/error_state.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../controllers/provider/services/agenda/provider_services_agenda_controller.dart';

class ProviderServicesAgendaPage extends GetView<ProviderServicesAgendaController> {
  const ProviderServicesAgendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null) return ErrorState(message: controller.error.value!);
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Agenda (Servicios)'),
          SizedBox(height: 12),
          EmptyState(title: 'Sin eventos programados'),
        ],
      );
    });
  }
}
