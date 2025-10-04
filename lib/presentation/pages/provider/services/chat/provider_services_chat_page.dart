import 'package:avanzza/presentation/widgets/empty_state.dart';
import 'package:avanzza/presentation/widgets/error_state.dart';
import 'package:avanzza/presentation/widgets/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/chat/provider_services_chat_controller.dart';


class ProviderServicesChatPage extends GetView<ProviderServicesChatController> {
  const ProviderServicesChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ProviderServicesChatController(), permanent: false);
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null) return ErrorState(message: controller.error.value!);
      return controller.conversationTiles.isEmpty
          ? const EmptyState(title: 'Sin conversaciones')
          : ListView(children: controller.conversationTiles);
    });
  }
}
