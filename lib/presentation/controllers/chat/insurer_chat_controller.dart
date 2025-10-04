import 'base_chat_controller.dart';

class InsurerChatController extends BaseChatController {
  @override
  List<String> get acceptedRoleKeys => const ['aseguradora', 'broker'];
}
