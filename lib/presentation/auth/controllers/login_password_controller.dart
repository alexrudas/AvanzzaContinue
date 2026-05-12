import 'package:get/get.dart';
import '../../../domain/errors/auth_failure.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/sign_in_username_password_uc.dart';
import '../../../domain/usecases/send_mfa_code_uc.dart';
import '../../../domain/usecases/verify_mfa_uc.dart';
import '../../../routes/app_pages.dart';

class LoginPasswordController extends GetxController {
  final SignInUsernamePasswordUC signInUC;
  final SendMfaCodeUC sendMfaUC;
  final VerifyMfaUC verifyMfaUC;

  LoginPasswordController({
    required this.signInUC,
    required this.sendMfaUC,
    required this.verifyMfaUC,
  });

  final RxString status = 'idle'.obs;
  final RxnString errorMessage = RxnString();
  SignInMfaResolver? _resolver;

  Future<void> signIn(String username, String password) async {
    status.value = 'signing';
    errorMessage.value = null;
    try {
      final res = await signInUC(username: username, password: password);
      if (res.uid != null) {
        status.value = 'signed_in';
        // Re-disparar el routing gate. Splash recalcula el destino correcto
        // (workspace / profile / countryCity) sin que tengamos que
        // duplicar lógica de routing aquí.
        Get.offAllNamed(Routes.splash);
        return;
      }
      _resolver = res.mfaResolver;
      if (_resolver != null) {
        await sendMfaUC(_resolver!);
        status.value = 'awaiting_mfa';
      } else {
        status.value = 'idle';
      }
    } on AuthFailure catch (e) {
      status.value = 'idle';
      errorMessage.value = e.message;
    } catch (_) {
      status.value = 'idle';
      errorMessage.value = 'No se pudo iniciar sesión.';
    }
  }

  Future<String> verifyMfa(String code) async {
    final resolver = _resolver;
    if (resolver == null) throw StateError('No hay resolver MFA');
    status.value = 'verifying_mfa';
    final uid = await verifyMfaUC(resolver, code);
    status.value = 'signed_in';
    // Mismo principio que `signIn`: re-correr splash para enrutar.
    Get.offAllNamed(Routes.splash);
    return uid;
  }
}
