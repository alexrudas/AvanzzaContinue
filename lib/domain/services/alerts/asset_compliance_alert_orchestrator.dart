// ============================================================================
// lib/domain/services/alerts/asset_compliance_alert_orchestrator.dart
// ASSET COMPLIANCE ALERT ORCHESTRATOR — Orquestador del pipeline de alertas
//
// QUÉ HACE:
// - Ejecuta todos los evaluadores sobre un AssetAlertSnapshot.
// - Consolida los resultados en una lista única de DomainAlert.
// - Aplica dedupe y sort en ese orden.
// - Retorna la lista final lista para consumo por la presentation layer.
//
// QUÉ NO HACE:
// - NO accede a repositorios directamente — recibe el snapshot ya construido.
// - NO importa Flutter, GetX ni infraestructura.
// - NO persiste alertas.
// - NO decide qué sube a Home (eso es responsabilidad de AlertPromotionService).
// - NO importa core directamente — soat_alert_adapter se inyecta por constructor.
//
// PRINCIPIOS:
// - Constructor injection: recibe el assembler y el evaluador SOAT como dependencias.
// - Pipeline canónico: fuentes → snapshot → evaluadores → dedupe → sort.
// - Si el assembler retorna null (activo no encontrado), retorna lista vacía.
// - SoatAlertBuilder desacopla el orquestador del adapter de core:
//   la implementación (buildSoatAlert) se inyecta desde DIContainer.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 2 — Orquestador canónico v1. Ver ALERTS_SYSTEM_V4.md §12.
// ============================================================================

import '../../entities/alerts/domain_alert.dart';
import 'asset_alert_snapshot.dart';
import 'asset_alert_snapshot_assembler.dart';
import 'evaluators/legal_alert_evaluator.dart';
import 'evaluators/rc_alert_evaluator.dart';
import 'evaluators/rtm_alert_evaluator.dart';
import 'support/alert_dedupe.dart';
import 'support/alert_sort.dart';

/// Función que evalúa el SOAT de un snapshot y retorna una alerta o null.
///
/// Implementada por [buildSoatAlert] en `lib/core/alerts/evaluators/soat_alert_adapter.dart`.
/// Inyectada por constructor para desacoplar el orquestador (domain) del adapter (core).
typedef SoatAlertBuilder = DomainAlert? Function(AssetAlertSnapshot snapshot);

/// Orquestador del pipeline de alertas de cumplimiento de activos.
///
/// Instanciar vía [DIContainer] — no usar directamente en widgets.
class AssetComplianceAlertOrchestrator {
  final AssetAlertSnapshotAssembler _assembler;
  final SoatAlertBuilder _buildSoatAlert;

  AssetComplianceAlertOrchestrator({
    required AssetAlertSnapshotAssembler assembler,
    required SoatAlertBuilder buildSoatAlert,
  })  : _assembler = assembler,
        _buildSoatAlert = buildSoatAlert;

  // ─────────────────────────────────────────────────────────────────────────
  // API PÚBLICA
  // ─────────────────────────────────────────────────────────────────────────

  /// Ejecuta el pipeline completo para [assetId] en [orgId].
  ///
  /// Pipeline:
  /// 1. Construye el snapshot vía [AssetAlertSnapshotAssembler].
  /// 2. Ejecuta todos los evaluadores (SOAT, RTM, RC, Legal).
  /// 3. Aplica dedupe (retiene la alerta más reciente por dedupeKey).
  /// 4. Aplica sort (5 reglas canónicas descendentes).
  ///
  /// Retorna lista vacía si el activo no existe o no hay alertas activas.
  Future<List<DomainAlert>> evaluate({
    required String assetId,
    required String orgId,
  }) async {
    // 1. Construir snapshot
    final snapshot = await _assembler.assemble(
      assetId: assetId,
      orgId: orgId,
    );
    if (snapshot == null) return const [];

    // 2. Ejecutar evaluadores
    final raw = <DomainAlert>[];

    // SOAT — inyectado por constructor (implementación vive en core/)
    final soat = _buildSoatAlert(snapshot);
    if (soat != null) raw.add(soat);

    // RTM
    final rtm = buildRtmAlert(snapshot);
    if (rtm != null) raw.add(rtm);

    // RC (hasta 2 alertas: contractual + extracontractual)
    raw.addAll(buildRcAlerts(snapshot));

    // Legal (hasta 2 alertas: embargo + limitaciones)
    raw.addAll(buildLegalAlerts(snapshot));

    if (raw.isEmpty) return const [];

    // 3. Dedupe
    final deduped = dedupeAlerts(raw);

    // 4. Sort
    return sortAlerts(deduped);
  }
}
