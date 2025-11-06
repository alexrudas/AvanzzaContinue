import '../repositories/auth_repository.dart';

class SignUpUsernamePasswordUC {
  final AuthRepository repo;
  SignUpUsernamePasswordUC(this.repo);
  Future<String> call(
      {required String username,
      required String password,
      required String phoneNumber}) {
    return repo.signUpUsernamePassword(
        username: username, password: password, phoneNumber: phoneNumber);
  }
}
