import 'base_chat_controller.dart';

class ProviderServicesChatController extends BaseChatController {
  @override
  List<String> get acceptedRoleKeys => const ['proveedor'];
  @override
  String? get providerTypeFilter => 'servicios';
}
