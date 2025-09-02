import 'package:isar_community/isar.dart';

import '../../models/asset/asset_document_model.dart';
import '../../models/asset/asset_model.dart';
import '../../models/asset/special/asset_inmueble_model.dart';
import '../../models/asset/special/asset_maquinaria_model.dart';
import '../../models/asset/special/asset_vehiculo_model.dart';

class AssetLocalDataSource {
  final Isar isar;
  AssetLocalDataSource(this.isar);

  Future<List<AssetModel>> listAssetsByOrg(String orgId,
      {String? assetType, String? cityId}) async {
    final q = isar.assetModels
        .filter()
        .orgIdEqualTo(orgId)
        .optional(assetType != null, (q) => q.assetTypeEqualTo(assetType!))
        .optional(cityId != null, (q) => q.cityIdEqualTo(cityId!));
    return q.findAll();
  }

  Future<AssetModel?> getAsset(String id) async {
    return isar.assetModels.filter().idEqualTo(id).findFirst();
  }

  Future<void> upsertAsset(AssetModel m) async {
    await isar.writeTxn(() async => isar.assetModels.put(m));
  }

  Future<void> deleteAssetById(String id) async {
    final item = await getAsset(id);
    if (item != null) {
      await isar.writeTxn(() async => isar.assetModels.delete(item.isarId!));
    }
  }

  // Specializations
  Future<AssetVehiculoModel?> getVehiculo(String assetId) async =>
      isar.assetVehiculoModels.filter().assetIdEqualTo(assetId).findFirst();
  Future<void> upsertVehiculo(AssetVehiculoModel m) async =>
      isar.writeTxn(() async => isar.assetVehiculoModels.put(m));

  Future<AssetInmuebleModel?> getInmueble(String assetId) async =>
      isar.assetInmuebleModels.filter().assetIdEqualTo(assetId).findFirst();
  Future<void> upsertInmueble(AssetInmuebleModel m) async =>
      isar.writeTxn(() async => isar.assetInmuebleModels.put(m));

  Future<AssetMaquinariaModel?> getMaquinaria(String assetId) async =>
      isar.assetMaquinariaModels.filter().assetIdEqualTo(assetId).findFirst();
  Future<void> upsertMaquinaria(AssetMaquinariaModel m) async =>
      isar.writeTxn(() async => isar.assetMaquinariaModels.put(m));

  // Documents
  Future<List<AssetDocumentModel>> listDocuments(String assetId,
      {String? countryId, String? cityId}) async {
    final q = isar.assetDocumentModels
        .filter()
        .assetIdEqualTo(assetId)
        .optional(countryId != null, (q) => q.countryIdEqualTo(countryId!))
        .optional(cityId != null, (q) => q.cityIdEqualTo(cityId!));
    return q.findAll();
  }

  Future<void> upsertDocument(AssetDocumentModel m) async =>
      isar.writeTxn(() async => isar.assetDocumentModels.put(m));
}
