// ============================================================================
// lib/presentation/pages/provider/specialties/widgets/specialty_list_tile.dart
// SPECIALTY LIST TILE — Fila individual de la lista de specialties
//
// QUÉ HACE:
// - Renderiza una fila de ~56 dp con check explícito + nombre.
// - Toda la fila es área de tap (hit area completa, regla del prompt).
// - Feedback visual inmediato al tap: ícono `check_circle` en
//   `colorScheme.primary` cuando seleccionado, `radio_button_unchecked`
//   atenuado cuando no. Highlight de fondo sutil (primaryContainer
//   semitransparente) en filas seleccionadas.
//
// QUÉ NO HACE:
// - NO muestra `key` ni `kind` (la UI no los expone — regla del prompt:
//   "sin confusión PRODUCT vs SERVICE", el filtro ya acota el universo).
// - NO maneja estado: es un widget controlado por el caller.
//
// CAUSA RAÍZ DEL FIX (Hito 1.x — UX):
//   La versión anterior usaba `Checkbox + IgnorePointer` con defaults
//   de Material; sin `activeColor` configurado en el theme global, el
//   estado `selected=true` mostraba un check casi invisible (issue de
//   contraste, no de reactividad — el rebuild del Obx funcionaba bien).
//   Cambiar al ícono explícito + highlight elimina la dependencia del
//   theme y deja el feedback cristalino en cualquier modo (light/dark).
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../../core/theme/spacing.dart';
import '../../../../../domain/entities/catalog/specialty_entity.dart';

class SpecialtyListTile extends StatelessWidget {
  final Specialty specialty;
  final bool selected;
  final VoidCallback onTap;

  const SpecialtyListTile({
    super.key,
    required this.specialty,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Material(
      // Highlight de fondo sutil cuando seleccionado — ayuda al ojo a
      // localizar las filas marcadas al hacer scroll.
      color: selected
          ? cs.primaryContainer.withValues(alpha: 0.18)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                // Ícono explícito: el tap real lo maneja el InkWell
                // padre, así toda la fila es área de selección.
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? cs.primary : theme.hintColor,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    specialty.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      // Bold sutil cuando seleccionado refuerza el
                      // estado activo sin afectar layout (mismo height).
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected ? cs.onSurface : cs.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
