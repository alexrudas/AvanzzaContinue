// ============================================================================
// lib/presentation/controllers/admin/network/network_operational_controller.dart
// NETWORK OPERATIONAL CONTROLLER — GetX Controller
//
// QUÉ HACE:
// - Suscribe al stream de PortfolioEntity (Isar) para la organización activa.
// - Ejecuta [OwnerNetworkVm.fromPortfolios] al recibir datos — solo cuando
//   Isar emite un cambio real, no en cada rebuild de UI.
// - Expone [owners] (RxList), [isLoading], [error] y [filteredOwners]
//   para la vista [NetworkOperationalScreen].
// - Cancela la suscripción en [onClose] — sin fugas de memoria.
//
// QUÉ NO HACE:
// - No accede a Firebase ni red.
// - No contiene lógica de UI (colores, textos, widgets).
// - No conoce SessionContextController — el orgId viene resuelto
//   desde el Binding como String.
// - No implementa actores distintos de Propietarios en Sprint 1.
//
// PRINCIPIOS:
// - orgId recibido como String desde el Binding (Opción A — fijo en contexto).
// - PortfolioRepository inyectado por constructor — testable, sin Get.find.
// - StreamSubscription capturada y cancelada explícitamente en onClose().
// - Error de stream y error de procesamiento manejados por separado.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Sprint 1 módulo "Mi red operativa" — Propietarios.
// ============================================================================

import 'dart:async';

import 'package:get/get.dart';

import '../../../../domain/repositories/portfolio_repository.dart';
import '../../../view_models/network/owner_network_vm.dart';

class NetworkOperationalController extends GetxController {
  // ── Dependencias ──────────────────────────────────────────────────────────
  final PortfolioRepository _portfolioRepository;

  /// orgId de la organización activa. Resuelto en el Binding antes de que
  /// el controller sea instanciado — estable durante toda la sesión.
  final String _orgId;

  NetworkOperationalController(
    this._portfolioRepository,
    this._orgId,
  );

  // ── Estado reactivo ──────────────────────────────────────────────────────

  /// Lista de propietarios deduplicados y agregados.
  /// Actualizada solo cuando Isar emite un cambio.
  final owners = RxList<OwnerNetworkVm>([]);

  /// True mientras el stream aún no emitió su primer evento.
  final isLoading = true.obs;

  /// Mensaje de error si el stream o el procesamiento fallaron.
  /// Null cuando no hay error.
  final error = RxnString();

  /// Texto de búsqueda para filtrar el listado.
  final searchQuery = ''.obs;

  // ── Suscripción al stream ─────────────────────────────────────────────────
  StreamSubscription<dynamic>? _portfolioSubscription;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _subscribeToPortfolios();
  }

  @override
  void onClose() {
    _portfolioSubscription?.cancel();
    _portfolioSubscription = null;
    super.onClose();
  }

  // ── Getters computados ────────────────────────────────────────────────────

  /// Lista de propietarios filtrada por [searchQuery].
  ///
  /// Filtra por nombre (case-insensitive) o documento.
  /// Retorna todos los owners si la búsqueda está vacía.
  List<OwnerNetworkVm> get filteredOwners {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return owners;
    return owners
        .where((o) =>
            o.name.toLowerCase().contains(q) ||
            o.document.toLowerCase().contains(q))
        .toList();
  }

  // ── Privados ──────────────────────────────────────────────────────────────

  /// Inicia la suscripción al stream de portfolios activos de la organización.
  ///
  /// La suscripción se mantiene activa mientras el controller vive.
  /// Se cancela en [onClose] para evitar fugas de memoria.
  void _subscribeToPortfolios() {
    _portfolioSubscription = _portfolioRepository
        .watchActivePortfoliosByOrg(_orgId)
        .listen(
          (portfolios) {
            try {
              owners.value = OwnerNetworkVm.fromPortfolios(portfolios);
              error.value = null;
            } catch (e) {
              // Error de procesamiento (mapper) — los datos llegaron pero
              // la agregación falló. Informar sin romper la app.
              error.value = 'Error procesando datos de propietarios.';
            } finally {
              isLoading.value = false;
            }
          },
          onError: (Object e) {
            // Error de stream (Isar cerrado, migración, etc.)
            error.value = 'Error cargando portafolios.';
            isLoading.value = false;
          },
        );
  }
}
