// ============================================================================
// lib/presentation/alerts/viewmodels/fleet_alert_group_vm.dart
// FLEET ALERT GROUP VM — ViewModel de grupo de alertas por vehículo
//
// QUÉ HACE:
// - Define FleetAlertGroupVm: agrupación de todas las alertas de un activo,
//   con conteos derivados y nivel de riesgo para el Nivel 1 del flujo de flota.
// - Define FleetRiskLevel: heurística MVP de riesgo global del activo.
// - Es el contrato entre FleetAlertGrouper y FleetAlertListPage / FleetVehicleAlertsPage.
// - Contiene List<AlertCardVm> completa para que el Nivel 2 no necesite re-fetch.
//
// QUÉ NO HACE:
// - No depende de package:flutter (Dart puro + Equatable).
// - No contiene lógica de evaluación ni de negocio.
// - No recalcula alertas — las recibe ya evaluadas del pipeline canónico.
//
// PRINCIPIOS:
// - Dart puro + Equatable: value equality para listas eficientes.
// - riskLevel es una HEURÍSTICA MVP (severidad máxima del grupo).
//   No es scoring enterprise — no considera frecuencia, historial ni
//   combinaciones de riesgo cruzado. En V2+ reemplazar por RiskScoringService.
// - criticasCount y porVencerCount se derivan de AlertSeverity y AlertDocStatus
//   respectivamente — nunca se parsean strings para calcularlos.
// - alerts contiene las AlertCardVm originales en su orden canónico (sort
//   intra-grupo aplicado por FleetAlertGrouper): vencido crítico → vencido →
//   por vencer → ausente → otros.
//
// ENTERPRISE NOTES:
// CREADO (2026-04): Fase 6 UX — Rediseño flujo de alertas por vehículo.
// ============================================================================

import 'package:equatable/equatable.dart';

import 'alert_card_vm.dart';

/// Nivel de riesgo global del grupo de alertas de un activo.
///
/// HEURÍSTICA MVP: derivado de la severidad máxima del grupo.
/// No es scoring enterprise — ver docstring de clase para detalles.
///
/// Orden declarado ascending (low=0, medium=1, high=2) para sort
/// descendente por índice: `b.riskLevel.index.compareTo(a.riskLevel.index)`.
enum FleetRiskLevel {
  low,
  medium,
  high;

  /// Etiqueta en español para display en UI.
  String get label => switch (this) {
        FleetRiskLevel.low => 'Bajo',
        FleetRiskLevel.medium => 'Medio',
        FleetRiskLevel.high => 'Alto',
      };
}

/// ViewModel de grupo de alertas de un activo para el flujo de flota.
///
/// Producido exclusivamente por [FleetAlertGrouper.group].
/// Consumido por FleetAlertListPage (Nivel 1) y FleetVehicleAlertsPage (Nivel 2).
/// No construir manualmente en UI.
final class FleetAlertGroupVm extends Equatable {
  /// ID del activo que originó el grupo — clave de partición y navegación.
  final String sourceEntityId;

  /// Label primario del activo (placa, matrícula, serial).
  ///
  /// Tomado de [AlertCardVm.assetPrimaryLabel] del primer alert del grupo.
  /// Garantizado no-null (hereda el fallback 'Activo sin identificar' del mapper).
  final String placa;

  /// Label secundario del activo (marca + modelo, dirección, nombre).
  ///
  /// Null si no disponible.
  final String? vehicleLabel;

  /// Tipo de activo wire-stable ('vehicle', 'real_estate', 'machinery', 'equipment').
  ///
  /// Null si no disponible.
  final String? assetType;

  /// Número de alertas con [AlertSeverity.critical] en el grupo.
  final int criticasCount;

  /// Número de alertas con [AlertDocStatus.dueSoon] en el grupo.
  ///
  /// Excluye alertas que ya están en criticasCount si su docStatus
  /// coincide con dueSoon — ambos conteos son independientes.
  final int porVencerCount;

  /// Total de alertas en el grupo (= alerts.length).
  final int totalCount;

  /// Nivel de riesgo heurístico del grupo.
  ///
  /// high   → al menos 1 alert con severity == critical
  /// medium → al menos 1 alert con severity == high (ninguna critical)
  /// low    → solo severity medium/low
  final FleetRiskLevel riskLevel;

  /// Lista de alertas del grupo en orden canónico intra-grupo.
  ///
  /// Orden: vencido crítico → vencido no crítico → por vencer → ausente → otros.
  /// Dentro de cada bloque: daysRemaining ASC (más urgente primero).
  /// Fuente única de verdad para FleetVehicleAlertsPage (Nivel 2).
  /// No re-fetch al navegar — pasar por Get.arguments.
  final List<AlertCardVm> alerts;

  const FleetAlertGroupVm({
    required this.sourceEntityId,
    required this.placa,
    this.vehicleLabel,
    this.assetType,
    required this.criticasCount,
    required this.porVencerCount,
    required this.totalCount,
    required this.riskLevel,
    required this.alerts,
  });

  @override
  List<Object?> get props => [
        sourceEntityId,
        placa,
        vehicleLabel,
        assetType,
        criticasCount,
        porVencerCount,
        totalCount,
        riskLevel,
        alerts,
      ];
}
