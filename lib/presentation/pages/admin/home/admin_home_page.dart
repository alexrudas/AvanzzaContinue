// lib/presentation/admin/home/admin_home_page.dart
import 'dart:ui' show ImageFilter; // blur para efecto acuoso

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: const _Header(title: 'Administrador', subtitle: 'Ingresos S.A.'),
        actions: const [
          Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.notifications_none)),
          Padding(
              padding: EdgeInsets.only(right: 12), child: Icon(Icons.search)),
        ],
      ),
      body: const _HomeRoot(), // Stack + fila flotante
    );
  }
}

/* ========================== ROOT (STACK) ========================== */

class _HomeRoot extends StatelessWidget {
  const _HomeRoot();

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    return Stack(
      children: [
        _ScrollableHomeContent(bottomPadding: 120 + bottomSafe),
        const _FloatingQuickActionsRow(),
      ],
    );
  }
}

/* ========================== CONTENIDO SCROLL ========================== */

class _ScrollableHomeContent extends StatelessWidget {
  final double bottomPadding;
  const _ScrollableHomeContent({required this.bottomPadding});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.fromLTRB(10, 8, 10, bottomPadding),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Panel360(),
            SizedBox(height: 10),
            _IndicadoresGestion(),
            SizedBox(height: 10),
            _EventosPorRevisarTile(),
            SizedBox(height: 10),
            _PublicacionesTile(),
          ],
        ),
      ),
    );
  }
}

/* ========================== PANEL 360 ========================== */

class _Panel360 extends StatefulWidget {
  const _Panel360();

  @override
  State<_Panel360> createState() => _Panel360State();
}

class _Panel360State extends State<_Panel360> {
  static const _kPrefsKey = 'panel360_expanded';
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      final v = sp.getBool(_kPrefsKey) ?? false;
      if (mounted) setState(() => _expanded = v);
    });
  }

  Future<void> _saveExpanded(bool v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kPrefsKey, v);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.outline, width: 1.1),
        boxShadow: const [
          BoxShadow(color: _C.cardShadow, blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            'Panel 360',
            subtitle: _expanded
                ? 'Vista consolidada de la operación de activos.'
                : '',
            expanded: _expanded,
            onToggle: () {
              setState(() => _expanded = !_expanded);
              _saveExpanded(_expanded);
            },
          ),
          const SizedBox(height: 6),
          if (!_expanded)
            const Text('Monitorea aspectos claves de tu aciividad'),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6),
                _RowHeader('Operación'),
                SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                        child: _ActionCard(
                            label: 'Restricciones',
                            icon: Icons.block,
                            accent: Color(0xFF005F73),
                            badge: '2')),
                    SizedBox(width: 10),
                    Expanded(
                        child: _ActionCard(
                            label: 'Mtto. Ptes.',
                            icon: Icons.handyman,
                            accent: Color(0xFF2E7D32),
                            badge: '3')),
                    SizedBox(width: 10),
                    Expanded(
                        child: _ActionCard(
                            label: 'Multas',
                            icon: Icons.report_problem_outlined,
                            accent: Color(0xFFEE9B00),
                            badge: '5')),
                  ],
                ),
                SizedBox(height: 14),
                _RowHeader('Finanzas'),
                SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                        child: _ActionCard(
                            label: 'CxC Pend.',
                            icon: Icons.trending_up_outlined,
                            accent: Color(0xFF2E7D32),
                            money: '\$ 3,450,000',
                            kind: FinanceKind.cxc)),
                    SizedBox(width: 10),
                    Expanded(
                        child: _ActionCard(
                            label: 'CxP Pend.',
                            icon: Icons.trending_down_outlined,
                            accent: Color(0xFFD32F2F),
                            money: '\$ 7,980,500',
                            kind: FinanceKind.cxp)),
                    SizedBox(width: 10),
                    Expanded(
                        child: _ActionCard(
                            label: 'Gastos',
                            icon: Icons.payments_outlined,
                            accent: Color(0xFF546E7A),
                            money: '\$ 3,587,120',
                            kind: FinanceKind.gastos)),
                  ],
                ),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

/* ===================== INDICADORES DE GESTIÓN ===================== */

