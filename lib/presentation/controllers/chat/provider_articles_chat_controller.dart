import 'base_chat_controller.dart';

class ProviderArticlesChatController extends BaseChatController {
  @override
  List<String> get acceptedRoleKeys => const ['proveedor'];
  @override
  String? get providerTypeFilter => 'articulos';
}
