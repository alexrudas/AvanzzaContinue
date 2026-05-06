// ============================================================================
// lib/presentation/controllers/alerts/alert_center_controller.dart
// ALERT CENTER CONTROLLER — Vista global de alertas de la flota
//
// QUÉ HACE:
// - Carga TODAS las alertas de la org activa (sin filtro de promoción) vía
//   HomeAlertAggregationService.allAlertsForOrg().
// - Expone [alerts] (lista completa) y [filteredAlerts] (filtrado por
//   [activeFilter]) para consumo por AlertCenterPage.
// - Expone [refreshAlerts()] para pull-to-refresh.
// - Mantiene consistencia entre pipeline de dominio y filtros UI V1,
//   incluyendo RTM exenta (rtmExempt) dentro de la categoría Documentos.
//
// QUÉ NO HACE:
// - NO filtra con reglas de negocio — solo filtra por categoría UI.
// - NO evalúa alertas — recibe la lista del pipeline canónico.
// - NO importa data layer directamente.
// - NO resuelve navegación ni copy visual de las cards (eso vive en mapper/UI).
//
// PRINCIPIOS:
// - Constructor injection / acceso vía DIContainer — registrado en AlertCenterBinding.
// - [filteredAlerts] es un getter derivado de [alerts] + [activeFilter]:
//   sin estado adicional, sin listas paralelas.
// - Estado explícito mínimo: si no hay org activa, la lista se limpia para
//   evitar residuos visuales de una carga previa.
// - Fallo tolerante: ante error del pipeline, la pantalla no colapsa.
// - Observabilidad defensiva en debug: se deja traza útil de condiciones de
//   salida temprana y fallos operativos.
//
// ENTERPRISE NOTES:
// CREADO (2026-03): Fase 5.5 — Vista global AlertCenter V1.
//   Ver ALERTS_SYSTEM_V4.md §18 Fase 5.5.
// ACTUALIZADO (2026-03): Soporte categórico para AlertCode.rtmExempt.
// ACTUALIZADO (2026-03): Limpieza explícita de estado cuando no existe org activa.
// ACTUALIZADO (2026-03): Trazabilidad de debug reforzada en loadAlerts().
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/container.dart';
import '../../../domain/entities/alerts/alert_code.dart';
import '../../../domain/entities/alerts/alert_severity.dart';
import '../../alerts/mappers/domain_alert_mapper.dart';
import '../../alerts/viewmodels/alert_card_vm.dart';
import '../session_context_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FILTRO — categorías de la AlertCenterPage
// ─────────────────────────────────────────────────────────────────────────────

/// Categorías de filtro de la vista global de alertas.
///
/// Los valores [maintenance], [accounting] y [purchasing] están declarados
/// para Fase 6 — se renderizan disabled en la UI hasta que sus evaluadores
/// estén activos.
enum AlertCenterFilter {
  all,
  critical,
  documents,
  legal,

  /// Oportunidades comerciales (alertKind == opportunity).
  /// V1: rcExtracontractualOpportunity.
  opportunities,

  // Fase 6 — disabled en V1
  maintenance,
  accounting,
  purchasing;

  String get label => switch (this) {
        AlertCenterFilter.all => 'Todas',
        AlertCenterFilter.critical => 'Críticas',
        AlertCenterFilter.documents => 'Documentos',
        AlertCenterFilter.legal => 'Legal',
        AlertCenterFilter.opportunities => 'Oportunidades',
        AlertCenterFilter.maintenance => 'Mantenimiento',
        AlertCenterFilter.accounting => 'Contabilidad',
        AlertCenterFilter.purchasing => 'Compras',
      };

