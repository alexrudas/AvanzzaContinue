// lib/presentation/pages/dev/integrations_diagnostics/widgets/diagnostic_state_view.dart
// ============================================================================
// DIAGNOSTIC STATE VIEW (DEV-only)
// ----------------------------------------------------------------------------
// Estados de pantalla compartidos por las 4 herramientas de diagnóstico:
//   idle | loading | success | empty | failed
// El éxito (success/empty) se renderiza vía slot `successBuilder`.
// ============================================================================

import 'package:flutter/material.dart';

enum DiagnosticState { idle, loading, success, empty, failed }

class DiagnosticStateView extends StatelessWidget {
  final DiagnosticState state;
  final String idleMessage;
  final String emptyMessage;
  final String? failureMessage;
  final WidgetBuilder successBuilder;

  const DiagnosticStateView({
    super.key,
    required this.state,
    required this.idleMessage,
    required this.emptyMessage,
    required this.successBuilder,
    this.failureMessage,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case DiagnosticState.idle:
        return _Centered(icon: Icons.search_outlined, text: idleMessage);
      case DiagnosticState.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Center(child: CircularProgressIndicator()),
        );
      case DiagnosticState.failed:
        return _Centered(
          icon: Icons.error_outline,
          text: failureMessage ?? 'La consulta falló.',
          color: Theme.of(context).colorScheme.error,
        );
      case DiagnosticState.empty:
        return _Centered(icon: Icons.inbox_outlined, text: emptyMessage);
      case DiagnosticState.success:
        return successBuilder(context);
    }
  }
}

class _Centered extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  const _Centered({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = color ?? cs.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        children: [
          Icon(icon, size: 36, color: fg),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: fg, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// Card sección reutilizable para agrupar bloques de información renderizada.
class DiagnosticSectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget child;

  const DiagnosticSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: cs.primary),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

/// Fila label/valor estandarizada para los renders de detalle.
class DiagnosticKvRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool monospace;

  const DiagnosticKvRow({
    super.key,
    required this.label,
    required this.value,
    this.monospace = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final display = (value == null || value!.trim().isEmpty) ? '—' : value!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              display,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: monospace ? 'monospace' : null,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
