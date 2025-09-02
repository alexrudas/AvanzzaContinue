import 'package:get/get.dart';

import '../controllers/incidencia_controller.dart';

class IncidenciaBinding extends Bindings {
  final String assetId;
  IncidenciaBinding(this.assetId);

  @override
  void dependencies() {
    Get.put(IncidenciaController(assetId));
  }
}
