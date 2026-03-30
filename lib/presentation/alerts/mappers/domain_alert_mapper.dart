// ============================================================================
// lib/presentation/alerts/mappers/domain_alert_mapper.dart
// DOMAIN ALERT MAPPER — Transforma DomainAlert → AlertCardVm
//
// QUÉ HACE:
// - Convierte DomainAlert en AlertCardVm: traduce AlertCode a texto español (V1).
// - Genera subtitle contextual desde facts (daysRemaining, expirationDate, sourceName).
// - Resuelve sourceEntityId, actionLabel y actionRoute para cada alerta.
// - Soporta códigos operativos vigentes del pipeline RTM/RC/SOAT/Jurídico,
//   incluyendo RTM exenta (rtmExempt).
//
// QUÉ NO HACE:
// - NO recalcula la severidad de la alerta.
// - NO cambia la prioridad de la alerta.
// - NO filtra alertas de la lista (filtrar es responsabilidad del caller).
// - NO contiene lógica de negocio ni reglas de evaluación.
// - NO importa package:flutter.
//
// PRINCIPIOS:
// - Transformación pura: sin side effects.
// - V1: resolución de título directamente en español (sin sistema i18n).
//   En V2: resolver desde titleKey de DomainAlert usando el sistema i18n real.
// - Los facts se leen con null guard — nunca cast inseguro.
// - Prioridad de subtitle:
//     * RTM exenta: expirationDate > daysRemaining > sourceName > null
//     * Resto:      daysRemaining > expirationDate > sourceName > null
// - actionRoute fallback: null para alertas sin navegación implementada en V1.
//   El caller decide si renderiza CTA.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 3 — Consumo contextual V1. Ver ALERTS_SYSTEM_V4.md §13.
// ACTUALIZADO (2026-03): Soporte rc_contractual_missing y rc_extracontractual_missing.
// ACTUALIZADO (2026-03): Fase 5.5 — sourceEntityId, actionLabel, actionRoute en AlertCardVm.
// ACTUALIZADO (2026-03): Soporte explícito para AlertCode.rtmExempt.
//   IMPORTANTE: el pipeline actual de RTM puede emitir rtmExempt; si el mapper
//   no lo soporta, se rompe el consumo en Centro de alertas.
// ACTUALIZADO (2026-03): V5 — Soporte AlertCode.rcExtracontractualOpportunity.
//   BUG FIX: mapper sin este case lanzaba AssertionError en debug → loadAlerts()
//   capturaba la excepción y vaciaba la lista → "No hay alertas activas".
//   Subtitle canónico: "Cobertura recomendada para protección patrimonial".
// ============================================================================

import '../../../domain/entities/alerts/alert_code.dart';
import '../../../domain/entities/alerts/alert_fact_keys.dart';
import '../../../domain/entities/alerts/domain_alert.dart';
import '../viewmodels/alert_card_vm.dart';

abstract final class DomainAlertMapper {
  DomainAlertMapper._();

  // ─────────────────────────────────────────────────────────────────────────
  // API PÚBLICA
  // ─────────────────────────────────────────────────────────────────────────

  /// Convierte una [DomainAlert] en [AlertCardVm].
  ///
  /// No filtra, no recalcula severidad, no cambia prioridad.
  static AlertCardVm fromDomain(DomainAlert alert) {
    return AlertCardVm(
      title: _resolveTitle(alert.code),
      // CAMBIO CLAVE:
      // El subtítulo ahora conoce el código para poder renderizar correctamente
      // casos especiales como RTM exenta, cuyo texto no debe sonar como una
      // alerta de vencimiento normal.
      subtitle: _resolveSubtitle(alert.code, alert.facts),
      severity: alert.severity,
      code: alert.code,
      sourceEntityId: alert.sourceEntityId,
      assetPrimaryLabel: _resolveAssetPrimaryLabel(alert.facts),
      assetSecondaryLabel: _resolveAssetSecondaryLabel(alert.facts),
      assetType: _resolveAssetType(alert.facts),
      actionLabel: _resolveActionLabel(alert.code),
      actionRoute: _resolveActionRoute(alert.code, alert.sourceEntityId),
    );
  }

  /// Convierte una lista de [DomainAlert] en [AlertCardVm].
  ///
  /// No filtra — retorna una VM por cada alerta recibida.
  static List<AlertCardVm> fromDomainList(List<DomainAlert> alerts) =>
      alerts.map(fromDomain).toList();

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS PRIVADOS
  // ─────────────────────────────────────────────────────────────────────────

