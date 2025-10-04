import 'package:avanzza/presentation/widgets/empty_state.dart';
import 'package:avanzza/presentation/widgets/error_state.dart';
import 'package:avanzza/presentation/widgets/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/chat/provider_articles_chat_controller.dart';


class ProviderArticlesChatPage extends GetView<ProviderArticlesChatController> {
  const ProviderArticlesChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ProviderArticlesChatController(), permanent: false);
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null) return ErrorState(message: controller.error.value!);
      return controller.conversationTiles.isEmpty
          ? const EmptyState(title: 'Sin conversaciones')
          : ListView(children: controller.conversationTiles);
    });
  }
}
