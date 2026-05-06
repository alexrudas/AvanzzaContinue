import '../entities/asset/asset_entity.dart';
import '../entities/asset/asset_document_entity.dart';
import '../entities/asset/special/asset_vehiculo_entity.dart';
import '../entities/asset/special/asset_inmueble_entity.dart';
import '../entities/asset/special/asset_maquinaria_entity.dart';
import '../value/purchase/vehicle_spec.dart';
import '../value/registration/asset_runt_snapshot.dart';

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

  // NUEVO: Portfolio integration
  /// Crear activo desde RUNT y vincularlo a un portafolio
  /// - Incrementa assetsCount del portafolio (transición DRAFT → ACTIVE si es el primero)
  /// - Retorna el asset creado
  Future<AssetEntity> createAssetFromRuntAndLinkToPortfolio({
    required String portfolioId,
    required String orgId,
    required String plate,
    required String marca,
    required String modelo,
    required int anio,
    required String countryId,
    required String cityId,
    required String createdBy,
    AssetRuntSnapshot runtSnapshot = AssetRuntSnapshot.empty,
  });

  /// Obtener activos de un portafolio (consulta puntual).
  Future<List<AssetEntity>> getAssetsByPortfolio(String portfolioId);

  /// Stream reactivo de activos de un portafolio.
  ///
  /// Emite inmediatamente y se actualiza automáticamente ante cualquier
  /// cambio (inserción, actualización, borrado) en Isar para ese portfolioId.
  Stream<List<AssetEntity>> watchAssetsByPortfolio(String portfolioId);

  /// Deriva la lista de [VehicleSpec] a partir del parque vehicular real del
  /// workspace.
  ///
  /// Contrato:
  /// - Lee vehículos tipo `vehicle` del orgId y su especialización
  ///   ([AssetVehiculoEntity]) para obtener marca/modelo/año reales.
  /// - Agrupa con normalización y devuelve la lista canónica ordenada.
  /// - Offline-first: usa la cache Isar ya disponible. No llama a red aquí.
  /// - Uso previsto: selector de inventario/stock en Purchase Request. El
  ///   caller invoca este método UNA vez al abrir el selector; no se pretende
  ///   que recalcule por frame.
  Future<List<VehicleSpec>> fetchVehicleSpecsByOrg(String orgId);
}
