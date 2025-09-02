import 'package:get/get.dart';

import '../controllers/org_selection_controller.dart';

class OrgSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrgSelectionController());
  }
}
