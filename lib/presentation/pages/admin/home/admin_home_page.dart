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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../application/services/accounting/accounting_outbox_sync_service.dart';
import '../../../../core/auth/auth_state_observer.dart';
import '../../../../domain/entities/accounting/accounting_event.dart';
import '../../../../infrastructure/isar/repositories/isar_accounting_event_repository.dart';
import '../../../config/empty_state_config.dart';
import '../../../controllers/activation/activation_gate_controller.dart';
import '../../../controllers/admin/home/admin_home_controller.dart';
import '../../../widgets/activation/activation_gate_overlay.dart';
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
  late final ActivationGateController _gateCtrl;
  Worker? _uiEventWorker;

  @override
  void initState() {
    super.initState();

    // Obtener controllers (ya registrados por AdminHomeBinding)
    controller = Get.find<AdminHomeController>();
    _gateCtrl = Get.find<ActivationGateController>();

    // UI Event Listener — registrado una sola vez
    _uiEventWorker = ever<AdminUiEvent?>(controller.uiEvent, _handleUiEvent);

    // NOTA: NO usar SystemChrome.setSystemUIOverlayStyle aquí.
    // El Theme global maneja status bar para soportar Dark Mode.
  }

  // ============================================================================
  // SMOKE TEST — DEBUG ONLY
  // ============================================================================

  /// Prueba end-to-end del pipeline Outbox:
  /// 1. Crea un AccountingEvent único (entityId con timestamp → sin prevHash).
  /// 2. appendAtomic → queda en Outbox como pending.
  /// 3. Espera máximo 15 s a que el worker lo marque synced/error.
  /// 4. Muestra snackbar con resultado.
  ///
  /// Solo activo en kDebugMode. Requiere que el worker esté corriendo
  /// (AccountingOutboxSyncService registrado en GetX).
  Future<void> _runOutboxSmokeTest() async {
    if (!kDebugMode) return;

    final repo = Get.find<IsarAccountingEventRepository>();
    final ts = DateTime.now().microsecondsSinceEpoch;
    final eventId = 'smoke_evt_$ts';
    final entityId = 'ar_debug_smoke_$ts';
    final now = DateTime.now();

    // Diagnóstico: estado del DI antes de insertar el evento.
    final workerReg = Get.isRegistered<AccountingOutboxSyncService>(
        tag: 'accounting_outbox_sync');
    final observerReg = Get.isRegistered<AuthStateObserver>();
    debugPrint(
      '[P2D][Outbox][Smoke][Start] eventId=$eventId entityId=$entityId '
      'workerReg=$workerReg observerReg=$observerReg',
    );

    // Si el worker está registrado: confirmar identidad y vitalidad del loop.
    if (workerReg) {
      final worker =
          Get.find<AccountingOutboxSyncService>(tag: 'accounting_outbox_sync');
      debugPrint(
        '[P2D][Outbox][Smoke][Diag] '
        'workerHash=${worker.hashCode} '
        'tickCount=${worker.debugTickCount()}',
      );
    }

    Get.snackbar(
      'Smoke Test',
      'Enviando evento $eventId…',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
    );

    try {
      final event = AccountingEvent(
        id: eventId,
        entityType: 'account_receivable',
        entityId: entityId,
        eventType: 'ar_collection_recorded',
        occurredAt: now,
        recordedAt: now,
        actorId: 'debug_worker',
        // saldoInicialCop → _initProjection fija saldoActualCop = 10000
        // totalIngresadoCop = 3000, saldoFinalCop = 10000 - 3000 = 7000
        // sumSplits (3000) == totalIngresadoCop (3000) ✓
        payload: const {
          'saldoInicialCop': 10000,
          'splits': [
            {'montoCop': 3000}
          ],
          'totalIngresadoCop': 3000,
          'saldoFinalCop': 7000,
        },
      );
      await repo.appendAtomic(event);
    } catch (e, st) {
      debugPrint('[P2D][Outbox][Smoke][FAIL] appendAtomic error: $e');
      debugPrint('StackTrace: $st');
      final msg = e.toString();
      final preview = msg.length > 150 ? '${msg.substring(0, 150)}…' : msg;
      Get.snackbar(
        'Smoke Test — Error',
        preview,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        duration: const Duration(seconds: 8),
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    debugPrint(
        '[P2D][Outbox][Smoke][Inserted] eventId=$eventId status=pending');

    // Polling: hasta 15 intentos × 1 s.
    for (var i = 0; i < 15; i++) {
      await Future.delayed(const Duration(seconds: 1));
      final snap = await repo.getDebugOutboxSnapshot(eventId);
      final status = snap?['status'] as String?;

      debugPrint(
        '[P2D][Outbox][Smoke][Poll] t=${i + 1} '
        'status=${snap?['status'] ?? 'null'} '
        'lockBy=${snap?['lockedBy'] ?? 'null'} '
        'retry=${snap?['retryCount'] ?? 'null'} '
        'err=${snap?['lastError'] ?? 'null'}',
      );

      if (status == 'synced') {
        debugPrint(
          '[P2D][Outbox][Smoke][DONE][OK] eventId=$eventId t=${i + 1}',
        );
        Get.snackbar(
          'Smoke Test — OK ✓',
          'Evento sincronizado en ${i + 1}s',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      if (status == 'error') {
        debugPrint(
          '[P2D][Outbox][Smoke][DONE][NACK] eventId=$eventId t=${i + 1}',
        );
        Get.snackbar(
          'Smoke Test — NACK',
          'Evento en estado error tras ${i + 1}s',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade100,
          colorText: Colors.orange.shade900,
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(16),
        );
        return;
      }
    }

    debugPrint('[P2D][Outbox][Smoke][DONE][TIMEOUT] eventId=$eventId');
    Get.snackbar(
      'Smoke Test — Timeout',
      'Evento $eventId no sincronizado tras 15s',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.amber.shade100,
      colorText: Colors.amber.shade900,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(16),
    );
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
          child: AdminPremiumFAB(
            onTap: () {
              HapticFeedback.mediumImpact();
              _showNewOperationSheet(context);
            },
          ),
        ),

        // --- ACTIVATION GATE OVERLAY ---
        // Capa topmost: bloquea acceso al Home hasta que el usuario registre
        // su primer activo. Controlado reactivamente por ActivationGateController.
        Obx(() {
          if (!_gateCtrl.showGate.value) return const SizedBox.shrink();
          return Positioned.fill(
            child: ActivationGateOverlay(
              config: _gateCtrl.config.value,
              onPrimaryAction: _gateCtrl.onCtaPressed,
              onDismiss: _gateCtrl.dismissForSession,
            ),
          );
        }),
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

    // Empty State: el gate fue descartado y el usuario aún no tiene activos.
    // El gate (Tarea 1) cubre el caso de primer acceso; este cubre el re-ingreso
    // cuando showGate == false pero assetsCount sigue siendo 0.
    if (controller.assetsCount.value == 0 && !_gateCtrl.showGate.value) {
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

        const SizedBox(height: 26),

        // ────────────────────────────────────────────────────────────────────
        // ESTADO OPERATIVO (siempre visible)
        // ────────────────────────────────────────────────────────────────────
        const AdminSectionTitle(title: 'Estado operativo'),
        const SizedBox(height: 12),
        _buildOperationalStatusCard(),
        const SizedBox(height: 24),

        // KPIs Section — SIEMPRE VISIBLE (Activos + Egresos del mes)
        const AdminSectionTitle(title: 'Resumen'),
        const SizedBox(height: 14),
        ..._getVisibleKpis().map((kpi) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AdminAssetCategoryCard(
                title: kpi.label,
                subtitle: _getKpiSubtitle(kpi.label),
                value: _formatKpiValue(kpi),
                icon: _getKpiIcon(kpi.label),
                color: _getKpiColor(kpi.label, cs),
                onTap: () => _handleKpiTap(kpi.label),
              ),
            )),
        const SizedBox(height: 14),

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
        AdminPersonasDashboard(
          onPropietariosTap: () => _handlePersonaTap('Propietarios'),
          onArrendatariosTap: () => _handlePersonaTap('Arrendatarios'),
          onDirectorioTap: () => _showDirectorioSheet(context),
        ),

        // DEBUG ONLY — smoke test del pipeline Outbox
        if (kDebugMode) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _runOutboxSmokeTest(),
            icon: const Icon(Icons.science_outlined, size: 18),
            label: const Text('Run Outbox Smoke Test'),
          ),
        ],

        const SizedBox(height: 80), // Espacio para el FAB
      ],
    );
  }

  // ============================================================================
  // UI EVENT HANDLER (side-effects)
  // ============================================================================

  void _handleUiEvent(AdminUiEvent? event) {
    if (event == null) return;

    switch (event.type) {
      case AdminUiEventType.snackbar:
        Get.snackbar(
          event.title!,
          event.message!,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
        );
        break;

      case AdminUiEventType.redirect:
        Get.toNamed(event.route!, arguments: event.arguments);
        break;

      case AdminUiEventType.snackbarAndRedirect:
        Get.snackbar(
          event.title!,
          event.message!,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.toNamed(event.route!, arguments: event.arguments);
        });
        break;
    }

    // Limpiar evento después de manejarlo (evita re-ejecución)
    controller.uiEvent.value = null;
  }

  // ============================================================================
  // HELPERS
  // ============================================================================

  /// Construye la tarjeta de estado operativo según alertas
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
          items: AssetType.values
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
                _DirectoryOption(
                  icon: Icons.store_rounded,
                  title: 'Proveedores',
                  subtitle: 'Suministro de productos o insumos',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _handlePersonaTap('Proveedores');
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'Nuevo',
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
