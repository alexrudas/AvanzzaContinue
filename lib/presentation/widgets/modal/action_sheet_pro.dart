// lib/presentation/widgets/modals/avanzza_action_sheet_pro.dart
// ============================================================================
// AVANZZA ACTION SHEET — PRO 2025
// Hoja de acciones tipo iOS/Material con:
// • Diseño glass (blur + gradient) sobre fondo blanco con opacidad
// • Drag handle, spring animation, safe area, teclado, accesibilidad
// • Lista dinámica con secciones opcionales
// • Estados de ítem: normal, destructivo, disabled, async-loading por ítem
// • Icono opcional, subtítulo opcional, badge opcional, trailing custom
// • Haptics, semántica, focus, shortcuts (desktop/web)
// • Theming centralizado y override por llamada
// • Adaptativo: ancho máx en tablet/desktop, scroll con separadores
// ============================================================================

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ---------------------------------------------------------------------------
/// Tema del sheet (Material 3 friendly).
class ActionSheetTheme {
  final double cornerRadius;
  final double elevation;
  final double opacity; // Opacidad del card
  final Color background; // Base del card antes de la opacidad
  final Color borderColor; // Borde más oscuro que el fondo
  final EdgeInsets padding;
  final bool backdropBlur;
  final double backdropSigma;
  final double bottomGap; // <--- NUEVO

  const ActionSheetTheme({
    this.cornerRadius = 18,
    this.elevation = 18,
    this.opacity = 0.94,
    this.background = Colors.white,
    this.borderColor = const Color(0x1A000000),
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    this.backdropBlur = true,
    this.backdropSigma = 8,
    this.bottomGap = 24, // <--- separación extra desde el borde inferior
  });

  ActionSheetTheme copyWith({
    double? cornerRadius,
    double? elevation,
    double? opacity,
    Color? background,
    Color? borderColor,
    EdgeInsets? padding,
    bool? backdropBlur,
    double? backdropSigma,
    double? bottomGap, // <--- NUEVO
  }) {
    return ActionSheetTheme(
      cornerRadius: cornerRadius ?? this.cornerRadius,
      elevation: elevation ?? this.elevation,
      opacity: opacity ?? this.opacity,
      background: background ?? this.background,
      borderColor: borderColor ?? this.borderColor,
      padding: padding ?? this.padding,
      backdropBlur: backdropBlur ?? this.backdropBlur,
      backdropSigma: backdropSigma ?? this.backdropSigma,
      bottomGap: bottomGap ?? this.bottomGap, // <---
    );
  }
}

/// ---------------------------------------------------------------------------
/// Modelo de un ítem. Soporta estados y UI avanzada.
class ActionItem {
  final String label; // Requerido
  final String? subtitle; // Opcional
  final IconData? icon; // Opcional
  final bool destructive; // Rojo de advertencia
  final bool enabled; // Para deshabilitar
  final String? badge; // "99+" etc.
  final Widget? trailing; // Chip/Toggle/etc.
  final Future<void> Function()? onAsyncTap; // Manejo async con spinner
  final VoidCallback? onTap; // Manejo sync

  const ActionItem({
    required this.label,
    this.subtitle,
    this.icon,
    this.destructive = false,
    this.enabled = true,
    this.badge,
    this.trailing,
    this.onAsyncTap,
    this.onTap,
  }) : assert(onAsyncTap != null || onTap != null, 'Define onTap o onAsyncTap');
}

/// ---------------------------------------------------------------------------
/// Sección opcional con encabezado.
class ActionSection {
  final String? header; // Título de sección opcional
  final List<ActionItem> items; // Ítems de la sección
  const ActionSection({this.header, required this.items});
}

