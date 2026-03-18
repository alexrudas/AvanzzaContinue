// ============================================================================
// lib/presentation/bindings/portfolio/portfolio_detail_binding.dart
// PORTFOLIO DETAIL BINDING
//
// QUÉ HACE:
// - Registra PortfolioDetailController en el scope de la ruta
//   Routes.portfolioDetail para que la página pueda encontrarlo con
//   Get.find<PortfolioDetailController>().
//
// QUÉ NO HACE:
// - No gestiona ciclo de vida del controller; GetX lo maneja automáticamente
//   al salir de la ruta (fenix=false por defecto → se destruye al hacer pop).
//
// PRINCIPIOS:
// - Get.lazyPut para instanciación diferida (solo al primer Get.find).
// ============================================================================

import 'package:get/get.dart';

import '../../pages/portfolio/controllers/portfolio_detail_controller.dart';

class PortfolioDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PortfolioDetailController>(
      () => PortfolioDetailController(),
    );
  }
}
