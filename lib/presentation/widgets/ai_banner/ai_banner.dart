// ============================================================================
// lib/presentation/widgets/ai_banner/ai_banner.dart
// ============================================================================
//
// QUÉ ES:
//   Banner IA PRO 2025 con:
//   - Ticker vertical por tarjeta (translateY + fade)
//   - Color semántico por severidad (fondo suave + acento en icono)
//   - Título y subtítulo (jerarquía tipográfica real)
//   - Pausa de rotación en interacción y al abrir modal
//   - Modal "Centro de alertas" con título fijo y body scrolleable
//   - Variante Sliver sticky
//   - Opción showHeader para ocultar el encabezado y dejar solo la tarjeta
//
// CÓMO USAR:
//   final msgs = aiMessagesTenantVehicle;
//   AIBanner(
//     messages: msgs,
//     showHeader: false,               // si la quieres debajo del saludo
//     badgeCount: msgs.length,
//     rotationInterval: const Duration(seconds: 5),
//   );
//
// NOTAS:
//   - Si MediaQuery.accessibleNavigation == true, reduce animaciones.
//   - Mantén títulos en 5–9 palabras y subtítulos en 1 línea, máx 2.
//
// ============================================================================

import 'dart:async';

import 'package:flutter/material.dart';

/// Dominios de alertas para clasificación
enum AIAlertDomain {
  documentos,
  financiero,
  operativo,
  comercial,
  multas,
  legal
}

/// Severidad tipada - Compatible con versión anterior
enum AIMessageType { success, warning, critical, info }

/// Prioridad de alerta (mapea desde severidad)
enum AIAlertPriority { critica, alta, media, oportunidad }

// Mapeo automático de severidad a prioridad
AIAlertPriority _defaultPriority(AIMessageType type) {
  return switch (type) {
    AIMessageType.critical => AIAlertPriority.critica,
    AIMessageType.warning => AIAlertPriority.alta,
    AIMessageType.info => AIAlertPriority.media,
    AIMessageType.success => AIAlertPriority.oportunidad,
  };
}

/// Modelo del mensaje con taxonomía extendida
@immutable
class AIBannerMessage {
  final AIMessageType type;
  final IconData icon;
  final String title;
  final String? subtitle;
  final AIAlertDomain domain;
  final AIAlertPriority priority;

  AIBannerMessage({
    required this.type,
    required this.icon,
    required this.title,
    this.subtitle,
    this.domain = AIAlertDomain.operativo,
    AIAlertPriority? priority,
  }) : priority = priority ?? _defaultPriority(type);

  /// Compatibilidad legada con string
  factory AIBannerMessage.legacy({
    required String type, // 'success' | 'warning' | 'danger' | 'info'
    required IconData icon,
    required String text,
  }) {
    final mapped = switch (type) {
      'success' => AIMessageType.success,
      'warning' => AIMessageType.warning,
      'danger' => AIMessageType.critical,
      'info' => AIMessageType.info,
      _ => AIMessageType.info,
    };
    // Usamos el mismo texto en title y null en subtitle para no romper layouts.
    return AIBannerMessage(
      type: mapped,
      icon: icon,
      title: text,
      subtitle: null,
      domain: AIAlertDomain.operativo,
    );
  }
}

/// Paleta semántica calculada por tipo
class _AITypeColors {
  final Color bg; // fondo suave
  final Color fg; // acento/ícono
  const _AITypeColors(this.bg, this.fg);
}

_AITypeColors _typeColors(AIMessageType type, ColorScheme cs) {
  return switch (type) {
    AIMessageType.success => const _AITypeColors(Color(0xFFD1FAE5), Color(0xFF10B981)),
    AIMessageType.warning => const _AITypeColors(Color(0xFFFEF3C7), Color(0xFFF59E0B)),
    AIMessageType.critical => const _AITypeColors(Color(0xFFFEE2E2), Color(0xFFEF4444)),
    AIMessageType.info => _AITypeColors(cs.primaryContainer.withValues(alpha: 0.35), cs.primary),
  };
}

/// Banner principal
class AIBanner extends StatefulWidget {
  // Contenido
  final List<AIBannerMessage> messages;

