// ============================================================================
// lib/presentation/widgets/design_system/app_button.dart
// APP BUTTON — Design System Avanzza
//
// Componente reutilizable de botón. Preparado para onboarding, formularios,
// dashboards y modales.
//
// Variantes : primary  (FilledButton)  | secondary (OutlinedButton)
// Tamaños   : md (estándar)            | lg (CTA principal / onboarding)
// Estados   : normal | loading | disabled
// Iconos    : leadingIcon funciona en AMBAS variantes
// ============================================================================

import 'package:flutter/material.dart';

import '../../../core/theme/radius.dart';
import '../../../core/theme/spacing.dart';

// ── Enums públicos del Design System ─────────────────────────────────────────

/// Variante visual del botón.
enum AppButtonVariant {
  /// FilledButton — alto énfasis. Acción principal de la pantalla.
  primary,

  /// OutlinedButton — bajo énfasis. Acción secundaria o destructiva suave.
  secondary,
}

/// Tamaño del botón.
enum AppButtonSize {
  /// Tamaño estándar — formularios, listas, modales.
  md,

  /// Tamaño grande — CTAs de onboarding, pantallas de activación.
  lg,
}

// ── Widget ────────────────────────────────────────────────────────────────────

/// Botón estándar del Design System de Avanzza.
///
/// Siempre full-width. Soporta dark mode automáticamente vía [ThemeData].
///
/// ```dart
/// // CTA de onboarding
/// AppButton(
///   label: 'Registrar mi primer activo',
///   onPressed: controller.onRegister,
///   leadingIcon: Icons.add_circle_outline_rounded,
///   size: AppButtonSize.lg,
/// )
///
/// // Acción secundaria
/// AppButton(
///   label: 'Más tarde',
///   onPressed: controller.onDismiss,
///   variant: AppButtonVariant.secondary,
/// )
///
/// // Estado loading
/// AppButton(
///   label: 'Guardando…',
///   onPressed: null,
///   isLoading: true,
/// )
/// ```
class AppButton extends StatelessWidget {
  /// Texto del botón.
  final String label;

  /// Callback al presionar. Si es null, el botón queda deshabilitado.
  final VoidCallback? onPressed;

  /// Variante visual. Default: [AppButtonVariant.primary].
  final AppButtonVariant variant;

  /// Ícono izquierdo opcional. Funciona en primary y secondary.
  final IconData? leadingIcon;

  /// Si true, muestra spinner y deshabilita interacción.
  /// El ancho del botón NO cambia.
  final bool isLoading;

  /// Si true, deshabilita el botón independientemente de [onPressed].
  final bool disabled;

  /// Tamaño del botón. Default: [AppButtonSize.md].
  final AppButtonSize size;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
    this.isLoading = false,
    this.disabled = false,
    this.size = AppButtonSize.md,
  });

  // ── Efectividad de interacción ─────────────────────────────────────────────

  /// El botón está inactivo si está explícitamente deshabilitado,
  /// si no tiene callback, o si está en estado loading.
  bool get _isEffectivelyDisabled => disabled || onPressed == null || isLoading;

  VoidCallback? get _effectiveOnPressed =>
      _isEffectivelyDisabled ? null : onPressed;

  // ── Estilos dependientes de tamaño ────────────────────────────────────────

  EdgeInsets get _padding => switch (size) {
        AppButtonSize.md => const EdgeInsets.symmetric(vertical: AppSpacing.md),
        AppButtonSize.lg =>
          const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      };

  TextStyle get _labelStyle => switch (size) {
        AppButtonSize.md => const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        AppButtonSize.lg => const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
      };

  double get _iconSize => switch (size) {
        AppButtonSize.md => 18,
        AppButtonSize.lg => 20,
      };

  double get _spinnerSize => switch (size) {
        AppButtonSize.md => 16,
        AppButtonSize.lg => 18,
      };

  static const _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
  );

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: switch (variant) {
        AppButtonVariant.primary => FilledButton(
            onPressed: _effectiveOnPressed,
            style: FilledButton.styleFrom(padding: _padding, shape: _shape),
            child: _buildContent(context),
          ),
        AppButtonVariant.secondary => OutlinedButton(
            onPressed: _effectiveOnPressed,
            style: OutlinedButton.styleFrom(padding: _padding, shape: _shape),
            child: _buildContent(context),
          ),
      },
    );
  }

  // ── Contenido interno ──────────────────────────────────────────────────────

  /// Construye el contenido del botón según estado (loading / normal).
  ///
  /// Usa [context] para derivar el color del spinner desde el [ColorScheme],
  /// garantizando contraste correcto en primary y secondary.
  Widget _buildContent(BuildContext context) {
    if (isLoading) return _buildLoadingContent(context);
    if (leadingIcon != null) return _buildIconContent();
    return Text(label, style: _labelStyle);
  }

  /// Loading: spinner + label. Ancho del botón inalterado.
  Widget _buildLoadingContent(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // El spinner toma el color del foreground del botón según variante
    final spinnerColor = switch (variant) {
      AppButtonVariant.primary => cs.onPrimary,
      AppButtonVariant.secondary => cs.primary,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: _spinnerSize,
          height: _spinnerSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: spinnerColor,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: _labelStyle),
      ],
    );
  }

  /// Contenido normal con ícono izquierdo.
  Widget _buildIconContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(leadingIcon, size: _iconSize),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: _labelStyle),
      ],
    );
  }
}
