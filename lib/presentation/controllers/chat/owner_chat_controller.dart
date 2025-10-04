import 'base_chat_controller.dart';

class OwnerChatController extends BaseChatController {
  @override
  List<String> get acceptedRoleKeys => const ['propietario'];
}