  /// Filtros habilitados en V1. Los demás se muestran disabled.
  bool get isEnabledInV1 => switch (this) {
        AlertCenterFilter.all ||
        AlertCenterFilter.critical ||
        AlertCenterFilter.documents ||
        AlertCenterFilter.legal ||
        AlertCenterFilter.opportunities =>
          true,
        _ => false,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// CONTROLLER
// ─────────────────────────────────────────────────────────────────────────────

/// Controller de la vista global de alertas de la flota.
///
/// Fuente:
/// [HomeAlertAggregationService.allAlertsForOrg()] — sin filtro de promoción.
/// Muestra todas las alertas activas del pipeline canónico.
///
/// NOTA DE DISEÑO:
/// Este controller mantiene un enfoque V1 sobrio: carga y filtra.
/// No agrega listas paralelas ni lógica de negocio.
/// La reactividad avanzada al cambio de org/contexto puede endurecerse en una
/// iteración posterior si el ciclo de vida real de la pantalla lo exige.
class AlertCenterController extends GetxController {
  // ── Estado observable ──────────────────────────────────────────────────────

  /// Todas las alertas de la org, ya mapeadas para presentation.
  ///
  /// Fuente:
  /// pipeline canónico via [HomeAlertAggregationService.allAlertsForOrg].
  final alerts = <AlertCardVm>[].obs;

  /// Flag simple de carga para spinner / pull-to-refresh.
  final isLoading = false.obs;

  /// Filtro activo de la UI.
  final activeFilter = AlertCenterFilter.all.obs;

  /// Código de alerta específico activo — drill-down desde el Home agrupado.
  ///
  /// Cuando es no-null, [filteredAlerts] ignora [activeFilter] y solo retorna
  /// las alertas cuyo [AlertCardVm.code] coincide. Se setea en [onInit] si
  /// [Get.arguments] coincide con un [AlertCode] válido. Se limpia
  /// automáticamente al invocar [setFilter] (interacción manual con chips).
  ///
  /// Diseño: NO se limpia en [loadAlerts] ni [refreshAlerts] — el drill-down
  /// debe sobrevivir a un pull-to-refresh para preservar el contexto del usuario.
  final Rx<AlertCode?> activeCodeFilter = Rx<AlertCode?>(null);

  // ── Dependencias ───────────────────────────────────────────────────────────

  /// Contexto de sesión actual.
  ///
  /// Se resuelve una vez por acceso a Get.find. Mantenerlo local a esta capa
  /// evita duplicar búsquedas por todo el método de carga.
  SessionContextController get _sessionContext =>
      Get.find<SessionContextController>();

  // ── Getters derivados ──────────────────────────────────────────────────────

  /// Alertas filtradas por [activeCodeFilter] (drill-down) o [activeFilter] (chips).
  ///
  /// Derivado puro: sin estado adicional, sin lista paralela.
  /// Prioridad:
  ///   1. [activeCodeFilter] != null → solo alertas con ese code exacto.
  ///   2. [activeFilter] → categoría de la UI (chips).
  List<AlertCardVm> get filteredAlerts {
    final all = alerts;

    // Prioridad 1: drill-down por código específico (entrada desde Home).
    // Ignora la categoría de chips mientras esté activo.
    final code = activeCodeFilter.value;
    if (code != null) {
      return all.where((v) => v.code == code).toList();
    }

    // Prioridad 2: filtro de categoría manual (chips).
    return switch (activeFilter.value) {
      AlertCenterFilter.all => all,
      AlertCenterFilter.critical =>
        all.where((v) => v.severity == AlertSeverity.critical).toList(),
      AlertCenterFilter.documents =>
        all.where((v) => _isDocumentCode(v.code)).toList(),
      AlertCenterFilter.legal =>
        all.where((v) => _isLegalCode(v.code)).toList(),
      AlertCenterFilter.opportunities =>
        all.where((v) => _isOpportunityCode(v.code)).toList(),

      // Fase 6 — sin evaluadores activos, lista siempre vacía en V1.
      AlertCenterFilter.maintenance ||
      AlertCenterFilter.accounting ||
      AlertCenterFilter.purchasing =>
        const [],
    };
  }

  /// Indica si no hay alertas cargadas actualmente.
  bool get isEmpty => alerts.isEmpty;

  /// Título resuelto del [activeCodeFilter], o null si no hay drill-down activo.
  ///
  /// Consumido por la UI para renderizar el banner *"Filtrando: X · Quitar"*.
  /// Reusa la fuente única de verdad para títulos de alertas
  /// ([DomainAlertMapper.resolveTitle]) — no duplica el switch.
  String? get activeCodeFilterLabel {
    final code = activeCodeFilter.value;
    if (code == null) return null;
    return DomainAlertMapper.resolveTitle(code);
  }

  // ── Ciclo de vida ──────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();

    // ── Parsing robusto del argumento de navegación ──────────────────────────
    //
    // Soporta tres formatos de String, en orden de prioridad:
    //   1. AlertCenterFilter.name habilitado en V1 (ej: 'opportunities')
    //      → setea activeFilter.
    //   2. AlertCode.name (camelCase Dart por defecto, ej: 'soatExpired')
    //      → setea activeCodeFilter (drill-down).
    //   3. AlertCode.wireName (snake_case wire-stable, ej: 'soat_expired')
    //      → setea activeCodeFilter (defensivo ante callers que envíen el
    //        contrato wire en lugar del .name).
    //
    // CONVENCIÓN DE MANTENIMIENTO: los nombres de AlertCenterFilter NO deben
    // colisionar con nombres de AlertCode. Si en el futuro se agrega un
    // AlertCode con el mismo .name que un filter (ej: AlertCode.documents),
    // filter tiene prioridad por orden de evaluación. Documentar el caso
    // antes de introducir colisiones.
    //
    // Cualquier valor no reconocido cae silenciosamente en
    // AlertCenterFilter.all (default) — coherente con el comportamiento previo.
    final arg = Get.arguments;
    if (arg is String && arg.isNotEmpty) {
      final filterMatch = _tryParseFilter(arg);
      if (filterMatch != null) {
        activeFilter.value = filterMatch;
      } else {
        final codeMatch = _tryParseAlertCode(arg);
        if (codeMatch != null) {
          activeCodeFilter.value = codeMatch;
        }
      }
    }

    // V1:
    // Carga inicial simple. Si más adelante se detecta que el contexto de
    // sesión/hidratación llega tarde en algunos flujos, este punto debe
    // evolucionar a workers reactivos (ever/debounce) sobre el contexto.
    loadAlerts();
  }

  // ── API pública ────────────────────────────────────────────────────────────

  /// Cambia el filtro activo de la UI.
  ///
  /// Los filtros de Fase 6 se ignoran mientras estén deshabilitados.
  /// Sale del modo drill-down: limpia [activeCodeFilter] cuando el usuario
  /// interactúa manualmente con los chips.
  void setFilter(AlertCenterFilter filter) {
    if (!filter.isEnabledInV1) return;
    // Drill-down y filtro manual son mutuamente excluyentes desde el punto de
    // vista de UX. Refresh y carga inicial NO limpian activeCodeFilter para
    // preservar el contexto del usuario en pull-to-refresh.
    activeCodeFilter.value = null;
    activeFilter.value = filter;
  }

  /// Recarga manual de alertas.
  Future<void> refreshAlerts() => loadAlerts();

  // ── Pipeline ───────────────────────────────────────────────────────────────

  /// Carga todas las alertas de la organización activa.
  ///
  /// Comportamiento:
  /// - Si no existe org activa: limpia estado visible y sale sin error.
  /// - Si el pipeline retorna alertas: las mapea a [AlertCardVm].
  /// - Si el pipeline falla: conserva la app estable y deja traza en debug.
  Future<void> loadAlerts() async {
    isLoading.value = true;

    try {
      final orgId = _sessionContext.user?.activeContext?.orgId;

      // CAMBIO IMPORTANTE:
      // Antes se hacía return silencioso dejando posible estado viejo o estado
      // ambiguo. Ahora limpiamos explícitamente la lista para que la pantalla
      // represente la realidad actual: no hay contexto activo evaluable.
      if (orgId == null || orgId.trim().isEmpty) {
        alerts.clear();

        assert(() {
          debugPrint(
            '[AlertCenter] loadAlerts skipped: no active org context available.',
          );
          return true;
        }());

        return;
      }

      final domainAlerts = await DIContainer()
          .homeAlertAggregationService
          .allAlertsForOrg(orgId);

      // Mapear en bloque mantiene el contrato presentation canónico:
      // DomainAlert -> AlertCardVm.
      final viewModels = DomainAlertMapper.fromDomainList(domainAlerts);

      alerts.assignAll(viewModels);

      assert(() {
        debugPrint(
          '[AlertCenter] loadAlerts ok: orgId=$orgId, '
          'domainAlerts=${domainAlerts.length}, viewModels=${viewModels.length}',
        );
        return true;
      }());
    } catch (e, st) {
      // En V1 mantenemos tolerancia al fallo para no bloquear la pantalla.
      // Se limpia la lista para evitar residuos de una carga previa que ya no
      // representan el estado actual del pipeline.
      alerts.clear();

      assert(() {
        debugPrint('[AlertCenter] loadAlerts failed: $e');
        debugPrint('$st');
        return true;
      }());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Helpers de parsing del argumento ───────────────────────────────────────

  /// Intenta resolver [arg] contra [AlertCenterFilter.name] habilitado en V1.
  ///
  /// Retorna null si no hay match. Iteración manual en lugar de
  /// `firstWhere` para evitar la excepción que lanza ese método cuando no
  /// encuentra elemento — fallback explícito al caller.
  static AlertCenterFilter? _tryParseFilter(String arg) {
    for (final f in AlertCenterFilter.values) {
      if (f.name == arg && f.isEnabledInV1) return f;
    }
    return null;
  }

  /// Intenta resolver [arg] contra [AlertCode], aceptando dos formatos:
  ///   - .name      → camelCase, default Dart (ej: 'soatExpired').
  ///   - .wireName  → snake_case, contrato wire-stable (ej: 'soat_expired').
  ///
  /// Defensivo ante callers que envíen cualquiera de los dos formatos.
  /// Retorna null si no hay match — el caller decide el fallback.
  static AlertCode? _tryParseAlertCode(String arg) {
    for (final c in AlertCode.values) {
      if (c.name == arg || c.wireName == arg) return c;
    }
    return null;
  }

  // ── Helpers de categoría ───────────────────────────────────────────────────

  /// Determina si un [AlertCode] pertenece a la categoría "Documentos".
  ///
  /// Incluye:
  /// - SOAT
  /// - RTM
  /// - RTM exenta
  /// - RC contractual / extracontractual
  ///
  /// NOTA:
  /// [AlertCode.rtmExempt] se considera documental porque sigue siendo un
  /// estado del documento/obligación RTM del activo, aunque no represente
  /// urgencia negativa.
  static bool _isDocumentCode(AlertCode code) => switch (code) {
        AlertCode.soatExpired ||
        AlertCode.soatDueSoon ||
        AlertCode.rtmExpired ||
        AlertCode.rtmDueSoon ||
        AlertCode.rtmExempt ||
        AlertCode.rcContractualExpired ||
        AlertCode.rcContractualDueSoon ||
        AlertCode.rcContractualMissing ||
        AlertCode.rcExtracontractualExpired ||
        AlertCode.rcExtracontractualDueSoon ||
        AlertCode.rcExtracontractualMissing =>
          true,
        // rcExtracontractualOpportunity es una oportunidad comercial —
        // se clasifica en la categoría Oportunidades, no en Documentos.
        _ => false,
      };

  /// Determina si un [AlertCode] pertenece a la categoría "Oportunidades".
  ///
  /// V1: solo rcExtracontractualOpportunity.
  /// Fase 6+: otros códigos de oportunidad comercial cuando se agreguen.
  static bool _isOpportunityCode(AlertCode code) => switch (code) {
        AlertCode.rcExtracontractualOpportunity => true,
        _ => false,
      };

  /// Determina si un [AlertCode] pertenece a la categoría "Legal".
  static bool _isLegalCode(AlertCode code) => switch (code) {
        AlertCode.embargoActive || AlertCode.legalLimitationActive => true,
        _ => false,
      };
}
