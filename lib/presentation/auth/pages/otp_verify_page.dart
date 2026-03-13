// ============================================================================
// lib/presentation/auth/pages/otp_verify_page.dart
// OTP VERIFY PAGE — Enterprise Ultra Pro (Presentation / Auth / Pages)
//
// QUÉ HACE:
// - Muestra las 6 casillas OTP con auto-advance, paste y backspace.
// - Countdown 60 s vía AuthOtpController; botón Reenviar habilitado al llegar a 0.
// - Errores de verificación mostrados inline (sin exponer verificationId).
//
// QUÉ NO HACE:
// - NO muestra verificationId al usuario (era un bug de seguridad; eliminado).
// - No navega directamente; delega a AuthController.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/auth_otp_controller.dart';
import '../widgets/otp_input_widget.dart';

class OtpVerifyPage extends StatefulWidget {
  const OtpVerifyPage({super.key});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  late final AuthController _authCtrl;
  late final AuthOtpController _otpCtrl;

  @override
  void initState() {
    super.initState();
    _authCtrl = Get.find<AuthController>();
    // Tag aislado para que el controller se destruya con la página.
    _otpCtrl = Get.put(AuthOtpController(), tag: 'otp_verify');
    // Arrancar countdown inmediatamente: esta página solo existe tras codeSent.
    _otpCtrl.startTimer();
  }

  @override
  void dispose() {
    Get.delete<AuthOtpController>(tag: 'otp_verify');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingresar código')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(() {
          final s = _authCtrl.state.value;
          final verifying = s.status == 'verifying';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ingresa el código enviado por SMS',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // ── Casillas OTP ──────────────────────────────────────────────
              OtpInputWidget(
                onCompleted: (code) {
                  if (!verifying) _authCtrl.onVerifyCode(code);
                },
              ),
              const SizedBox(height: 24),

              // ── Botón verificar (deshabilitado durante verificación) ───────
              ElevatedButton(
                onPressed: verifying ? null : null, // se activa por OtpInputWidget
                child: Text(verifying ? 'Verificando...' : 'Verificar'),
              ),
              const SizedBox(height: 16),

              // ── Countdown + Reenviar ──────────────────────────────────────
              Obx(() {
                final enabled = _otpCtrl.resendEnabled;
                return Column(
                  children: [
                    if (!enabled)
                      Text(
                        'Reenviar en ${_otpCtrl.timerText}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: enabled
                          ? () {
                              _otpCtrl.startTimer();
                              _authCtrl.resendOtp();
                            }
                          : null,
                      child: const Text('Reenviar código'),
                    ),
                  ],
                );
              }),

              // ── Mensaje de error inline ───────────────────────────────────
              if (s.message != null) ...[
                const SizedBox(height: 16),
                Text(
                  s.message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }
}
