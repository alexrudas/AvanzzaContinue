// ============================================================================
// lib/presentation/tenant/pages/tenant_home_page.dart
// ============================================================================
// TenantHomePage — REDISEÑO PRO 2025
// ============================================================================

import 'package:avanzza/presentation/widgets/ai_banner/ai_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ============================================================================
// DESIGN TOKENS PRO 2025
// ============================================================================
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
}

class AppElevation {
  static List<BoxShadow> sm(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> md(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> lg(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> colored(Color color, double alpha) => [
        BoxShadow(
          color: color.withValues(alpha: alpha),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];
}

// ============================================================================
// THEME EXTENSIONS
// ============================================================================
@immutable
class SemanticColors extends ThemeExtension<SemanticColors> {
  final Color critical;
  final Color criticalContainer;
  final Color warning;
  final Color warningContainer;
  final Color success;
  final Color successContainer;
  final Color info;
  final Color infoContainer;

  const SemanticColors({
    required this.critical,
    required this.criticalContainer,
    required this.warning,
    required this.warningContainer,
    required this.success,
    required this.successContainer,
    required this.info,
    required this.infoContainer,
  });

  factory SemanticColors.from(ColorScheme cs) => SemanticColors(
        critical: const Color(0xFFEF4444),
        criticalContainer: const Color(0xFFFEE2E2),
        warning: const Color(0xFFF59E0B),
        warningContainer: const Color(0xFFFEF3C7),
        success: const Color(0xFF10B981),
        successContainer: const Color(0xFFD1FAE5),
        info: cs.primary,
        infoContainer: cs.primaryContainer,
      );

  @override
  SemanticColors copyWith({
    Color? critical,
    Color? criticalContainer,
    Color? warning,
    Color? warningContainer,
    Color? success,
    Color? successContainer,
    Color? info,
    Color? infoContainer,
  }) =>
      SemanticColors(
        critical: critical ?? this.critical,
        criticalContainer: criticalContainer ?? this.criticalContainer,
        warning: warning ?? this.warning,
        warningContainer: warningContainer ?? this.warningContainer,
        success: success ?? this.success,
        successContainer: successContainer ?? this.successContainer,
        info: info ?? this.info,
        infoContainer: infoContainer ?? this.infoContainer,
      );

  @override
  ThemeExtension<SemanticColors> lerp(
      ThemeExtension<SemanticColors>? other, double t) {
    if (other is! SemanticColors) return this;
    return SemanticColors(
      critical: Color.lerp(critical, other.critical, t)!,
      criticalContainer:
          Color.lerp(criticalContainer, other.criticalContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
    );
  }
}

// ============================================================================
// UTILS
// ============================================================================
class Formatters {
  static String money(num value) {
    final f =
        NumberFormat.currency(locale: 'es_CO', symbol: r'$', decimalDigits: 0);
    return f.format(value);
  }

  static String dayShort(DateTime date) {
    final f = DateFormat('EEE, d MMM', 'es_CO');
    final s = f.format(date);
    return s[0].toUpperCase() + s.substring(1);
  }

  static String weekdayLong(DateTime date) {
    final f = DateFormat('EEEE', 'es_CO');
    final s = f.format(date);
    return s[0].toUpperCase() + s.substring(1);
  }

  static String timeOfDay(DateTime date) {
    final hour = date.hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  static String relativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}m';
      }
      return '${diff.inHours}h';
    }
    if (diff.inDays == 1) return 'Mañana';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat('d MMM', 'es_CO').format(date);
  }
}

class Analytics {
  static void track(String event, [Map<String, dynamic>? props]) {
    debugPrint('📊 Analytics: $event ${props ?? ""}');
  }
}

class Routes {
  static const paymentsPending = '/payments/pending';
  static const picoPlacaCalendar = '/traffic/restrictions';
  static const tasksAll = '/tasks';
  static const rentalsAll = '/rentals';
  static const notifications = '/notifications';
  static const profile = '/profile';

  // Emergencias / soporte
  static const emergencyCai = '/emergency/cai';
  static const emergencyAmbulance = '/emergency/ambulance';
  static const emergencyFirefighters = '/emergency/firefighters';
  static const emergencyTow = '/emergency/tow';
  static const accidentGuide = '/emergency/accident-guide';
  static const techHelp = '/support/tech-help';
  static const callInsurance = '/support/insurance-help';
  static const legalHelp = '/support/legal-help';
  static const onlineAssistance = '/support/online-assistance';
}

// ============================================================================
// VIEW MODELS
// ============================================================================
class TaskVM {
  final String id;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final DateTime? dueDate;
  final bool isUrgent;
  final bool isCompleted;

  TaskVM({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.dueDate,
    this.isUrgent = false,
    this.isCompleted = false,
  });

  String get dueLabel {
    if (dueDate == null) return '';
    return Formatters.relativeTime(dueDate!);
  }
}

class RentalVM {
  final String id;
  final String icon;
  final String type;
  final String name;
  final String details;
  final bool hasPendingPayment;
  final int pendingInvoices;
  final num nextPaymentAmount;
  final DateTime? nextPaymentDate;

  RentalVM({
    required this.id,
    required this.icon,
    required this.type,
    required this.name,
    required this.details,
    required this.hasPendingPayment,
    required this.pendingInvoices,
    required this.nextPaymentAmount,
    this.nextPaymentDate,
  });

  String get dueDateLabel {
    if (nextPaymentDate == null) return '';
    final now = DateTime.now();
    final diff = nextPaymentDate!.difference(now);

    if (diff.inDays == 0) return 'Vence hoy';
    if (diff.inDays < 0) return 'Pago inmediato';
    if (diff.inDays == 1) return 'Vence mañana';
    return Formatters.dayShort(nextPaymentDate!);
  }

  bool get isOverdue {
    if (nextPaymentDate == null) return false;
    return nextPaymentDate!.isBefore(DateTime.now());
  }
}

class UrgentPaymentVM {
  final num amount;
  final String concept;
  final DateTime dueDate;
  final String vehicleName;

  UrgentPaymentVM({
    required this.amount,
    required this.concept,
    required this.dueDate,
    required this.vehicleName,
  });

  String get timeRemaining {
    final now = DateTime.now();
    final diff = dueDate.difference(now);

    if (diff.inHours < 0) return 'Vencido';
    if (diff.inHours == 0) return 'Vence en ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'Vence en ${diff.inHours}h';
    return 'Vence hoy';
  }

  bool get isOverdue => dueDate.isBefore(DateTime.now());
}

// ============================================================================
// CONTROLLER
// ============================================================================
class TenantHomeController extends GetxController {
  final userName = 'Alexander'.obs;
  final now = DateTime.now().obs;
  final notificationsCount = 3.obs;

  // Urgent Payment
  final urgentPayment = Rxn<UrgentPaymentVM>();

  // Pico y Placa
  final picoPlacaActive = false.obs;
  final picoPlacaCity = 'Barranquilla'.obs;

  // Tasks
  final tasks = <TaskVM>[].obs;
  final showAllTasks = false.obs;

  // Rentals
  final rentals = <RentalVM>[].obs;

  // AI Messages
  final aiMessages = <AIBannerMessage>[].obs;

  // Online assistance subscription
  final assistanceSubscribed = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    urgentPayment.value = UrgentPaymentVM(
      amount: 450000,
      concept: 'Arriendo',
      dueDate: DateTime.now().add(const Duration(hours: 2)),
      vehicleName: 'Hyundai Grand i10',
    );

    tasks.value = [
      TaskVM(
        id: '1',
        icon: Icons.local_gas_station_rounded,
        iconColor: const Color(0xFFEF4444),
        title: 'Pagar arriendo del vehículo',
        subtitle: '🚗 Hyundai Grand i10',
        dueDate: DateTime.now().add(const Duration(hours: 2)),
        isUrgent: true,
      ),
      TaskVM(
        id: '2',
        icon: Icons.build_rounded,
        iconColor: const Color(0xFFF59E0B),
        title: 'Revisar equipo de carretera',
        subtitle: '🚗 Hyundai Grand i10',
        dueDate: DateTime.now().add(const Duration(hours: 6)),
      ),
      TaskVM(
        id: '3',
        icon: Icons.engineering_rounded,
        iconColor: const Color(0xFF3B82F6),
        title: 'Llevar el carro al taller',
        subtitle: '🚗 Hyundai Grand i10',
        dueDate: DateTime.now().add(const Duration(hours: 9)),
      ),
    ];

    rentals.value = [
      RentalVM(
        id: '1',
        icon: '🚗',
        type: 'Vehículo',
        name: 'Hyundai Grand i10',
        details: 'WPV-584 • 2018',
        hasPendingPayment: true,
        pendingInvoices: 1,
        nextPaymentAmount: 450000,
        nextPaymentDate: DateTime.now().add(const Duration(hours: 2)),
      ),
      RentalVM(
        id: '2',
        icon: '🏠',
        type: 'Inmueble',
        name: 'Casa en San José',
        details: 'Calle 45 # 19-54',
        hasPendingPayment: false,
        pendingInvoices: 0,
        nextPaymentAmount: 980000,
        nextPaymentDate: DateTime.now().add(const Duration(days: 15)),
      ),
    ];

    aiMessages.value = [
      AIBannerMessage(
        type: AIMessageType.warning,
        icon: Icons.gavel_rounded,
        title: 'Tienes 3 multas vigentes.',
        subtitle: 'Verifica',
      ),
      AIBannerMessage(
        type: AIMessageType.info,
        icon: Icons.trending_up_rounded,
        title: 'Morosidad en 6.3%',
      ),
      AIBannerMessage(
        type: AIMessageType.success,
        icon: Icons.lightbulb_outline_rounded,
        title: 'Tip:  ahorra 2%',
      ),
      AIBannerMessage(
        type: AIMessageType.critical,
        icon: Icons.lightbulb_outline_rounded,
        title: 'Tip: Programa pagos',
      ),
    ];
  }

  String get greeting => Formatters.timeOfDay(now.value);
  String get todayLabel => Formatters.dayShort(now.value);
  String get picoPlacaLabel => picoPlacaActive.value
      ? '🔴 Pico y Placa HOY en ${picoPlacaCity.value}'
      : 'Sin restricción vehicular en ${picoPlacaCity.value}';

  int get urgentTasksCount =>
      tasks.where((t) => t.isUrgent && !t.isCompleted).length;
  int get totalTasksCount => tasks.where((t) => !t.isCompleted).length;

  List<TaskVM> get visibleTasks =>
      showAllTasks.value ? tasks : tasks.take(3).toList();

  void toggleTasksView() {
    showAllTasks.value = !showAllTasks.value;
    HapticFeedback.selectionClick();
  }

  void goToPayment() {
    HapticFeedback.mediumImpact();
    Analytics.track('urgent_payment_tap');
    Get.toNamed(Routes.paymentsPending);
  }

  void goToNotifications() {
    HapticFeedback.lightImpact();
    Analytics.track('notifications_tap');
    Get.toNamed(Routes.notifications);
  }

  void goToProfile() {
    HapticFeedback.lightImpact();
    Analytics.track('profile_tap');
    Get.toNamed(Routes.profile);
  }

  void onTaskTap(TaskVM task) {
    HapticFeedback.selectionClick();
    Analytics.track('task_tap', {'task_id': task.id});
  }

  void onRentalTap(RentalVM rental) {
    HapticFeedback.selectionClick();
    Analytics.track('rental_tap', {'rental_id': rental.id});
  }

  void onAIMessageTap() {
    HapticFeedback.lightImpact();
    Analytics.track('ai_banner_tap');
  }

  // --- Emergencias actions (placeholder navigations) ---
  void openCai() {
    HapticFeedback.mediumImpact();
    Analytics.track('emergency_cai');
    Get.toNamed(Routes.emergencyCai);
  }

  void callAmbulance() {
    HapticFeedback.mediumImpact();
    Analytics.track('emergency_ambulance');
    Get.toNamed(Routes.emergencyAmbulance);
  }

  void callFirefighters() {
    HapticFeedback.mediumImpact();
    Analytics.track('emergency_firefighters');
    Get.toNamed(Routes.emergencyFirefighters);
  }

  void requestTow() {
    HapticFeedback.mediumImpact();
    Analytics.track('emergency_tow');
    Get.toNamed(Routes.emergencyTow);
  }

  void openAccidentGuide() {
    HapticFeedback.lightImpact();
    Analytics.track('accident_guide');
    Get.toNamed(Routes.accidentGuide);
  }

  void registerCallInsurance() {
    HapticFeedback.lightImpact();
    Analytics.track('accident_guide');
    Get.toNamed(Routes.callInsurance);
  }

  void openLegalHelp() {
    HapticFeedback.lightImpact();
    Analytics.track('accident_guide');
    Get.toNamed(Routes.legalHelp);
  }

  void openTechHelp() {
    HapticFeedback.lightImpact();
    Analytics.track('tech_help');
    Get.toNamed(Routes.techHelp);
  }

  void openOnlineAssistance() {
    HapticFeedback.lightImpact();
    Analytics.track('online_assistance');
    Get.toNamed(Routes.onlineAssistance);
  }
}

// ============================================================================
// PAGE
// ============================================================================
class TenantHomePage extends GetView<TenantHomeController> {
  const TenantHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TenantHomeController());