  /// Resuelve el título de la alerta desde su [AlertCode].
  ///
  /// V1: resolución directa en español por AlertCode.
  ///
  /// NOTA DE DEUDA — titleKey / bodyKey de DomainAlert:
  /// Los campos titleKey y bodyKey existen en DomainAlert para futura
  /// integración con el sistema i18n real, pero NO se consumen en V1.
  /// En V2, reemplazar este switch por: `i18n.resolve(alert.titleKey)`.
  static String _resolveTitle(AlertCode code) => switch (code) {
        AlertCode.soatExpired => 'SOAT vencido',
        AlertCode.soatDueSoon => 'SOAT próximo a vencer',
        AlertCode.rtmExpired => 'Técnico-mecánica vencida',
        AlertCode.rtmDueSoon => 'Técnico-mecánica próxima a vencer',

        // NUEVO:
        // Soporte explícito para la alerta de exención RTM.
        // Sin este case, el mapper cae en _unsupportedCode(code) y rompe el
        // consumo de la alerta en presentation.
        AlertCode.rtmExempt => 'Técnico-mecánica exenta',
        AlertCode.rcContractualExpired => 'RC contractual vencida',
        AlertCode.rcContractualDueSoon => 'RC contractual próxima a vencer',
        AlertCode.rcExtracontractualExpired => 'RC extracontractual vencida',
        AlertCode.rcExtracontractualDueSoon =>
          'RC extracontractual próxima a vencer',
        AlertCode.rcContractualMissing => 'RC contractual ausente',
        AlertCode.rcExtracontractualMissing => 'RC extracontractual ausente',
        AlertCode.rcExtracontractualOpportunity => 'Sin RC extracontractual',
        AlertCode.legalLimitationActive => 'Limitación jurídica activa',
        AlertCode.embargoActive => 'Embargo registrado',

        // Reservados — no deben llegar en V1.
        // Si llegan, es un bug del evaluador o del pipeline.
        _ => _unsupportedCode(code),
      };

  /// Fallback para códigos no soportados en V1.
  ///
  /// Los códigos reservados (simitFineActive, maintenanceOverdue, etc.) no
  /// deben ser emitidos por ningún evaluador V1. Si llegan aquí es un bug.
  /// El assert lo detecta en debug; en release retorna texto honesto.
  static String _unsupportedCode(AlertCode code) {
    assert(
      false,
      'DomainAlertMapper: AlertCode "${code.wireName}" no soportado en V1. '
      'Ver ALERTS_SYSTEM_V4.md §6.1.',
    );
    return 'Alerta (tipo no soportado en V1)';
  }

  /// Resuelve el subtítulo contextual desde los facts de la alerta.
  ///
  /// Regla general:
  /// - daysRemaining → expirationDate → sourceName → null
  ///
  /// Excepción importante:
  /// - Para [AlertCode.rtmExempt], el texto debe comunicar exención, no urgencia.
  ///   Por eso se prioriza expirationDate con copy específico ("Exenta hasta ...").
  static String? _resolveSubtitle(
    AlertCode code,
    Map<String, Object?> facts,
  ) {
    // CASO ESPECIAL — OPORTUNIDAD RC EXTRACONTRACTUAL
    //
    // Esta señal no tiene daysRemaining ni expirationDate (no hay póliza que
    // evaluar). La lógica general retornaría null dejando la card sin contexto.
    // Copy fijo: refleja valor comercial sin sonar como alerta de cumplimiento.
    if (code == AlertCode.rcExtracontractualOpportunity) {
      return 'Cobertura recomendada para protección patrimonial';
    }

    // CASO ESPECIAL — RTM EXENTA
    //
    // El evaluador RTM actual puede emitir rtmExempt y aportar facts
    // compatibles con expirationDate/daysRemaining. Si aquí reutilizáramos
    // la lógica estándar, podríamos mostrar "Vence en X días", lo cual es
    // semánticamente flojo para una exención.
    if (code == AlertCode.rtmExempt) {
      final expirationDate = facts[AlertFactKeys.expirationDate];
      if (expirationDate is String && expirationDate.isNotEmpty) {
        return 'Exenta hasta $expirationDate';
      }

      final daysRemaining = facts[AlertFactKeys.daysRemaining];
      if (daysRemaining is int) {
        if (daysRemaining <= 0) {
          // Defensa adicional: si por inconsistencia llegara 0 o negativo,
          // no devolvemos copy absurda tipo "Exenta hasta hace 3 días".
          return 'Exención finaliza hoy';
        }
        return 'Exenta por $daysRemaining ${daysRemaining == 1 ? 'día' : 'días'}';
      }

      final sourceName = facts[AlertFactKeys.sourceName];
      if (sourceName is String && sourceName.isNotEmpty) return sourceName;

      return 'Exención vigente';
    }

    // LÓGICA GENERAL — alertas operativas normales
    final daysRemaining = facts[AlertFactKeys.daysRemaining];
    if (daysRemaining is int) {
      if (daysRemaining < 0) {
        final n = -daysRemaining;
        return 'Vencido hace $n ${n == 1 ? 'día' : 'días'}';
      }
      if (daysRemaining == 0) return 'Vence hoy';
      return 'Vence en $daysRemaining ${daysRemaining == 1 ? 'día' : 'días'}';
    }

    final expirationDate = facts[AlertFactKeys.expirationDate];
    if (expirationDate is String && expirationDate.isNotEmpty) {
      return 'Fecha: $expirationDate';
    }

    // Último fallback contextual: nombre de la entidad fuente (aseguradora,
    // entidad jurídica, etc.). Se muestra sin prefijo — el título ya identifica
    // el tipo de alerta.
    final sourceName = facts[AlertFactKeys.sourceName];
    if (sourceName is String && sourceName.isNotEmpty) return sourceName;

    return null;
  }

