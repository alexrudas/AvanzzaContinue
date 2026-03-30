// ============================================================================
// lib/domain/services/alerts/home_alert_aggregation_service.dart
// HOME ALERT AGGREGATION SERVICE — Evalúa y agrega alertas de toda una org
//
// QUÉ HACE:
// - Obtiene todos los activos de la org via AssetRepository.
// - Ejecuta el pipeline canónico en paralelo para cada activo via
//   AssetComplianceAlertOrchestrator.
// - promotedAlertsForOrg(): aplica AlertPromotionService §14.1 — para Home.
// - allAlertsForOrg(): retorna TODAS las alertas sin filtro de promoción —
//   para AlertCenterPage (vista global de la flota).
// - Retorna listas planas de DomainAlert (multi-activo, ordenadas).
//
// QUÉ NO HACE:
// - No mapea a ViewModels — la capa presentation hace ese paso.
// - No importa Flutter, GetX ni presentation helpers.
// - No persiste resultados — on-read, stateless.
// - No agrupa por código en V1 (agrupación multi-activo es Fase 6+).
//
// PRINCIPIOS:
// - Constructor injection: recibe sus dependencias via DI (registrado en DIContainer).
// - Falla silenciosamente por activo: si un activo falla, continúa con los demás.
// - Evaluación paralela: Future.wait sobre todos los activos para minimizar latencia.
// - Sin activos → retorna lista vacía sin llamar al orchestrator.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 4 — Promotion Layer v1. Ver ALERTS_SYSTEM_V4.md §14.2.
// ACTUALIZADO (2026-03): Fase 5.5 — allAlertsForOrg() para AlertCenterPage.
// ============================================================================

import '../../entities/alerts/domain_alert.dart';
import '../../repositories/asset_repository.dart';
import 'alert_promotion_service.dart';
import 'asset_compliance_alert_orchestrator.dart';
import 'support/alert_sort.dart';

/// Evalúa y promueve alertas para todos los activos de una organización.
///
/// Instanciar vía [DIContainer] — no usar directamente en widgets.
class HomeAlertAggregationService {
  final AssetComplianceAlertOrchestrator _orchestrator;
  final AssetRepository _assetRepository;

  const HomeAlertAggregationService({
    required AssetComplianceAlertOrchestrator orchestrator,
    required AssetRepository assetRepository,
  })  : _orchestrator = orchestrator,
        _assetRepository = assetRepository;

  // ─────────────────────────────────────────────────────────────────────────
  // API PÚBLICA
  // ─────────────────────────────────────────────────────────────────────────

  /// Evalúa todos los activos de [orgId] y retorna las alertas promovidas.
  ///
  /// Pipeline:
  /// 1. Obtiene todos los activos de la org ([fetchAssetsByOrg]).
  /// 2. Ejecuta el pipeline canónico en paralelo para cada activo.
  ///    Falla silenciosamente por activo: un error individual no detiene el resto.
  /// 3. Aplana la lista de resultados multi-activo.
  /// 4. Aplica [AlertPromotionService.promote()] según reglas V4 §14.1.
  ///
  /// Retorna lista vacía si no hay activos, o si todos los activos fallan.
  Future<List<DomainAlert>> promotedAlertsForOrg(String orgId) async {
    final assets = await _assetRepository.fetchAssetsByOrg(orgId);
    if (assets.isEmpty) return const [];

    // Evaluación paralela: todos los activos concurrentemente.
    // _safeEvaluate garantiza que un fallo por activo no propague la excepción.
    final futures = assets.map(
      (asset) => _safeEvaluate(assetId: asset.id, orgId: orgId),
    );

    final rawResults = await Future.wait(futures);

    // Aplanar resultados multi-activo y aplicar reglas de promoción.
    final all = rawResults.expand((list) => list).toList();
    return AlertPromotionService.promote(all);
  }

  /// Retorna TODAS las alertas de [orgId] sin filtro de promoción.
  ///
  /// Usado por AlertCenterPage para mostrar el estado completo de la flota.
  /// A diferencia de [promotedAlertsForOrg], no aplica [AlertPromotionService]:
  /// el usuario ve todas las alertas activas ordenadas por severidad.
  ///
  /// Pipeline:
  /// 1. Obtiene todos los activos de la org.
  /// 2. Ejecuta el pipeline canónico en paralelo para cada activo.
  /// 3. Aplana resultados y aplica sort canónico (sin filtro de promoción).
  ///
  /// Retorna lista vacía si no hay activos o todos fallan.
  Future<List<DomainAlert>> allAlertsForOrg(String orgId) async {
    final assets = await _assetRepository.fetchAssetsByOrg(orgId);
    if (assets.isEmpty) return const [];

    final futures = assets.map(
      (asset) => _safeEvaluate(assetId: asset.id, orgId: orgId),
    );

    final rawResults = await Future.wait(futures);

    // Aplanar y ordenar — sin filtro de promoción.
    final all = rawResults.expand((list) => list).toList();
    return sortAlerts(all);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS PRIVADOS
  // ─────────────────────────────────────────────────────────────────────────

  /// Ejecuta el pipeline para un activo y absorbe errores individualmente.
  ///
  /// Si el orchestrator falla para este activo, retorna lista vacía.
  /// Garantiza que un activo con datos corruptos o faltantes no bloquea
  /// la evaluación del resto de la org.
  Future<List<DomainAlert>> _safeEvaluate({
    required String assetId,
    required String orgId,
  }) async {
    try {
      return await _orchestrator.evaluate(assetId: assetId, orgId: orgId);
    } catch (_) {
      return const [];
    }
  }
}