class _IndicadoresGestion extends StatelessWidget {
  const _IndicadoresGestion();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.outline, width: 1.1),
        boxShadow: const [
          BoxShadow(color: _C.cardShadow, blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      child: LayoutBuilder(
        builder: (context, c) {
          const double minBig = 190;
          const double minMini = 110;
          const double gutter = 10;
          final bool stackVertical = c.maxWidth < (minBig + minMini + gutter);

          if (stackVertical) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _KpiBigTile(
                  color: _C.kpiCoral,
                  icon: Icons.account_balance_wallet_outlined,
                  projectedLabel: 'Presupuesto mes',
                  projectedValue: '\$ 200.000.000',
                  availableValue: '\$ 103.580.000',
                  availableLabel: 'Presupuesto Disponible',
                ),
                SizedBox(height: 10),
                _KpiMiniTile(
                    color: _C.kpiGreen,
                    icon: Icons.stacked_line_chart,
                    value: '25%',
                    label: 'Margen Esperado'),
                SizedBox(height: 10),
                _KpiMiniTile(
                    color: _C.kpiNavy,
                    icon: Icons.percent,
                    value: '92%',
                    label: 'Productividad'),
              ],
            );
          }

          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Indicadores de Gestión',
                  style: TextStyle(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      color: _C.textPrimary)),
              SizedBox(height: _KPI.miniGap),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: _KpiBigTile(
                      color: _C.kpiCoral,
                      icon: Icons.account_balance_wallet_outlined,
                      projectedLabel: 'Presupuesto mes',
                      projectedValue: '\$ 200.000.000',
                      availableValue: '\$ 103.580.000',
                      availableLabel: 'Presupuesto Disponible',
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _KpiMiniTile(
                            color: _C.kpiGreen,
                            icon: Icons.stacked_line_chart,
                            value: '25%',
                            label: 'Margen Esperado'),
                        SizedBox(height: 8),
                        _KpiMiniTile(
                            color: _C.kpiNavy,
                            icon: Icons.percent,
                            value: '92%',
                            label: 'Productividad'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _KPI {
  static const double miniH = 60.0;
  static const double miniGap = 8.0;
  static const double bigH = miniH * 2 + miniGap;
}

/* ----------------- Tiles ----------------- */

class _KpiBigTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String projectedLabel;
  final String projectedValue;
  final String availableValue;
  final String availableLabel;

  const _KpiBigTile({
    required this.color,
    required this.icon,
    required this.projectedLabel,
    required this.projectedValue,
    required this.availableValue,
    required this.availableLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: _KPI.bigH,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.outline, width: 1.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: color.withOpacity(0.10)),
                  alignment: Alignment.center,
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(projectedLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12,
                              color: _C.textSecondary,
                              height: 1.15,
                              fontWeight: FontWeight.w600)),
                      Text(projectedValue,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13.5,
                              color: _C.textPrimary,
                              height: 1.15,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(availableValue,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color,
                    height: 1.0)),
            const SizedBox(height: 4),
            const Text('Presupuesto Disponible',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12.5,
                    color: _C.textSecondary,
                    height: 1.2,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _KpiMiniTile extends StatelessWidget {
  final String value, label;
  final Color color;
  final IconData icon;

  const _KpiMiniTile(
      {required this.value,
      required this.label,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: _KPI.miniH,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _C.outline, width: 1.1)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: color.withOpacity(0.10)),
                    alignment: Alignment.center,
                    child: Icon(icon, color: color, size: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: color,
                                height: 1.0)),
                        const SizedBox(height: 2),
                      ]),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Productividad',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        color: _C.textSecondary,
                        height: 1.25,
                        fontWeight: FontWeight.w600)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/* ---------- helpers ---------- */

class _RowHeader extends StatelessWidget {
  final String text;
  const _RowHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return const Text('Operación',
        style: TextStyle(
            color: _C.textPrimary,
            fontSize: 14.5,
            fontWeight: FontWeight.w700));
  }
}

/* ========================== ENUMS/PANEL ========================== */

enum FinanceKind { cxc, cxp, gastos, neutro }

class _ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accent;
  final String? badge;
  final String? money;
  final FinanceKind? kind;
  final Color? moneyColorOverride;

  const _ActionCard({
    required this.label,
    required this.icon,
    required this.accent,
    this.badge,
    this.money,
    this.kind,
    this.moneyColorOverride,
  });

  Color _moneyColor() {
    if (moneyColorOverride != null) return moneyColorOverride!;
    switch (kind) {
      case FinanceKind.cxc:
        return const Color(0xFF2E7D32);
      case FinanceKind.cxp:
        return const Color(0xFFD32F2F);
      case FinanceKind.gastos:
        return const Color(0xFFF57C00);
      case FinanceKind.neutro:
      case null:
        return accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _C.border)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent.withOpacity(0.10)),
                      alignment: Alignment.center,
                      child: Icon(icon, color: accent, size: 20)),
                  if (badge != null)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(badge!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: _C.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.15)),
              if (money != null) ...[
                const SizedBox(height: 4),
                Text(money!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: _moneyColor())),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/* ========================== EVENTOS POR REVISAR ========================== */

class _EventosPorRevisarTile extends StatelessWidget {
  const _EventosPorRevisarTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFB3E5FC)),
          boxShadow: const [BoxShadow(color: Color(0xFFFFCC80))]),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _IconCircle(icon: Icons.notifications_active_rounded),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tienes 3 eventos por revisar',
                        style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E3A8A),
                            height: 1.2)),
                    SizedBox(height: 4),
                    Text('Revisa tus eventos y gestiona su solución',
                        style: TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF607D8B),
                            height: 1.25)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  const _IconCircle({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: _C.primary.withOpacity(0.12)),
        alignment: Alignment.center,
        child: Icon(icon, color: _C.primary, size: 24));
  }
}

