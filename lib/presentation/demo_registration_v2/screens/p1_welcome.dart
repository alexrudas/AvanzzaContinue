// ============================================================================
// DEMO REGISTRATION V2 — P1: WELCOME + PHONE + TERMS
// ============================================================================
// CABLEADO Firebase Auth real (ítem 11.1):
//   El "Continuar" llama a SendOtpUC (Get.find canónico) y persiste el
//   verificationId en DemoRegistrationState.verificationId. Si Firebase
//   auto-verifica (por ejemplo en emulator con número de prueba), marca
//   firebaseAuthenticated=true y P2 lo detecta para auto-saltarse. Los
//   errores se muestran inline con mensajes claros mapeados.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../domain/errors/auth_failure.dart';
import '../../../domain/usecases/send_otp_uc.dart';
import '../demo_state.dart';
import '../widgets/demo_step_scaffold.dart';

/// Catálogo demo de prefijos regionales (file-private para que tanto el
/// state como el picker sheet lo compartan). En producción esto vendría de
/// un endpoint `/v1/catalog/dial-codes` filtrado por la región del usuario.
const _dialCodes = <Map<String, String>>[
  {'code': '+57', 'flag': '🇨🇴', 'name': 'Colombia'},
  {'code': '+52', 'flag': '🇲🇽', 'name': 'México'},
  {'code': '+54', 'flag': '🇦🇷', 'name': 'Argentina'},
  {'code': '+56', 'flag': '🇨🇱', 'name': 'Chile'},
  {'code': '+51', 'flag': '🇵🇪', 'name': 'Perú'},
  {'code': '+1', 'flag': '🇺🇸', 'name': 'EE. UU.'},
  {'code': '+34', 'flag': '🇪🇸', 'name': 'España'},
];

class P1Welcome extends StatefulWidget {
  final DemoRegistrationState state;
  final VoidCallback onNext;

  /// Total de pasos a mostrar en el indicador "Paso N de M".
  /// Default 5 = Demo 1 legacy. FusionadoFlow pasa 4 (Q5 fue eliminado).
  final int totalSteps;

  const P1Welcome({
    super.key,
    required this.state,
    required this.onNext,
    this.totalSteps = 5,
  });

  @override
  State<P1Welcome> createState() => _P1WelcomeState();
}

class _P1WelcomeState extends State<P1Welcome> {
  late final TextEditingController _phoneCtrl;

  bool _isSending = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _phoneCtrl = TextEditingController(text: widget.state.phone);
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  // Validación CO: teléfono exactamente 10 dígitos.
  bool get _canContinue =>
      _phoneCtrl.text.trim().length == 10 &&
      widget.state.acceptedTerms &&
      !_isSending;

  /// Normaliza dial code + número a E.164 (`+573001234567`).
  String _e164Phone() {
    final dial = widget.state.countryDialCode.trim();
    final raw = _phoneCtrl.text.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (raw.startsWith('+')) return raw;
    return '$dial$raw';
  }

