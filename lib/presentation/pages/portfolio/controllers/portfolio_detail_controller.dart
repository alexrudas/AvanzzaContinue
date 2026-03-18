// ============================================================================
// lib/presentation/pages/portfolio/controllers/portfolio_detail_controller.dart
// PORTFOLIO DETAIL CONTROLLER — Enterprise Ultra Pro
//
// QUÉ HACE:
// - Gestiona el estado de la página de detalle de un portafolio existente.
// - Recibe el PortfolioEntity completo como argumento de navegación.
// - Expone el portafolio como observable reactivo para que la UI refleje
//   actualizaciones locales sin necesidad de recargar desde Isar.
// - updatePortfolioName(): persiste el nuevo nombre vía PortfolioRepository
//   (upsert local en Isar). El stream watchActivePortfoliosByOrg del
//   AdminHomeController se actualiza automáticamente.
// - goToRegisterAsset(): pre-registra CreatePortfolioController con el
//   portfolioId del portafolio actual y navega directamente a Step2,
//   saltando Step1 (que crea un nuevo portafolio). Step2 usa
//   Get.find<CreatePortfolioController>() y operará sobre el portfolio
//   ya existente.
//
// QUÉ NO HACE:
// - No crea portafolios nuevos.
// - No toca Isar directamente (delega a PortfolioRepository).
// - No hace polling ni stream de activos (eso es PortfolioAssetListPage).
//
// PRINCIPIOS:
// - Recibe PortfolioEntity por argumento (Get.arguments) para evitar
//   una consulta redundante en onInit.
// - DIContainer como fuente de repositorios (no Get.find<Repository>()).
//
// ENTERPRISE NOTES:
// - Si portfolioEntity llega null (argumento inválido), la página debe
//   mostrar un error y llamar Get.back(). El controller solo expone la
//   entidad; el guard de argumento vive en el builder de app_pages.dart.
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../core/di/container.dart';
import '../../../../domain/entities/portfolio/portfolio_entity.dart';
import '../../../../domain/repositories/portfolio_repository.dart';
import '../../../../domain/shared/enums/asset_type.dart';
import '../../../../domain/value/registration/asset_registration_context.dart';
import '../../../../routes/app_pages.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class PortfolioDetailController extends GetxController {
  late final PortfolioRepository _portfolioRepository;

  /// Portafolio activo. Se inicializa desde Get.arguments en onInit.
  /// Null indica argumento inválido; la UI muestra error + back.
  final portfolio = Rxn<PortfolioEntity>();

  /// Estado de carga durante operaciones de escritura (rename).
  final isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    _portfolioRepository = DIContainer().portfolioRepository;

    // Recibir entidad de navegación
    final arg = Get.arguments;
    if (arg is PortfolioEntity) {
      portfolio.value = arg;
    } else {
      if (kDebugMode) {
        debugPrint(
          '[P2D][PortfolioDetail] ERROR: argumento inválido. '
          'Esperado PortfolioEntity, recibido ${arg.runtimeType}',
        );
      }
      // portfolio.value queda null → la UI muestra error + back
    }
  }

  // ---------------------------------------------------------------------------
  // Operación: Renombrar portafolio
  // ---------------------------------------------------------------------------

  /// Persiste el nuevo nombre del portafolio.
  ///
  /// No hace nada si [newName] está vacío o es idéntico al nombre actual.
  /// Actualiza [portfolio] localmente de inmediato (optimistic update) y
  /// escribe en Isar para que el stream de Home se refresque.
  Future<void> updatePortfolioName(String newName) async {
    final trimmed = newName.trim();
    final current = portfolio.value;
    if (current == null) return;
    if (trimmed.isEmpty || trimmed == current.portfolioName) return;

    try {
      isUpdating.value = true;

      final updated = current.copyWith(
        portfolioName: trimmed,
        updatedAt: DateTime.now().toUtc(),
      );

      // Optimistic update: la UI refleja el cambio antes de la confirmación.
      portfolio.value = updated;

      // Persistencia en Isar — el stream del AdminHomeController se actualiza
      // automáticamente vía watchActivePortfoliosByOrg.
      await _portfolioRepository.updatePortfolio(updated);

      if (kDebugMode) {
        debugPrint(
          '[P2D][PortfolioDetail] renamed: "${current.portfolioName}" '
          '→ "${trimmed}" (id=${current.id})',
        );
      }
    } catch (e) {
      // Revertir optimistic update en caso de error
      portfolio.value = current;
      if (kDebugMode) debugPrint('[P2D][PortfolioDetail] rename error: $e');
      Get.snackbar(
        'Error',
        'No se pudo actualizar el nombre. Intenta de nuevo.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Navegación: registrar activo en este portafolio
  // ---------------------------------------------------------------------------

  /// Navega a [Routes.assetRegister] con un [AssetRegistrationContext] construido
  /// desde los primitivos del portafolio actual.
  ///
  /// Cada llamada genera un [registrationSessionId] fresco (Uuid().v4()) para
  /// garantizar que el subsistema RUNT no reutilice el job de un registro anterior.
  void goToRegisterAsset() {
    final p = portfolio.value;
    if (p == null) return;

    final ctx = AssetRegistrationContext(
      portfolioId:           p.id,
      portfolioName:         p.portfolioName,
      countryId:             p.countryId,
      cityId:                p.cityId,
      assetType:             AssetRegistrationType.vehiculo,
      registrationSessionId: const Uuid().v4(),
    );

    if (kDebugMode) {
      debugPrint(
        '[P2D][PortfolioDetail] goToRegisterAsset: '
        'portfolioId=${p.id} sessionId=${ctx.registrationSessionId}',
      );
    }

    Get.toNamed(Routes.assetRegister, arguments: ctx);
  }
}
