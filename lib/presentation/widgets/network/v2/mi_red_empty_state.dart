// ============================================================================
// lib/presentation/widgets/network/v2/mi_red_empty_state.dart
// MI RED EMPTY STATE — Estado global cuando no hay actores
// ============================================================================
// QUÉ HACE:
//   - Renderiza icono + título + descripción + CTA "Registrar actor".
//   - El CTA dispara el callback inyectado (típicamente:
//     `showRegisterActorSheet(context)`).
//   - Vive dentro de un ListView envuelto por RefreshIndicator (gracias
//     al padre MiRedPage) — por eso es scrollable aunque cabe en pantalla.
//
// QUÉ NO HACE:
//   - No renderiza FAB: la página padre oculta el FAB cuando este empty
//     state está visible (decisión congelada del blueprint V1).
//   - No infiere data — solo recibe el callback.
// ============================================================================

import 'package:flutter/material.dart';

import '../../../view_models/network/v2/mi_red_labels.dart';

class MiRedEmptyState extends StatelessWidget {
  /// Callback del CTA central. Debe abrir el RegisterActorSheet.
  final VoidCallback onTapRegistrar;

  const MiRedEmptyState({super.key, required this.onTapRegistrar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.groups_outlined,
              size: 64,
              color: cs.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              MiRedLabels.emptyTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              MiRedLabels.emptyDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onTapRegistrar,
              icon: const Icon(Icons.add),
              label: const Text(MiRedLabels.emptyCta),
            ),
          ],
        ),
      ),
    );
  }
}
