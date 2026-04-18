// ============================================================================
// lib/presentation/alerts/mappers/domain_alert_mapper.dart
// DOMAIN ALERT MAPPER — Transforma DomainAlert → AlertCardVm
//
// QUÉ HACE:
// - Convierte DomainAlert en AlertCardVm: traduce AlertCode a texto español (V1).
// - Genera subtitle contextual desde facts (daysRemaining, expirationDate, sourceName).
// - Resuelve sourceEntityId, actionLabel y actionRoute para cada alerta.
// - Propaga daysRemaining (int?) y expiryDate (DateTime?) como campos estructurados
//   para que FleetAlertGrouper pueda ordenar sin parsear strings de presentación.
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
// - daysRemaining es la fuente de verdad para lógica temporal y sort.
//   expiryDate es solo display — puede ser null si el backend envía formato inesperado.
// - _safeParseDateOnly acepta solo YYYY-MM-DD (o ISO completo truncado a 10 chars).
//   Descarta timezone. Loguea en debug ante formato inválido.
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
// ACTUALIZADO (2026-04): Fase 6 UX — daysRemaining y expiryDate propagados como
//   campos estructurados en AlertCardVm. _safeParseDateOnly + _parseExpiryDate
//   con logging defensivo debug-only.
// ============================================================================

