import 'package:get/get.dart';

import '../../controllers/accounting/base_accounting_controller.dart';
import '../../controllers/chat/provider_articles_chat_controller.dart';
import '../../controllers/provider/articles/accounting/provider_articles_accounting_controller.dart';
import '../../controllers/provider/articles/catalog/provider_articles_catalog_controller.dart';
import '../../controllers/provider/articles/home/provider_articles_home_controller.dart';
import '../../controllers/provider/articles/orders/provider_articles_orders_controller.dart';
import '../../controllers/provider/articles/quotes/provider_articles_quotes_controller.dart';

class ProviderArticlesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProviderArticlesHomeController(), fenix: true);
    Get.lazyPut(() => ProviderArticlesCatalogController(), fenix: true);
    Get.lazyPut(() => ProviderArticlesQuotesController(), fenix: true);
    Get.lazyPut(() => ProviderArticlesOrdersController(), fenix: true);
    Get.lazyPut<BaseAccountingController>(
        () => ProviderArticlesAccountingController(),
        fenix: true);
    Get.lazyPut(() => ProviderArticlesChatController(), fenix: true);
  }
}