  /// Resuelve la etiqueta del CTA de acción para el [AlertCode].
  ///
  /// Null para alertas cuya pantalla de destino no está implementada en V1.
  static String? _resolveActionLabel(AlertCode code) => switch (code) {
        AlertCode.soatExpired || AlertCode.soatDueSoon => 'Ver SOAT',
        AlertCode.rtmExpired ||
        AlertCode.rtmDueSoon ||
        // NUEVO:
        // RTM exenta sigue navegando al mismo detalle RTM; cambia el estado,
        // no el destino.
        AlertCode.rtmExempt =>
          'Ver RTM',
        AlertCode.rcContractualExpired ||
        AlertCode.rcContractualDueSoon ||
        AlertCode.rcContractualMissing ||
        AlertCode.rcExtracontractualExpired ||
        AlertCode.rcExtracontractualDueSoon ||
        AlertCode.rcExtracontractualMissing ||
        AlertCode.rcExtracontractualOpportunity =>
          'Ver RC',
        AlertCode.embargoActive ||
        AlertCode.legalLimitationActive =>
          'Ver estado jurídico',
        _ => null,
      };

  /// Resuelve la ruta canónica de navegación para el CTA de acción.
  ///
  /// Retorna la ruta sin assetId embebido — el assetId se pasa como
  /// `arguments: vm.sourceEntityId` en el caller (AlertCenterPage).
  /// Coincide con las constantes de Routes.* en app_routes.dart.
  ///
  /// Null solo si [_resolveActionLabel] retorna null.
  static String? _resolveActionRoute(AlertCode code, String sourceEntityId) =>
      switch (code) {
        AlertCode.soatExpired ||
        AlertCode.soatDueSoon =>
          '/asset/insurance/soat',
        AlertCode.rtmExpired ||
        AlertCode.rtmDueSoon ||
        // NUEVO:
        // Mismo racional que el actionLabel: la exención RTM debe llevar al
        // detalle RTM del activo.
        AlertCode.rtmExempt =>
          '/asset/rtm/detail',
        AlertCode.rcContractualExpired ||
        AlertCode.rcContractualDueSoon ||
        AlertCode.rcContractualMissing ||
        AlertCode.rcExtracontractualExpired ||
        AlertCode.rcExtracontractualDueSoon ||
        AlertCode.rcExtracontractualMissing ||
        AlertCode.rcExtracontractualOpportunity =>
          '/asset/insurance/rc',
        AlertCode.embargoActive ||
        AlertCode.legalLimitationActive =>
          '/asset/legal',
        _ => null,
      };

  /// Resuelve el label primario del activo desde facts.
  ///
  /// Fallback obligatorio: 'Activo sin identificar' si el fact es null, vacío
  /// o de tipo incorrecto. Garantiza que [AlertCardVm.assetPrimaryLabel]
  /// nunca sea null ni vacío.
  static String _resolveAssetPrimaryLabel(Map<String, Object?> facts) {
    final v = facts[AlertFactKeys.assetPrimaryLabel];
    if (v is String && v.isNotEmpty) return v;
    return 'Activo sin identificar';
  }

  /// Resuelve el label secundario del activo desde facts.
  ///
  /// Null si no disponible o tipo incorrecto.
  static String? _resolveAssetSecondaryLabel(Map<String, Object?> facts) {
    final v = facts[AlertFactKeys.assetSecondaryLabel];
    if (v is String && v.isNotEmpty) return v;
    return null;
  }

  /// Resuelve el tipo de activo desde facts.
  ///
  /// Null si no disponible o tipo incorrecto.
  static String? _resolveAssetType(Map<String, Object?> facts) {
    final v = facts[AlertFactKeys.assetType];
    if (v is String && v.isNotEmpty) return v;
    return null;
  }
}
