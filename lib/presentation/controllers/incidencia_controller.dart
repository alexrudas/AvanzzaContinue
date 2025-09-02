import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../domain/entities/maintenance/incidencia_entity.dart';

class IncidenciaController extends GetxController {
  final String assetId;
  IncidenciaController(this.assetId);

  final _items = <IncidenciaEntity>[].obs;
  List<IncidenciaEntity> get items => _items;

  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    di.maintenanceRepository.watchIncidencias('org_mock', assetId: assetId).listen((list) {
      _items.assignAll(list);
    });
  }

  Future<void> createIncidencia(String descripcion) async {
    final di = DIContainer();
    final entity = IncidenciaEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orgId: 'org_mock',
      assetId: assetId,
      descripcion: descripcion,
      fotosUrls: const [],
      prioridad: 'media',
      estado: 'abierta',
      reportedBy: 'user_mock',
      cityId: null,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
    await di.maintenanceRepository.upsertIncidencia(entity);
  }
}
