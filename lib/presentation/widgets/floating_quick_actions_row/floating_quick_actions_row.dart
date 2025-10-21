/// QUICK ACTIONS — fila flotante con Positioned + blur + badge opcional
/// - Usa `FloatingQuickActions` dentro de un Stack. Este sí "flota".
/// - Contenido reutilizable en `FloatingQuickActionsRow`.
/// - onTap requerido en `QuickAction`.

library;

import 'dart:ui';

import 'package:flutter/material.dart';

/// Posición unificada
const double kQALeft = 10;
const double kQARight = 10;
const double kQABottom = 8;

/// Reserva estándar para que el scroll no quede tapado
const double kQAScrollReserve = 120;

/// Helper para padding inferior de scroll
double paddingBottomForQuickActions(BuildContext context,
    {double reserve = kQAScrollReserve}) {
  return reserve + MediaQuery.of(context).padding.bottom;
}

/// ---------------------------------------------------------------------------
/// Contenedor flotante (Positioned) que calcula safe bottom.
/// ---------------------------------------------------------------------------
class FloatingQuickActions extends StatelessWidget {
  final List<QuickAction> items;
  final double left;
  final double right;
  final double bottom; // margen base
  final bool respectSafeBottom; // suma padding.bottom
  final double spacing;
  final EdgeInsets padding;
  final Color borderColor;
  final Color containerTint;
  final double blurSigma;

  const FloatingQuickActions({
    super.key,
    required this.items,
    this.left = kQALeft,
    this.right = kQARight,
    this.bottom = kQABottom,
    this.respectSafeBottom = true,
    this.spacing = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
    this.borderColor = const Color(0xFF000000),
    this.containerTint = const Color(0x05000000),
    this.blurSigma = 10,
  });

  @override
  Widget build(BuildContext context) {
    final safe =
        respectSafeBottom ? MediaQuery.of(context).padding.bottom : 0.0;
    return Positioned(
      left: left,
      right: right,
      bottom: bottom + safe,
      child: FloatingQuickActionsRow(
        items: items,
        spacing: spacing,
        padding: padding,
        borderColor: borderColor,
        containerTint: containerTint,
        blurSigma: blurSigma,
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Fila visual reutilizable (sin Positioned).
/// ---------------------------------------------------------------------------
class FloatingQuickActionsRow extends StatelessWidget {
  final List<QuickAction> items;
  final double spacing;
  final EdgeInsets padding;
  final Color borderColor;
  final Color containerTint;
  final double blurSigma;

  const FloatingQuickActionsRow({
    super.key,
    required this.items,
    this.spacing = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
    this.borderColor = const Color(0xFF000000),
    this.containerTint = const Color(0x05000000),
    this.blurSigma = 10,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: containerTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 0.7),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _withSpacing(items, spacing),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _withSpacing(List<Widget> children, double gap) {
    if (children.isEmpty) return const [];
    final out = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      out.add(children[i]);
      if (i != children.length - 1) out.add(SizedBox(width: gap));
    }
    return out;
  }
}

/// ---------------------------------------------------------------------------
/// Botón individual con efecto acuoso y badge opcional. onTap requerido.
/// ---------------------------------------------------------------------------
class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  // Badge opcional
  final int badgeCount; // 0 = sin conteo
  final bool showBadge; // false = oculta aunque badgeCount > 0
  final Color badgeColor; // color del globo
  final bool capAt99; // true = "99+"

  const QuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.badgeCount = 0,
    this.showBadge = false,
    this.badgeColor = const Color(0xFFE53935),
    this.capAt99 = true,
  });

  @override
  Widget build(BuildContext context) {
    const double side = 64;
    final radius = BorderRadius.circular(12);

    final button = Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
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
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.30),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
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
                            Colors.white.withOpacity(0.05),
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
            if (showBadge && badgeCount > 0)
              Positioned(
                right: -4,
                top: -6,
                child: Badge(
                  count: badgeCount,
                  color: badgeColor,
                  capAt99: capAt99,
                ),
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
              color: Color(0xFF3C3C3C),
            ),
          ),
        ),
      ],
    );

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: button,
    );
  }
}

/// ---------------------------------------------------------------------------
/// Badge rojo opcional con contador.
/// ---------------------------------------------------------------------------
class Badge extends StatelessWidget {
  final int count;
  final Color color;
  final bool capAt99;

  const Badge({
    super.key,
    required this.count,
    required this.color,
    this.capAt99 = true,
  });

  @override
  Widget build(BuildContext context) {
    final text = capAt99 && count > 99 ? '99+' : '$count';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          height: 1.0,
        ),
      ),
    );
  }
}
