import '../repositories/auth_repository.dart';

class SendMfaCodeUC {
  final AuthRepository repo;
  SendMfaCodeUC(this.repo);
  Future<void> call(SignInMfaResolver resolver) => repo.sendMfaCode(resolver);
}
