import '../repositories/auth_repository.dart';

class CheckUsernameAvailableUC {
  final AuthRepository repo;
  CheckUsernameAvailableUC(this.repo);
  Future<bool> call(String username) => repo.checkUsernameAvailable(username);
}
