// lib/presentation/admin/accounting/admin_accounting_page.dart
import 'dart:math';

import 'package:avanzza/presentation/pages/admin/accounting/account_payable_detail_page.dart';
import 'package:avanzza/presentation/pages/admin/accounting/expense_form_page.dart';
import 'package:avanzza/presentation/pages/admin/accounting/income_form_page.dart';
import 'package:avanzza/presentation/themes/theme_module.dart';
import 'package:avanzza/presentation/widgets/ai_banner/ai_banner.dart';
import 'package:avanzza/presentation/widgets/floating_quick_actions_row/floating_quick_actions_row.dart';
import 'package:avanzza/presentation/widgets/modal/action_sheet_pro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/admin/accounting/admin_accounting_controller.dart';
import '../../../widgets/error_state.dart';
import '../../../widgets/loading_state.dart';
import 'account_receivable_detail_page.dart';

/// ============================================================================
/// AdminAccountingPage — Asistente IA dentro del scroll + KPIs + Charts + FAB
/// ============================================================================
/// Cambio clave:
/// - El AIBanner ahora es el PRIMER bloque del body scrolleable (no flotante).
/// - Se elimina el Stack superior fijo y el padding-top manual.
/// - Se mantiene `badgeCount` (Budget Count) y los mensajes originales.
class AdminAccountingPage extends GetView<AdminAccountingController> {
  const AdminAccountingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          if (controller.loading.value) return const LoadingState();
          if (controller.error.value != null) {
            return ErrorState(message: controller.error.value!);
          }

          // ----------------------- Datos demo (conecta tu controller) ----------------
          final caja = controller.totalIngresos;
          final bancos = controller.totalEgresos;

          const cxc = 23850.0; // Cuentas por cobrar mes actual
          const cxp = 17950.0; // Cuentas por pagar mes actual
          const prevCxc = 21000.0; // periodo anterior
          const prevCxp = 20000.0;

          double pctDelta(double current, double previous) {
            if (previous <= 0) return 0.0;
            return ((current - previous) / previous) * 100.0;
          }

          final cxcDelta = pctDelta(cxc, prevCxc); // + sube, - baja
          final cxpDelta = pctDelta(cxp, prevCxp);

          // =========================
          // SSOT de GASTOS del mes
          // =========================
          const double gastoPresupuestoMes = 18000000.0; // presupuesto del mes
          const double gastoEjecutadoMes =
              21000000.0; // gasto real/causado del mes
          const double disponibleAbs =
              gastoPresupuestoMes - gastoEjecutadoMes; // dinámico

          // =========================
          // SSOT de INGRESOS del mes
          // =========================
          const double metaIngresosMes = 31500000.0;
          const double ingresosAcumMes = 28700000.0;

          // Resumen financiero del mes (derivados desde SSOT)
          const double gastosAcumMes = gastoEjecutadoMes; // misma variable
          const double utilidadAbs = ingresosAcumMes - gastosAcumMes;

          // ---------- VALORES MES ANTERIOR PARA DELTAS ----------
          const double prevIngresosAcumMes = 26500000.0;
          const double prevGastosAcumMes = 19500000.0;
          const double prevUtilidadAbs =
              prevIngresosAcumMes - prevGastosAcumMes;

          // ---------- % principales ----------
          const double ingresoPct = metaIngresosMes == 0
              ? 0.0
              : (ingresosAcumMes / metaIngresosMes * 100.0);

          const double gastoPctVsIngreso = ingresosAcumMes == 0
              ? 0.0
              : (gastosAcumMes / ingresosAcumMes * 100.0);

          const double utilidadPctVsIngreso = ingresosAcumMes == 0
              ? 0.0
              : (utilidadAbs / ingresosAcumMes * 100.0);

          // ---------- DELTAS VS PERIODO ANTERIOR ----------
          final double ingresosDelta =
              pctDelta(ingresosAcumMes, prevIngresosAcumMes);
          final double gastosDelta = pctDelta(gastosAcumMes, prevGastosAcumMes);
          final double utilidadDelta = pctDelta(utilidadAbs, prevUtilidadAbs);

          // Morosidad
          const morosidadPct = 6.3;
          const morosidadValor = 9850000.0;