import '../../../domain/entities/alerts/alert_code.dart';
import '../../../domain/entities/alerts/alert_fact_keys.dart';
import '../../../domain/entities/alerts/domain_alert.dart';
import '../viewmodels/alert_card_vm.dart';
import '../viewmodels/alert_doc_status.dart';

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
      // El subtítulo conoce el código para renderizar correctamente casos
      // especiales como RTM exenta (no suena como alerta de vencimiento normal).
      subtitle: _resolveSubtitle(alert.code, alert.facts),
      severity: alert.severity,
      code: alert.code,
      sourceEntityId: alert.sourceEntityId,
      assetPrimaryLabel: _resolveAssetPrimaryLabel(alert.facts),
      assetSecondaryLabel: _resolveAssetSecondaryLabel(alert.facts),
      assetType: _resolveAssetType(alert.facts),
      actionLabel: _resolveActionLabel(alert.code),
      actionRoute: _resolveActionRoute(alert.code, alert.sourceEntityId),
      // Estado documental derivado desde AlertCode — fuente única de verdad.
      // La UI consume este campo para el badge; no infiere estado desde strings.
      docStatus: _resolveDocStatus(alert.code),
      // Campos estructurados para lógica temporal y sort (FleetAlertGrouper).
      // daysRemaining: fuente de verdad (int del evaluador, no parseo de strings).
      // expiryDate: solo display — puede ser null si el formato es inesperado.
      daysRemaining: _resolveDaysRemaining(alert.facts),
      expiryDate: _parseExpiryDate(alert.facts, alert.code),
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
  /// CRITERIO: CTA que inicia resolución real, no solo navegación informativa.
  ///
  /// OPERATIVO (flujo de resolución existente hoy):
  ///   rcExtracontractual* → 'Solicitar cotización' → /insurance/rc/quote/request
  ///
  /// INFORMATIVO (ruta de detalle, flujo de resolución pendiente):
  ///   soat*         → 'Cotizar SOAT'          → pendiente flujo cotización SOAT
  ///   rtm*          → 'Solicitar gestión RTM'  → pendiente flujo servicio RTM
  ///   rcContractual → 'Solicitar cotización'   → pendiente flujo RC contractual
  ///   legal*        → 'Solicitar revisión'     → pendiente flujo acompañamiento legal
  ///
  /// Null para códigos reservados sin ruta implementada en V1.
  static String? _resolveActionLabel(AlertCode code) => switch (code) {
        // INFORMATIVO — pendiente flujo cotización SOAT
        AlertCode.soatExpired || AlertCode.soatDueSoon => 'Ver estado SOAT',

        // INFORMATIVO — pendiente flujo servicio RTM
        AlertCode.rtmExpired ||
        AlertCode.rtmDueSoon ||
        AlertCode.rtmExempt =>
          'Ver estado RTM',

        // INFORMATIVO — pendiente flujo RC contractual
        AlertCode.rcContractualExpired ||
        AlertCode.rcContractualDueSoon ||
        AlertCode.rcContractualMissing =>
          'Ver póliza RC contractual',

        // OPERATIVO — flujo SRCE activo (/insurance/rc/quote/request)
        AlertCode.rcExtracontractualExpired ||
        AlertCode.rcExtracontractualDueSoon ||
        AlertCode.rcExtracontractualMissing ||
        AlertCode.rcExtracontractualOpportunity =>
          'Solicitar cotización RC',

        // INFORMATIVO — pendiente flujo acompañamiento legal
        AlertCode.embargoActive ||
        AlertCode.legalLimitationActive =>
          'Ver estado legal',

        _ => null,
      };

  /// Resuelve la ruta canónica de navegación para el CTA de acción.
  ///
  /// OPERATIVO hoy (flujo de resolución real abierto desde el CTA):
  ///   rcExtracontractual* → /insurance/rc/quote/request
  ///     Arguments: {assetId, primaryLabel, secondaryLabel} (sin vehicleSnapshot)
  ///     Compatible con el contrato de RcQuoteRequestPage.
  ///
  /// INFORMATIVO hoy (página de detalle — flujo de resolución pendiente):
  ///   soat*         → /asset/insurance/soat  (PENDIENTE: flujo cotización SOAT)
  ///   rtm*          → /asset/rtm/detail      (PENDIENTE: flujo servicio RTM)
  ///   rcContractual → /asset/insurance/rc    (PENDIENTE: flujo RC contractual)
  ///   legal*        → /asset/legal           (PENDIENTE: flujo legal)
  ///
  /// Null solo si [_resolveActionLabel] retorna null.
  static String? _resolveActionRoute(AlertCode code, String sourceEntityId) =>
      switch (code) {
        // INFORMATIVO — detalle SOAT (pendiente flujo cotización)
        AlertCode.soatExpired ||
        AlertCode.soatDueSoon =>
          '/asset/insurance/soat',

        // INFORMATIVO — detalle RTM (pendiente flujo servicio)
        AlertCode.rtmExpired ||
        AlertCode.rtmDueSoon ||
        AlertCode.rtmExempt =>
          '/asset/rtm/detail',

        // INFORMATIVO — detalle RC contractual (pendiente flujo cotización)
        AlertCode.rcContractualExpired ||
        AlertCode.rcContractualDueSoon ||
        AlertCode.rcContractualMissing =>
          '/asset/insurance/rc',

        // OPERATIVO — flujo SRCE activo
        // Arguments pasados por AlertCenterPage y FleetAlertDetailPage:
        //   {assetId, primaryLabel, secondaryLabel} — compatibles con RcQuoteRequestPage
        AlertCode.rcExtracontractualExpired ||
        AlertCode.rcExtracontractualDueSoon ||
        AlertCode.rcExtracontractualMissing ||
        AlertCode.rcExtracontractualOpportunity =>
          '/insurance/rc/quote/request',

        // INFORMATIVO — detalle legal (pendiente flujo acompañamiento)
        AlertCode.embargoActive ||
        AlertCode.legalLimitationActive =>
          '/asset/legal',

        _ => null,
      };

  /// Deriva el estado documental desde [AlertCode].
  ///
  /// Fuente única de verdad para el badge de estado en la UI.
  /// Un código → un estado, sin ambigüedad, sin inferencia desde strings.
  static AlertDocStatus _resolveDocStatus(AlertCode code) => switch (code) {
        // Expirados — documento existió pero venció
        AlertCode.soatExpired ||
        AlertCode.rtmExpired ||
        AlertCode.rcContractualExpired ||
        AlertCode.rcExtracontractualExpired =>
          AlertDocStatus.expired,

        // Por vencer — dentro de la ventana de alerta
        AlertCode.soatDueSoon ||
        AlertCode.rtmDueSoon ||
        AlertCode.rcContractualDueSoon ||
        AlertCode.rcExtracontractualDueSoon =>
          AlertDocStatus.dueSoon,

        // Ausente — nunca contratado ni registrado
        AlertCode.rcContractualMissing ||
        AlertCode.rcExtracontractualMissing =>
          AlertDocStatus.missing,

        // Exento — por clasificación legal o regulatoria
        AlertCode.rtmExempt => AlertDocStatus.exempt,

        // Con restricción jurídica activa
        AlertCode.legalLimitationActive ||
        AlertCode.embargoActive =>
          AlertDocStatus.restricted,

        // Oportunidad comercial — no es alerta de cumplimiento
        AlertCode.rcExtracontractualOpportunity => AlertDocStatus.opportunity,

        // Reservados V1 — no deben llegar en producción
        _ => AlertDocStatus.unknown,
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

  // ─────────────────────────────────────────────────────────────────────────
  // CAMPOS TEMPORALES ESTRUCTURADOS
  // ─────────────────────────────────────────────────────────────────────────

  /// Extrae daysRemaining desde facts como int nullable.
  ///
  /// Fuente de verdad para lógica temporal y sort (FleetAlertGrouper).
  /// Calculado por los evaluadores de dominio — no depende de formato de fecha.
  /// Negativo si ya venció. Null si no aplica (legal, oportunidades, etc.).
  static int? _resolveDaysRemaining(Map<String, Object?> facts) {
    final v = facts[AlertFactKeys.daysRemaining];
    return v is int ? v : null;
  }

  /// Parsea expiryDate desde facts de forma defensiva.
  ///
  /// Solo acepta YYYY-MM-DD (primeros 10 chars de ISO 8601).
  /// Descarta timezone para evitar off-by-one UTC vs local.
  /// Retorna null (sin lanzar) ante cualquier formato inválido.
  /// Loguea en debug si el formato es inesperado o hay desalineación con
  /// daysRemaining.
  ///
  /// REGLA: solo usar para display — para lógica usar [_resolveDaysRemaining].
  static DateTime? _parseExpiryDate(
    Map<String, Object?> facts,
    AlertCode code,
  ) {
    final rawDate = facts[AlertFactKeys.expirationDate];
    final rawDays = facts[AlertFactKeys.daysRemaining];

    final parsed = _safeParseDateOnly(
      rawDate is String ? rawDate : null,
      code,
    );

    // DEBUG: detectar desalineación entre daysRemaining y expiryDate.
    // daysRemaining es la fuente de verdad — este check detecta inconsistencias
    // del backend que podrían afectar la coherencia visual.
    assert(() {
      if (parsed != null && rawDays is int) {
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        final dateIsFuture = parsed.isAfter(todayDate);
        if (dateIsFuture && rawDays < 0) {
          // ignore: avoid_print
          print(
            '[DomainAlertMapper] desalineación temporal: '
            'code=${code.wireName}, expiryDate=$rawDate (futura) '
            'pero daysRemaining=$rawDays (negativo). '
            'daysRemaining es la fuente de verdad.',
          );
        }
        if (!dateIsFuture && rawDays > 0) {
          // ignore: avoid_print
          print(
            '[DomainAlertMapper] desalineación temporal: '
            'code=${code.wireName}, expiryDate=$rawDate (pasada) '
            'pero daysRemaining=$rawDays (positivo). '
            'daysRemaining es la fuente de verdad.',
          );
        }
      }
      return true;
    }());

    return parsed;
  }

  /// Parsea un string de fecha aceptando solo el formato YYYY-MM-DD.
  ///
  /// Si el string tiene zona horaria o parte de tiempo (ISO completo), toma
  /// solo los primeros 10 caracteres. Valida el patrón antes de parsear.
  /// Retorna null y loguea en debug ante cualquier formato no reconocible.
  static DateTime? _safeParseDateOnly(String? raw, AlertCode code) {
    if (raw == null || raw.isEmpty) return null;

    // Normalizar: tomar solo los primeros 10 chars para descartar timezone/hora.
    final datePart = raw.length >= 10 ? raw.substring(0, 10) : raw;

    // Validar que el fragmento sea exactamente YYYY-MM-DD.
    final isValidFormat =
        RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(datePart);

    assert(() {
      if (!isValidFormat) {
        // ignore: avoid_print
        print(
          '[DomainAlertMapper] expirationDate formato inesperado: '
          'code=${code.wireName}, raw="$raw" (se esperaba YYYY-MM-DD)',
        );
      }
      return true;
    }());

    if (!isValidFormat) return null;

    // DateTime.tryParse nunca lanza — retorna null ante error residual.
    return DateTime.tryParse(datePart);
  }
}
