// ============================================================================
// lib/presentation/controllers/alerts/fleet_alert_controller.dart
// FLEET ALERT CONTROLLER — Lista de alertas agrupadas por vehículo (Nivel 1)
//
// QUÉ HACE:
// - Carga TODAS las alertas de la org activa (sin filtro de promoción) vía
//   HomeAlertAggregationService.allAlertsForOrg().
// - Agrupa las alertas por activo usando FleetAlertGrouper.
// - Expone [groups] (List<FleetAlertGroupVm>) para FleetAlertListPage.
// - Implementa cache TTL de 5 minutos para evitar re-fetch innecesario al
//   navegar entre niveles 1 → 2 → 3 → back.
// - Expone [invalidateCache()] para que pantallas de detalle de documentos
//   (SOAT, RTM, RC, Legal) puedan forzar recarga al volver al Nivel 1.
// - Expone [refreshGroups()] para pull-to-refresh manual.
//
// QUÉ NO HACE:
// - NO filtra con reglas de negocio — recibe lista completa del pipeline.
// - NO evalúa alertas — recibe la lista del pipeline canónico.
// - NO importa data layer directamente.
// - NO resuelve navegación ni copy visual (eso vive en FleetAlertGrouper/UI).
//
// PRINCIPIOS:
// - Constructor injection / acceso vía DIContainer — registrado en FleetAlertBinding.
// - Una sola carga por sesión de navegación (cache TTL).
//   fenix: true en el binding → el controller sobrevive pops a Niveles 2 y 3.
// - Fallo tolerante: ante error del pipeline la pantalla no colapsa.
// - Observabilidad defensiva en debug: traza de condiciones de salida temprana.
//
// CONTRATO DE INVALIDACIÓN:
// Al hacer pop desde pantallas que modifiquen documentos (SoatDetailPage,
// AssetRtmDetailPage, SegurosRcDetailPage, LegalStatusPage), llamar:
//   if (Get.isRegistered<FleetAlertController>()) {
//     Get.find<FleetAlertController>().invalidateCache();
//   }
// Esto fuerza recarga en el próximo loadGroups() sin interrumpir la sesión.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Fase 6 UX — Rediseño flujo de alertas por vehículo.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../alerts/groupers/fleet_alert_grouper.dart';
import '../../alerts/mappers/domain_alert_mapper.dart';
import '../../alerts/viewmodels/fleet_alert_group_vm.dart';
import '../session_context_controller.dart';

class FleetAlertController extends GetxController {
  // ── Estado observable ──────────────────────────────────────────────────────

  /// Grupos de alertas por activo, listos para FleetAlertListPage.
  ///
  /// 1 elemento por activo. Ordenados por riskLevel DESC (HIGH primero).
  final groups = <FleetAlertGroupVm>[].obs;

  /// Flag de carga para spinner / pull-to-refresh.
  final isLoading = false.obs;

  // ── Cache ──────────────────────────────────────────────────────────────────

  DateTime? _lastLoadedAt;
  String? _lastLoadedOrgId;

  /// TTL del cache en memoria. Pasado este tiempo, la próxima llamada a
  /// [loadGroups] recarga aunque la org no haya cambiado.
  static const _cacheTtl = Duration(minutes: 5);

  // ── Dependencias ───────────────────────────────────────────────────────────

  SessionContextController get _sessionContext =>
      Get.find<SessionContextController>();

  // ── Ciclo de vida ──────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    loadGroups();
  }

  // ── API pública ────────────────────────────────────────────────────────────

  /// Recarga manual de grupos (pull-to-refresh).
  ///
  /// Invalida el cache antes de recargar.
  Future<void> refreshGroups() async {
    _lastLoadedAt = null;
    await loadGroups();
  }

  /// Invalida el cache sin recargar datos.
  ///
  /// Llamar desde pantallas de detalle de documentos (SOAT, RTM, RC, Legal)
  /// antes de hacer pop, para que [loadGroups] recargue en el próximo acceso
  /// al Nivel 1. No dispara ninguna llamada de red.
  ///
  /// Patrón de uso:
  /// ```dart
  /// if (Get.isRegistered<FleetAlertController>()) {
  ///   Get.find<FleetAlertController>().invalidateCache();
  /// }
  /// ```
  void invalidateCache() => _lastLoadedAt = null;

  // ── Pipeline ───────────────────────────────────────────────────────────────

  /// Carga y agrupa todas las alertas de la organización activa.
  ///
  /// Cache hit: misma org + dentro del TTL + lista no vacía → no re-fetch.
  /// Cache miss o lista vacía → ejecuta el pipeline completo.
  Future<void> loadGroups() async {
    final orgId = _sessionContext.user?.activeContext?.orgId;

    if (orgId == null || orgId.trim().isEmpty) {
      groups.clear();

      assert(() {
        debugPrint(
          '[FleetAlert] loadGroups skipped: no active org context available.',
        );
        return true;
      }());

      return;
    }

    // Cache hit: misma org + dentro del TTL + lista no vacía
    if (_lastLoadedOrgId == orgId &&
        _lastLoadedAt != null &&
        DateTime.now().difference(_lastLoadedAt!) < _cacheTtl &&
        groups.isNotEmpty) {
      assert(() {
        debugPrint(
          '[FleetAlert] loadGroups cache hit: orgId=$orgId, '
          'groups=${groups.length}',
        );
        return true;
      }());
      return;
    }

    isLoading.value = true;

    try {
      final domainAlerts = await DIContainer()
          .homeAlertAggregationService
          .allAlertsForOrg(orgId);

      final viewModels = DomainAlertMapper.fromDomainList(domainAlerts);
      final grouped = FleetAlertGrouper.group(viewModels);

      groups.assignAll(grouped);
      _lastLoadedAt = DateTime.now();
      _lastLoadedOrgId = orgId;

      assert(() {
        debugPrint(
          '[FleetAlert] loadGroups ok: orgId=$orgId, '
          'domainAlerts=${domainAlerts.length}, '
          'groups=${grouped.length}',
        );
        return true;
      }());
    } catch (e, st) {
      groups.clear();

      assert(() {
        debugPrint('[FleetAlert] loadGroups failed: $e');
        debugPrint('$st');
        return true;
      }());
    } finally {
      isLoading.value = false;
    }
  }
}
