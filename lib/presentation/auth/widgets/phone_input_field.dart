// ============================================================================
// lib/presentation/auth/widgets/phone_input_field.dart
// PHONE INPUT FIELD — Enterprise Ultra Pro (Presentation / Auth / Widgets)
//
// QUÉ HACE:
// - Selector país (CO fijo +57 | 🌐 Otro con prefijo editable).
// - Emite E.164 válido via onChanged; null si incompleto/inválido.
// - Nunca permite '+' en el campo principal de número.
//
// QUÉ NO HACE:
// - No llama a Firebase.
// - No navega.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputField extends StatefulWidget {
  /// Callback con E.164 válido (+57XXXXXXXXXX) o null si incompleto.
  final void Function(String? e164) onChanged;

  const PhoneInputField({super.key, required this.onChanged});

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  bool _useOther = false;
  final _numberCtrl = TextEditingController();
  final _prefixCtrl = TextEditingController(text: '+');

  // Regex: + seguido de 1-3 dígitos (e.g. +1, +44, +593)
  static final _prefixRegex = RegExp(r'^\+\d{1,3}$');

  @override
  void initState() {
    super.initState();
    _numberCtrl.addListener(_emit);
    _prefixCtrl.addListener(_emit);
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
    _prefixCtrl.dispose();
    super.dispose();
  }

  void _emit() => widget.onChanged(_buildE164());

  String? _buildE164() {
    final digits = _numberCtrl.text.replaceAll(RegExp(r'\D'), '');
    if (!_useOther) {
      // Colombia: exactamente 10 dígitos
      return digits.length == 10 ? '+57$digits' : null;
    }
    // Otro país: validar prefijo
    final prefix = _prefixCtrl.text.trim();
    if (!_prefixRegex.hasMatch(prefix)) return null;
    return digits.isNotEmpty ? '$prefix$digits' : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<bool>(
          value: _useOther,
          decoration: const InputDecoration(labelText: 'País'),
          items: const [
            DropdownMenuItem(value: false, child: Text('🇨🇴  Colombia (+57)')),
            DropdownMenuItem(value: true, child: Text('🌐  Otro país')),
          ],
          onChanged: (val) {
            setState(() {
              _useOther = val ?? false;
              _numberCtrl.clear();
              _prefixCtrl.text = '+';
            });
            _emit();
          },
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_useOther) ...[
              // Prefijo editable para otros países
              SizedBox(
                width: 72,
                child: TextFormField(
                  controller: _prefixCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Prefijo'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[+\d]')),
                    // + seguido de max 3 dígitos = 4 chars
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ] else
              // Prefijo fijo CO
              Container(
                height: 56,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('+57',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            if (_useOther) const SizedBox() else const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _numberCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Número',
                  hintText: _useOther ? 'Número local' : '300 123 4567',
                ),
                inputFormatters: [
                  // Bloquea '+' en el campo principal (NUNCA permitir)
                  FilteringTextInputFormatter.digitsOnly,
                  if (!_useOther) LengthLimitingTextInputFormatter(10),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
