import 'dart:async';

import 'package:get/get.dart';

import '../../domain/entities/user/user_entity.dart';
import '../../domain/entities/user/membership_entity.dart';
import '../../domain/entities/user/active_context.dart';
import '../../domain/repositories/user_repository.dart';

/// SessionContextController
/// - Loads and observes the current user and memberships
/// - Updates activeContext both locally (Isar) and remotely (Firestore)
/// - Uses UserRepository which implements offline-first policies
class SessionContextController extends GetxController {
  final UserRepository userRepository;

  SessionContextController({required this.userRepository});

  final Rxn<UserEntity> _user = Rxn<UserEntity>();
  UserEntity? get user => _user.value;

  final RxList<MembershipEntity> _memberships = <MembershipEntity>[].obs;
  List<MembershipEntity> get memberships => _memberships;

  StreamSubscription<UserEntity?>? _userSub;
  StreamSubscription<List<MembershipEntity>>? _mbrSub;

  Future<void> init(String uid) async {
    _userSub?.cancel();
    _mbrSub?.cancel();

    _userSub = userRepository.watchUser(uid).listen((u) {
      _user.value = u;
    });

    _mbrSub = userRepository.watchMemberships(uid).listen((list) {
      _memberships.assignAll(list);
    });
  }

  Future<void> setActiveContext(ActiveContext ctx) async {
    final uid = user?.uid;
    if (uid == null) return;
    // Repository will persist to Isar and mirror to Firestore (write-through)
    await userRepository.updateActiveContext(uid, ctx);
    // Local observable update (optimistic)
    final current = user;
    if (current != null) {
      _user.value = current.copyWith(activeContext: ctx, updatedAt: DateTime.now().toUtc());
    }
  }

  @override
  void onClose() {
    _userSub?.cancel();
    _mbrSub?.cancel();
    super.onClose();
  }
}
