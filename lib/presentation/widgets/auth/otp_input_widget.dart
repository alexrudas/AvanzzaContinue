import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// OtpInputWidget - Widget para entrada de código OTP de 6 dígitos
///
/// Características UI PRO 2025:
/// - 6 campos individuales con auto-foco
/// - Animación de entrada fluida
/// - Validación visual por campo
/// - Bordes suaves
/// - Auto-submit cuando se completan los 6 dígitos
class OtpInputWidget extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final int length;
  final bool autoFocus;

  const OtpInputWidget({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.length = 6,
    this.autoFocus = true,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _currentOtp = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (_) => FocusNode(),
    );

    // Auto-foco en el primer campo
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[0].requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isEmpty) {
      // Borrar: mover al campo anterior
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    } else {
      // Ingresar dígito: mover al siguiente campo
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Último campo: quitar foco
        _focusNodes[index].unfocus();
      }
    }

    // Actualizar OTP actual
    _updateCurrentOtp();
  }

  void _updateCurrentOtp() {
    final otp = _controllers.map((c) => c.text).join();
    _currentOtp = otp;

    // Callback de cambio
    widget.onChanged?.call(otp);

    // Si completamos los 6 dígitos, disparar onCompleted
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: index == 0 || index == widget.length - 1 ? 0 : 4,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  counterText: '', // Ocultar contador "1/1"
                  filled: true,
                  fillColor: _focusNodes[index].hasFocus
                      ? colorScheme.primaryContainer.withValues(alpha: 0.2)
                      : colorScheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) => _onDigitChanged(index, value),
              ),
            ),
          ),
        );
      }),
    );
  }
}
