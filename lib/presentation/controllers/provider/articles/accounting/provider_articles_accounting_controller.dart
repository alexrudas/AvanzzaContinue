import '../../../accounting/base_accounting_controller.dart';

class ProviderArticlesAccountingController extends BaseAccountingController {
  @override
  String? get providerTypeFilter => 'articulos';
  @override
  String get title => 'Contabilidad (Artículos)';
}
