// ============================================================================
// lib/presentation/widgets/core_common/match_resolution_sheet.dart
// MATCH RESOLUTION SHEET — F5 Hito 3 / UI mínima de acción
// ============================================================================
// QUÉ HACE:
//   - Bottom sheet que ofrece dos acciones sobre un MatchCandidate expuesto:
//       · Vincular (confirm)
//       · Descartar (dismiss)
//   - Delega en ResolveMatchCandidate (DI) y cierra al terminar.
//
// QUÉ NO HACE:
//   - NO crea OperationalRelationship ni pantallas de detalle.
//   - NO muestra spinners full-screen; solo deshabilita los botones durante
//     la operación para prevenir doble-tap.
//   - NO reintenta: el error se muestra via SnackBar y el usuario decide.
// ============================================================================

import 'package:flutter/material.dart';

import '../../../application/core_common/use_cases/resolve_match_candidate.dart';
import '../../../core/di/container.dart';
import '../../../domain/entities/core_common/match_candidate_entity.dart';

class MatchResolutionSheet extends StatefulWidget {
  final MatchCandidateEntity candidate;

  const MatchResolutionSheet({super.key, required this.candidate});

  /// Atajo para abrir el sheet modal.
  static Future<void> show(
    BuildContext context,
    MatchCandidateEntity candidate,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: false,
      builder: (_) => MatchResolutionSheet(candidate: candidate),
    );
  }

  @override
  State<MatchResolutionSheet> createState() => _MatchResolutionSheetState();
}

class _MatchResolutionSheetState extends State<MatchResolutionSheet> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.link, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Canal disponible',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Este registro coincide con un actor verificado en Avanzza. '
              'Puedes vincularlo para habilitar interacciones más integradas, '
              'o descartarlo si no corresponde.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _busy ? null : () => _execute(ResolveDecision.confirm),
              child: const Text('Vincular'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _busy ? null : () => _execute(ResolveDecision.dismiss),
              child: const Text('Descartar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _execute(ResolveDecision decision) async {
    setState(() => _busy = true);
    try {
      await DIContainer().resolveMatchCandidate.execute(
            candidate: widget.candidate,
            decision: decision,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (err) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo guardar la decisión. Intenta de nuevo.',
          ),
        ),
      );
    }
  }
}
