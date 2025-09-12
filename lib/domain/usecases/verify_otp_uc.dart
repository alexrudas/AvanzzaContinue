import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import 'package:avanzza/domain/usecases/bootstrap_first_login_uc.dart' show BootstrapFirstLoginUC;
import 'package:avanzza/domain/usecases/load_initial_cache_uc.dart' show LoadInitialCacheUC;
import 'package:avanzza/domain/usecases/set_active_context_uc.dart' show SetActiveContextUC;

class VerifyOtpUC {
  final AuthRepository authRepo;
  final UserRepository userRepo;
  final BootstrapFirstLoginUC bootstrapFirstLogin;
  final LoadInitialCacheUC loadInitialCache;
  final SetActiveContextUC setActiveContext;
  VerifyOtpUC({
    required this.authRepo,
    required this.userRepo,
    required this.bootstrapFirstLogin,
    required this.loadInitialCache,
    required this.setActiveContext,
  });

  Future<String> call({required String verificationId, required String smsCode}) async {
    final uid = await authRepo.verifyOtp(verificationId, smsCode);
    // Additional logic can be placed here using the other UCs (bootstrap, cache, set context)
    return uid;
  }
}
