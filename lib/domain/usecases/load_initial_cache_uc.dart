import '../repositories/user_repository.dart';

class LoadInitialCacheUC {
  final UserRepository userRepository;
  LoadInitialCacheUC(this.userRepository);

  Future<void> call(String uid) async {
    final profile =
        await userRepository.getOrBootstrapProfile(uid: uid, phone: '');
    await userRepository.cacheProfile(profile);
    await userRepository.loadRolePermissions(profile.roles);
  }
}
