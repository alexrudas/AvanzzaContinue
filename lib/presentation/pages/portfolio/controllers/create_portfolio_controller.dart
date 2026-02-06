import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../core/di/container.dart';
import '../../../../domain/entities/portfolio/portfolio_entity.dart';
import '../../../../domain/repositories/portfolio_repository.dart';
import '../../../../domain/shared/enums/asset_type.dart';

/// Controller para el wizard de creación de portafolio
/// Gestiona la lógica de negocio y coordina con el repositorio
///
/// IMPORTANTE: Este controller es compartido entre Step1 y Step2.
/// Step1 usa Get.put(), Step2 usa Get.find().
class CreatePortfolioController extends GetxController {
  late final PortfolioRepository _portfolioRepository;

  final isLoading = false.obs;
  String? portfolioId; // ID del portafolio creado en Step 1

  /// Tipo de activo seleccionado (persiste entre steps)
  /// Se setea en Step1 desde preselectedAssetType
  final Rxn<AssetType> selectedAssetType = Rxn<AssetType>();

  /// Getter sync para verificar si es vehículo
  bool get isVehiculo => selectedAssetType.value == AssetType.vehiculo;

  @override
  void onInit() {
    super.onInit();
    _portfolioRepository = DIContainer().portfolioRepository;
  }

  /// Paso 1: Crear portafolio DRAFT
  /// - Crea PortfolioEntity con status=DRAFT, assetsCount=0
  /// - Persiste en repo (repo genera el ID)
  /// - Guarda portfolioId para Step 2
  Future<void> createPortfolioStep1({
    required PortfolioType portfolioType,
    required String portfolioName,
    required String countryId,
    required String cityId,
  }) async {
    try {
      isLoading.value = true;

      // TODO: Obtener currentUserId del contexto de sesión (AuthService/SessionContext)
      const currentUserId = 'mock-user-id';

      // Crear entidad sin ID (el repo lo genera)
      final portfolioData = PortfolioEntity(
        id: '', // Placeholder - El repo genera el ID real
        portfolioType: portfolioType,
        portfolioName: portfolioName,
        countryId: countryId,
        cityId: cityId,
        status: PortfolioStatus.draft,
        assetsCount: 0,
        createdBy: currentUserId,
        createdAt: DateTime.now().toUtc(),
      );

      // Crear portfolio DRAFT en Isar
      final created = await _portfolioRepository.createPortfolio(portfolioData);
      portfolioId = created.id;

      debugPrint('[CreatePortfolioController] Portfolio DRAFT created: $portfolioId');
    } catch (e) {
      debugPrint('[CreatePortfolioController] Error creating portfolio: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Paso 2: Vincular primer activo al portafolio
  /// - AssetRepository crea el activo y lo vincula al portfolioId
  /// - PortfolioRepository incrementa assetsCount (DRAFT → ACTIVE)
  Future<void> linkFirstAssetToPortfolio({
    required String plate,
    required String marca,
    required String modelo,
    required int anio,
    required String countryId,
    required String cityId,
  }) async {
    if (portfolioId == null) {
      throw Exception('No portfolio ID. Complete Step 1 first.');
    }

    try {
      isLoading.value = true;

      // TODO: Usar AssetRepository.createAssetFromRuntAndLinkToPortfolio
      // El repo se encarga de:
      // 1. Crear AssetEntity con portfolioId
      // 2. Crear AssetVehiculoEntity
      // 3. Incrementar assetsCount del portfolio (DRAFT → ACTIVE)

      throw UnimplementedError(
        'AssetRepository.createAssetFromRuntAndLinkToPortfolio() not implemented yet',
      );

      // debugPrint('[CreatePortfolioController] Asset linked to portfolio: $portfolioId');
    } catch (e) {
      debugPrint('[CreatePortfolioController] Error linking asset: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
