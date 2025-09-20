import '../repositories/auth_repository.dart';

class VerifyMfaUC {
  final AuthRepository repo;
  VerifyMfaUC(this.repo);
  Future<String> call(SignInMfaResolver resolver, String code) => repo.verifyMfaCode(resolver, code);
}
