// ============================================================================
// lib/presentation/widgets/forms/reactive_text_field.dart
// REACTIVE TEXT FIELD — Enterprise Ultra Pro (Presentation / Widgets)
//
// QUÉ HACE:
// - Provee un campo de texto “reactivo” para formularios con GetX (RxString).
// - Mantiene binding bidireccional: UI -> RxString y RxString -> UI.
// - Evita deuda técnica de `TextFormField(initialValue: ...)` usando
//   TextEditingController + Worker (ever) para reflejar cambios programáticos.
// - Implementa tap-to-focus completo (icono + padding + campo).
// - Administra correctamente el ciclo de vida:
//   - FocusNode interno (si no se provee) se crea y se dispone sin leaks.
//   - Si se provee FocusNode externo, NO se dispone.
//   - TextEditingController siempre se dispone.
// - Dark-mode safe: usa ColorScheme + tokens (sin colores hardcodeados).
//
// QUÉ NO HACE:
// - NO define estilos hardcodeados de marca (colores fijos fuera de tokens).
// - NO hace validación de negocio (solo validator UI si se provee).
// - NO aplica formateadores/mascaras por defecto (solo si el caller lo extiende).
// - NO fuerza sincronización de estado si el usuario está escribiendo (no pisa input
//   mientras tiene foco).
//
// NOTAS:
// - `initialValue` solo se re-aplica si el campo NO tiene foco (protege UX).
// - Si cambia la instancia de RxString (nuevo controller / nuevo binding), el widget
//   re-bindea el Worker y refleja el valor cuando no hay foco.
// - Usa InteractionStates.disabledOpacity para opacidad disabled.
// ============================================================================

import 'package:avanzza/presentation/themes/tokens/primitives.dart';
import 'package:avanzza/presentation/themes/tokens/semantic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Campo de texto reactivo para formularios con binding GetX.
///
/// Enterprise-grade:
/// - Binding bidireccional: UI <-> RxString.
/// - UI reacciona a cambios programáticos del RxString (sin deuda técnica).
/// - Tap-to-focus completo (icono + padding + campo).
/// - FocusNode y TextEditingController con ciclo de vida correcto (sin leaks).
/// - Dark-mode safe: usa ColorScheme + tokens (sin colores hardcodeados).
/// - Disabled state coherente (usa disabledOpacity de tokens).
class ReactiveTextField extends StatefulWidget {
  const ReactiveTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.icon,
    this.initialValue,
    this.keyboardType,
    this.textInputAction,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onEditingComplete,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.focusNode,
  });

  final String label;
  final String hint;
  final RxString value;
  final IconData icon;

  /// Valor inicial para pre-poblar el campo (ej. desde BD).
  /// Si es null, usa value.value como fallback.
  ///
  /// Nota: Si cambia en rebuild, se aplicará SOLO si el campo NO tiene foco,
  /// para no pisar al usuario mientras escribe.
  final String? initialValue;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onEditingComplete;
  final AutovalidateMode autovalidateMode;

  /// FocusNode externo opcional. Si se provee, el widget NO lo dispone.
  final FocusNode? focusNode;

  @override
  State<ReactiveTextField> createState() => _ReactiveTextFieldState();
}

class _ReactiveTextFieldState extends State<ReactiveTextField> {
  late FocusNode _focusNode;
  bool _isInternalNode = false;

  late final TextEditingController _controller;

  /// Worker GetX para escuchar cambios en RxString y reflejarlos en UI.
  Worker? _rxWorker;

  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();

    _adoptFocusNode(widget.focusNode);
    _focusNode.addListener(_onFocusChanged);

    _controller = TextEditingController(
      text: widget.initialValue ?? widget.value.value,
    );