/* ========================== QUICK ACTIONS (FILA FLOTANTE) ========================== */

class _FloatingQuickActionsRow extends StatelessWidget {
  const _FloatingQuickActionsRow();

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    return Positioned(
      left: 10,
      right: 10,
      bottom: 8 + bottomSafe,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 0.7),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              // _FloatingQuickActionsRow → Row con badgeCount (ejemplos: 6,3,4,5)
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _QuickAction(
                      icon: Icons.emoji_transportation,
                      label: 'Activos',
                      color: Color(0xFF43A047),
                      badgeCount: 6),
                  SizedBox(width: 8),
                  _QuickAction(
                      icon: Icons.key_outlined,
                      label: 'Propietarios',
                      color: Color(0xFF4E6E9B),
                      badgeCount: 3),
                  SizedBox(width: 8),
                  _QuickAction(
                      icon: Icons.groups_2_outlined,
                      label: 'Colaboradores',
                      color: Color(0xFF1E88E5),
                      badgeCount: 4),
                  SizedBox(width: 8),
                  _QuickAction(
                      icon: Icons.contact_page_outlined,
                      label: 'Arrendatarios',
                      color: Color(0xFFFFB300),
                      badgeCount: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int badgeCount; // NUEVO

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    this.badgeCount = 0, // por defecto sin badge
  });

  @override
  Widget build(BuildContext context) {
    const double side = 64; // si necesitas, ajústalo
    final radius = BorderRadius.circular(12);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Botón “acuoso”
            Container(
              width: side,
              height: side,
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withOpacity(0.85), color.withOpacity(0.70)],
                ),
                // border:
                //     Border.all(color: Colors.white.withOpacity(0.35), width: 1),
                boxShadow: [
                  BoxShadow(
                      color: color.withOpacity(0.30),
                      blurRadius: 16,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.white.withOpacity(0.25),
                            Colors.white.withOpacity(0.05)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 8,
                    right: 8,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.18),
                      ),
                    ),
                  ),
                  Center(child: Icon(icon, color: Colors.white, size: 26)),
                ],
              ),
            ),
            // Badge en esquina superior derecha
            if (badgeCount > 0)
              Positioned(
                right: -4,
                top: -6,
                child: _Badge(count: badgeCount),
              ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 84,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.1,
                color: Color(0xFF3C3C3C)),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    final text = count > 99 ? '99+' : '$count';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935), // rojo alerta
        borderRadius: BorderRadius.circular(10), // “globito”
        border: Border.all(color: Colors.white, width: 2), // recorte limpio
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          height: 1.0,
        ),
      ),
    );
  }
}

/* ========================== PUBLICACIONES ========================== */

class _PublicacionesTile extends StatelessWidget {
  const _PublicacionesTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E3E7), width: 1.1),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                spreadRadius: 0.5,
                offset: Offset(0, 3))
          ]),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              _IconCircle(icon: Icons.campaign_outlined),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Publicaciones',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _C.textPrimary)),
                    SizedBox(height: 2),
                    Text('Publicar activos sin arrendar',
                        style: TextStyle(
                            fontSize: 13.5,
                            color: _C.textSecondary,
                            height: 1.2)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ========================== COMMON ========================== */

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  const _Header({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        const Text('Ingresos S.A.',
            style: TextStyle(fontSize: 13.5, color: _C.textSecondary)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final String subtitle;
  final bool expanded;
  final VoidCallback onToggle;

  const _SectionTitle(this.text,
      {required this.subtitle, required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,
                style: const TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: _C.textPrimary)),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: _C.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(48, 36),
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: onToggle,
              child: Row(
                children: [
                  Text(expanded ? 'Ocultar panel' : 'Mostrar panel',
                      style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          height: 1.2)),
                  const SizedBox(width: 3),
                  AnimatedRotation(
                      turns: expanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(Icons.keyboard_arrow_down, size: 20)),
                ],
              ),
            ),
          ],
        ),
        if (subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(subtitle,
                style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    color: _C.textSecondary)),
          ),
      ],
    );
  }
}

/* ========================== THEME ========================== */

class _C {
  static const primary = Color(0xFF1E88E5);
  static const surface = Colors.white;
  static const neutralContainer = Color(0xFFF5F6F7);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B6F76);
  static const warningBg = Color(0xFFFFF7E0);
  static const warningFg = Color(0xFFF5A000);

  static const kpiGreen = Color(0xFF0A9396);
  static const kpiCoral = Color(0xFFE76F51);
  static const kpiNavy = Color(0xFF1E3A8A);

  static const outline = Color(0xFFE0E3E7);
  static const cardShadow = Color(0x1A000000);
  static const border = outline;
}
