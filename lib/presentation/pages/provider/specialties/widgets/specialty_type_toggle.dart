// ============================================================================
// lib/presentation/pages/provider/specialties/widgets/specialty_type_toggle.dart
// SPECIALTY TYPE TOGGLE — Segmented [Productos] [Servicios] [Ambos]
//
// QUÉ HACE:
// - Segmented control de 3 opciones (Productos / Servicios / Ambos),
//   controlado por el caller. Siempre hay UNA opción activa — no hay
//   estado "ninguno". El default visual es "Ambos" cuando
//   `offerType == SpecialtyOfferType.both` (== `selectedKind == null`).
// - Tap sobre una opción notifica al caller con el `SpecialtyOfferType`
//   correspondiente; el caller traduce a `SpecialtyKind?` para el fetch.
//
// MICRO-FEEDBACK:
// - `AnimatedContainer` (160 ms) suaviza la transición de color/borde
//   cuando el chip pasa de no-seleccionado → seleccionado y viceversa.
// - `_PressScale` aplica un escalado 1.0 ↔ 0.96 mientras el dedo está
//   abajo, dando sensación táctil instantánea sin esperar al refetch.
//
// QUÉ NO HACE:
// - NO filtra en cliente.
// - NO bloquea durante el loading: el indicador inline de la página basta
//   para feedback de carga.
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../../core/theme/radius.dart';
import '../../../../../core/theme/spacing.dart';
import '../../../../../domain/services/catalog/specialty_grouping.dart';

class SpecialtyTypeToggle extends StatelessWidget {
  final SpecialtyOfferType offerType;
  final ValueChanged<SpecialtyOfferType> onSelectOfferType;

  const SpecialtyTypeToggle({
    super.key,
    required this.offerType,
    required this.onSelectOfferType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleChip(
              label: 'Productos',
              selected: offerType == SpecialtyOfferType.product,
              onTap: () => onSelectOfferType(SpecialtyOfferType.product),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _ToggleChip(
              label: 'Servicios',
              selected: offerType == SpecialtyOfferType.service,
              onTap: () => onSelectOfferType(SpecialtyOfferType.service),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _ToggleChip(
              label: 'Ambos',
              selected: offerType == SpecialtyOfferType.both,
              onTap: () => onSelectOfferType(SpecialtyOfferType.both),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Toggle chip con dos capas de feedback:
//   - estado `selected` animado (color/borde)  — AnimatedContainer 160 ms
//   - estado `pressed` táctil instantáneo      — _PressScale 1.0 ↔ 0.96
// ─────────────────────────────────────────────────────────────────────────
class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const Duration _selectedDuration = Duration(milliseconds: 160);
  static const Curve _selectedCurve = Curves.easeOut;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bg = selected ? cs.primaryContainer : cs.surfaceContainerHighest;
    final fg = selected ? cs.onPrimaryContainer : cs.onSurfaceVariant;
    final border =
        selected ? cs.primary : cs.outlineVariant.withValues(alpha: 0.6);

    return _PressScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: _selectedDuration,
        curve: _selectedCurve,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border, width: 1),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: AnimatedDefaultTextStyle(
          duration: _selectedDuration,
          curve: _selectedCurve,
          style: theme.textTheme.labelLarge!.copyWith(
            color: fg,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

/// Wrapper táctil: escala el hijo a 0.96 mientras el dedo está abajo y
/// vuelve a 1.0 al soltar/cancelar. Dispara `onTap` en `onTapUp`.
///
/// Se prefiere sobre `InkWell` aquí porque la respuesta visual debe ser
/// inmediata (no esperar al ripple) y porque el `AnimatedContainer` ya
/// gestiona el highlight de color por estado `selected`.
class _PressScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PressScale({
    required this.child,
    required this.onTap,
  });

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  static const Duration _pressDuration = Duration(milliseconds: 90);
  static const double _pressedScale = 0.96;

  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) {
        _setPressed(false);
        widget.onTap();
      },
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        duration: _pressDuration,
        curve: Curves.easeOut,
        scale: _pressed ? _pressedScale : 1.0,
        child: widget.child,
      ),
    );
  }
}