    final theme = Theme.of(context);
    final semantic = theme.extension<SemanticColors>() ??
        SemanticColors.from(theme.colorScheme);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, theme),

          // IA Banner con margen superior/lateral
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 0),
            sliver: SliverAIBanner(
              messages: controller.aiMessages,
              showHeader: false,
              rotationInterval: const Duration(seconds: 5),
              onTap: controller.onAIMessageTap,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildQuickStats(context, theme, semantic),
                const SizedBox(height: AppSpacing.md),
                _buildRentalsSection(context, theme, semantic),
                const SizedBox(height: AppSpacing.xxxl * 2),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // APP BAR
  // ==========================================================================
  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    final cs = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 110,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cs.primary, cs.primary.withValues(alpha: 0.85)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.md,
              ),
              child: Obx(() {
                final greeting = controller.greeting;
                final name = controller.userName.value;
                final today = controller.todayLabel;
                final urgentCount = controller.urgentTasksCount;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                greeting,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onPrimary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                name,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: cs.onPrimary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Row(
                                children: [
                                  Text(
                                    today,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color:
                                          cs.onPrimary.withValues(alpha: 0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (urgentCount > 0) ...[
                                    const SizedBox(width: AppSpacing.sm),
                                    Text('•',
                                        style: TextStyle(
                                            color: cs.onPrimary
                                                .withValues(alpha: 0.6))),
                                    const SizedBox(width: AppSpacing.sm),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.sm,
                                        vertical: AppSpacing.xs / 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEF4444),
                                        borderRadius:
                                            BorderRadius.circular(AppRadius.sm),
                                      ),
                                      child: Text(
                                        '$urgentCount urgente${urgentCount > 1 ? "s" : ""}',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            _buildHeaderIconButton(
                              context: context,
                              icon: Icons.notifications_outlined,
                              onTap: controller.goToNotifications,
                              badgeCount: controller.notificationsCount.value,
                              cs: cs,
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            _buildHeaderIconButton(
                              context: context,
                              icon: Icons.person_outline_rounded,
                              onTap: controller.goToProfile,
                              cs: cs,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIconButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
    required ColorScheme cs,
    int? badgeCount,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.onPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: cs.onPrimary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(icon, color: cs.onPrimary, size: 22),
            ),
          ),
        ),
        if (badgeCount != null && badgeCount > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ==========================================================================
  // QUICK STATS
  // ==========================================================================
  Widget _buildQuickStats(
    BuildContext context,
    ThemeData theme,
    SemanticColors semantic,
  ) {
    final cs = theme.colorScheme;

    return Obx(() {
      final totalTasks = controller.totalTasksCount;
      const dayOff = 'Dom.'; // etiqueta breve

      return Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.task_alt_rounded,
              label: 'Tareas',
              value: '$totalTasks',
              color: semantic.info,
              theme: theme,
              onTap: () => _showTasksModal(context, theme, semantic),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _StatCard(
              icon: Icons.calendar_month_rounded,
              label: 'Descanso',
              value: dayOff,
              color: cs.tertiary,
              theme: theme,
              onTap: () => _showRestDaysModal(context, theme, semantic),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _StatCard(
              icon: Icons.emergency_share_rounded,
              label: 'Emergencias',
              value: 'S.O.S',
              color: semantic.warning,
              theme: theme,
              onTap: () => _showEmergencyModal(context, theme, semantic),
            ),
          ),
        ],
      );
    });
  }

  // ==========================================================================
// MODAL: EMERGENCIAS (UI PRO 2025)
// ==========================================================================
  Future<void> _showEmergencyModal(
    BuildContext context,
    ThemeData theme,
    SemanticColors semantic,
  ) async {
    HapticFeedback.mediumImpact();
    Analytics.track('emergency_modal_open');

    final cs = theme.colorScheme;
    final subscribed = controller.assistanceSubscribed.value;

    Widget sectionTitle(String text, IconData icon) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: cs.primary, size: 18),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              text,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      );
    }

    ListTile actionTile({
      required IconData icon,
      required Color color,
      required String title,
      String? subtitle,
      required VoidCallback onTap,
      bool prominent = false,
    }) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: prominent ? Border.all(color: color, width: 2) : null,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
        trailing: Icon(Icons.chevron_right_rounded,
            color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
        onTap: onTap,
      );
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(
                AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: AppElevation.lg(Colors.black),
              border: Border.all(color: cs.outlineVariant, width: 1),
            ),
            child: Column(
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg,
                      AppSpacing.md, AppSpacing.sm, AppSpacing.sm),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Icon(Icons.calendar_today_rounded,
                            color: cs.primary, size: 18),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Centro de Emergencias',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text('Guarde la calma y gestione',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: cs.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded,
                            color: cs.onSurfaceVariant),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: cs.outline.withValues(alpha: 0.12)),

                // Body
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // Asistencia en línea (suscripción)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            border: Border.all(color: cs.outlineVariant),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: semantic.info.withValues(alpha: 0.12),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.sm),
                                ),
                                child: Icon(Icons.gavel_rounded,
                                    color: semantic.info, size: 20),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Asistencia jurídica',
                                      style:
                                          theme.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      subscribed
                                          ? 'Suscrito · Soporte prioritario 24/7'
                                          : 'Asesoría legal inmediata por evento',
                                      style:
                                          theme.textTheme.labelMedium?.copyWith(
                                        color: cs.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FilledButton(
                                onPressed: controller.openOnlineAssistance,
                                style: FilledButton.styleFrom(
                                  backgroundColor: subscribed
                                      ? semantic.success
                                      : semantic.info,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.lg,
                                      vertical: AppSpacing.sm),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.md),
                                  ),
                                ),
                                child: Text(
                                  subscribed ? 'Suscrito' : 'Activar',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // === EMERGENCIAS CRÍTICAS ===
                      actionTile(
                        icon: Icons.emergency_rounded,
                        color: semantic.critical,
                        title: 'Ambulancia',
                        subtitle: 'Línea de urgencias y geolocalización',
                        onTap: controller.callAmbulance,
                        prominent: true,
                      ),
                      actionTile(
                        icon: Icons.local_fire_department_rounded,
                        color: const Color(0xFFEA580C),
                        title: 'Bomberos',
                        subtitle: 'Reporte de incendio o rescate',
                        onTap: controller.callFirefighters,
                      ),

                      // === SEGURIDAD ===
                      actionTile(
                        icon: Icons.local_police_rounded,
                        color: cs.primary,
                        title: 'CAI cercano',
                        subtitle: 'Ver en mapa el punto policial más cercano',
                        onTap: controller.openCai,
                      ),

                      // === ASISTENCIA VEHICULAR ===
                      actionTile(
                        icon: Icons.car_repair_rounded,
                        color: const Color(0xFF0EA5E9),
                        title: 'Grúa',
                        subtitle: 'Solicitar asistencia de remolque',
                        onTap: controller.requestTow,
                        prominent: true,
                      ),
                      actionTile(
                        icon: Icons.shield_rounded,
                        color: const Color(0xFF10B981),
                        title: 'Compañía de Seguros',
                        subtitle: 'Reportar siniestro y solicitar asistencia',
                        onTap: controller.registerCallInsurance,
                        prominent: true,
                      ),

                      // === ORIENTACIÓN Y SOPORTE ===
                      actionTile(
                        icon: Icons.gavel_rounded,
                        color: const Color(0xFF8B5CF6),
                        title: 'Asistencia jurídica',
                        subtitle: 'Asesoría legal inmediata por evento',
                        onTap: controller.openLegalHelp,
                        prominent: true,
                      ),
                      actionTile(
                        icon: Icons.fact_check_rounded,
                        color: cs.tertiary,
                        title: 'Guía de accidente',
                        subtitle: 'Paso a paso legal y operativo',
                        onTap: controller.openAccidentGuide,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
// MODAL: DESCANSO (4 domingos de octubre 2025)
// ==========================================================================
  Future<void> _showRestDaysModal(
    BuildContext context,
    ThemeData theme,
    SemanticColors semantic,
  ) async {
    final dates = <DateTime>[];
    DateTime d = DateTime(2025, 10, 1);
    while (d.weekday != DateTime.sunday) {
      d = d.add(const Duration(days: 1));
    }
    for (int i = 0; i < 4; i++) {
      dates.add(d.add(Duration(days: 7 * i))); // 5, 12, 19, 26 oct 2025
    }

    String fmtDate(DateTime dt) {
      final s = DateFormat('EEEE d MMM y', 'es_CO').format(dt);
      final cleaned = s.replaceFirst(',', '');
      return cleaned[0].toUpperCase() + cleaned.substring(1);
    }

    final cs = theme.colorScheme;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: AppElevation.lg(Colors.black),
              border: Border.all(color: cs.outlineVariant, width: 1),
            ),
            child: Column(
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg,
                      AppSpacing.md, AppSpacing.sm, AppSpacing.sm),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Icon(Icons.calendar_today_rounded,
                            color: cs.primary, size: 18),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Días de descanso',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                )),
                            Text('Octubre 2025',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: cs.outline.withValues(alpha: 0.12)),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm, horizontal: AppSpacing.lg),
                    itemCount: dates.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: cs.outlineVariant),
                    itemBuilder: (_, i) {
                      final dt = dates[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: semantic.info,
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 18),
                        ),
                        title: Text(
                          fmtDate(dt),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          'Descanso del vehículo',
                          style: theme.textTheme.labelMedium
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: semantic.info.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: semantic.info.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'Programado',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: semantic.info,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        onTap: () {
                          HapticFeedback.selectionClick();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
// MODAL: LISTA COMPLETA DE TAREAS
// ==========================================================================
  Future<void> _showTasksModal(
    BuildContext context,
    ThemeData theme,
    SemanticColors semantic,
  ) async {
    HapticFeedback.lightImpact();
    Analytics.track('tasks_modal_open');

    final cs = theme.colorScheme;
    final tasks = controller.tasks;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: AppElevation.lg(Colors.black),
              border: Border.all(color: cs.outlineVariant, width: 1),
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg,
                      AppSpacing.md, AppSpacing.sm, AppSpacing.sm),
                  child: Row(
                    children: [
                      Text(
                        'Tareas pendientes',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close_rounded,
                            color: cs.onSurfaceVariant),
                        tooltip: 'Cerrar',
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: cs.outline.withValues(alpha: 0.12)),
                Expanded(
                  child: Obx(() {
                    if (tasks.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Text(
                            'No tienes tareas pendientes',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) => Divider(
                          height: 1, color: cs.outline.withValues(alpha: 0.08)),
                      itemBuilder: (_, i) {
                        final t = tasks[i];
                        return _TaskListItem(
                          task: t,
                          theme: theme,
                          semantic: semantic,
                          onTap: () {
                            controller.onTaskTap(t);
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
// RENTALS SECTION
// ==========================================================================
  Widget _buildRentalsSection(
    BuildContext context,
    ThemeData theme,
    SemanticColors semantic,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Mis Arriendos',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Analytics.track('view_all_rentals');
                Get.toNamed(Routes.rentalsAll);
              },
              child: Text(
                'Ver todos',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        Obx(() {
          final rentals = controller.rentals;
          return Column(
            children: [
              for (int i = 0; i < rentals.length; i++) ...[
                _RentalCard(
                  rental: rentals[i],
                  theme: theme,
                  semantic: semantic,
                  onTap: () => controller.onRentalTap(rentals[i]),
                  onPayTap: controller.goToPayment,
                ),
                if (i < rentals.length - 1)
                  const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        }),
      ],
    );
  }
}

// ============================================================================
// HELPER WIDGETS
// ============================================================================
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final ThemeData theme;
  final VoidCallback? onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: card,
      ),
    );
  }
}

class _TaskListItem extends StatelessWidget {
  final TaskVM task;
  final ThemeData theme;
  final SemanticColors semantic;
  final VoidCallback onTap;

  const _TaskListItem({
    required this.task,
    required this.theme,
    required this.semantic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    final chipColor =
        task.isUrgent ? semantic.criticalContainer : cs.surfaceContainerLow;
    final chipFg = task.isUrgent ? semantic.critical : cs.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: task.iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: task.isUrgent
                      ? Border.all(color: task.iconColor, width: 2)
                      : null,
                ),
                child: Icon(task.icon, color: task.iconColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs / 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (task.dueDate != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs / 2,
                            ),
                            decoration: BoxDecoration(
                              color: chipColor,
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: Text(
                              task.dueLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: chipFg,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.chevron_right_rounded,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RentalCard extends StatelessWidget {
  final RentalVM rental;
  final ThemeData theme;
  final SemanticColors semantic;
  final VoidCallback onTap;
  final VoidCallback onPayTap;

  const _RentalCard({
    required this.rental,
    required this.theme,
    required this.semantic,
    required this.onTap,
    required this.onPayTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    final isPending = rental.hasPendingPayment;
    final isOverdue = rental.isOverdue;

    return Container(
      decoration: BoxDecoration(
        color: isPending ? semantic.warningContainer : cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isPending
              ? semantic.warning.withValues(alpha: 0.4)
              : cs.outlineVariant,
          width: 1,
        ),
        boxShadow: AppElevation.sm(Colors.black),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(rental.icon, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rental.type,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            rental.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: isPending ? semantic.warning : semantic.success,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPending
                                ? Icons.schedule_rounded
                                : Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            isPending ? 'Pendiente' : 'Al día',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  rental.details,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                if (isPending && rental.pendingInvoices > 0) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${rental.pendingInvoices} factura${rental.pendingInvoices > 1 ? "s" : ""} pendiente${rental.pendingInvoices > 1 ? "s" : ""}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: semantic.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isPending ? 'Monto adeudado' : 'Próximo pago',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs / 2),
                          Text(
                            Formatters.money(rental.nextPaymentAmount),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color:
                                  isOverdue ? semantic.critical : cs.onSurface,
                              fontWeight: FontWeight.w900,
                              fontFeatures: const [
                                FontFeature.tabularFigures()
                              ],
                            ),
                          ),
                          if (rental.nextPaymentDate != null) ...[
                            const SizedBox(height: AppSpacing.xs / 2),
                            Text(
                              rental.dueDateLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isOverdue
                                    ? semantic.critical
                                    : cs.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isPending)
                      FilledButton.icon(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          onPayTap();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              isOverdue ? semantic.critical : semantic.warning,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        icon: const Icon(Icons.payment_rounded, size: 18),
                        label: const Text(
                          'Pagar',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
