// ============================================================================
// DEMO REGISTRATION V2 — STEP SCAFFOLD (TEMPORARY, SAFE TO DELETE)
// ============================================================================

import 'package:flutter/material.dart';

class DemoStepScaffold extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String title;
  final Widget child;

  /// Acción principal (botón Continuar). Se renderiza INLINE al final del
  /// body, justo después del `child` — no sticky al bottom. Esto coloca
  /// el CTA cerca del contenido (mejor ergonomía) y evita el "muy abajo"
  /// del bottomNavigationBar.
  final Widget? primaryAction;

  /// Acción secundaria opcional (ej. "Lo configuraré después"). Se renderiza
  /// debajo del primaryAction, dentro del scroll, no sticky.
  final Widget? secondaryAction;

  final VoidCallback? onBack;
  final bool showBack;

  /// Label opcional encima del título principal. Útil cuando queremos que el
  /// title sea contextual (ej. nombre del rol del usuario) y "Tu negocio" o
  /// similar quede como categoría/eyebrow más pequeña.
  final String? eyebrow;

  /// Widget opcional que se renderiza PEGADO al título principal (gap 4px),
  /// antes del child. Útil para subtítulos contextuales con peso fuerte
  /// (ej. "Conductor de vehículo") que deben sentirse parte del header,
  /// no del body.
  ///
  /// Si es null, gap title→child sigue siendo 12px (default).
  /// Si está presente, gap title→headerExtra=0 (pegado al title, solo
  /// line-height natural separa) y headerExtra→child=12px.
  final Widget? headerExtra;

  const DemoStepScaffold({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    required this.child,
    this.primaryAction,
    this.secondaryAction,
    this.onBack,
    this.showBack = true,
    this.eyebrow,
    this.headerExtra,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final progress = (currentStep + 1) / totalSteps;

    return Scaffold(
      appBar: AppBar(
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              )
            : const SizedBox.shrink(),
        title: Row(
          children: [
            const Icon(Icons.science_rounded, size: 18),
            const SizedBox(width: 8),
            Text(
              'Registro · Demo',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: cs.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Paso ${currentStep + 1} de $totalSteps',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      letterSpacing: 0.4,
                    ),
                  ),
                  if (eyebrow != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      eyebrow!,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ] else
                    const SizedBox(height: 4),
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // headerExtra (subtítulo fuerte) PEGADO al título:
                  // sin SizedBox arriba — solo el line-height natural de las
                  // fuentes los separa. 12px abajo (separación con body).
                  // Si no hay headerExtra, gap directo al child = 12px (legacy).
                  if (headerExtra != null) ...[
                    headerExtra!,
                    const SizedBox(height: 12),
                  ] else
                    const SizedBox(height: 12),
                  child,
                  // Primary action INLINE — justo después del contenido, no
                  // pegado al bottom de la pantalla. Acerca el CTA al form.
                  if (primaryAction != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: primaryAction,
                    ),
                  ],
                  if (secondaryAction != null) ...[
                    const SizedBox(height: 4),
                    Center(child: secondaryAction!),
                  ],
                  // Padding inferior mínimo para que el último elemento no
                  // se pegue al borde del scroll cuando todo cabe en viewport.
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