  Future<void> _onContinue() async {
    if (!_canContinue) return;
    setState(() {
      _isSending = true;
      _errorMsg = null;
    });

    final SendOtpUC sendOtp;
    try {
      sendOtp = Get.find<SendOtpUC>();
    } catch (_) {
      // Fallback: GetX no inicializado (test, preview). Mantén comportamiento
      // legacy demo para no romper el flujo en builds sin Firebase.
      if (!mounted) return;
      setState(() {
        _isSending = false;
        widget.state.phone = _phoneCtrl.text.trim();
      });
      widget.onNext();
      return;
    }

    try {
      final result = await sendOtp(_e164Phone());
      if (!mounted) return;
      widget.state.update(() {
        widget.state.phone = _phoneCtrl.text.trim();
        widget.state.verificationId = result.verificationId;
        // Auto-verify (caso típico Firebase emulator con número de prueba):
        // Firebase ya autenticó al usuario, pasa el uid sin requerir SMS.
        if (result.autoVerified && result.uid != null) {
          widget.state.firebaseAuthenticated = true;
          widget.state.otpVerified = true;
        }
      });
      setState(() => _isSending = false);
      widget.onNext();
    } on AuthFailure catch (e) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
        _errorMsg = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSending = false;
        _errorMsg = 'Error inesperado al enviar el código. Intenta de nuevo.';
      });
    }
  }

  /// Devuelve el item del catálogo asociado al prefijo seleccionado.
  /// Si el código no está en el catálogo (improbable), retorna el primero.
  Map<String, String> _countryFor(String dialCode) {
    return _dialCodes.firstWhere(
      (c) => c['code'] == dialCode,
      orElse: () => _dialCodes.first,
    );
  }

  String _flagFor(String dialCode) => _countryFor(dialCode)['flag']!;
  String _nameFor(String dialCode) => _countryFor(dialCode)['name']!;

  /// Abre el bottom sheet con la lista regional rica (bandera + nombre +
  /// prefijo). Refuerza la pertenencia regional al permitir ver otros países.
  Future<void> _pickPrefix() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => _PrefixPickerSheet(
        selected: widget.state.countryDialCode,
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        widget.state.countryDialCode = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return DemoStepScaffold(
      currentStep: 0,
      totalSteps: widget.totalSteps,
      title: 'Bienvenido a Avanzza',
      showBack: true,
      onBack: () => Navigator.of(context).maybePop(),
      primaryAction: FilledButton(
        onPressed: _canContinue ? _onContinue : null,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isSending
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Continuar'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Te enviaremos un código por SMS para verificar tu número.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),

          // ── Chip del país seleccionado ───────────────────────────────────
          // Refleja el prefijo elegido en lenguaje natural ("🇨🇴 Colombia")
          // alineado a la izquierda — refuerza pertenencia regional antes
          // de que el usuario interactúe con el selector compacto.
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _flagFor(widget.state.countryDialCode),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _nameFor(widget.state.countryDialCode),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Selector de prefijo + número ─────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo compacto (solo prefijo + chevron). La bandera y el
              // nombre del país ya viven en el chip de arriba — aquí basta
              // con el indicativo telefónico. Ancho 110 (suficiente para
              // "+999" + chevron sin overflow).
              SizedBox(
                width: 110,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _pickPrefix,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Prefijo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 22,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      widget.state.countryDialCode,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    hintText: '3001234567',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (v) {
                    setState(() {
                      widget.state.phone = v.trim();
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Checkbox términos inline (reemplaza pantalla aparte) ─────────
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              setState(() {
                widget.state.acceptedTerms = !widget.state.acceptedTerms;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: widget.state.acceptedTerms,
                    onChanged: (v) {
                      setState(() {
                        widget.state.acceptedTerms = v ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text.rich(
                        TextSpan(
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                          children: const [
                            TextSpan(text: 'Acepto los '),
                            TextSpan(
                              text: 'Términos de uso',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(text: ' y la '),
                            TextSpan(
                              text: 'Política de privacidad',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(text: ' de Avanzza.'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_errorMsg != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.errorContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: cs.error.withValues(alpha: 0.5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline_rounded, color: cs.error, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMsg!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// BOTTOM SHEET — selector de prefijo regional
// Cada item: bandera + nombre del país + prefijo. Refuerza pertenencia
// regional al primer tap.
// ════════════════════════════════════════════════════════════════════════════

class _PrefixPickerSheet extends StatelessWidget {
  final String selected;
  const _PrefixPickerSheet({required this.selected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final maxHeight = MediaQuery.of(context).size.height * 0.7;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                'Selecciona tu país',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                shrinkWrap: true,
                itemCount: _dialCodes.length,
                itemBuilder: (ctx, i) {
                  final c = _dialCodes[i];
                  final isSelected = c['code'] == selected;
                  return ListTile(
                    leading: Text(
                      c['flag']!,
                      style: const TextStyle(fontSize: 26),
                    ),
                    title: Text(
                      c['name']!,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          c['code']!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                isSelected ? cs.primary : cs.onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isSelected)
                          Icon(Icons.check_rounded, color: cs.primary)
                        else
                          const SizedBox(width: 24),
                      ],
                    ),
                    onTap: () => Navigator.of(context).pop(c['code']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
