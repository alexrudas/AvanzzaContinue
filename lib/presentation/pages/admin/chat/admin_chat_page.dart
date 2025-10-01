import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/error_state.dart';
import '../../../widgets/loading_state.dart';
import '../../../controllers/admin/chat/admin_chat_controller.dart';

class AdminChatPage extends GetView<AdminChatController> {
  const AdminChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.loading.value) return const LoadingState();
      if (controller.error.value != null) return ErrorState(message: controller.error.value!);
      if (!controller.hasActiveOrg) return const EmptyState(title: 'Selecciona tu organización');

      return Column(
        children: [
          Expanded(
            child: controller.conversationTiles.isNotEmpty
                ? ListView(children: controller.conversationTiles)
                : const EmptyState(title: 'Sin conversaciones'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: controller.broadcastMessage,
                    icon: const Icon(Icons.campaign),
                    label: const Text('Broadcast'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.newDirectMessage,
                    icon: const Icon(Icons.send),
                    label: const Text('Mensaje directo'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
