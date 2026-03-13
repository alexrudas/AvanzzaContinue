// ============================================================================
// lib/presentation/auth/controllers/auth_otp_controller.dart
// AUTH OTP CONTROLLER — Enterprise Ultra Pro (Presentation / Controllers)
//
// QUÉ HACE:
// - Mantiene el countdown de 60 s para habilitar el botón "Reenviar".
// - Expone secondsRemaining (RxInt), timerText (mm:ss), resendEnabled.
// - startTimer()/cancelTimer() son el único contrato con la UI/página.
//
// QUÉ NO HACE:
// - No llama a Firebase directamente.
// - No navega.
// ============================================================================

import 'dart:async';

import 'package:get/get.dart';

class AuthOtpController extends GetxController {
  Timer? _timer;

  final RxInt secondsRemaining = 0.obs;

  bool get resendEnabled => secondsRemaining.value == 0;

  /// Formato mm:ss para mostrar en UI.
  String get timerText {
    final s = secondsRemaining.value;
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  /// Inicia (o reinicia) el countdown. Llamar cuando Firebase confirma codeSent.
  void startTimer([int seconds = 60]) {
    cancelTimer();
    secondsRemaining.value = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining.value <= 0) {
        cancelTimer();
      } else {
        secondsRemaining.value--;
      }
    });
  }

  /// Detiene el countdown sin resetear el valor.
  void cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void onClose() {
    cancelTimer();
    super.onClose();
  }
}