          // ----------------------- Mensajes IA (banner) ------------------------------
          // Mantiene los mensajes existentes.
          List<AIBannerMessage> msgs = [
            const AIBannerMessage(
              type: AIMessageType.success,
              icon: Icons.auto_graph_rounded,
              title: 'Liquidez saludable (+12%). Flujo neto positivo este mes.',
            ),
            const AIBannerMessage(
              type: AIMessageType.warning,
              icon: Icons.local_gas_station_rounded,
              title: 'IA: reduce combustible 8% → utilidad +9%.',
            ),
            const AIBannerMessage(
              type: AIMessageType.critical,
              icon: Icons.priority_high_rounded,
              title: 'Alerta: presupuesto de gastos supera el 110% del plan.',
            ),
            const AIBannerMessage(
              type: AIMessageType.info,
              icon: Icons.people_alt_rounded,
              title: 'Morosidad 6.3%: contactar 3 arrendatarios en riesgo.',
            ),
            const AIBannerMessage(
              type: AIMessageType.warning,
              icon: Icons.build_rounded,
              title: 'IA: reprograma mantenimientos menores a ventana ociosa.',
            ),
            const AIBannerMessage(
              type: AIMessageType.success,
              icon: Icons.sell_rounded,
              title: 'IA: sube tarifa diaria +3% en alta demanda (ROI +2 pts).',
            ),
          ];

          // Conteo del badge (Budget Count): aquí total de mensajes (ajusta con no-leídas si aplica).
          final int badgeCount = msgs.length;

          // ----------------------- UI principal -------------------------------------
          return FloatingQuickActions(
            items: [
              QuickAction(
                icon: Icons.receipt_long_rounded,
                label: 'Balances',
                color: const Color(0xFF43A047),
                onTap: () {},
              ),
              QuickAction(
                icon: Icons.receipt_long_rounded,
                label: 'Recargos',
                color: const Color(0xFF4E6E9B),
                onTap: () {},
              ),
              QuickAction(
                icon: Icons.percent_rounded,
                label: 'Descuentos',
                color: const Color(0xFF1E88E5),
                onTap: () {},
              ),
              QuickAction(
                icon: Icons.add_rounded,
                label: '+ Acciones',
                color: const Color(0xFFFFB300),
                onTap: () {
                  ActionSheetPro.show(
                    context,
                    title: 'Acciones',
                    data: [
                      ActionSection(
                        items: [
                          ActionItem(
                            label: 'Adjuntar archivo',
                            subtitle: 'PDF, DOCX, Imágenes',
                            icon: Icons.attach_file_outlined,
                            badge: 'Nuevo',
                            onTap: () {},
                          ),
                          ActionItem(
                            label: 'Nuevo Ingreso',
                            subtitle: 'Registra tu pago recibido',
                            icon: Icons.mic_none_rounded,
                            onAsyncTap: () async {
                              await Get.to(() => const IncomeFormPage());
                            },
                          ),
                          ActionItem(
                            label: 'Nuevo Gasto',
                            subtitle: 'Registra tu gasto realilzado',
                            icon: Icons.mic_none_rounded,
                            onAsyncTap: () async {
                              await Get.to(() => const ExpenseFormPage());
                            },
                          ),
                          ActionItem(
                            label: 'Nuevo Cuenta x Pagar',
                            subtitle: 'Registra tu gastos pediente por pagar',
                            icon: Icons.mic_none_rounded,
                            onAsyncTap: () async {
                              await Get.to(
                                  () => const APDetailPage(apId: '123'));
                            },
                          ),
                          ActionItem(
                            label: 'Nuevo Cuenta x Cobrar',
                            subtitle: 'Registra deuda por cobrar',
                            icon: Icons.mic_none_rounded,
                            onAsyncTap: () async {
                              await Get.to(
                                  () => const ARDetailPage(arId: "abc"));
                            },
                          ),
                        ],
                      ),
                    ],
                    theme: const ActionSheetTheme(
                      opacity: 0.96,
                      cornerRadius: 20,
                      backdropBlur: true,
                    ),
                  );
                },
              ),
            ],
            child: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                      10, 8, 10, paddingBottomForQuickActions(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ----------------------- Asistente IA EN EL SCROLL ----------------
                      // (Ya no está flotante ni sticky)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AIBanner(
                          messages: msgs,
                          headerTitle: 'Asistente IA',
                          headerIcon: Icons.smart_toy_rounded,
                          badgeCount: badgeCount,
                          rotationInterval: const Duration(seconds: 5),
                        ),
                      ),