  // Header opcional
  final bool showHeader;
  final String headerTitle;
  final IconData headerIcon;
  final int badgeCount;

  // Comportamiento
  final Duration rotationInterval;
  final VoidCallback? onTap;
  final WidgetBuilder? detailsBuilder;

  // Estética
  final EdgeInsetsGeometry? padding; // padding interno de la tarjeta
  final BorderRadius? borderRadius; // radio del contenedor exterior
  final Gradient? gradient; // gradiente del contenedor
  final bool showBackdropCircle; // decoración sutil de fondo

  const AIBanner({
    super.key,
    required this.messages,
    this.showHeader = true,
    this.headerTitle = 'Asistente IA',
    this.headerIcon = Icons.smart_toy_rounded,
    this.badgeCount = 0,
    this.rotationInterval = const Duration(seconds: 5),
    this.onTap,
    this.detailsBuilder,
    this.padding,
    this.borderRadius,
    this.gradient,
    this.showBackdropCircle = true,
  });

  @override
  State<AIBanner> createState() => _AIBannerState();
}

class _AIBannerState extends State<AIBanner> {
  int _currentIndex = 0;
  Timer? _rotationTimer;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _startRotation();
  }

  @override
  void dispose() {
    _rotationTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AIBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changedInterval =
        oldWidget.rotationInterval != widget.rotationInterval;
    final changedLength = oldWidget.messages.length != widget.messages.length;
    if (changedInterval || changedLength) _restartRotation();
  }

  void _restartRotation() {
    _rotationTimer?.cancel();
    _startRotation();
  }

  void _startRotation() {
    if (widget.messages.length <= 1) return;
    _rotationTimer = Timer.periodic(widget.rotationInterval, (_) {
      if (!mounted || _paused) return;
      setState(
          () => _currentIndex = (_currentIndex + 1) % widget.messages.length);
    });
  }

  void _pause() => setState(() => _paused = true);
  void _resume() => setState(() => _paused = false);

  Future<void> _openDetailsModal(BuildContext context) async {
    _pause();
    if (widget.detailsBuilder != null) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: widget.detailsBuilder!,
      );
      _resume();
      return;
    }

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Asumo que .withValues es un método de extensión de tu proyecto.
    // Si no, reemplázalo por .withOpacity(0.18)
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
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
                // Header fijo del modal
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                  child: Row(
                    children: [
                      Text(
                        'Centro de alertas',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: cs.outline.withValues(alpha: 0.12)),
                // Body scrolleable
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: widget.messages.length,
                    separatorBuilder: (_, __) => Divider(
                        height: 1, color: cs.outline.withValues(alpha: 0.08)),
                    itemBuilder: (_, i) {
                      final m = widget.messages[i];
                      final colors = _typeColors(m.type, cs);
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: colors.fg,
                          child: Icon(m.icon, color: Colors.white, size: 18),
                        ),
                        title: Text(
                          m.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: m.subtitle == null
                            ? null
                            : Text(
                                m.subtitle!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Detalle: ${m.title}')),
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

    _resume();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) return const SizedBox.shrink();

    final mq = MediaQuery.of(context);
    final reduceMotion = mq.accessibleNavigation;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final current = widget.messages[_currentIndex];
    final colors = _typeColors(current.type, cs);

    // Alturas calculadas
    const cardHeight = 64.0; // tarjeta: un poco más alta por subtítulo

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header opcional

        // Ticker vertical: tarjeta con title + subtitle
        SizedBox(
          height: cardHeight,
          child: _VerticalTicker(
            key: ValueKey<int>(_currentIndex), // Clave para AnimatedSwitcher
            message: current,
            colors: colors,
            padding: widget.padding ??
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            reduceMotion: reduceMotion,
            onTap: widget.onTap ?? () => _openDetailsModal(context),
            onPointerDown: _pause,
            onPointerUpOrCancel: _resume,
          ),
        ),
      ],
    );
  }
}

