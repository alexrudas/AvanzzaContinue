import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../domain/usecases/bootstrap_first_login_uc.dart';
import '../../../domain/usecases/load_initial_cache_uc.dart';
import '../../../domain/usecases/send_otp_uc.dart';
import '../../../domain/usecases/set_active_context_uc.dart';
import '../../../domain/usecases/verify_otp_uc.dart';
import '../../../routes/app_pages.dart';
import '../../../services/telemetry/telemetry_service.dart';

class AuthState {
  final String
      status; // idle, sending, sent, verifying, needsProfile, selectingRole, authenticated, error
  final String? verificationId;
  final String? message;
  const AuthState(this.status, {this.verificationId, this.message});
}

class AuthController extends GetxController {
  final SendOtpUC sendOtpUC;
  final VerifyOtpUC verifyOtpUC;
  final BootstrapFirstLoginUC bootstrapFirstLoginUC;
  final LoadInitialCacheUC loadInitialCacheUC;
  final SetActiveContextUC setActiveContextUC;
  final TelemetryService telemetry;

  AuthController({
    required this.sendOtpUC,
    required this.verifyOtpUC,
    required this.bootstrapFirstLoginUC,
    required this.loadInitialCacheUC,
    required this.setActiveContextUC,
    required this.telemetry,
  });

  final Rx<AuthState> state = const AuthState('idle').obs;
  String? _verificationId;
  Timer? _resendTimer;
  int _seconds = 0;

  int get secondsToResend => _seconds;
  String? _lastPhone;
  bool get canResend => _seconds == 0;

  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }

  Future<void> onSendOtp(String phone) async {
    _lastPhone = phone; // << guardar para reenvío
    state.value = const AuthState('sending');
    try {
      final res = await sendOtpUC(phone);
      if (res.autoVerified && res.uid != null) {
        telemetry.log('auth_otp_auto_verify_success', {'uid': res.uid});
        await loadInitialCacheUC(res.uid!);
        Get.offAllNamed(Routes.registerUsername);
        state.value = const AuthState('authenticated');
        return;
      }
      _verificationId = res.verificationId;
      telemetry.log(
          'auth_otp_send_success', {'phone': phone, 'timeout': res.timeout});
      _startResendTimer();
      state.value = AuthState('sent', verificationId: _verificationId);
    } on FirebaseAuthException catch (e) {
      telemetry.log('auth_otp_send_fail', {'code': e.code});
      state.value = AuthState('error', message: _mapError(e.code));
    } catch (_) {
      state.value = const AuthState('error', message: 'Error inesperado');
    }
  }

  Future<void> resendOtp() async {
    if (_lastPhone == null || !canResend) return;
    await onSendOtp(_lastPhone!);
  }

  Future<void> onVerifyCode(String smsCode) async {
    final vid = _verificationId;
    if (vid == null) {
      state.value = const AuthState('error', message: 'Falta verificationId');
      return;
    }
    state.value = const AuthState('verifying');
    try {
      final uid = await verifyOtpUC(verificationId: vid, smsCode: smsCode);
      telemetry.log('auth_otp_verify_success', {'uid': uid});
      await loadInitialCacheUC(uid);
      Get.offAllNamed(Routes.registerUsername);
      state.value = const AuthState('authenticated');
    } on FirebaseAuthException catch (e) {
      telemetry.log('auth_otp_verify_fail', {'code': e.code});
      state.value = AuthState('error', message: _mapError(e.code));
    } catch (_) {
      state.value = const AuthState('error', message: 'Error inesperado');
    }
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _seconds = 60;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      _seconds -= 1;
      if (_seconds <= 0) t.cancel();
      state.refresh();
    });
  }

  String _mapError(String code) {
    switch (code) {
      case 'invalid-phone-number':
        return 'Número inválido';
      case 'quota-exceeded':
        return 'Límite de SMS alcanzado, intenta luego';
      case 'too-many-requests':
        return 'Demasiados intentos';
      case 'code-expired':
      case 'session-expired':
        return 'Código expirado';
      case 'network-request-failed':
        return 'Sin conexión';
      default:
        return 'Error de autenticación';
    }
  }
}
