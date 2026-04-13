// ============================================================================
// lib/presentation/auth/widgets/otp_input_widget.dart
// OTP INPUT WIDGET — Enterprise Ultra Pro (Presentation / Auth / Widgets)
//
// QUÉ HACE:
// - 6 casillas independientes con auto-advance, backspace inteligente y paste.
// - FocusNodes y TextEditingControllers creados en initState, disposed en dispose.
// - Paste detectado en el formatter ANTES de LengthLimitingTextInputFormatter(1).
// - Backspace en casilla vacía: mueve foco a la anterior y la borra.
// - onCompleted se invoca cuando las 6 casillas tienen exactamente 1 dígito cada una.
//
// QUÉ NO HACE:
// - No crea FocusNodes en build().
// - No usa RawKeyboardListener con FocusNodes efímeros.
// - No navega ni llama a Firebase.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputWidget extends StatefulWidget {
  final void Function(String code) onCompleted;
  final int length;

  const OtpInputWidget({
    super.key,
    required this.onCompleted,
    this.length = 6,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late final List<TextEditingController> _ctls;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _ctls = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());

    // Backspace inteligente: si la casilla está vacía y se presiona backspace,
    // mover al anterior y borrarlo. Usa onKeyEvent de los FocusNodes existentes.
    for (int i = 0; i < widget.length; i++) {
      final idx = i;
      _nodes[i].onKeyEvent = (_, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            _ctls[idx].text.isEmpty &&
            idx > 0) {
          _ctls[idx - 1].clear();
          _nodes[idx - 1].requestFocus();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };
    }
  }

  @override
  void dispose() {
    for (final c in _ctls) { c.dispose(); }
    for (final n in _nodes) { n.dispose(); }
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Paste: distribuir dígitos en todas las casillas
  // ---------------------------------------------------------------------------

  void _handlePaste(String digits) {
    final len = widget.length;
    final code = digits.length > len ? digits.substring(0, len) : digits;

    for (int i = 0; i < len; i++) {
      _ctls[i].text = i < code.length ? code[i] : '';
    }

    // Enfocar la siguiente casilla vacía (o la última si todas llenas)
    final focusIdx = code.length < len ? code.length : len - 1;
    _nodes[focusIdx].requestFocus();

    if (code.length == len) widget.onCompleted(code);
  }

  // ---------------------------------------------------------------------------
  // Completitud
  // ---------------------------------------------------------------------------

  void _checkComplete() {
    final code = _ctls.map((c) => c.text).join();
    if (code.length == widget.length) {
      // Quitar foco de todas las casillas al completar el código.
      // Sin esto, la última casilla permanece activa y el teclado sigue
      // aceptando input después del 6.º dígito.
      FocusScope.of(context).unfocus();
      widget.onCompleted(code);
    }
  }

  // ---------------------------------------------------------------------------
  // onChanged por casilla
  // ---------------------------------------------------------------------------

  void _onChanged(int idx, String value) {
    if (value.isEmpty) return; // borrado normal; backspace lo maneja onKeyEvent
    // Auto-advance al siguiente
    if (idx < widget.length - 1) {
      _nodes[idx + 1].requestFocus();
    }
    _checkComplete();
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (idx) => _buildCell(context, idx)),
    );
  }

  Widget _buildCell(BuildContext context, int idx) {
    return Container(
      width: 44,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: _ctls[idx],
        focusNode: _nodes[idx],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        // Estilo explícito con color del tema: evita heredar color incorrecto
        // (const TextStyle sin color fallaba en M3 dark/light según plataforma).
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        decoration: const InputDecoration(
          counterText: '',
          // contentPadding explícito: sin esto, M3 aplica 16px top+bottom
          // que con fontSize 20 superaba la altura del Container (56px)
          // y clipeaba los dígitos mostrando solo fragmentos ("punticos").
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        inputFormatters: [
          // ORDEN CRÍTICO: _OtpPasteFormatter PRIMERO para interceptar paste
          // antes de que LengthLimitingTextInputFormatter(1) lo trunque.
          _OtpPasteFormatter(onPaste: _handlePaste),
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) => _onChanged(idx, value),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Formatter privado: detecta paste y distribuye dígitos
// ---------------------------------------------------------------------------

/// Detecta cuando el nuevo valor tiene más de 1 dígito (paste) y delega a
/// [onPaste]. Siempre limita la casilla actual a 0-1 dígitos.
///
/// DEBE ir antes de [LengthLimitingTextInputFormatter] en la lista.
class _OtpPasteFormatter extends TextInputFormatter {
  final void Function(String digits) onPaste;

  const _OtpPasteFormatter({required this.onPaste});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 1) {
      // Paste detectado: programar distribución y retener solo primer dígito.
      WidgetsBinding.instance.addPostFrameCallback((_) => onPaste(digits));
      return TextEditingValue(
        text: digits[0],
        selection: const TextSelection.collapsed(offset: 1),
      );
    }

    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}
