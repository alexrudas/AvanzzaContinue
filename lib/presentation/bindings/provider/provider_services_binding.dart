import 'package:get/get.dart';

import '../../controllers/accounting/base_accounting_controller.dart';
import '../../controllers/chat/provider_services_chat_controller.dart';
import '../../controllers/provider/services/accounting/provider_services_accounting_controller.dart';
import '../../controllers/provider/services/agenda/provider_services_agenda_controller.dart';
import '../../controllers/provider/services/home/provider_services_home_controller.dart';
import '../../controllers/provider/services/orders/provider_services_orders_controller.dart';

class ProviderServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProviderServicesHomeController(), fenix: true);
    Get.lazyPut(() => ProviderServicesAgendaController(), fenix: true);
    Get.lazyPut(() => ProviderServicesOrdersController(), fenix: true);
    Get.lazyPut<BaseAccountingController>(
        () => ProviderServicesAccountingController(),
        fenix: true);
    Get.lazyPut(() => ProviderServicesChatController(), fenix: true);
  }
}
