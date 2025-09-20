import 'package:avanzza/domain/entities/user_profile_entity.dart';
import 'package:avanzza/domain/repositories/user_repository.dart';

class FinalizeRegistrationUC {
  final UserRepository userRepository;
  FinalizeRegistrationUC(this.userRepository);

  Future<void> call(UserProfileEntity profile) async {
    await userRepository.updateUserProfile(profile);
    await userRepository.cacheProfile(profile);
  }
}
