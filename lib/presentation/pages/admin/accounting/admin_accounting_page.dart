// lib/presentation/admin/accounting/admin_accounting_page.dart
import 'dart:async';
import 'dart:math';

import 'package:avanzza/presentation/widgets/floating_quick_actions_row/floating_quick_actions_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/admin/accounting/admin_accounting_controller.dart';
import '../../../widgets/error_state.dart';
import '../../../widgets/loading_state.dart';

/// ============================================================================
/// AdminAccountingPage — Banner IA Sticky + KPIs + Charts + Métricas + FAB
/// ============================================================================
class AdminAccountingPage extends GetView<AdminAccountingController> {
  const AdminAccountingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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

      // Charts comparativos (mini)
      const ingresosMes = 80000.0;
      const egresosMes = 60000.0;
      const utilidadBrutaAbs = 23879000.0;

      // =========================
      // SSOT de GASTOS del mes
      // =========================
      const double gastoPresupuestoMes = 18000000.0; // presupuesto del mes
      const double gastoEjecutadoMes = 21000000.0; // gasto real/causado del mes
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
      const double prevUtilidadAbs = prevIngresosAcumMes - prevGastosAcumMes;

      // ---------- % principales ----------
      const double ingresoPct = metaIngresosMes == 0
          ? 0.0
          : (ingresosAcumMes / metaIngresosMes * 100.0);

      const double gastoPctVsIngreso = ingresosAcumMes == 0
          ? 0.0
          : (gastosAcumMes / ingresosAcumMes * 100.0);

      const double utilidadPctVsIngreso =
          ingresosAcumMes == 0 ? 0.0 : (utilidadAbs / ingresosAcumMes * 100.0);

      // ---------- DELTAS VS PERIODO ANTERIOR ----------
      final double ingresosDelta =
          pctDelta(ingresosAcumMes, prevIngresosAcumMes);
      final double gastosDelta = pctDelta(gastosAcumMes, prevGastosAcumMes);
      final double utilidadDelta = pctDelta(utilidadAbs, prevUtilidadAbs);

      // Morosidad
      const morosidadPct = 6.3;
      const morosidadValor = 9850000.0;

