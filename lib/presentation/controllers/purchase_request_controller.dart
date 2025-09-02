import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../domain/entities/purchase/purchase_request_entity.dart';

class PurchaseRequestController extends GetxController {
  final _items = <PurchaseRequestEntity>[].obs;
  List<PurchaseRequestEntity> get items => _items;

  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    di.purchaseRepository.watchRequestsByOrg('org_mock').listen((list) {
      _items.assignAll(list);
    });
  }

  Future<void> createRequest({required String tipoRepuesto, int cantidad = 1}) async {
    final di = DIContainer();
    final e = PurchaseRequestEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orgId: 'org_mock',
      assetId: null,
      tipoRepuesto: tipoRepuesto,
      specs: null,
      cantidad: cantidad,
      ciudadEntrega: 'city_mock',
      proveedorIdsInvitados: const [],
      estado: 'abierta',
      respuestasCount: 0,
      currencyCode: 'USD',
      expectedDate: null,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
    await di.purchaseRepository.upsertRequest(e);
  }
}
