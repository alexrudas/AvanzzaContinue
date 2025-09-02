import 'package:get/get.dart';

import '../controllers/asset_list_controller.dart';

class AssetListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AssetListController());
  }
}