                      // ----------------------------- KPIs 2×2 ---------------------------
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 2.2,
                        children: [
                          _KpiTile(
                            icon: Icons.account_balance_wallet_outlined,
                            label: 'Caja',
                            value: caja,
                          ),
                          _KpiTile(
                            icon: Icons.account_balance,
                            label: 'Bancos',
                            value: bancos,
                          ),
                          _KpiTile(
                            icon: Icons.trending_up,
                            label: 'CxCobrar',
                            value: cxc,
                            color: Colors.green,
                            trendPct: cxcDelta.abs(),
                            trendUp: cxcDelta >= 0,
                          ),
                          _KpiTile(
                            icon: Icons.trending_down,
                            label: 'CxPagar',
                            value: cxp,
                            color: Colors.red,
                            trendPct: cxpDelta.abs(),
                            trendUp: cxpDelta >= 0,
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ----------------------------- Charts -----------------------------
                      // Presupuesto de Gastos usando SemiCircularGaugeChart del Theme Module
                      Row(
                        children: [
                          const Expanded(
                            child: _ChartCard(
                              child: SizedBox(
                                height: 126,
                                child: _CircularMorosidadChart(
                                  morosidadPct: morosidadPct,
                                  vencidoAbs: morosidadValor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ChartCard(
                              // Aumentada altura para evitar overflow del gauge
                              child: SizedBox(
                                height: 160,
                                child: SemiCircularGaugeChart(
                                  maxValue: gastoPresupuestoMes,
                                  value: gastoEjecutadoMes,
                                  title: 'Presupuesto Gastos',
                                  subtitle:
                                      '€ ${_formatMoney(gastoPresupuestoMes)}',
                                  footerLabel: 'Disp.',
                                  footerValueAbs: disponibleAbs,
                                  animationDuration:
                                      const Duration(milliseconds: 900),
                                  strokeWidth: 16.0,
                                  height: 72.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // --------------------- Resumen financiero (3 tarjetas) ------------
                      Text('Resumen financiero',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: _MetricStatTile(
                              title: 'Ingresos',
                              percentLabel:
                                  '${ingresoPct.clamp(0.0, 999.0).toStringAsFixed(0)} %',
                              amountLabel: '€ ${_formatMoney(ingresosAcumMes)}',
                              color: _scaleColor(ingresoPct,
                                  good: Colors.green.shade700),
                              trendPct: ingresosDelta.abs(),
                              trendUp: ingresosDelta >= 0,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: _MetricStatTile(
                              title: 'Gastos',
                              percentLabel:
                                  '${gastoPctVsIngreso.clamp(0.0, 999.0).toStringAsFixed(0)} %',
                              amountLabel: '€ ${_formatMoney(gastosAcumMes)}',
                              color: _scaleColorSpend(gastoPctVsIngreso),
                              trendPct: gastosDelta.abs(),
                              trendUp: gastosDelta >= 0,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: _MetricStatTile(
                              title: 'Utilidad',
                              percentLabel:
                                  '${utilidadPctVsIngreso.clamp(0.0, 999.0).toStringAsFixed(0)} %',
                              amountLabel: '€ ${_formatMoney(utilidadAbs)}',
                              color: utilidadAbs >= 0
                                  ? _scaleColor(utilidadPctVsIngreso,
                                      good: Colors.teal.shade700)
                                  : Colors.red,
                              trendPct: utilidadDelta.abs(),
                              trendUp: utilidadDelta >= 0,
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
        }),
      ],
    );
  }
}

/// Colorea según umbrales. good es el color objetivo en alto desempeño.
Color _scaleColor(double pct, {required Color good}) {
  if (pct >= 90) return good;
  if (pct >= 70) return Colors.amber.shade700;
  return Colors.red;
}

/// Para gasto como % del ingreso. Menor es mejor.
Color _scaleColorSpend(double pct) {
  if (pct <= 60) return Colors.green.shade700;
  if (pct <= 80) return Colors.amber.shade700;
  return Colors.red;
}

/// Gauge semicircular para Morosidad: título, % grande y valor debajo
class _CircularMorosidadChart extends StatelessWidget {
  final double morosidadPct; // 0..100  = (Σ mora / Σ causado)*100
  final double vencidoAbs; // Σ valores en mora

  const _CircularMorosidadChart({
    required this.morosidadPct,
    required this.vencidoAbs,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final pct01 = (morosidadPct / 100).clamp(0.0, 2.0);

    // Indicadores por umbral
    final Color gaugeColor = morosidadPct > 10
        ? Colors.red
        : (morosidadPct > 5 ? Colors.amber.shade700 : Colors.green.shade700);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Morosidad',
            style:
                t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        Text('8 de 25 Arrendatarios',
            style:
                t.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        SizedBox(
          height: 70,
          child: Stack(
            alignment: Alignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: pct01),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeInOutCubic,
                builder: (context, value, _) {
                  return CustomPaint(
                    painter: _GaugePainterPro(
                      percent: value,
                      progressColor: gaugeColor,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      strokeWidth: 16,
                    ),
                    size: Size.infinite,
                  );
                },
              ),
              Positioned(
                bottom: 6,
                child: Text(
                  '${morosidadPct.toStringAsFixed(1)}%',
                  style: t.textTheme.titleLarge?.copyWith(
                    color: gaugeColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 0),
        Center(
          child: Text(
            '€ ${_formatMoney(vencidoAbs)}',
            style:
                t.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

/// CustomPainter para gauge semicircular usado por _CircularMorosidadChart.
/// Mantiene compatibilidad con el gauge de morosidad existente.
class _GaugePainterPro extends CustomPainter {
  final double percent; // 0..2
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _GaugePainterPro({
    required this.percent,
    required this.progressColor,
    required this.backgroundColor,
    this.strokeWidth = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.8);
    final radius = (size.width / 2) * 0.7;
    final rect = Rect.fromCircle(center: center, radius: radius);

    const startAngle = pi;
    const sweepAngle = pi;
    const visualMaxPercent = 1.5;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepAngle, false, bgPaint);

    final progressSweep =
        (sweepAngle * (percent / visualMaxPercent)).clamp(0.0, sweepAngle);

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.22)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    canvas.drawArc(
        rect.translate(0, 2), startAngle, progressSweep, false, shadowPaint);

    final fgPaint = Paint()
      ..shader = LinearGradient(
        colors: [progressColor.withValues(alpha: 0.7), progressColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, progressSweep, false, fgPaint);

    const markerAngle = startAngle + (sweepAngle * (1.0 / visualMaxPercent));
    final markerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeWidth = strokeWidth / 4
      ..style = PaintingStyle.stroke;
    final markerStart = Offset(
      center.dx + (radius - strokeWidth / 2) * cos(markerAngle),
      center.dy + (radius - strokeWidth / 2) * sin(markerAngle),
    );
    final markerEnd = Offset(
      center.dx + (radius + strokeWidth / 2) * cos(markerAngle),
      center.dy + (radius + strokeWidth / 2) * sin(markerAngle),
    );
    canvas.drawLine(markerStart, markerEnd, markerPaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainterPro old) {
    return old.percent != percent ||
        old.progressColor != progressColor ||
        old.backgroundColor != backgroundColor ||
        old.strokeWidth != strokeWidth;
  }
}

class _BarsChart extends StatelessWidget {
  final double ingresos;
  final double egresos;
  final String footerTitle;
  final double footerValueAbs;

  const _BarsChart({
    required this.ingresos,
    required this.egresos,
    required this.footerTitle,
    required this.footerValueAbs,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final maxVal = ingresos > egresos ? ingresos : egresos;
    final ingPct = (ingresos / (maxVal == 0 ? 1 : maxVal)).clamp(0.1, 1.0);
    final egrPct = (egresos / (maxVal == 0 ? 1 : maxVal)).clamp(0.1, 1.0);
    final marginPct =
        ingresos == 0 ? 0 : ((ingresos - egresos) / ingresos * 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Utilidad  •  ${marginPct.toStringAsFixed(1)} %',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        SizedBox(
          height: 76,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FractionallySizedBox(
                  heightFactor: ingPct,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FractionallySizedBox(
                  heightFactor: egrPct,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(footerTitle, style: t.textTheme.labelMedium),
            Text('€ ${_formatMoney(footerValueAbs)}',
                style: t.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }
}

class _QuickFab extends StatefulWidget {
  final VoidCallback onAddIncome;
  final VoidCallback onAddExpense;
  final VoidCallback onAddSurcharge;
  final VoidCallback onAddDiscount;

  const _QuickFab({
    required this.onAddIncome,
    required this.onAddExpense,
    required this.onAddSurcharge,
    required this.onAddDiscount,
  });

  @override
  State<_QuickFab> createState() => _QuickFabState();
}

class _QuickFabState extends State<_QuickFab>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 220));
  late final Animation<double> _scale =
      CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  static const Color _arcaBlue = Color(0xFF005CFF);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    _open ? _c.forward() : _c.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 72 + (_open ? 280 : 0),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          if (_open)
            Positioned.fill(
              child: GestureDetector(
                  onTap: _toggle, behavior: HitTestBehavior.opaque),
            ),
          Positioned(
            bottom: 80,
            right: 0,
            child: ScaleTransition(
              scale: _scale,
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _FabAction(
                    icon: Icons.add_card_rounded,
                    label: 'Agregar ingreso',
                    onTap: () {
                      _toggle();
                      widget.onAddIncome();
                    },
                  ),
                  const SizedBox(height: 10),
                  _FabAction(
                    icon: Icons.receipt_long_rounded,
                    label: 'Agregar gasto',
                    onTap: () {
                      _toggle();
                      widget.onAddExpense();
                    },
                  ),
                  const SizedBox(height: 10),
                  _FabAction(
                    icon: Icons.price_change_rounded,
                    label: 'Agregar recargo',
                    onTap: () {
                      _toggle();
                      widget.onAddSurcharge();
                    },
                  ),
                  const SizedBox(height: 10),
                  _FabAction(
                    icon: Icons.discount_rounded,
                    label: 'Agregar descuento',
                    onTap: () {
                      _toggle();
                      widget.onAddDiscount();
                    },
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _toggle,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _arcaBlue.withOpacity(0.85),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _arcaBlue.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedRotation(
                    turns: _open ? 0.125 : 0.0,
                    duration: const Duration(milliseconds: 220),
                    child: const Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FabAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FabAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 10,
                  offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF005CFF)),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final Color? color;
  final double? trendPct; // null = sin indicador
  final bool? trendUp; // true ↑  false ↓

  const _KpiTile({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
    this.trendPct,
    this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    Color trendColor;
    IconData trendIcon;
    if (trendPct != null && trendUp != null) {
      trendColor = trendUp! ? Colors.green.shade700 : Colors.red.shade700;
      trendIcon =
          trendUp! ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
    } else {
      trendColor = t.colorScheme.onSurfaceVariant;
      trendIcon = Icons.remove;
    }

    return Card(
      elevation: 0.8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon,
                        size: 20, color: color ?? t.colorScheme.onSurface),
                    const SizedBox(width: 8),
                    Text(label,
                        style: t.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
                if (trendPct != null && trendUp != null)
                  Row(
                    children: [
                      Icon(trendIcon, size: 14, color: trendColor),
                      const SizedBox(width: 2),
                      Text(
                        '${trendPct!.abs().clamp(0, 999).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: trendColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text('€${_formatMoney(value)}',
                style: t.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _MetricStatTile extends StatelessWidget {
  final String title;
  final String percentLabel;
  final String amountLabel;
  final Color color;
  final double? trendPct; // opcional
  final bool? trendUp; // opcional

  const _MetricStatTile({
    required this.title,
    required this.percentLabel,
    required this.amountLabel,
    required this.color,
    this.trendPct,
    this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    Color? trendColor;
    IconData? trendIcon;
    if (trendPct != null && trendUp != null) {
      trendColor = trendUp! ? Colors.green.shade700 : Colors.red.shade700;
      trendIcon =
          trendUp! ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
    }

    return Card(
      elevation: 0.8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título + delta mensual
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: t.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),
                if (trendPct != null && trendUp != null)
                  Row(
                    children: [
                      Icon(trendIcon, size: 14, color: trendColor),
                      const SizedBox(width: 2),
                      Text(
                        '${trendPct!.abs().clamp(0, 999).toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: trendColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              percentLabel,
              style: t.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              amountLabel,
              style: t.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: t.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final Widget child;
  const _ChartCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}

// ---------------------- util dinero ----------------------
String _formatMoney(double value) {
  final isNegative = value < 0;
  final s = value.abs().toStringAsFixed(0);
  final buf = StringBuffer();
  if (isNegative) buf.write('-');
  for (int i = 0; i < s.length; i++) {
    final pos = s.length - i;
    buf.write(s[i]);
    if (pos > 1 && pos % 3 == 1 && i != s.length - 1) buf.write('.');
  }
  return buf.toString();
}
