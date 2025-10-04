import 'package:get/get.dart';

import '../../controllers/accounting/base_accounting_controller.dart';
import '../../controllers/chat/owner_chat_controller.dart';
import '../../controllers/owner/accounting/owner_accounting_controller.dart';
import '../../controllers/owner/contracts/owner_contracts_controller.dart';
import '../../controllers/owner/home/owner_home_controller.dart';
import '../../controllers/owner/portfolio/owner_portfolio_controller.dart';

class OwnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OwnerHomeController(), fenix: true);
    Get.lazyPut(() => OwnerPortfolioController(), fenix: true);
    Get.lazyPut(() => OwnerContractsController(), fenix: true);
    Get.lazyPut<BaseAccountingController>(() => OwnerAccountingController(),
        fenix: true);
    Get.lazyPut(() => OwnerChatController(), fenix: true);
  }
}
