import '../../../accounting/base_accounting_controller.dart';

class ProviderServicesAccountingController extends BaseAccountingController {
  @override
  String? get providerTypeFilter => 'servicios';
  @override
  String get title => 'Contabilidad (Servicios)';
}
