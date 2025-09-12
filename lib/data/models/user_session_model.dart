import 'package:isar_community/isar.dart';

import '../../domain/entities/user_session_entity.dart' as domain;

part 'user_session_model.g.dart';

@Collection()
class UserSessionModel {
  Id? isarId;
  @Index(unique: true, replace: true)
  late String uid;
  String? idToken;
  String? refreshToken;
  String? deviceId;
  DateTime? lastLoginAt;
  String? activeContextJson; // JSON map
  String? featureFlagsJson; // JSON map

  UserSessionModel();

  factory UserSessionModel.fromEntity(domain.UserSessionEntity e) {
    final m = UserSessionModel();
    m.uid = e.uid;
    m.idToken = e.idToken;
    m.refreshToken = e.refreshToken;
    m.deviceId = e.deviceId;
    m.lastLoginAt = e.lastLoginAt;
    m.activeContextJson = e.activeContext?.toString();
    m.featureFlagsJson = e.featureFlags?.toString();
    return m;
  }

  domain.UserSessionEntity toEntity() => domain.UserSessionEntity(
        uid: uid,
        idToken: idToken,
        refreshToken: refreshToken,
        deviceId: deviceId,
        lastLoginAt: lastLoginAt,
        activeContext: null,
        featureFlags: null,
      );
}