/// Ticker vertical con transición translateY + fade
class _VerticalTicker extends StatelessWidget {
  final AIBannerMessage message;
  final _AITypeColors colors;
  final EdgeInsetsGeometry padding;
  final bool reduceMotion;
  final VoidCallback onTap;
  final VoidCallback onPointerDown;
  final VoidCallback onPointerUpOrCancel;

  const _VerticalTicker({
    super.key,
    required this.message,
    required this.colors,
    required this.padding,
    required this.reduceMotion,
    required this.onTap,
    required this.onPointerDown,
    required this.onPointerUpOrCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final duration = reduceMotion
        ? const Duration(milliseconds: 0)
        : const Duration(
            milliseconds: 400); // Aumento la duración para que sea más visible

    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (child, anim) {
        final offsetTween = Tween<Offset>(
          // El nuevo hijo entra desde arriba (ej. -1.0 significa una altura completa arriba)
          begin: const Offset(0, -1.0),
          end: Offset.zero,
        );

        // Para el hijo que sale, AnimatedSwitcher usará el tween 'reverse' (de end a begin)
        // Por lo tanto, el hijo que sale se moverá de Offset.zero a Offset(0, -1.0),
        // pero queremos que salga por abajo.
        // Para esto, necesitamos crear un CustomTween para el `out` animation.

        final animation = CurvedAnimation(
            parent: anim, curve: Curves.easeInOutQuad); // Curva más suave

        return SlideTransition(
          position: animation.drive(offsetTween), // El hijo que entra
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      // Este es un truco para AnimatedSwitcher. Al usar FadeTransition y SlideTransition
      // juntas, y querer movimientos opuestos (uno entra por arriba, otro sale por abajo),
      // a veces AnimatedSwitcher necesita un poco de ayuda con el "reverse" del slide.
      // Una forma de asegurar que el que sale se mueva hacia abajo es envolverlo en un
      // Transform.translate con un Tween para la salida, si el SlideTransition del
      // AnimatedSwitcher no es suficiente.

      // Sin embargo, AnimatedSwitcher con ValueKey debería manejarlo. Si no se ve
      // el movimiento saliente, podríamos necesitar un CustomTransitionBuilder más complejo.
      // Probemos con estos offsets primero, ya que son proporcionales al tamaño del contenedor.

      // Si el movimiento de salida sigue sin ser claro, podríamos necesitar un CustomTransitionBuilder
      // que use dos animaciones distintas para la entrada y la salida.
      // Por ahora, con un Offset de -1.0, debería ser más visible.

      child: Listener(
        onPointerDown: (_) => onPointerDown(),
        onPointerUp: (_) => onPointerUpOrCancel(),
        onPointerCancel: (_) => onPointerUpOrCancel(),
        child: InkWell(
          key: ValueKey<String>(
              message.title), // CLAVE CRUCIAL para AnimatedSwitcher
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: colors.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: colors.fg.withValues(alpha: 0.25), width: 1),
            ),
            constraints: const BoxConstraints(minHeight: 56),
            child: Row(
              children: [
                // Icono
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colors.fg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(message.icon, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 10),
                // Texto
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título fuerte
                      Text(
                        message.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          // Asumo que .withValues es un método de extensión de tu proyecto.
                          // Si no, reemplázalo por .withOpacity(0.90)
                          color: Colors.black.withValues(alpha: 0.90),
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      // Subtítulo tenue
                      if (message.subtitle != null)
                        Text(
                          message.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            // Asumo que .withValues es un método de extensión de tu proyecto.
                            // Si no, reemplázalo por .withOpacity(0.70)
                            color: cs.onSurface.withValues(alpha: 0.70),
                            fontWeight: FontWeight.w500,
                            height: 1.15,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.unfold_more_rounded,
                    // Asumo que .withValues es un método de extensión de tu proyecto.
                    // Si no, reemplázalo por .withOpacity(0.45)
                    color: Colors.black.withValues(alpha: 0.45),
                    size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Variante Sliver sticky
class SliverAIBanner extends StatelessWidget {
  final List<AIBannerMessage> messages;
  final bool showHeader;
  final String headerTitle;
  final IconData headerIcon;
  final int badgeCount;
  final Duration rotationInterval;
  final VoidCallback? onTap;
  final WidgetBuilder? detailsBuilder;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final bool showBackdropCircle;

  const SliverAIBanner({
    super.key,
    required this.messages,
    this.showHeader = true,
    this.headerTitle = 'Asistente IA',
    this.headerIcon = Icons.smart_toy_rounded,
    this.badgeCount = 0,
    this.rotationInterval = const Duration(seconds: 5),
    this.onTap,
    this.detailsBuilder,
    this.padding,
    this.borderRadius,
    this.gradient,
    this.showBackdropCircle = true,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverPersistentHeader(
      pinned: true,
      delegate: _AIBannerHeaderDelegate(
        messages: messages,
        showHeader: showHeader,
        headerTitle: headerTitle,
        headerIcon: headerIcon,
        badgeCount: badgeCount,
        rotationInterval: rotationInterval,
        onTap: onTap,
        detailsBuilder: detailsBuilder,
        padding: padding,
        borderRadius: borderRadius,
        gradient: gradient,
        showBackdropCircle: showBackdropCircle,
      ),
    );
  }
}

class _AIBannerHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<AIBannerMessage> messages;
  final bool showHeader;
  final String headerTitle;
  final IconData headerIcon;
  final int badgeCount;
  final Duration rotationInterval;
  final VoidCallback? onTap;
  final WidgetBuilder? detailsBuilder;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final bool showBackdropCircle;

  _AIBannerHeaderDelegate({
    required this.messages,
    required this.showHeader,
    required this.headerTitle,
    required this.headerIcon,
    required this.badgeCount,
    required this.rotationInterval,
    this.onTap,
    this.detailsBuilder,
    this.padding,
    this.borderRadius,
    this.gradient,
    this.showBackdropCircle = true,
  });

  @override
  double get minExtent => showHeader ? 96.0 : 72.0;
  @override
  double get maxExtent => minExtent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AIBanner(
      messages: messages,
      showHeader: showHeader,
      headerTitle: headerTitle,
      headerIcon: headerIcon,
      badgeCount: badgeCount,
      rotationInterval: rotationInterval,
      onTap: onTap,
      detailsBuilder: detailsBuilder,
      padding: padding,
      borderRadius: borderRadius,
      gradient: gradient,
      showBackdropCircle: showBackdropCircle,
    );
  }

  @override
  bool shouldRebuild(covariant _AIBannerHeaderDelegate old) {
    return old.messages != messages ||
        old.showHeader != showHeader ||
        old.headerTitle != headerTitle ||
        old.headerIcon != headerIcon ||
        old.badgeCount != badgeCount ||
        old.rotationInterval != rotationInterval ||
        old.padding != padding ||
        old.borderRadius != borderRadius ||
        old.gradient != gradient ||
        old.showBackdropCircle != showBackdropCircle ||
        old.onTap != onTap ||
        old.detailsBuilder != detailsBuilder;
  }
}

// ============================================================================
// LISTA DE MENSAJES — Rol: Arrendatario de Vehículo (ejemplo)
// Sustituye {placa}, {ciudad}, {díaDescanso}, {fechaX} en runtime.
// ============================================================================

final aiMessagesTenantVehicle = <AIBannerMessage>[
  // MULTAS
  AIBannerMessage(
    type: AIMessageType.warning,
    icon: Icons.gavel_rounded,
    title: 'Multas activas detectadas',
    subtitle: 'Revisa comparendos pendientes y evita intereses',
    domain: AIAlertDomain.multas,
  ),
  AIBannerMessage(
    type: AIMessageType.info,
    icon: Icons.verified_rounded,
    title: 'Sin multas registradas',
    subtitle: 'Buen comportamiento vial. Mantén esta racha',
    domain: AIAlertDomain.multas,
  ),

  // PICO Y PLACA
  AIBannerMessage(
    type: AIMessageType.info,
    icon: Icons.rule_rounded,
    title: 'Restricción por pico y placa',
    subtitle: 'Hoy la placa {placa} está restringida en {ciudad}',
    domain: AIAlertDomain.operativo,
  ),
  AIBannerMessage(
    type: AIMessageType.success,
    icon: Icons.directions_car_filled_rounded,
    title: 'Sin restricción vehicular',
    subtitle: 'Puedes circular hoy en {ciudad}',
    domain: AIAlertDomain.operativo,
  ),

  // DESCANSO
  AIBannerMessage(
    type: AIMessageType.info,
    icon: Icons.event_busy_rounded,
    title: 'Día de descanso: {díaDescanso}',
    subtitle: 'Aprovecha para mantenimiento preventivo',
    domain: AIAlertDomain.operativo,
  ),

  // LICENCIA
  AIBannerMessage(
    type: AIMessageType.warning,
    icon: Icons.badge_rounded,
    title: 'Licencia próxima a vencer',
    subtitle: 'Renueva antes de {fechaLicencia}',
    domain: AIAlertDomain.documentos,
  ),
  AIBannerMessage(
    type: AIMessageType.critical,
    icon: Icons.report_rounded,
    title: 'Licencia vencida',
    subtitle: 'Venció el {fechaLicencia}. No circules hasta renovarla',
    domain: AIAlertDomain.legal,
  ),

  // SOAT
  AIBannerMessage(
    type: AIMessageType.warning,
    icon: Icons.receipt_long_rounded,
    title: 'SOAT por vencer',
    subtitle: '{placa} vence el {fechaSOAT}',
    domain: AIAlertDomain.documentos,
  ),
  AIBannerMessage(
    type: AIMessageType.critical,
    icon: Icons.block_rounded,
    title: 'SOAT vencido',
    subtitle: '{placa} sin cobertura. Evita sanciones, renueva ya',
    domain: AIAlertDomain.legal,
  ),

  // SEGURO CONTRACTUAL
  AIBannerMessage(
    type: AIMessageType.warning,
    icon: Icons.policy_rounded,
    title: 'Seguro contractual por vencer',
    subtitle: 'Fecha límite {fechaContractual}',
    domain: AIAlertDomain.documentos,
  ),
  AIBannerMessage(
    type: AIMessageType.critical,
    icon: Icons.warning_amber_rounded,
    title: 'Seguro contractual vencido',
    subtitle: 'Venció el {fechaContractual}. Actualiza tu póliza',
    domain: AIAlertDomain.legal,
  ),

  // SEGURO EXTRACONTRACTUAL
  AIBannerMessage(
    type: AIMessageType.warning,
    icon: Icons.health_and_safety_rounded,
    title: 'Seguro extracontractual por vencer',
    subtitle: 'Revisa coberturas antes de {fechaExtra}',
    domain: AIAlertDomain.documentos,
  ),
  AIBannerMessage(
    type: AIMessageType.critical,
    icon: Icons.health_and_safety_outlined,
    title: 'Seguro extracontractual vencido',
    subtitle: 'Sin cobertura a terceros desde {fechaExtra}',
    domain: AIAlertDomain.legal,
  ),

  // RTM
  AIBannerMessage(
    type: AIMessageType.warning,
    icon: Icons.build_circle_rounded,
    title: 'RTM próxima a vencer',
    subtitle: 'Agenda la inspección antes de {fechaRTM}',
    domain: AIAlertDomain.documentos,
  ),
  AIBannerMessage(
    type: AIMessageType.critical,
    icon: Icons.engineering_rounded,
    title: 'RTM vencida',
    subtitle: 'Evita comparendos realizando la revisión',
    domain: AIAlertDomain.legal,
  ),

  // CONTRATO DE ARRENDAMIENTO
  AIBannerMessage(
    type: AIMessageType.warning,
    icon: Icons.description_rounded,
    title: 'Contrato por vencer',
    subtitle: 'Finaliza el {fechaContrato}. Decide renovar o terminar',
    domain: AIAlertDomain.comercial,
  ),
  AIBannerMessage(
    type: AIMessageType.critical,
    icon: Icons.assignment_late_rounded,
    title: 'Contrato vencido',
    subtitle: 'Sin vigencia desde {fechaContrato}. Regulariza el estado',
    domain: AIAlertDomain.legal,
  ),
];
