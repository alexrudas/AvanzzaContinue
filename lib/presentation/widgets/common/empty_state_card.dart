// ============================================================================
// lib/presentation/widgets/common/empty_state_card.dart
// EMPTY STATE CARD — Widget reutilizable de estado vacío
// ============================================================================

import 'package:flutter/material.dart';

import '../../../core/theme/radius.dart';
import '../../../core/theme/spacing.dart';
import '../../config/empty_state_config.dart';
import '../design_system/app_button.dart';

class EmptyStateCard extends StatelessWidget {
  final EmptyStateConfig config;
  final VoidCallback onCtaPressed;
  final Widget? leading;
  final double maxWidth;
  final bool scrollSafe;
  final EdgeInsetsGeometry padding;

  const EmptyStateCard({
    super.key,
    required this.config,
    required this.onCtaPressed,
    this.leading,
    this.maxWidth = 480,
    this.scrollSafe = true,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
  });

  @override
  Widget build(BuildContext context) {
    final card = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: _CardShell(
          padding: padding,
          child: _CardContent(
            config: config,
            leading: leading,
            onCtaPressed: onCtaPressed,
          ),
        ),
      ),
    );

    if (!scrollSafe) return card;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: card,
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _CardShell({
    required this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.40),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final EmptyStateConfig config;
  final Widget? leading;
  final VoidCallback onCtaPressed;

  const _CardContent({
    required this.config,
    required this.leading,
    required this.onCtaPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        leading ??
            _DefaultLeading(
              icon: config.icon,
              backgroundColor: cs.primaryContainer,
              iconColor: cs.onPrimaryContainer,
            ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          config.title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: AppSpacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Text(
            config.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.55,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: config.ctaLabel,
          onPressed: onCtaPressed,
          leadingIcon: Icons.add_circle_outline_rounded,
          size: AppButtonSize.lg,
        ),
      ],
    );
  }
}

class _DefaultLeading extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _DefaultLeading({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Icon(
        icon,
        size: 40,
        color: iconColor,
      ),
    );
  }
}
