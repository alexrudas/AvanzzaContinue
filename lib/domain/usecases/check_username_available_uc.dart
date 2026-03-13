import '../repositories/auth_repository.dart';

class CheckUsernameAvailableUC {
  final AuthRepository repo;
  CheckUsernameAvailableUC(this.repo);
  Future<bool> call(String username) => repo.checkUsernameAvailable(username);
}

/// UC idempotente: retorna [UsernameCheckResult] distinguiendo propio/libre/ajeno.
class CheckUsernameAvailabilityUC {
  final AuthRepository repo;
  CheckUsernameAvailabilityUC(this.repo);
  Future<UsernameCheckResult> call(String username, String currentUid) =>
      repo.checkUsernameAvailability(username, currentUid);
}
