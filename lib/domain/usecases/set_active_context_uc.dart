import '../repositories/user_repository.dart';

class SetActiveContextUC {
  final UserRepository userRepository;
  SetActiveContextUC(this.userRepository);

  Future<void> call(String uid, Map<String, dynamic> ctx) => userRepository.setActiveContext(uid, ctx);
}