    _bindRxWorker(widget.value);
  }

  @override
  void didUpdateWidget(covariant ReactiveTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 1) FocusNode lifecycle (si cambia el external focusNode)
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_onFocusChanged);

      if (_isInternalNode) {
        _focusNode.dispose();
      }

      _adoptFocusNode(widget.focusNode);
      _focusNode.addListener(_onFocusChanged);
    }

    // 2) Si cambia la instancia de RxString, re-bindea el worker.
    if (oldWidget.value != widget.value) {
      _unbindRxWorker();
      _bindRxWorker(widget.value);

      // Refresca el texto desde el nuevo source si NO hay foco.
      if (!_hasFocus) {
        final next = widget.initialValue ?? widget.value.value;
        if (_controller.text != next) _controller.text = next;
      }
    }

    // 3) Si cambia initialValue, aplícalo SOLO si no hay foco.
    if (oldWidget.initialValue != widget.initialValue && !_hasFocus) {
      final next = widget.initialValue ?? widget.value.value;
      if (_controller.text != next) _controller.text = next;
    }
  }

  void _adoptFocusNode(FocusNode? external) {
    if (external != null) {
      _focusNode = external;
      _isInternalNode = false;
    } else {
      _focusNode = FocusNode();
      _isInternalNode = true;
    }
  }

  void _onFocusChanged() {
    final nowFocused = _focusNode.hasFocus;
    if (_hasFocus == nowFocused) return;

    setState(() {
      _hasFocus = nowFocused;
    });

    // Al perder foco, si RxString tiene otro valor (ej. normalización),
    // lo reflejamos en el campo.
    if (!_hasFocus) {
      final v = widget.value.value;
      if (_controller.text != v) _controller.text = v;
    }
  }

  void _bindRxWorker(RxString rx) {
    // Escucha cambios programáticos del RxString y actualiza UI
    // sin pisar al usuario mientras escribe (cuando hay foco).
    _rxWorker = ever<String>(rx, (v) {
      if (_hasFocus) return;
      if (_controller.text == v) return;
      _controller.text = v;
    });
  }

  void _unbindRxWorker() {
    _rxWorker?.dispose();
    _rxWorker = null;
  }

  @override
  void dispose() {
    _unbindRxWorker();
    _controller.dispose();

    _focusNode.removeListener(_onFocusChanged);
    if (_isInternalNode) _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Ojo: esto asume que InteractionStates.disabledOpacity existe en tus tokens.
    // Si no existe, reemplaza por 0.38.
    const disabledAlpha = InteractionStates.disabledOpacity;

    final fillColor = widget.enabled
        ? scheme.surfaceContainerHighest
        : scheme.surfaceContainerHighest.withValues(alpha: disabledAlpha);

    final borderColor = widget.enabled
        ? scheme.outline
        : scheme.outline.withValues(alpha: disabledAlpha);

    final iconColor = widget.enabled
        ? scheme.onSurfaceVariant
        : scheme.onSurfaceVariant.withValues(alpha: disabledAlpha);

    final labelColor = widget.enabled
        ? scheme.onSurface
        : scheme.onSurface.withValues(alpha: disabledAlpha);

    final hintColor = widget.enabled
        ? scheme.onSurfaceVariant
        : scheme.onSurfaceVariant.withValues(alpha: disabledAlpha);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        const SizedBox(height: SpacingPrimitives.xs),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: widget.enabled ? () => _focusNode.requestFocus() : null,
          child: Container(
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(RadiusPrimitives.md),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                const SizedBox(width: SpacingPrimitives.md),
                Icon(widget.icon, color: iconColor, size: 20),
                const SizedBox(width: SpacingPrimitives.sm),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    enabled: widget.enabled,
                    maxLines: widget.maxLines,
                    maxLength: widget.maxLength,
                    validator: widget.validator,
                    onEditingComplete: widget.onEditingComplete,
                    autovalidateMode: widget.autovalidateMode,

                    // Binding UI -> Rx
                    onChanged: (v) {
                      if (widget.value.value != v) widget.value.value = v;
                    },

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      hintText: widget.hint,
                      hintStyle: TextStyle(color: hintColor),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
