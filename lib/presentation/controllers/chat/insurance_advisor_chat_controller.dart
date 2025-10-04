import 'base_chat_controller.dart';

class InsuranceAdvisorChatController extends BaseChatController {
  @override
  List<String> get acceptedRoleKeys => const ['asesor', 'asesor_seguros'];
}
