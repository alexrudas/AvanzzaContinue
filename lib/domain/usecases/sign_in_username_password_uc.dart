import '../repositories/auth_repository.dart';

class SignInUsernamePasswordUC {
  final AuthRepository repo;
  SignInUsernamePasswordUC(this.repo);
  Future<SignInResult> call({required String username, required String password}) {
    return repo.signInWithUsernamePassword(username: username, password: password);
  }
}
