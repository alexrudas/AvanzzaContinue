import 'package:cloud_firestore/cloud_firestore.dart';

import '../repositories/user_repository.dart';

class BootstrapFirstLoginUC {
  final UserRepository userRepository;
  BootstrapFirstLoginUC(this.userRepository);

  Future<void> call({required String uid, required String phone, String? countryId, String? cityId}) async {
    // Create minimum profile if not exists; repository handles existence
    await userRepository.getOrBootstrapProfile(uid: uid, phone: phone);
    if (countryId != null || cityId != null) {
      await userRepository.setActiveContext(uid, {
        'orgId': null,
        'role': null,
        'cityId': cityId,
      });
    }
  }
}
