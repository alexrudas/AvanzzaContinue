import 'package:get/get.dart';
import '../../../domain/usecases/sign_in_username_password_uc.dart';
import '../../../domain/usecases/send_mfa_code_uc.dart';
import '../../../domain/usecases/verify_mfa_uc.dart';

class LoginUsernameFlowController extends GetxController {
  final SignInUsernamePasswordUC signInUC;
  final SendMfaCodeUC sendMfaUC;
  final VerifyMfaUC verifyMfaUC;
  LoginUsernameFlowController({required this.signInUC, required this.sendMfaUC, required this.verifyMfaUC});
}
