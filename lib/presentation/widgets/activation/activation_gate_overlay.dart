// ============================================================================
// lib/presentation/widgets/activation/activation_gate_overlay.dart
// ACTIVATION GATE OVERLAY — Enterprise Ultra Pro (Presentation / Activation)
//
// QUÉ HACE
// - Renderiza un overlay full-screen que bloquea la interacción con el Home.
// - Presenta copy dinámico según el contexto del usuario mediante
//   [ActivationGateConfig].
// - Expone un CTA principal para activar el flujo de creación/configuración
//   inicial del workspace.
// - Soporta dismiss opcional solo de sesión mediante callback externo.
// - Aplica animación de entrada fade + scale.
//
// QUÉ NO HACE
// - No consulta repositorios.
// - No contiene lógica de dominio.
// - No conoce controllers concretos.
// - No persiste estado de dismiss.
//
// PRINCIPIOS
// - Componente puramente de presentación.
// - A11y y scroll safety primero.
// - Anti-escape accidental: bloquea back mientras está montado.
// - Reutilizable: depende solo de config + callbacks.
//
// ENTERPRISE NOTES
// - Este widget no decide si debe mostrarse; esa responsabilidad vive en
//   ActivationGateController.
// - El CTA principal no asume necesariamente “crear activo”; el label lo define
//   [ActivationGateConfig]. El ícono puede sobreescribirse por parámetro.
// - "Más tarde" es opcional para permitir casos donde el gate deba ser
//   estrictamente obligatorio.
// ============================================================================

import 'package:flutter/material.dart';

import '../../../core/theme/radius.dart';
import '../../../core/theme/spacing.dart';
import '../design_system/app_button.dart';
import 'activation_gate_config.dart';

/// Overlay full-screen de activación inicial del workspace.
///
/// Completamente agnóstico del controller. Recibe:
/// - [config] para copy e ícono contextual
/// - [onPrimaryAction] para el CTA principal
/// - [onDismiss] para dismiss temporal de sesión (opcional)
///
/// Uso esperado:
/// ```dart
/// Obx(() {
///   if (!gateCtrl.showGate.value) return const SizedBox.shrink();
///
///   return Positioned.fill(
///     child: ActivationGateOverlay(
///       config: gateCtrl.config.value,
///       onPrimaryAction: gateCtrl.onCtaPressed,
///       onDismiss: gateCtrl.dismissForSession,
///     ),
///   );
/// })
/// ```
class ActivationGateOverlay extends StatefulWidget {
  /// Configuración visual y textual del overlay.
  final ActivationGateConfig config;

  /// Acción principal del gate.
  ///
  /// Normalmente navega al flujo de activación del workspace
  /// (ej. creación del primer activo, configuración técnica, catálogo, etc.).
  final VoidCallback onPrimaryAction;

  /// Dismiss opcional del gate para el resto de la sesión.
  ///
  /// Si es null, el gate se comporta como no descartable.
  final VoidCallback? onDismiss;

  /// Permite ocultar completamente la acción secundaria aunque [onDismiss]
  /// exista. Útil para escenarios donde producto requiera activación obligatoria.
  final bool allowDismiss;

  /// Label del botón secundario.
  ///
  /// Mantiene un default razonable para no obligar a repetir copy en todos
  /// los callers.
  final String dismissLabel;

  /// Ícono del CTA principal.
  ///
  /// Si es null, usa un ícono por defecto genérico de activación.
  final IconData? primaryActionIcon;

  const ActivationGateOverlay({
    super.key,
    required this.config,
    required this.onPrimaryAction,
    this.onDismiss,
    this.allowDismiss = true,
    this.dismissLabel = 'Más tarde',
    this.primaryActionIcon,
  });

  @override
  State<ActivationGateOverlay> createState() => _ActivationGateOverlayState();
}

class _ActivationGateOverlayState extends State<ActivationGateOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;

  bool get _canDismiss => widget.allowDismiss && widget.onDismiss != null;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animCtrl,
      curve: Curves.easeOut,
    );

    _scaleAnim = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: Curves.easeOutCubic,
      ),
    );

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final config = widget.config;

    return PopScope(
      canPop: false,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Scrim de bloqueo ────────────────────────────────────────
                ColoredBox(
                  color: cs.surface.withValues(alpha: 0.96),
                ),

                // ── Contenido seguro / scrollable ─────────────────────────
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.lg,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 560,
                        ),
                        child: _ActivationCard(
                          config: config,
                          primaryActionIcon: widget.primaryActionIcon ??
                              Icons.add_circle_outline_rounded,
                          onPrimaryAction: widget.onPrimaryAction,
                          showDismiss: _canDismiss,
                          dismissLabel: widget.dismissLabel,
                          onDismiss: widget.onDismiss,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

class _ActivationCard extends StatelessWidget {
  final ActivationGateConfig config;
  final IconData primaryActionIcon;
  final VoidCallback onPrimaryAction;
  final bool showDismiss;
  final String dismissLabel;
  final VoidCallback? onDismiss;

  const _ActivationCard({
    required this.config,
    required this.primaryActionIcon,
    required this.onPrimaryAction,
    required this.showDismiss,
    required this.dismissLabel,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.10),
            blurRadius: 28,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _WorkspaceIcon(
              icon: config.icon,
              backgroundColor: cs.primaryContainer,
              iconColor: cs.onPrimaryContainer,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              config.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              config.lead,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              config.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.55,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              label: config.ctaLabel,
              onPressed: onPrimaryAction,
              leadingIcon: primaryActionIcon,
              size: AppButtonSize.lg,
            ),
            if (showDismiss) ...[
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: dismissLabel,
                onPressed: onDismiss,
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.lg,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Ícono principal del contexto con tratamiento visual consistente.
class _WorkspaceIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _WorkspaceIcon({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Icon(
        icon,
        size: 48,
        color: iconColor,
      ),
    );
  }
}