      // lib/presentation/admin/accounting/admin_accounting_page.dart
// ...
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // ---------------------- Contenido principal ----------------------
              Padding(
                padding: const EdgeInsets.only(top: 88),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                      10, 8, 10, paddingBottomForQuickActions(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // KPIs 2×2
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

                      // Charts
                      const Row(
                        children: [
                          Expanded(
                            child: _ChartCard(
                              child: SizedBox(
                                height: 126,
                                child: _BarsChart(
                                  ingresos: ingresosMes,
                                  egresos: egresosMes,
                                  footerTitle: 'Ut. bruta',
                                  footerValueAbs: utilidadBrutaAbs,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _ChartCard(
                              child: SizedBox(
                                height: 126,
                                child: _CircularBudgetChart(
                                  budget: gastoPresupuestoMes,
                                  actual: gastoEjecutadoMes,
                                  footerTitle: 'Disp.',
                                  footerValueAbs: disponibleAbs,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Resumen financiero (3 tarjetas)
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

                      const SizedBox(height: 10),

                      // Métricas clave — Fila 2
                      Row(
                        children: [
                          Expanded(
                            child: _MetricStatTile(
                              title: 'Morosidad',
                              percentLabel:
                                  '${morosidadPct.toStringAsFixed(1)} %',
                              amountLabel: '€ ${_formatMoney(morosidadValor)}',
                              color: morosidadPct > 7
                                  ? Colors.red
                                  : Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ActionTile(
                              title: 'Balances',
                              subtitle: 'Activos y Propietarios',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Ir a Balances')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 96), // reserva para FAB abierto
                    ],
                  ),
                ),
              ),

              // Banner IA sticky (arriba)
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const _DynamicAIBanner(),
              ),

              // ------------ QUICK ACTIONS flotante (abajo fijo) ------------
              FloatingQuickActions(
                items: [
                  QuickAction(
                    icon: Icons.balance_rounded,
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
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
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

class _AIMsg {
  final String type; // success | warning | danger | info
  final IconData icon;
  final String text;
  const _AIMsg({required this.type, required this.icon, required this.text});
}

class _DynamicAIBanner extends StatefulWidget {
  const _DynamicAIBanner();
  @override
  State<_DynamicAIBanner> createState() => _DynamicAIBannerState();
}

class _DynamicAIBannerState extends State<_DynamicAIBanner> {
  final List<_AIMsg> messages = const [
    _AIMsg(
      type: 'success',
      icon: Icons.auto_graph_rounded,
      text: 'Liquidez saludable (+12%). Flujo neto positivo este mes.',
    ),
    _AIMsg(
      type: 'warning',
      icon: Icons.local_gas_station_rounded,
      text: 'IA: reduce combustible 8% → utilidad +9%.',
    ),
    _AIMsg(
      type: 'danger',
      icon: Icons.priority_high_rounded,
      text: 'Alerta: presupuesto de gastos supera el 110% del plan.',
    ),
    _AIMsg(
      type: 'info',
      icon: Icons.people_alt_rounded,
      text: 'Morosidad 6.3%: contactar 3 arrendatarios en riesgo.',
    ),
    _AIMsg(
      type: 'warning',
      icon: Icons.build_rounded,
      text: 'IA: reprograma mantenimientos menores a ventana ociosa.',
    ),
    _AIMsg(
      type: 'success',
      icon: Icons.sell_rounded,
      text: 'IA: sube tarifa diaria +3% en alta demanda (ROI +2 pts).',
    ),
  ];

  int index = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      setState(() => index = (index + 1) % messages.length);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Color _bg(String type) {
    switch (type) {
      case 'success':
        return const Color(0xFF10B981);
      case 'warning':
        return const Color(0xFFF59E0B);
      case 'danger':
        return const Color(0xFFEF4444);
      case 'info':
      default:
        return const Color(0xFF3B82F6);
    }
  }

  void _openAll(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) {
        final t = Theme.of(context);
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.only(top: 8),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.65,
            ),
            decoration: BoxDecoration(
              color: t.colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: t.colorScheme.onSurface.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(
                    children: [
                      Text('Recomendaciones de IA',
                          style: t.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: messages.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final m = messages[i];
                      final c = _bg(m.type);
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: c,
                          child: Icon(m.icon, color: Colors.white, size: 18),
                        ),
                        title: Text(
                          m.text,
                          style: t.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          m.type.toUpperCase(),
                          style: t.textTheme.labelSmall?.copyWith(color: c),
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Abrir detalle: ${m.text}')),
                          );
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

  @override
  Widget build(BuildContext context) {
    final _AIMsg msg = messages[index];
    final Color bg = _bg(msg.type);
    const Color on = Colors.white;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: InkWell(
        key: ValueKey(index),
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openAll(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: bg.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(msg.icon, color: on),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  msg.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(color: on, fontWeight: FontWeight.w700),
                ),
              ),
              const Icon(Icons.unfold_more_rounded, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularBudgetChart extends StatelessWidget {
  final double budget;
  final double actual;
  final String footerTitle;
  final double footerValueAbs;

  const _CircularBudgetChart({
    required this.budget,
    required this.actual,
    required this.footerTitle,
    required this.footerValueAbs,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final pct = (actual / (budget == 0 ? 1 : budget)).clamp(0.0, 2.0);
    final percentValue = (pct * 100).toStringAsFixed(0);

    final Color progressColor;
    if (pct > 1.0) {
      progressColor = t.colorScheme.error;
    } else if (pct > 0.85) {
      progressColor = Colors.orange.shade700;
    } else {
      progressColor = t.colorScheme.primary;
    }

    final Color footerColor =
        (footerValueAbs < 0) ? t.colorScheme.error : t.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Presupuesto Gasto',
            style:
                t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        Text('€ ${_formatMoney(budget)}',
            style:
                t.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        SizedBox(
          height: 70,
          child: Stack(
            alignment: Alignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: pct),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeInOutCubic,
                builder: (context, value, _) {
                  return CustomPaint(
                    painter: _GaugePainterPro(
                      percent: value,
                      progressColor: progressColor,
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
                  '$percentValue%',
                  style: t.textTheme.titleLarge?.copyWith(
                    color: progressColor,
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(footerTitle, style: t.textTheme.labelMedium),
              const SizedBox(width: 8),
              Text('€ ${_formatMoney(footerValueAbs)}',
                  style: t.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700, color: footerColor)),
            ],
          ),
        ),
      ],
    );
  }
}

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
      ..color = Colors.black.withOpacity(0.22)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    canvas.drawArc(
        rect.translate(0, 2), startAngle, progressSweep, false, shadowPaint);

    final fgPaint = Paint()
      ..shader = LinearGradient(
        colors: [progressColor.withOpacity(0.7), progressColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, progressSweep, false, fgPaint);

    const markerAngle = startAngle + (sweepAngle * (1.0 / visualMaxPercent));
    final markerPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
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

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Card(
      elevation: 0.8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              Icon(Icons.pie_chart_outline_rounded,
                  color: t.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Balances',
                        style: t.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: t.textTheme.labelMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
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
      elevation: 0.8,
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
