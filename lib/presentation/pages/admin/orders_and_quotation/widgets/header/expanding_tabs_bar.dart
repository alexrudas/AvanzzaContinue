/// Barra de pestañas con animación de ancho expansivo.
/// Incluye AnimatedWidth, ExpandingTab y MiniIconButton internos.
library;

import 'dart:math';
import 'package:flutter/material.dart';

class ExpandingTabsBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final VoidCallback onSearch;
  final VoidCallback onFilter;
  const ExpandingTabsBar({
    super.key,
    required this.index,
    required this.onChanged,
    required this.onSearch,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    const gap = 8.0;
    const a = 0.65;
    const b = 1 - a;
    const minW = 120.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final total = constraints.maxWidth - gap;
        final left = index == 0 ? max(minW, total * a) : max(minW, total * b);
        final right = index == 1 ? max(minW, total * a) : max(minW, total * b);
        return Row(children: [
          AnimatedWidth(
            width: left,
            child: ExpandingTab(
              label: 'Pedidos',
              isActive: index == 0,
              onTap: () => onChanged(0),
              actions: [
                MiniIconButton(icon: Icons.search, tooltip: 'Buscar', onTap: onSearch),
                MiniIconButton(icon: Icons.tune, tooltip: 'Filtros', onTap: onFilter),
              ],
            ),
          ),
          const SizedBox(width: gap),
          AnimatedWidth(
            width: right,
            child: ExpandingTab(
              label: 'Cotizaciones',
              isActive: index == 1,
              onTap: () => onChanged(1),
              actions: [
                MiniIconButton(icon: Icons.search, tooltip: 'Buscar', onTap: onSearch),
                MiniIconButton(icon: Icons.tune, tooltip: 'Filtros', onTap: onFilter),
              ],
            ),
          ),
        ]);
      },
    );
  }
}

class AnimatedWidth extends StatelessWidget {
  final double width;
  final Widget child;
  const AnimatedWidth({super.key, required this.width, required this.child});
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween<double>(end: width),
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOutCubic,
        builder: (_, w, __) => SizedBox(width: w, child: child),
      );
}

class ExpandingTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final List<Widget> actions;
  const ExpandingTab({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final brand = t.colorScheme.primary;
    final idle = t.colorScheme.onSurface.withOpacity(0.7);
    final bg = isActive ? brand : Colors.transparent;
    final fg = isActive ? Colors.white : idle;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(horizontal: isActive ? 12 : 8, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isActive ? brand : idle.withOpacity(0.3), width: 1.1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(color: fg, fontWeight: isActive ? FontWeight.w800 : FontWeight.w500, fontSize: isActive ? 18 : 14),
                child: Text(label, overflow: TextOverflow.fade),
              ),
              if (isActive)
                IconTheme(
                  data: const IconThemeData(color: Colors.white),
                  child: Row(children: actions),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class MiniIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const MiniIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(icon, size: 18),
        tooltip: tooltip,
        onPressed: onTap,
        visualDensity: VisualDensity.compact,
      );
}
