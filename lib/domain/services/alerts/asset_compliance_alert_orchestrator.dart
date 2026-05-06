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

import 'dart:developer' as dev;

import '../../entities/alerts/domain_alert.dart';
import 'asset_alert_snapshot.dart';
import 'asset_alert_snapshot_assembler.dart';
import 'evaluators/legal_alert_evaluator.dart';
import 'evaluators/rc_alert_evaluator.dart';
import 'evaluators/rtm_alert_evaluator.dart';
import 'support/alert_dedupe.dart';
import 'support/alert_sort.dart';

// @audit-temp [AUDIT_VRC_DEBUG] — diagnóstico end-to-end VRC → AlertCenter.
// Eliminar tras validar las 4 placas. Buscar prefijo "[AUDIT_VRC_DEBUG]".
const Set<String> _kOrchAuditPlates = {
  'WPV760',
  'WPV583',
  'WPV585',
  'WGA960',
};
bool _orchAuditMatch(String? placa) =>
    placa != null && _kOrchAuditPlates.contains(placa.trim().toUpperCase());

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

    // @audit-temp [AUDIT_VRC_DEBUG]
    final auditOn = _orchAuditMatch(snapshot.placa);
    if (auditOn) {
      dev.log(
        '[AUDIT_VRC_DEBUG] [${snapshot.placa}] [ORCHESTRATOR] ENTER evaluate '
        'assetId=$assetId orgId=$orgId',
        name: 'AUDIT_VRC',
      );
    }

    // 2. Ejecutar evaluadores
    final raw = <DomainAlert>[];

    // SOAT — inyectado por constructor (implementación vive en core/)
    final soat = _buildSoatAlert(snapshot);
    if (soat != null) raw.add(soat);
    // @audit-temp [AUDIT_VRC_DEBUG]
    if (auditOn) {
      dev.log(
        '[AUDIT_VRC_DEBUG] [${snapshot.placa}] [ORCHESTRATOR] '
        'SOAT evaluator → ${soat == null ? "null" : "code=${soat.code.wireName}"}',
        name: 'AUDIT_VRC',
      );
    }

    // RTM
    final rtm = buildRtmAlert(snapshot);
    if (rtm != null) raw.add(rtm);
    // @audit-temp [AUDIT_VRC_DEBUG]
    if (auditOn) {
      dev.log(
        '[AUDIT_VRC_DEBUG] [${snapshot.placa}] [ORCHESTRATOR] '
        'RTM evaluator → ${rtm == null ? "null" : "code=${rtm.code.wireName}"}',
        name: 'AUDIT_VRC',
      );
    }

    // RC (hasta 2 alertas: contractual + extracontractual)
    final rcAlerts = buildRcAlerts(snapshot);
    raw.addAll(rcAlerts);
    // @audit-temp [AUDIT_VRC_DEBUG]
    if (auditOn) {
      dev.log(
        '[AUDIT_VRC_DEBUG] [${snapshot.placa}] [ORCHESTRATOR] '
        'RC evaluator → ${rcAlerts.length} alertas '
        'codes=${rcAlerts.map((a) => a.code.wireName).toList()}',
        name: 'AUDIT_VRC',
      );
    }

    // Legal (hasta 2 alertas: embargo + limitaciones)
    final legalAlerts = buildLegalAlerts(snapshot);
    raw.addAll(legalAlerts);
    // @audit-temp [AUDIT_VRC_DEBUG]
    if (auditOn) {
      dev.log(
        '[AUDIT_VRC_DEBUG] [${snapshot.placa}] [ORCHESTRATOR] '
        'Legal evaluator → ${legalAlerts.length} alertas '
        'codes=${legalAlerts.map((a) => a.code.wireName).toList()}',
        name: 'AUDIT_VRC',
      );
    }

    if (raw.isEmpty) {
      // @audit-temp [AUDIT_VRC_DEBUG]
      if (auditOn) {
        dev.log(
          '[AUDIT_VRC_DEBUG] [${snapshot.placa}] [ORCHESTRATOR] EXIT '
          'raw.isEmpty → AlertCenter recibirá 0 alertas para este activo.',
          name: 'AUDIT_VRC',
        );
      }
      return const [];
    }

    // 3. Dedupe
    final deduped = dedupeAlerts(raw);

    // 4. Sort
    final sorted = sortAlerts(deduped);

    // @audit-temp [AUDIT_VRC_DEBUG]
    if (auditOn) {
      dev.log(
        '[AUDIT_VRC_DEBUG] [${snapshot.placa}] [ORCHESTRATOR] EXIT '
        'raw=${raw.length} deduped=${deduped.length} sorted=${sorted.length} '
        'finalCodes=${sorted.map((a) => "${a.code.wireName}@${a.severity.name}").toList()}',
        name: 'AUDIT_VRC',
      );
    }

    return sorted;
  }
}
