// ============================================================================
// lib/presentation/alerts/groupers/fleet_alert_grouper.dart
// FLEET ALERT GROUPER — Agrupa AlertCardVm por activo → FleetAlertGroupVm
//
// QUÉ HACE:
// - Transforma List<AlertCardVm> en List<FleetAlertGroupVm>:
//   1 grupo por sourceEntityId (activo).
// - Calcula criticasCount, porVencerCount, totalCount y riskLevel por grupo.
// - Ordena las alertas intra-grupo por bucket de prioridad y urgencia temporal.
// - Ordena los grupos resultantes por riskLevel DESC (HIGH primero).
//
// QUÉ NO HACE:
// - No re-evalúa alertas ni consulta repositorios.
// - No depende de package:flutter (Dart puro).
// - No decide qué alertas se incluyen — recibe la lista ya filtrada del pipeline.
// - No parsea strings de subtítulo para derivar orden — usa daysRemaining (int).
//
// PRINCIPIOS:
// - Función estática pura: sin estado, sin side effects, testeable de forma aislada.
// - Preserva orden de primera aparición por activo (LinkedHashMap).
// - Sort intra-grupo: bucket de prioridad → daysRemaining ASC (999999 si null).
//   La urgencia temporal NO se deriva de subtitle, sino de AlertCardVm.daysRemaining.
// - Sort inter-grupos: riskLevel.index DESC (high=2 > medium=1 > low=0).
//
// ORDEN INTRA-GRUPO (bucket):
//   0: severity == critical AND docStatus == expired    → vencido crítico
//   1: severity != critical AND docStatus == expired    → vencido no crítico
//   2: docStatus == dueSoon                             → por vencer
//   3: docStatus == missing                             → ausente
//   4: resto (exempt, restricted, opportunity, unknown) → otros
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Fase 6 UX — Rediseño flujo de alertas por vehículo.
// ============================================================================

import 'dart:collection';

import '../viewmodels/alert_card_vm.dart';
import '../viewmodels/alert_doc_status.dart';
import '../viewmodels/fleet_alert_group_vm.dart';
import '../../../domain/entities/alerts/alert_severity.dart';

abstract final class FleetAlertGrouper {
  FleetAlertGrouper._();

  /// Agrupa [alerts] por [AlertCardVm.sourceEntityId] y retorna una lista de
  /// [FleetAlertGroupVm] ordenada por riesgo descendente.
  ///
  /// Lista vacía → retorna lista vacía.
  /// Alertas sin sourceEntityId válido se agrupan normalmente (el campo
  /// garantizado no-null por DomainAlertMapper).
  static List<FleetAlertGroupVm> group(List<AlertCardVm> alerts) {
    if (alerts.isEmpty) return const [];

    // ── Paso 1: agrupar por sourceEntityId preservando orden de aparición ──
    final map = LinkedHashMap<String, List<AlertCardVm>>();
    for (final alert in alerts) {
      map.putIfAbsent(alert.sourceEntityId, () => []).add(alert);
    }

    // ── Paso 2: construir FleetAlertGroupVm por cada grupo ──
    final groups = <FleetAlertGroupVm>[];

    for (final entry in map.entries) {
      final assetId = entry.key;
      final groupAlerts = entry.value;

      // Ordenar alertas intra-grupo por bucket de prioridad + urgencia temporal.
      final sortedAlerts = _sortAlertsInGroup(groupAlerts);

      final first = sortedAlerts[0];

      final criticasCount = sortedAlerts
          .where((a) => a.severity == AlertSeverity.critical)
          .length;

      final porVencerCount = sortedAlerts
          .where((a) => a.docStatus == AlertDocStatus.dueSoon)
          .length;

      final hasCritical = criticasCount > 0;
      final hasHigh =
          sortedAlerts.any((a) => a.severity == AlertSeverity.high);

      final riskLevel = hasCritical
          ? FleetRiskLevel.high
          : hasHigh
              ? FleetRiskLevel.medium
              : FleetRiskLevel.low;

      groups.add(FleetAlertGroupVm(
        sourceEntityId: assetId,
        placa: first.assetPrimaryLabel,
        vehicleLabel: first.assetSecondaryLabel,
        assetType: first.assetType,
        criticasCount: criticasCount,
        porVencerCount: porVencerCount,
        totalCount: sortedAlerts.length,
        riskLevel: riskLevel,
        alerts: sortedAlerts,
      ));
    }

    // ── Paso 3: ordenar grupos por riskLevel DESC (high=2 primero) ──
    groups.sort(
      (a, b) => b.riskLevel.index.compareTo(a.riskLevel.index),
    );

    return groups;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SORT INTRA-GRUPO
  // ─────────────────────────────────────────────────────────────────────────

  /// Ordena las alertas de un grupo por bucket de prioridad, luego por
  /// urgencia temporal (daysRemaining ASC).
  static List<AlertCardVm> _sortAlertsInGroup(List<AlertCardVm> alerts) {
    final sorted = [...alerts];
    sorted.sort((a, b) {
      final bucketA = _priorityBucket(a);
      final bucketB = _priorityBucket(b);
      if (bucketA != bucketB) return bucketA.compareTo(bucketB);
      // Dentro del mismo bucket: daysRemaining ASC (más urgente primero).
      // Null → 999999 (al final del bucket, sin urgencia temporal definida).
      final daysA = a.daysRemaining ?? 999999;
      final daysB = b.daysRemaining ?? 999999;
      return daysA.compareTo(daysB);
    });
    return sorted;
  }

  /// Retorna el bucket de prioridad de una alerta para el sort intra-grupo.
  ///
  /// 0: vencido crítico    (severity == critical AND docStatus == expired)
  /// 1: vencido no crítico (docStatus == expired, cualquier otra severity)
  /// 2: por vencer         (docStatus == dueSoon)
  /// 3: ausente            (docStatus == missing)
  /// 4: resto              (exempt, restricted, opportunity, unknown)
  static int _priorityBucket(AlertCardVm alert) {
    return switch (alert.docStatus) {
      AlertDocStatus.expired =>
        alert.severity == AlertSeverity.critical ? 0 : 1,
      AlertDocStatus.dueSoon => 2,
      AlertDocStatus.missing => 3,
      _ => 4,
    };
  }
}
