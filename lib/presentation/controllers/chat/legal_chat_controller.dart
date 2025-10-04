import 'base_chat_controller.dart';

class LegalChatController extends BaseChatController {
  @override
  List<String> get acceptedRoleKeys => const ['abog', 'legal'];
}
