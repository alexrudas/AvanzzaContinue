import 'package:get/get.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/sign_in_username_password_uc.dart';
import '../../../domain/usecases/send_mfa_code_uc.dart';
import '../../../domain/usecases/verify_mfa_uc.dart';

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
  SignInMfaResolver? _resolver;
  String? _verificationId;

  Future<void> signIn(String username, String password) async {
    status.value = 'signing';
    final res = await signInUC(username: username, password: password);
    if (res.uid != null) {
      status.value = 'signed_in';
      return;
    }
    _resolver = res.mfaResolver;
    if (_resolver != null) {
      await sendMfaUC(_resolver!);
      status.value = 'awaiting_mfa';
    } else {
      status.value = 'error';
    }
  }

  Future<String> verifyMfa(String code) async {
    final resolver = _resolver;
    if (resolver == null) throw StateError('No hay resolver MFA');
    status.value = 'verifying_mfa';
    final uid = await verifyMfaUC(resolver, code);
    status.value = 'signed_in';
    return uid;
  }
}
