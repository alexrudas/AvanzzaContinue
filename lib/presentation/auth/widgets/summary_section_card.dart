// ============================================================================
// lib/presentation/auth/widgets/summary_section_card.dart
//
// QUÉ HACE:
// Widget reutilizable que renderiza un bloque del resumen de registro.
// Cada bloque tiene un título, una lista de SummaryItem y un botón de edición
// opcional. Si el bloque no es editable, muestra un hint descriptivo.
//
// QUÉ NO HACE:
// - No conoce lógica de negocio ni datos de registro.
// - No navega; la navegación es responsabilidad del caller via [onEdit].
//
// USO:
// SummarySectionCard(
//   title: 'UBICACIÓN',
//   items: data.locationItems,
//   onEdit: () => Get.toNamed(Routes.countryCity, arguments: {...}),
// )
// ============================================================================

import 'package:flutter/material.dart';

import '../mappers/registration_summary_mapper.dart';

/// Bloque visual del resumen de registro.
///
/// - [title]          Encabezado de sección (se muestra en mayúsculas).
/// - [items]          Lista de campos a mostrar en el bloque.
/// - [onEdit]         Callback al pulsar "Editar". Si es null, el bloque
///                    se muestra como read-only con el [nonEditableHint].
/// - [nonEditableHint] Texto corto que explica por qué no es editable
///                    (p.ej. "Verificado"). Solo visible cuando onEdit == null.
class SummarySectionCard extends StatelessWidget {
  final String title;
  final List<SummaryItem> items;
  final VoidCallback? onEdit;
  final String? nonEditableHint;

  const SummarySectionCard({
    super.key,
    required this.title,
    required this.items,
    this.onEdit,
    this.nonEditableHint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // No renderizar si no hay datos.
    if (items.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 0,
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header: título + botón editar ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título de sección en mayúsculas, estilo label pequeño
                Text(
                  title.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),

                // Editar — visible solo si el bloque es editable
                if (onEdit != null)
                  TextButton(
                    onPressed: onEdit,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: cs.primary,
                    ),
                    child: const Text('Editar'),
                  )

                // Hint de no-editable — visible si el bloque es read-only
                else if (nonEditableHint != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_outlined,
                            size: 13, color: cs.tertiary),
                        const SizedBox(width: 4),
                        Text(
                          nonEditableHint!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: cs.tertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // ── Separador ─────────────────────────────────────────────────
          Divider(
            height: 16,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: cs.outlineVariant.withValues(alpha: 0.3),
          ),

          // ── Rows de datos ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  _SummaryRow(item: items[i], theme: theme),
                  if (i < items.length - 1)
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: cs.outlineVariant.withValues(alpha: 0.2),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Fila individual del bloque: label a la izquierda, valor a la derecha.
class _SummaryRow extends StatelessWidget {
  final SummaryItem item;
  final ThemeData theme;

  const _SummaryRow({required this.item, required this.theme});

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            item.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 6,
          child: Text(
            item.value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: cs.onSurface,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
