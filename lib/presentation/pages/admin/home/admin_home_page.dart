// lib/presentation/pages/admin/home/admin_home_page.dart
// ============================================================================
// AdminHomePage — UI Governance v1.0.5 (Enterprise-ready)
// ============================================================================
// - StatefulWidget con uiEvent listener registrado una sola vez en initState
// - Side-effects ejecutados en la vista (snackbar, navigation)
// - Widgets 100% presentacionales importados de admin_home_widgets.dart
// - NO SystemChrome manual (Theme global maneja Dark Mode)
// ============================================================================

import 'dart:ui';

import 'package:avanzza/domain/shared/enums/asset_type.dart';
import 'package:avanzza/presentation/widgets/modal/action_sheet_pro.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/alerts/alert_code.dart';
import '../../../../domain/entities/alerts/alert_severity.dart';
import '../../../../routes/app_routes.dart';
import '../../../alerts/mappers/domain_alert_mapper.dart';
import '../../../alerts/viewmodels/alert_card_vm.dart';
import '../../../config/empty_state_config.dart';
import '../../../controllers/admin/home/admin_home_controller.dart';
import '../../../widgets/common/empty_state_card.dart';
import 'admin_home_widgets.dart';

// ============================================================================
// PAGE
// ============================================================================

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late final AdminHomeController controller;
  Worker? _uiEventWorker;

  @override
  void initState() {
    super.initState();

    // Obtener controllers (ya registrados por AdminHomeBinding).
    // ActivationGateController retirado (2026-05): empty-state se maneja
    // dentro del flujo natural del shell con `EmptyStateCard`.
    controller = Get.find<AdminHomeController>();

    // UI Event Listener — registrado una sola vez
    _uiEventWorker = ever<AdminUiEvent?>(controller.uiEvent, _handleUiEvent);

    // NOTA: NO usar SystemChrome.setSystemUIOverlayStyle aquí.
    // El Theme global maneja status bar para soportar Dark Mode.
  }

  @override
  void dispose() {
    _uiEventWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Stack(
      children: [
        // --- FONDO AMBIENTAL ---
        Positioned(
          top: -50,
          right: -100,
          child: _AmbientLight(
            color: AdminHomeDS.accentStart.withValues(alpha: 0.1),
          ),
        ),
        Positioned(
          top: 300,
          left: -100,
          child: _AmbientLight(
            color: AdminHomeDS.accentEnd.withValues(alpha: 0.1),
          ),
        ),

        // --- CONTENIDO SCROLLABLE ---
        RefreshIndicator(
          onRefresh: controller.refreshData,
          color: cs.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Obx(() => _buildContent(context)),
          ),
        ),

        // --- FAB ---
        Positioned(
          bottom: 16,
          right: 16,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 2º FAB "Consultar" — solo en debug builds (kDebugMode).
              // No existe en release builds (compile-time stripped).
              if (kDebugMode) ...[
                _DiagnosticsFAB(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _showDiagnosticsSheet(context);
                  },
                ),
                const SizedBox(width: 10),
              ],
              AdminPremiumFAB(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  _showNewOperationSheet(context);
                },
              ),
            ],
          ),
        ),

        // ActivationGateOverlay retirado (2026-05). El empty-state se
        // maneja dentro del propio contenido del Home vía `EmptyStateCard`
        // (más abajo en `_buildContent`) — sin overlay bloqueante.
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (controller.loading.value) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (controller.error.value != null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: cs.error),
              const SizedBox(height: 16),
              Text(
                controller.error.value!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: controller.refreshData,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    // Empty State: usuario sin activos en el contexto activo.
    //
    // Bajo el modelo nuevo (2026-05) el `ActivationGateOverlay` fue
    // retirado — este empty-state inline es el ÚNICO mecanismo de
    // "todavía no tienes activos" en el Home. El CTA del card lleva al
    // flujo de registro. No bloquea la navegación al resto del shell.
    if (controller.assetsCount.value == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 32,
        ),
        child: EmptyStateCard(
          config: EmptyStateConfig.home,
          onCtaPressed: controller.goToAssetsPage,
          scrollSafe: false,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        AdminHeaderSection(
          greeting: controller.greeting,
          shortDate: controller.shortDate,
          userName: controller.userName,
          activeWorkspace: controller.activeWorkspace,
          hasMultipleWorkspaces: controller.hasMultipleWorkspaces,
          onWorkspaceTap: controller.hasMultipleWorkspaces
              ? () => _showWorkspaceSelector(context)
              : null,
        ),

        const SizedBox(height: 0),

        // Quick Actions
        AdminQuickActionsRow(
          onGpsTap: () {
            HapticFeedback.mediumImpact();
            controller.showFeatureUnavailable('GPS');
          },
          onPublicarTap: () {
            HapticFeedback.mediumImpact();
            controller.showFeatureUnavailable('Publicar');
          },
          onSolicitudesTap: () {
            HapticFeedback.mediumImpact();
            controller.showFeatureUnavailable('Solicitudes');
          },
          onEmergenciasTap: () {
            HapticFeedback.heavyImpact();
            controller.showFeatureUnavailable('Emergencias');
          },
        ),

        const SizedBox(height: 20),

        // ────────────────────────────────────────────────────────────────────
        // ALERTAS Y RIESGOS — bloque único tipo lista agrupada (iOS-like).
        //
        // Fusiona las 3 fuentes del controller en GRUPOS por tipo de alerta,
        // no por entidad individual. Cada fila representa "un tipo" con su
        // contador de activos afectados (no N filas iguales por N vehículos).
        //
        //   - controller.promotedAlertVms   (compliance: SOAT/RTM/RC/legal)
        //   - controller.opportunityAlertVms (oportunidad: rcExtracontractualOpportunity)
        //   - controller.alerts              (operacionales — ya son agregadas)
        //
        // Buckets especiales:
        //   - rcExtracontractualOpportunity → "Riesgo patrimonial"
        //   - rcContractual* + rcExtracontractual* (excepto opportunity) →
        //     "RC obligatorio pendiente" (multi-code combinado).
        //
        // Resto compliance: 1 grupo por code, título canónico desde mapper.
        // Operacionales: pasan directo (no requieren agrupación).
        //
        // Top 3 por criticidad. Si total > 3 → "Ver todos". Si lista vacía
        // → tile único "Todo está bajo control".
        // ────────────────────────────────────────────────────────────────────
        Obx(() {
          final groups = _buildAlertGroups(cs);
          final totalCount = groups.length;
          final visible = groups.take(3).toList();

          // Subtítulo del header interno: resumen agregado del estado.
          // - Sin grupos → null (el tile interno "Todo está bajo control"
          //   ya comunica el estado, sin redundar en el header).
          // - Con grupos → "{n} elemento(s) requiere(n) atención".
          final headerSubtitle = totalCount == 0
              ? null
              : '$totalCount ${totalCount == 1 ? "elemento requiere" : "elementos requieren"} atención';

          return AdminListBlock(
            title: 'Alertas y riesgos',
            subtitle: headerSubtitle,
            trailing:
                totalCount > 3 ? _buildSeeAllButton(context) : null,
            children: visible.isEmpty
                ? [
                    AdminListBlockTile(
                      icon: Icons.check_circle_rounded,
                      iconColor: cs.primary,
                      title: 'Todo está bajo control',
                      subtitle:
                          'No tienes tareas pendientes en este momento',
                    ),
                  ]
                : visible
                    .map((g) => AdminListBlockTile(
                          icon: g.icon,
                          iconColor: g.iconColor,
                          title: g.title,
                          subtitle: g.subtitle,
                          onTap: g.onTap,
                        ))
                    .toList(),
          );
        }),

        const SizedBox(height: 18),

        // ────────────────────────────────────────────────────────────────────
        // RESUMEN — bloque único tipo lista agrupada.
        // Bloque informativo (no de urgencia): sin colores de severidad
        // dramatizados. Muestra los KPIs visibles (Activos + Egresos del mes,
        // según _getVisibleKpis()). El valor numérico va en trailing.
        // ────────────────────────────────────────────────────────────────────
        AdminListBlock(
          title: 'Resumen',
          subtitle: 'Vista general de tu operación',
          children: _getVisibleKpis()
              .map((kpi) => AdminListBlockTile(
                    icon: _getKpiIcon(kpi.label),
                    iconColor: _getKpiColor(kpi.label, cs),
                    title: kpi.label,
                    subtitle: _getKpiSubtitle(kpi.label),
                    trailing: Text(
                      _formatKpiValue(kpi),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onTap: () => _handleKpiTap(kpi.label),
                  ))
              .toList(),
        ),
        const SizedBox(height: 18),

        // NOTA: la sección "Mis Portafolios de activos" se reubicó a
        // AssetListPage (Routes.assets) debajo del listado de tipos. La
        // suscripción a watchActivePortfoliosByOrg se conserva en
        // AdminHomeController porque sigue alimentando uniqueOwnersCount.

        // Red Operativa Section
        const AdminSectionTitle(title: 'Mi red operativa'),
        const SizedBox(height: 4),
        Text(
          'Actores vinculados a mi operación',
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 14),
        Obx(() => AdminPersonasDashboard(
          onPropietariosTap: () {
            HapticFeedback.lightImpact();
            Get.toNamed(Routes.networkOperational);
          },
          onArrendatariosTap: () => _handlePersonaTap('Arrendatarios'),
          onDirectorioTap: () => _showDirectorioSheet(context),
          ownersCount: controller.uniqueOwnersCount,
        )),

        const SizedBox(height: 80), // Espacio para el FAB
      ],
    );
  }

  // ============================================================================
  // UI EVENT HANDLER (side-effects)
  // ============================================================================

  void _handleUiEvent(AdminUiEvent? event) {
    if (event == null || !mounted) return;

    final messenger = ScaffoldMessenger.maybeOf(context);

    switch (event.type) {
      case AdminUiEventType.snackbar:
        messenger
          ?..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(event.message ?? ''),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
            ),
          );
        break;

      case AdminUiEventType.redirect:
        Get.toNamed(event.route!, arguments: event.arguments);
        break;

      case AdminUiEventType.snackbarAndRedirect:
        messenger
          ?..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(event.message ?? ''),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
            ),
          );

        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          Get.toNamed(event.route!, arguments: event.arguments);
        });
        break;
    }

    controller.uiEvent.value = null;
  }

  // ============================================================================
  // HELPERS — ALERTAS Y RIESGOS (agrupación por tipo)
  // ============================================================================

  /// Construye los grupos de alertas para el bloque "Alertas y riesgos".
  ///
  /// Agrupación por tipo de alerta (no por activo individual):
  ///   - rcExtracontractualOpportunity → bucket "Riesgo patrimonial".
  ///   - rcContractual* + rcExtracontractual* (excepto opportunity) →
  ///     bucket "RC obligatorio pendiente" (multi-code combinado).
  ///   - Resto compliance (SOAT/RTM/legal/embargo) → 1 grupo por code,
  ///     título canónico desde [DomainAlertMapper.resolveTitle].
  ///   - Operacionales (controller.alerts) → pasan directo, ya son agregados.
  ///
  /// Conteo: vehículos únicos por [AlertCardVm.sourceEntityId] dentro del
  /// grupo. Un activo con SOAT y RC vencidos cuenta dos veces (en grupos
  /// distintos) pero una sola vez dentro de cada grupo.
  ///
  /// Subtítulo:
  ///   - count == 1 → [AlertCardVm.assetPrimaryLabel] (placa, dirección, etc.).
  ///   - count >  1 → "{n} {label}" donde label es vehículos / inmuebles /
  ///                  activos según [_labelForGroup].
  ///   - Bucket opportunity agrega el sufijo "sin protección".
  ///
  /// Tap:
  ///   - count == 1 → ruta del único VM (preserva flujo de detalle).
  ///   - count >  1 → AlertCenter con `code.name` como argumento (drill-down).
  ///   - Bucket RC compliance multi-code → fallback `'documents'` (V1 no
  ///     soporta filtros multi-code; documentado en auditoría).
  ///
  /// Orden:
  ///   - 0..6   compliance documental (severity max → criticality).
  ///   - 100    opportunity (siempre tras compliance).
  ///   - 200+   operacionales (200 + priority del VM).
  List<_AlertGroup> _buildAlertGroups(ColorScheme cs) {
    final groups = <_AlertGroup>[];
    // Indigo canónico de oportunidades (preserva color del sistema).
    const indigoOpportunity = Color(0xFF6366F1);

    // 1) PARTICIONAR promotedAlertVms en RC compliance vs resto compliance.
    final rcComplianceItems = <AlertCardVm>[];
    final restComplianceByCode = <AlertCode, List<AlertCardVm>>{};

    for (final vm in controller.promotedAlertVms) {
      if (_isRcComplianceCode(vm.code)) {
        rcComplianceItems.add(vm);
      } else {
        restComplianceByCode.putIfAbsent(vm.code, () => []).add(vm);
      }
    }

    // 2) BUCKET ESPECIAL — "RC obligatorio pendiente" (multi-code combinado).
    if (rcComplianceItems.isNotEmpty) {
      groups.add(_buildRcComplianceGroup(rcComplianceItems, cs));
    }

    // 3) RESTO COMPLIANCE — 1 grupo por code (SOAT, RTM, legal, embargo).
    for (final entry in restComplianceByCode.entries) {
      groups.add(_buildComplianceGroupForCode(entry.key, entry.value, cs));
    }

    // 4) BUCKET ESPECIAL — "Riesgo patrimonial" (oportunidades).
    final opportunities = controller.opportunityAlertVms
        .where((v) => v.code == AlertCode.rcExtracontractualOpportunity)
        .toList();
    if (opportunities.isNotEmpty) {
      groups.add(_buildOpportunityGroup(opportunities, indigoOpportunity));
    }

    // 5) BUCKET ESPECIAL — "Documentos por vencer" (tracking 8–30 días).
    //
    // Canal informativo, NO urgente: agrega a nivel CONCEPTUAL (no por code).
    // SOAT/RTM/RC compliance con vencimiento próximo se cuentan juntos como
    // un único ítem "Documentos por vencer · N vehículos" — no se desglosan
    // como filas separadas. Disjunto con compliance urgente (≤7d) por
    // construcción del filtro en _loadTrackingDocs.
    final tracking = controller.trackingDocsVms.toList();
    if (tracking.isNotEmpty) {
      groups.add(_buildTrackingDocsGroup(tracking, cs));
    }

    // 6) OPERACIONALES — sin agrupación (ya son agregados naturales).
    // Criticality 200 + priority para garantizar que queden tras opportunity.
    for (final vm in controller.alerts) {
      final color = switch (vm.priority) {
        1 => cs.error,
        2 => cs.tertiary,
        _ => cs.primary,
      };
      groups.add(_AlertGroup(
        icon: _operationalIconFor(vm.title),
        iconColor: color,
        title: vm.title,
        subtitle: vm.subtitle,
        criticality: 200 + vm.priority,
        onTap: () {
          HapticFeedback.lightImpact();
          Get.toNamed(vm.route, arguments: vm.arguments);
        },
      ));
    }

    groups.sort((a, b) => a.criticality.compareTo(b.criticality));
    return groups;
  }

  /// Construye el grupo "RC obligatorio pendiente" — bucket multi-code.
  ///
  /// Combina rcContractual* + rcExtracontractual* (excepto opportunity).
  /// Tap multi-code cae en filtro 'documents' del AlertCenter (deuda V1).
  _AlertGroup _buildRcComplianceGroup(
    List<AlertCardVm> items,
    ColorScheme cs,
  ) {
    final uniqueAssets = items.map((v) => v.sourceEntityId).toSet();
    final n = uniqueAssets.length;
    final isSingle = n == 1;
    final maxSev = _maxSeverity(items);

    final subtitle = isSingle
        ? items.first.assetPrimaryLabel
        : '$n ${_labelForGroup(items)}';

    final onTap = isSingle
        ? _tapForSingleVm(items.first)
        : () {
            HapticFeedback.lightImpact();
            // V1: AlertCenter no soporta filtros multi-code.
            // Fallback a la categoría 'documents' (incluye SOAT/RTM/RC).
            // Documentado en auditoría — abrir issue para
            // AlertCenterFilter.rcCompliance dedicado.
            Get.toNamed(Routes.alertCenter, arguments: 'documents');
          };

    return _AlertGroup(
      icon: Icons.shield_outlined,
      iconColor: cs.error,
      title: 'RC obligatorio pendiente',
      subtitle: subtitle,
      criticality: _severityIndex(maxSev),
      onTap: onTap,
    );
  }

  /// Construye un grupo compliance para un [AlertCode] específico.
  ///
  /// Aplica a SOAT, RTM, embargo, legal — cualquier code que no sea RC.
  /// Tap: count==1 → actionRoute del VM; count>1 → AlertCenter con code.name.
  _AlertGroup _buildComplianceGroupForCode(
    AlertCode code,
    List<AlertCardVm> items,
    ColorScheme cs,
  ) {
    final uniqueAssets = items.map((v) => v.sourceEntityId).toSet();
    final n = uniqueAssets.length;
    final isSingle = n == 1;
    final maxSev = _maxSeverity(items);

    final subtitle = isSingle
        ? items.first.assetPrimaryLabel
        : '$n ${_labelForGroup(items)}';

    final onTap = isSingle
        ? _tapForSingleVm(items.first)
        : () {
            HapticFeedback.lightImpact();
            // Drill-down: AlertCenter filtra por este code específico.
            Get.toNamed(Routes.alertCenter, arguments: code.name);
          };

    return _AlertGroup(
      icon: _iconForComplianceCode(code),
      iconColor: _colorForSeverity(maxSev, cs),
      title: DomainAlertMapper.resolveTitle(code),
      subtitle: subtitle,
      criticality: _severityIndex(maxSev),
      onTap: onTap,
    );
  }

  /// Construye el grupo "Documentos por vencer" — bucket conceptual único.
  ///
  /// Agregación a nivel de activo (no por code): SOAT, RTM, RC contractual y
  /// extracontractual con vencimiento próximo (8–30d) se cuentan juntos como
  /// un único ítem en el Home. El usuario ve "qué vigilar", sin ruido de
  /// múltiples filas SOAT/RTM separadas.
  ///
  /// Contraste con [promotedAlertVms]: este bucket es **seguimiento**, no
  /// urgencia. Color tertiary (ámbar/info), no error. Lo urgente sigue
  /// expresándose por separado en sus propios grupos compliance.
  ///
  /// Tap → AlertCenter con filtro 'documents' (vista global de la categoría
  /// documental). V1 no soporta un filtro multi-code dedicado para tracking;
  /// el filtro 'documents' es el aproximado más fiel disponible hoy.
  _AlertGroup _buildTrackingDocsGroup(
    List<AlertCardVm> items,
    ColorScheme cs,
  ) {
    final uniqueAssets = items.map((v) => v.sourceEntityId).toSet();
    final n = uniqueAssets.length;
    final isSingle = n == 1;

    final subtitle = isSingle
        ? items.first.assetPrimaryLabel
        : '$n ${_labelForGroup(items)}';

    return _AlertGroup(
      icon: Icons.event_note_outlined,
      // Tertiary = ámbar/info en el theme. Reforzado conceptualmente: este
      // bucket NO es urgencia, es vigilancia. Mezclarlo con cs.error sería
      // engañar al usuario sobre la severidad real.
      iconColor: cs.tertiary,
      title: 'Documentos por vencer',
      subtitle: subtitle,
      // Criticidad fija 50 — entre compliance urgente (0..6) y opportunity
      // (100). Refleja: "más relevante que Riesgo patrimonial pero menos
      // que un SOAT vencido". No depende de severities individuales porque
      // todos los items aquí son `low` por construcción del rango temporal.
      criticality: 50,
      onTap: () {
        HapticFeedback.lightImpact();
        // V1: AlertCenter no expone un filtro dedicado "tracking 8–30d".
        // 'documents' es la categoría más cercana — incluye urgentes y
        // tracking, pero el usuario aterriza en la vista correcta para
        // explorar el detalle por activo. Deuda explícita en auditoría.
        Get.toNamed(Routes.alertCenter, arguments: 'documents');
      },
    );
  }

  /// Construye el grupo "Riesgo patrimonial" — oportunidades comerciales.
  ///
  /// Solo aplica a [AlertCode.rcExtracontractualOpportunity] en V1.
  /// Sufijo "sin protección" en el subtítulo refuerza copy comercial.
  _AlertGroup _buildOpportunityGroup(
    List<AlertCardVm> items,
    Color indigo,
  ) {
    final uniqueAssets = items.map((v) => v.sourceEntityId).toSet();
    final n = uniqueAssets.length;
    final isSingle = n == 1;

    final subtitle = isSingle
        ? '${items.first.assetPrimaryLabel} sin protección'
        : '$n ${_labelForGroup(items)} sin protección';

    final onTap = isSingle
        ? _tapForSingleVm(items.first)
        : () {
            HapticFeedback.lightImpact();
            Get.toNamed(
              Routes.alertCenter,
              arguments: AlertCode.rcExtracontractualOpportunity.name,
            );
          };

    return _AlertGroup(
      icon: Icons.lightbulb_outline_rounded,
      iconColor: indigo,
      title: 'Riesgo patrimonial',
      // Criticality fija — siempre tras compliance, antes de operacionales.
      criticality: 100,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  // ── Helpers de agrupación ───────────────────────────────────────────────

  /// True si el code es RC compliance (cualquier rcContractual* o
  /// rcExtracontractual* salvo opportunity). Define el bucket multi-code.
  static bool _isRcComplianceCode(AlertCode code) => switch (code) {
        AlertCode.rcContractualMissing ||
        AlertCode.rcContractualExpired ||
        AlertCode.rcContractualDueSoon ||
        AlertCode.rcExtracontractualMissing ||
        AlertCode.rcExtracontractualExpired ||
        AlertCode.rcExtracontractualDueSoon =>
          true,
        _ => false,
      };

  /// Máxima severidad presente en una lista de VMs.
  ///
  /// Comparación ordinal vía AlertSeverity.index (low=0 < critical=3).
  /// Retorna AlertSeverity.low si la lista está vacía (no debería ocurrir).
  static AlertSeverity _maxSeverity(Iterable<AlertCardVm> items) {
    var max = AlertSeverity.low;
    for (final i in items) {
      if (i.severity.index > max.index) max = i.severity;
    }
    return max;
  }

  /// Mapea severidad a índice de criticidad para orden visual del bloque.
  /// Menor índice = mayor urgencia.
  static int _severityIndex(AlertSeverity s) => switch (s) {
        AlertSeverity.critical => 0,
        AlertSeverity.high => 2,
        AlertSeverity.medium => 4,
        AlertSeverity.low => 6,
      };

  /// Color del icono para un grupo según severidad máxima.
  Color _colorForSeverity(AlertSeverity s, ColorScheme cs) => switch (s) {
        AlertSeverity.critical || AlertSeverity.high => cs.error,
        AlertSeverity.medium => cs.tertiary,
        AlertSeverity.low => cs.primary,
      };

  /// Icono canónico por categoría de code compliance (no aplica a RC ni
  /// opportunity, que usan icono fijo del bucket especial).
  IconData _iconForComplianceCode(AlertCode code) => switch (code) {
        AlertCode.soatExpired ||
        AlertCode.soatDueSoon =>
          Icons.security_rounded,
        AlertCode.rtmExpired ||
        AlertCode.rtmDueSoon ||
        AlertCode.rtmExempt =>
          Icons.fact_check_outlined,
        AlertCode.embargoActive ||
        AlertCode.legalLimitationActive =>
          Icons.gavel_rounded,
        _ => Icons.warning_amber_rounded,
      };

  /// Etiqueta plural dinámica para un grupo según [AlertCardVm.assetType].
  ///
  /// - todos vehicle      → "vehículos"
  /// - todos real_estate  → "inmuebles"
  /// - mezcla / fallback  → "activos"
  ///
  /// Conscientemente no se cubre maquinaria/equipo en V1: el copy del
  /// producto nunca los plurariza por separado. Caen en "activos".
  static String _labelForGroup(Iterable<AlertCardVm> items) {
    final types = items.map((v) => v.assetType).toSet();
    if (types.length != 1) return 'activos';
    final type = types.first;
    return switch (type) {
      'vehicle' => 'vehículos',
      'real_estate' => 'inmuebles',
      _ => 'activos',
    };
  }

  /// Construye el callback de tap para un grupo de un solo VM.
  ///
  /// Usa [AlertCardVm.actionRoute] si existe (preserva flujo de detalle).
  /// Si no hay ruta específica, fallback a AlertCenter sin filtro.
  VoidCallback _tapForSingleVm(AlertCardVm vm) => () {
        HapticFeedback.lightImpact();
        if (vm.actionRoute != null) {
          Get.toNamed(
            vm.actionRoute!,
            arguments: {
              'assetId': vm.sourceEntityId,
              'primaryLabel': vm.assetPrimaryLabel,
              'secondaryLabel': vm.assetSecondaryLabel,
            },
          );
        } else {
          Get.toNamed(Routes.alertCenter);
        }
      };

  /// Asocia un icono a cada alerta operacional a partir de su título.
  /// Match por substring porque el título es la fuente de verdad del VM
  /// (no hay un enum de tipo en AdminAiAlertVM).
  IconData _operationalIconFor(String title) {
    if (title.contains('Incidencias')) return Icons.report_problem_outlined;
    if (title.contains('Programaciones')) return Icons.calendar_month_outlined;
    if (title.contains('Compras')) return Icons.shopping_cart_outlined;
    return Icons.warning_amber_rounded;
  }

  /// Botón "Ver todos" del header de Alertas y riesgos. Solo se renderiza
  /// cuando hay más de 3 grupos. Navega al centro unificado de alertas.
  Widget _buildSeeAllButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        Get.toNamed(Routes.alertCenter);
      },
      style: TextButton.styleFrom(
        foregroundColor: cs.primary,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text(
        'Ver todos',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  // ============================================================================
  // HELPERS — LEGACY (mantenidos hasta limpieza posterior)
  // ============================================================================

  /// @Deprecated — sustituido por el bloque tipo lista de Estado operativo.
  /// Se conserva temporalmente para no remover lógica hasta confirmar que no
  /// se usa en otro flujo. Eliminar en una pasada posterior si sigue sin uso.
  // ignore: unused_element
  Widget _buildOperationalStatusCard() {
    final alert = controller.topAlert;

    if (alert != null) {
      // HAY ALERTAS: mostrar variante alert
      return AdminOperationalStatusCard(
        pendingCount: controller.pendingAlertsCount,
        title: alert.title,
        subtitle: alert.subtitle,
        variant: AdminStatusCardVariant.alert,
        onTap: () {
          HapticFeedback.lightImpact();
          controller.openTopAlert();
        },
      );
    } else {
      // NO HAY ALERTAS: mostrar variante ok
      return const AdminOperationalStatusCard(
        pendingCount: 0,
        title: 'Todo está bajo control',
        subtitle: 'No tienes tareas pendientes en este momento',
        variant: AdminStatusCardVariant.ok,
        onTap: null,
      );
    }
  }

  /// Filtra KPIs visibles (solo Activos y Egresos del mes).
  /// Fallback: si kpis está vacío, retorna ceros para garantizar visibilidad.
  List<AdminKpiVM> _getVisibleKpis() {
    const visibleLabels = {'Activos', 'Egresos del mes'};
    final filtered = controller.kpis
        .where((kpi) => visibleLabels.contains(kpi.label))
        .toList();
    if (filtered.isNotEmpty) return filtered;
    // Fallback determinista: siempre 2 tarjetas con ceros
    return const [
      AdminKpiVM(label: 'Activos', value: 0),
      AdminKpiVM(label: 'Egresos del mes', value: 0, suffix: '\$'),
    ];
  }

  String _getKpiSubtitle(String label) {
    switch (label) {
      case 'Activos':
        return 'Unidades registradas';
      case 'Incidencias':
        return 'Pendientes de atención';
      case 'Programaciones':
        return 'Mantenimientos agendados';
      case 'Compras abiertas':
        return 'Solicitudes activas';
      case 'Egresos del mes':
        return 'Gastos acumulados';
      default:
        return '';
    }
  }

  String _formatKpiValue(AdminKpiVM kpi) {
    if (kpi.suffix == '\$') {
      return '\$${_formatNumber(kpi.value)}';
    }
    return kpi.value.toString();
  }

  String _formatNumber(num value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  IconData _getKpiIcon(String label) {
    switch (label) {
      case 'Activos':
        return Icons.inventory_2_outlined;
      case 'Incidencias':
        return Icons.warning_amber_outlined;
      case 'Programaciones':
        return Icons.calendar_month_outlined;
      case 'Compras abiertas':
        return Icons.shopping_cart_outlined;
      case 'Egresos del mes':
        return Icons.trending_down_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getKpiColor(String label, ColorScheme cs) {
    switch (label) {
      case 'Activos':
        return cs.primary;
      case 'Incidencias':
        return cs.error;
      case 'Programaciones':
        return cs.tertiary;
      case 'Compras abiertas':
        return cs.secondary;
      case 'Egresos del mes':
        return cs.tertiary;
      default:
        return cs.primary;
    }
  }

  void _handleKpiTap(String label) {
    HapticFeedback.lightImpact();

    // Caso especial: "Activos" → siempre muestra bottom sheet
    // (el sheet adapta título y botón secundario según hasAssets)
    if (label == 'Activos') {
      _showEmptyAssetsSheet(context);
      return;
    }

    switch (label) {
      case 'Incidencias':
        controller.goToNewMaintenance();
        break;
      case 'Programaciones':
        controller.goToNewMaintenance();
        break;
      case 'Compras abiertas':
        controller.goToNewPurchase();
        break;
      case 'Egresos del mes':
        controller.goToNewAccountingEntry();
        break;
    }
  }

  /// Muestra bottom sheet de empty state para activos.
  /// Botón secundario dinámico:
  /// - assetsCount == 0 → "Ahora no" (dismiss)
  /// - assetsCount > 0  → "Ver activos" (navega a lista)
  void _showEmptyAssetsSheet(BuildContext context) {
    final hasAssets = controller.hasAssets;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (ctx) => AdminEmptyStateActionSheetContent(
        title: hasAssets ? 'Registrar nuevo activo' : 'Aún no tienes activos',
        subtitle: hasAssets
            ? 'Elige el tipo de activo que deseas registrar'
            : 'Registra tu primer activo para comenzar a operar',
        primaryCta: 'Registrar activo',
        secondaryCta: hasAssets ? 'Ver activos' : 'Ahora no',
        icon: Icons.inventory_2_outlined,
        onClose: () => Navigator.of(ctx).pop(),
        onSecondary: () {
          Navigator.of(ctx).pop();
          if (hasAssets) {
            controller.goToAssetsPage();
          }
        },
        onPrimary: () {
          Navigator.of(ctx).pop();
          _showAssetTypeSelectorSheet(context);
        },
      ),
    );
  }

  /// Muestra selector de tipo de activo usando ActionSheetPro
  void _showAssetTypeSelectorSheet(BuildContext context) {
    ActionSheetPro.show(
      context,
      title: 'Selecciona el tipo de activo',
      data: [
        ActionSection(
          header: 'Elige la categoría para tu primer registro',
          items: AssetRegistrationType.values
              .map(
                (type) => ActionItem(
                  label: type.displayName,
                  icon: type.icon,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.of(context).pop(); // Cerrar ActionSheet
                    controller.openCreateAssetWizard(type);
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  void _handlePersonaTap(String tipo) {
    HapticFeedback.lightImpact();
    controller.showFeatureUnavailable(tipo);
  }

  // ============================================================================
  // MODALS
  // ============================================================================

  void _showWorkspaceSelector(BuildContext context) {
    HapticFeedback.lightImpact();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final availableRoles = controller.availableRoles;
    String selectedWorkspace = controller.activeWorkspace;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Título
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cambiar espacio de trabajo',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Selecciona uno para continuar',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 24),

                // Lista de workspaces
                ...availableRoles.map((role) {
                  final isSelected = selectedWorkspace == role;
                  final isCurrent = role == controller.activeWorkspace;

                  return RadioListTile<String>(
                    value: role,
                    groupValue: selectedWorkspace,
                    onChanged: (value) {
                      if (value != null) {
                        HapticFeedback.selectionClick();
                        setState(() => selectedWorkspace = value);
                      }
                    },
                    title: Row(
                      children: [
                        Text(
                          role,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Actual',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    activeColor: cs.primary,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  );
                }),

                const Divider(height: 24),

                // Botones
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            if (selectedWorkspace !=
                                controller.activeWorkspace) {
                              controller.changeWorkspace(selectedWorkspace);
                            }
                          },
                          child: const Text('Cambiar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDirectorioSheet(BuildContext context) {
    HapticFeedback.mediumImpact();

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'Mi red operativa',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: cs.outline.withValues(alpha: 0.12)),

                // Opciones
                // PROVEEDORES — Primer rostro visible del arquetipo transversal
                // comercial/servicio. Navega al directorio dedicado que
                // comparte fuente de verdad (LocalContactRepository) con el
                // selector de Pedidos. Cualquier alta/edición/eliminación
                // aquí se refleja en el selector y viceversa sin refresh.
                _DirectoryOption(
                  icon: Icons.store_rounded,
                  title: 'Proveedores',
                  subtitle: 'Suministro de productos o insumos',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Get.toNamed(Routes.providersDirectory);
                  },
                ),
                _DirectoryOption(
                  icon: Icons.engineering_rounded,
                  title: 'Técnicos',
                  subtitle: 'Personal de mantenimiento',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _handlePersonaTap('Técnicos');
                  },
                ),
                _DirectoryOption(
                  icon: Icons.business_rounded,
                  title: 'Oficina',
                  subtitle: 'Equipo administrativo',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _handlePersonaTap('Oficina');
                  },
                ),
                _DirectoryOption(
                  icon: Icons.gavel_rounded,
                  title: 'Abogado',
                  subtitle: 'Asesoría legal',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _handlePersonaTap('Abogado');
                  },
                ),
                _DirectoryOption(
                  icon: Icons.folder_shared_rounded,
                  title: 'Otros',
                  subtitle: 'Contactos adicionales',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _handlePersonaTap('Otros');
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNewOperationSheet(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // Header
                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '¿Qué deseas registrar?',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Selecciona una opción para registrar.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: cs.outline.withValues(alpha: 0.12)),

                // Opciones
                _DirectoryOption(
                  icon: Icons.commute,
                  title: 'Activos',
                  subtitle: 'Registra activos tipo vehículos, inmuebes, etc',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _showAssetTypeSelectorSheet(context);
                  },
                ),
                _DirectoryOption(
                  icon: Icons.build_outlined,
                  title: 'Mantenimiento',
                  subtitle: 'Reportar incidencia o programar servicio',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    controller.goToNewMaintenance();
                  },
                ),
                _DirectoryOption(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Compra',
                  subtitle: 'Solicitar cotización de productos',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    controller.goToNewPurchase();
                  },
                ),
                _DirectoryOption(
                  icon: Icons.receipt_long_outlined,
                  title: 'Asiento contable',
                  subtitle: 'Registrar ingreso o egreso',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    controller.goToNewAccountingEntry();
                  },
                ),
                _DirectoryOption(
                  icon: Icons.campaign_outlined,
                  title: 'Broadcast',
                  subtitle: 'Enviar comunicación masiva',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    controller.goToBroadcast();
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// DEV-only — Sheet de diagnóstico Integrations API (RUNT/SIMIT).
  /// Visible únicamente en kDebugMode. Las pantallas de destino consumen
  /// los endpoints individuales sin VRC, sin caché Isar y sin Firestore.
  void _showDiagnosticsSheet(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Diagnóstico Integrations API',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'DEV · consulta directa sin VRC ni persistencia.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: cs.outline.withValues(alpha: 0.12)),
                _DirectoryOption(
                  icon: Icons.person_search_outlined,
                  title: 'RUNT Persona',
                  subtitle: 'Licencias y estado del conductor',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Get.toNamed(Routes.devRuntPersonDiagnostic);
                  },
                ),
                _DirectoryOption(
                  icon: Icons.directions_car_outlined,
                  title: 'RUNT Vehículo',
                  subtitle: 'Identificación, SOAT, RTM, limitaciones',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Get.toNamed(Routes.devRuntVehicleDiagnostic);
                  },
                ),
                _DirectoryOption(
                  icon: Icons.account_balance_outlined,
                  title: 'SIMIT Persona',
                  subtitle: 'Comparendos y multas por documento',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Get.toNamed(Routes.devSimitPersonDiagnostic);
                  },
                ),
                _DirectoryOption(
                  icon: Icons.receipt_long_outlined,
                  title: 'SIMIT Vehículo',
                  subtitle: 'Comparendos y multas por placa',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Get.toNamed(Routes.devSimitVehicleDiagnostic);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// FAB compacto DEV-only para el sheet de diagnóstico Integrations API.
/// Vive a la izquierda del FAB principal "Registrar".
///
/// Reutiliza [AdminBottomActionButton] en variante secondary para compartir
/// la geometría y el lenguaje visual con "Registrar". Antes era un widget
/// con estilos hardcodeados (radius 30, elevation 4, w700/0.3) que rompía
/// la conversación visual con el navbar nuevo.
class _DiagnosticsFAB extends StatelessWidget {
  final VoidCallback onTap;
  const _DiagnosticsFAB({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AdminBottomActionButton(
      icon: Icons.search_rounded,
      label: 'Consultar',
      onTap: onTap,
      variant: AdminBottomActionVariant.secondary,
      tooltip: 'Consultar (DEV)',
      semanticsLabel: 'Diagnóstico Integrations API (DEV)',
    );
  }
}

// ============================================================================
// PRIVATE TYPES (solo usados en esta página)
// ============================================================================

/// Modelo interno para un grupo de alertas del bloque "Alertas y riesgos".
///
/// Cada grupo representa **un tipo de alerta agregado** (por code o por
/// bucket especial), no una alerta individual por activo. Lo construye
/// [_buildAlertGroups] a partir de las 3 fuentes del controller:
///
///   - controller.promotedAlertVms   (compliance — bucket RC + 1 grupo por code)
///   - controller.opportunityAlertVms (bucket "Riesgo patrimonial")
///   - controller.alerts              (operacionales — pasan directo)
///
/// El campo [criticality] es la única fuente de orden — menor índice
/// significa mayor urgencia. El subtítulo ya viene resuelto por el helper
/// (count + label dinámico, o assetPrimaryLabel cuando count == 1).
class _AlertGroup {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final int criticality;
  final VoidCallback? onTap;

  const _AlertGroup({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.criticality,
    this.onTap,
  });
}

// ============================================================================
// PRIVATE WIDGETS (solo usados en esta página)
// ============================================================================

/// Luz ambiental de fondo
class _AmbientLight extends StatelessWidget {
  final Color color;
  const _AmbientLight({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

/// Card de resumen de alertas de compliance (SOAT, RTM, RC, legal).
/// Distinta de AdminOperationalStatusCard (incidencias/compras).
/// Tap navega al centro de alertas.
///
/// @Deprecated — sustituida por el bloque tipo lista de Estado operativo
/// que fusiona compliance + oportunidades + operacionales. Se conserva
/// hasta confirmar que no se usa en otro flujo o limpieza posterior.
// ignore: unused_element
class _AdminAlertsSummaryCard extends StatelessWidget {
  final int total;
  final int critical;
  final int affectedAssets;
  final VoidCallback onTap;

  const _AdminAlertsSummaryCard({
    required this.total,
    required this.critical,
    required this.affectedAssets,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hasCritical = critical > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasCritical
              ? cs.errorContainer.withValues(alpha: 0.5)
              : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasCritical
                ? cs.error.withValues(alpha: 0.4)
                : cs.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasCritical
                  ? Icons.warning_rounded
                  : Icons.notifications_active_rounded,
              color: hasCritical ? cs.error : cs.primary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    total == 0
                        ? 'Sin alertas'
                        : '$total ${total == 1 ? 'ALERTA' : 'ALERTAS'}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: hasCritical ? cs.error : cs.onSurface,
                    ),
                  ),
                  Text(
                    _subtitle(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasCritical)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: cs.error,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$critical crítica${critical == 1 ? '' : 's'}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onError,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded,
                    color: cs.onSurfaceVariant, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _subtitle() {
    final parts = <String>[];
    if (affectedAssets > 0) {
      parts
          .add('$affectedAssets ${affectedAssets == 1 ? 'activo' : 'activos'}');
    }
    if (critical > 0) {
      parts.add('requieren atención');
    }
    return parts.isNotEmpty ? parts.join(' · ') : 'Ver centro de alertas';
  }
}

/// Card de oportunidades comerciales (alertKind == opportunity).
///
/// Distinta de [_AdminAlertsSummaryCard] (compliance).
/// Estilo indigo/comercial — no transmite urgencia sino valor.
/// Tap navega al Alert Center con filtro Oportunidades preseleccionado.
///
/// @Deprecated — sustituida por el bloque tipo lista de Estado operativo
/// que fusiona compliance + oportunidades + operacionales. Se conserva
/// hasta confirmar que no se usa en otro flujo o limpieza posterior.
// ignore: unused_element
class _AdminOpportunitiesCard extends StatelessWidget {
  final int count;
  final String summaryText;
  final VoidCallback onTap;

  const _AdminOpportunitiesCard({
    required this.count,
    required this.summaryText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const indigo = Color(0xFF6366F1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: indigo.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: indigo.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.lightbulb_outline_rounded,
              color: indigo,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count ${count == 1 ? 'RIESGO PATRIMONIAL' : 'RIESGO PATRIMONIAL'}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: indigo,
                    ),
                  ),
                  if (summaryText.isNotEmpty)
                    Text(
                      summaryText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              'Ver',
              style: theme.textTheme.labelLarge?.copyWith(
                color: indigo,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded, color: indigo, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Opción del modal de directorio
class _DirectoryOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DirectoryOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surface,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: cs.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
