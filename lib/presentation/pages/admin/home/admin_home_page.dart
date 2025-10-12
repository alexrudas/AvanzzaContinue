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
            child: Icon(Icons.notifications_none),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: const _HomeBody(),
      //bottomNavigationBar: const _BottomBar(),
    );
  }
}

/* ========================== BODY ========================== */

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Panel360(),
            SizedBox(height: 12),
            _EventosPorRevisarTile(),
            SizedBox(height: 12),
            _PublicacionesTile(),
            SizedBox(height: 12),
            _QuickActions(),
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
      final v = sp.getBool(_kPrefsKey) ?? false; // contraído por defecto
      if (mounted) setState(() => _expanded = v);
    });
  }

  Future<void> _saveExpanded(bool v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kPrefsKey, v);
  }

  @override
  Widget build(BuildContext context) {
    const resumenCerrado = 'Multas: 5 · Restricciones: 1 · Mttos. Ptes.: 3';

    return Container(
      decoration: BoxDecoration(
        color: _C.neutralContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            'Panel 360',
            subtitle: _expanded
                ? 'Vista consolidada de la operación de activos.'
                : resumenCerrado,
            expanded: _expanded,
            onToggle: () {
              setState(() => _expanded = !_expanded);
              _saveExpanded(_expanded);
            },
          ),

          const SizedBox(height: 10),

          // Contenido expandible
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6),

                // ROW 1 — OPERACIÓN
                _RowHeader('Operación'),
                SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        label: 'Restricciones',
                        icon: Icons.block,
                        accent: Color(0xFF005F73), // azul petróleo (marca)
                        badge: '2',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _ActionCard(
                        label: 'Mtto. Ptes.',
                        icon: Icons.handyman,
                        accent: Color(0xFF2E7D32), // verde operación
                        badge: '3',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _ActionCard(
                        label: 'Multas',
                        icon: Icons.report_problem_outlined,
                        accent: Color(0xFFEE9B00), // ámbar alerta
                        badge: '5',
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14),

                // ROW 2 — FINANZAS
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
                        kind: FinanceKind.cxc,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _ActionCard(
                        label: 'CxP Pend.',
                        icon: Icons.trending_down_outlined,
                        accent: Color(0xFFD32F2F),
                        money: '\$ 7,980,500',
                        kind: FinanceKind.cxp,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _ActionCard(
                        label: 'Gastos',
                        icon: Icons.payments_outlined,
                        accent: Color(0xFF546E7A),
                        money: '\$ 3,587,120',
                        kind: FinanceKind.gastos,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14),

                // ROW 3 — ESTRATEGIA
                _RowHeader('Estrategia'),
                SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        label: 'Métricas',
                        icon: Icons.insights_outlined,
                        accent: Color(0xFF005F73), // azul petróleo
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _ActionCard(
                        label: 'Trazabilidad',
                        icon: Icons.timeline_outlined,
                        accent: Color(0xFF9B5DE5), // violeta tech
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: _ActionCard(
                        label: 'Reportes',
                        icon: Icons.insert_chart_outlined_rounded,
                        accent: Color(0xFF1E3A8A), // navy
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
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
    return Text(
      text,
      style: const TextStyle(
        color: _C.textPrimary,
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// ENUMS Y CONSTANTES DEL PANEL 360
// -----------------------------------------------------------------------------

enum FinanceKind { cxc, cxp, gastos, neutro }

// -----------------------------------------------------------------------------
// WIDGETS DEL PANEL 360
// -----------------------------------------------------------------------------

class _ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accent;
  final String? badge;
  final String? money;
  final FinanceKind? kind; // <- tipa la semántica financiera
  final Color? moneyColorOverride; // opcional

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
        return const Color(0xFF2E7D32); // verde ingreso
      case FinanceKind.cxp:
        return const Color(0xFFD32F2F); // rojo egreso
      case FinanceKind.gastos:
        return const Color(0xFFF57C00); // naranja gasto
      case FinanceKind.neutro:
      case null:
        return accent; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _C.border),
          ),
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
                      color: accent.withValues(alpha: 0.12),
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, color: accent, size: 20),
                  ),
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
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: _C.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.15),
              ),
              if (money != null) ...[
                const SizedBox(height: 4),
                Text(
                  money!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: _moneyColor()),
                ),
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
        color: const Color(0xFFE3F2FD), // azul claro profesional
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB3E5FC)), // borde sutil
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ícono circular con tono institucional
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF005F73), // azul petróleo (marca Avanzza)
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              // Texto jerarquizado
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tienes 3 eventos por revisar',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E3A8A), // azul profundo (confianza)
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Revisa tus eventos y gestiona su solución',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF607D8B), // gris azulado neutro
                        height: 1.25,
                      ),
                    ),
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
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _C.primary.withValues(alpha: 0.10),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: _C.primary, size: 24),
    );
  }
}

/* ========================== QUICK ACTIONS ========================== */

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickAction(
            icon: Icons.emoji_transportation,
            label: 'Activos',
            fillColor: Color(0xFF43A047), // Verde profesional accesible
          ),
          _QuickAction(
            icon: Icons.key_outlined,
            label: 'Propietarios',
            fillColor: Color(0xFF4E6E9B), // Azul violáceo (accesible)
          ),
          _QuickAction(
            icon: Icons.groups_2_outlined,
            label: 'Colaborador',
            fillColor: Color(0xFF1E88E5), // Azul brillante, alto contraste
          ),
          _QuickAction(
            icon: Icons.contact_page_outlined,
            label: 'Arrendatarios',
            fillColor: Color(0xFFFFB300), // Ámbar accesible (mejor contraste)
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color fillColor;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    const double size = 64;
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fillColor.withValues(alpha: 0.85),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.05),
              width: 0.8,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 84,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF3C3C3C), // Gris institucional PRO
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),
        ),
      ],
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
        border: Border.all(color: _C.border),
      ),
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
                    Text(
                      'Publicaciones',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _C.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Publicar activos disponibles',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: _C.textSecondary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              // Icon(Icons.chevron_right, color: _C.textSecondary, size: 22),
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
        Text(subtitle,
            style: const TextStyle(fontSize: 13.5, color: _C.textSecondary)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final String subtitle;
  final bool expanded;
  final VoidCallback onToggle;

  const _SectionTitle(
    this.text, {
    required this.subtitle,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🔹 Título + Toggle (alineados en una fila)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Título
            Text(
              text,
              style: const TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.w800,
                height: 1.1,
                color: _C.textPrimary,
              ),
            ),

            // Toggle con icono a la derecha
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: _C.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: onToggle,
              child: Row(
                children: [
                  Text(
                    expanded ? 'Ocultar panel' : 'Mostrar panel',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(width: 3),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(Icons.keyboard_arrow_down, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),

        // 🔹 Subtítulo debajo
        if (subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                height: 1.2,
                color: _C.textSecondary,
              ),
            ),
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
  static const border = Color(0xFFE6E8EB);
  static const textPrimary = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B6F76);
  static const warningBg = Color(0xFFFFF7E0);
  static const warningFg = Color(0xFFF5A000);
}

class _G {
  static const blue = LinearGradient(
    colors: [Color(0xFF0052CC), Color(0xFF1E88E5)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const green = LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const amber = LinearGradient(
    colors: [Color(0xFFF9A825), Color(0xFFFFB300)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
