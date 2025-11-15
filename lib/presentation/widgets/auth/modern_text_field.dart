import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ModernTextField - Campo de texto Material 3 con animaciones fluidas
///
/// Características UI PRO 2025:
/// - Bordes suaves (12px radius)
/// - Animación de foco fluida
/// - Prefijo/sufijo con iconos
/// - Validación visual
/// - Altura estándar 56px
/// - Soporte para obscureText (contraseñas)
class ModernTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? errorText;
  final AutovalidateMode autovalidateMode;

  const ModernTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.autofocus = false,
    this.focusNode,
    this.errorText,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _obscureTextToggled = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureTextToggled = widget.obscureText;

    // Animación de escala al obtener foco
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            focusNode: _focusNode,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            obscureText: _obscureTextToggled,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            autovalidateMode: widget.autovalidateMode,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              errorText: widget.errorText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: _buildSuffixIcon(colorScheme),
              filled: true,
              fillColor: _focusNode.hasFocus
                  ? colorScheme.primaryContainer.withValues(alpha: 0.1)
                  : colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 2,
                ),
              ),
            ),
            style: theme.textTheme.bodyLarge,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            validator: widget.validator,
          ),
        );
      },
    );
  }

  /// Construir icono de sufijo (incluye toggle para contraseña si aplica)
  Widget? _buildSuffixIcon(ColorScheme colorScheme) {
    if (widget.obscureText) {
      // Si es campo de contraseña, agregar toggle de visibilidad
      return IconButton(
        icon: Icon(
          _obscureTextToggled ? Icons.visibility_off : Icons.visibility,
          color: colorScheme.onSurfaceVariant,
        ),
        onPressed: () {
          setState(() {
            _obscureTextToggled = !_obscureTextToggled;
          });
        },
      );
    }

    return widget.suffixIcon;
  }
}
