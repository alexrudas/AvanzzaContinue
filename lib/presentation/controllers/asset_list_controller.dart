import 'package:get/get.dart';

import '../../core/di/container.dart';
import '../../domain/entities/asset/asset_entity.dart';

class AssetListController extends GetxController {
  final _assets = <AssetEntity>[].obs;
  List<AssetEntity> get assets => _assets;

  @override
  void onInit() {
    super.onInit();
    final di = DIContainer();
    // Example: you might store orgId in session; here we just fetch all by a mock org
    di.assetRepository.watchAssetsByOrg('org_mock').listen((list) {
      _assets.assignAll(list);
    });
  }

  Future<void> addAsset(AssetEntity a) async {
    final di = DIContainer();
    await di.assetRepository.upsertAsset(a);
  }

  Future<void> deleteAsset(AssetEntity a) async {
    // Assuming repository provides delete; if not, it's omitted in this scaffold
    // TODO: implement delete in repositories
  }
}
