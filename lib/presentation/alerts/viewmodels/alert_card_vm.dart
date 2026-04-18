// ============================================================================
// lib/presentation/alerts/viewmodels/alert_card_vm.dart
// ALERT CARD VIEW MODEL — ViewModel de presentación de una alerta canónica
//
// QUÉ HACE:
// - Define AlertCardVm: representación de una DomainAlert lista para UI.
// - Es el contrato entre DomainAlertMapper y los widgets de alertas.
// - Expone sourceEntityId, actionLabel y actionRoute para navegación desde
//   la alerta hacia la pantalla correspondiente del activo.
// - Expone docStatus (AlertDocStatus) para el badge de estado documental,
//   eliminando la necesidad de inferir estado desde strings en la UI.
// - Expone daysRemaining y expiryDate como campos estructurados para lógica
//   de sort y ordenamiento sin parsear strings de presentación.
//
// QUÉ NO HACE:
// - No depende de package:flutter (sin widgets, sin colores, sin IconData).
// - No contiene lógica de evaluación ni de negocio.
// - No decide qué alertas se muestran (eso es del pipeline y del mapper).
//
// PRINCIPIOS:
// - Dart puro + Equatable: value equality para listas eficientes.
// - title y subtitle son strings resueltos (no i18n keys).
//   En V1 resueltos directamente en español por DomainAlertMapper.
// - code está expuesto para que la UI pueda filtrar por dominio si lo necesita.
// - sourceEntityId: assetId que originó la alerta — permite routing por activo.
// - actionLabel / actionRoute: CTA de navegación contextual (nullable en V1
//   para alertas cuya ruta destino aún no está implementada).
// - docStatus: canal ortogonal a severity — estado del documento/cobertura.
//   La UI consume docStatus para el badge; no infiere estado desde texto.
// - daysRemaining: fuente de verdad para lógica temporal y sort. int negativo
//   si ya venció. La UI NUNCA parsea subtitle para derivar este valor.
// - expiryDate: solo para display. Puede ser null si el formato del backend
//   no es reconocible. NUNCA usar para lógica — usar daysRemaining.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 3 — Consumo contextual V1. Ver ALERTS_SYSTEM_V4.md §13.
// ACTUALIZADO (2026-03): Fase 5.5 — sourceEntityId, actionLabel, actionRoute
//   para navegación desde AlertCenterPage y card de métricas en Home.
// ACTUALIZADO (2026-03): Fase 5.5 — docStatus para badge estructurado.
//   Elimina _statusLabel/_statusColor (inferencia desde strings) en UI.
// ACTUALIZADO (2026-04): Fase 6 UX — daysRemaining y expiryDate como campos
//   estructurados para FleetAlertGrouper (sort intra-grupo sin parsear strings).
// ============================================================================

import 'package:equatable/equatable.dart';

import '../../../domain/entities/alerts/alert_code.dart';
import '../../../domain/entities/alerts/alert_severity.dart';
import 'alert_doc_status.dart';

/// ViewModel de presentación de una alerta canónica.
///
/// Producido exclusivamente por [DomainAlertMapper.fromDomain].
/// Consumido por widgets de alertas — no construir manualmente en UI.
final class AlertCardVm extends Equatable {
  /// Título resuelto de la alerta (en español en V1).
  ///
  /// No es una key de i18n — es el string final para render.
  final String title;

  /// Subtítulo contextual opcional.
  ///
  /// Ejemplos: "Vence en 5 días", "Vencido hace 2 días", "Vence hoy".
  /// Null si no hay información contextual disponible.
  final String? subtitle;

  /// Nivel de urgencia. El widget decide el color a partir de este campo.
  ///
  /// REGLA: el widget no recalcula la severidad — solo la consume para
  /// derivar tokens visuales (color, icono).
  final AlertSeverity severity;

  /// Código canónico de la alerta.
  ///
  /// Útil para filtrar por dominio en vistas específicas (ej: jurídica
  /// filtra por legalLimitationActive / embargoActive).
  final AlertCode code;

  /// ID del activo que originó la alerta.
  ///
  /// Permite navegar hacia la pantalla específica del activo al hacer tap
  /// en una alerta dentro de AlertCenterPage o la card de resumen del Home.
  final String sourceEntityId;

  /// Label primario de identificación del activo.
  ///
  /// Placa (vehículo), matrícula (inmueble), serial (maquinaria/equipo).
  /// Fallback: 'Activo sin identificar' — garantizado no-null por DomainAlertMapper.
  /// Consumido por _AlertCard para mostrar identidad del activo en multi-activo.
  final String assetPrimaryLabel;

  /// Label secundario de identificación del activo.
  ///
  /// '$brand $model' (vehículo/maquinaria), dirección (inmueble), nombre (equipo).
  /// Null si no disponible.
  final String? assetSecondaryLabel;

  /// Tipo de activo (wire-stable).
  ///
  /// 'vehicle', 'real_estate', 'machinery', 'equipment'.
  /// Permite filtros en AlertCenterPage sin queries adicionales. Null si no disponible.
  final String? assetType;

  /// Etiqueta del CTA de acción contextual.
  ///
  /// Ejemplos: "Ver SOAT", "Ver RTM", "Ver estado jurídico".
  /// Null si no hay ruta de destino implementada para este código en V1.
  final String? actionLabel;

  /// Ruta de navegación para el CTA de acción.
  ///
  /// Ejemplos: '/assets/{id}/insurance/soat', '/assets/{id}/rtm'.
  /// Fallback: '/assets/{id}' para alertas sin ruta específica.
  /// Null si [actionLabel] es null.
  final String? actionRoute;

  /// Estado documental/legal derivado desde [AlertCode] por el mapper.
  ///
  /// Canal ortogonal a [severity]:
  /// - [severity] → urgencia operativa (barra de color lateral)
  /// - [docStatus] → estado del documento o cobertura (badge textual)
  ///
  /// REGLA: la UI nunca infiere este valor desde [title] ni [subtitle].
  /// Solo consume este campo para decidir label y color del badge.
  final AlertDocStatus docStatus;

  /// Días restantes hasta el vencimiento del documento/póliza.
  ///
  /// Negativo si ya venció (ej: -3 = venció hace 3 días).
  /// Null si no aplica (legal, oportunidades comerciales, códigos reservados).
  ///
  /// FUENTE DE VERDAD para lógica temporal y sort.
  /// Calculado por los evaluadores de dominio directamente desde fechas reales.
  /// REGLA: la UI NUNCA parsea [subtitle] para derivar este valor.
  final int? daysRemaining;

  /// Fecha de vencimiento del documento/póliza.
  ///
  /// Solo para display — puede ser null si el formato del backend no es
  /// reconocible (ver _safeParseDateOnly en DomainAlertMapper).
  /// REGLA: NUNCA usar para lógica ni sort — usar [daysRemaining].
  final DateTime? expiryDate;

  const AlertCardVm({
    required this.title,
    this.subtitle,
    required this.severity,
    required this.code,
    required this.sourceEntityId,
    required this.assetPrimaryLabel,
    this.assetSecondaryLabel,
    this.assetType,
    this.actionLabel,
    this.actionRoute,
    this.docStatus = AlertDocStatus.unknown,
    this.daysRemaining,
    this.expiryDate,
  });

  @override
  List<Object?> get props => [
        title,
        subtitle,
        severity,
        code,
        sourceEntityId,
        assetPrimaryLabel,
        assetSecondaryLabel,
        assetType,
        actionLabel,
        actionRoute,
        docStatus,
        daysRemaining,
        expiryDate,
      ];
}
