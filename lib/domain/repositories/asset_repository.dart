import '../entities/asset/asset_entity.dart';
import '../entities/asset/asset_document_entity.dart';
import '../entities/asset/special/asset_vehiculo_entity.dart';
import '../entities/asset/special/asset_inmueble_entity.dart';
import '../entities/asset/special/asset_maquinaria_entity.dart';

abstract class AssetRepository {
  // Assets root
  Stream<List<AssetEntity>> watchAssetsByOrg(String orgId,
      {String? assetType, String? cityId});
  Future<List<AssetEntity>> fetchAssetsByOrg(String orgId,
      {String? assetType, String? cityId});
  Stream<AssetEntity?> watchAsset(String assetId);
  Future<AssetEntity?> getAsset(String assetId);
  Future<void> upsertAsset(AssetEntity asset);

  // Details/specializations
  Future<
      ({
        AssetVehiculoEntity? vehiculo,
        AssetInmuebleEntity? inmueble,
        AssetMaquinariaEntity? maquinaria
      })> getAssetDetails(String assetId);
  Future<void> upsertVehiculo(AssetVehiculoEntity vehiculo);
  Future<void> upsertInmueble(AssetInmuebleEntity inmueble);
  Future<void> upsertMaquinaria(AssetMaquinariaEntity maquinaria);

  // Documents
  Stream<List<AssetDocumentEntity>> watchAssetDocuments(String assetId,
      {String? countryId, String? cityId});
  Future<List<AssetDocumentEntity>> fetchAssetDocuments(String assetId,
      {String? countryId, String? cityId});
  Future<void> upsertAssetDocument(AssetDocumentEntity document);
}