/// ---------------------------------------------------------------------------
/// API de presentación (estática).
// 2) show(): usa bottomGap para separar el sheet del borde inferior
class ActionSheetPro {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<ActionSection> data,
    ActionSheetTheme theme = const ActionSheetTheme(),
    Color? barrierColor,
  }) async {
    final safeTheme = theme;

    await HapticFeedback.selectionClick();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.28),
      elevation: 0,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 260),
      ),
      builder: (ctx) {
        final mq = MediaQuery.of(ctx);
        final maxWidth = mq.size.width > 520 ? 520.0 : double.infinity;

        final card = _SheetScaffold(
          title: title,
          data: data,
          theme: safeTheme,
          maxWidth: maxWidth,
        );

        // separación inferior = safeArea + gap configurable
        final bottomGap = mq.padding.bottom + safeTheme.bottomGap;

        return Stack(
          children: [
            // Cierra al tocar cualquier parte fuera del sheet
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(ctx).maybePop(),
              ),
            ),

            // Sheet alineado abajo con espacio extra
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, bottomGap + 12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: safeTheme.backdropBlur
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.circular(safeTheme.cornerRadius),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: safeTheme.backdropSigma,
                              sigmaY: safeTheme.backdropSigma,
                            ),
                            child: card,
                          ),
                        )
                      : card,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// UI del sheet: header + lista de secciones + separadores.
class _SheetScaffold extends StatelessWidget {
  final String title;
  final List<ActionSection> data;
  final ActionSheetTheme theme;
  final double maxWidth;

  const _SheetScaffold({
    required this.title,
    required this.data,
    required this.theme,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final bg = theme.background.withOpacity(theme.opacity);
    final border = _darker(bg, 0.14);

    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.cornerRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.13),
              blurRadius: theme.elevation,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(theme.cornerRadius),
            border: Border.all(color: border, width: 0.9),
            // Gradiente muy sutil para dar “profundidad”
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [bg, bg.withOpacity((theme.opacity - 0.08).clamp(0, 1))],
            ),
          ),
          child: Padding(
            padding: theme.padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 6),
                _DragHandle(color: _darker(bg, 0.25)),
                const SizedBox(height: 8),

                // ---------------------- Header -------------------------------
                Semantics(
                  label: title,
                  header: true,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Cerrar',
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // ---------------------- Lista -------------------------------
                Flexible(
                  child: _SectionsList(data: data),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Color _darker(Color base, double amount) {
    final hsl = HSLColor.fromColor(base);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor()
        .withOpacity(base.opacity);
  }
}

/// ---------------------------------------------------------------------------
/// Drag handle superior.
class _DragHandle extends StatelessWidget {
  final Color color;
  const _DragHandle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Lista con secciones y separadores.
class _SectionsList extends StatelessWidget {
  final List<ActionSection> data;
  const _SectionsList({required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: data.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, idx) {
        final section = data[idx];
        return _Section(section: section);
      },
    );
  }
}

/// ---------------------------------------------------------------------------
/// Sección con header opcional y lista de ítems.
class _Section extends StatelessWidget {
  final ActionSection section;
  const _Section({required this.section});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.header != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 6),
              child: Text(
                section.header!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.black54, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              color: Colors.transparent,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: section.items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) =>
                    _ActionTile(item: section.items[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Tile de acción PRO: icono opcional, subtítulo, badge, estados, loading.
class _ActionTile extends StatefulWidget {
  final ActionItem item;
  const _ActionTile({required this.item});

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final i = widget.item;
    final baseStyle = Theme.of(context).textTheme.bodyLarge!;
    final color = i.enabled
        ? (i.destructive ? Colors.red.shade700 : Colors.black87)
        : Colors.black38;

    return FocusableActionDetector(
      enabled: i.enabled,
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<Intent>(onInvoke: (e) {
          _onPressed();
          return null;
        }),
      },
      child: InkWell(
        onTap: i.enabled ? _onPressed : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              if (i.icon != null) ...[
                Icon(i.icon, color: color, size: 22),
                const SizedBox(width: 12),
              ],
              // Texto principal + subtítulo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            i.label,
                            style: baseStyle.copyWith(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Badge opcional
                        if (i.badge != null) ...[
                          const SizedBox(width: 8),
                          _Badge(text: i.badge!),
                        ],
                      ],
                    ),
                    if (i.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        i.subtitle!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.black54),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Trailing custom o spinner si loading async
              if (_loading)
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                (i.trailing ?? const Icon(Icons.chevron_right_rounded)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onPressed() async {
    final i = widget.item;
    await HapticFeedback.lightImpact();

    if (i.onAsyncTap != null) {
      setState(() => _loading = true);
      try {
        await i.onAsyncTap!.call();
        if (mounted) Navigator.of(context).maybePop();
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    } else {
      if (mounted) Navigator.of(context).pop();
      i.onTap?.call();
    }
  }
}

/// ---------------------------------------------------------------------------
/// Badge compacto.
class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black26, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
