import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/datetime_timestamp_converter.dart';

part 'user_session_entity.freezed.dart';
part 'user_session_entity.g.dart';

@freezed
abstract class UserSessionEntity with _$UserSessionEntity {
  const factory UserSessionEntity({
    required String uid,
    String? idToken,
    String? refreshToken,
    String? deviceId,
    @DateTimeTimestampConverter() DateTime? lastLoginAt,
    Map<String, dynamic>? activeContext, // {orgId, role, cityId}
    Map<String, dynamic>? featureFlags,
  }) = _UserSessionEntity;

  factory UserSessionEntity.fromJson(Map<String, dynamic> json) => _$UserSessionEntityFromJson(json);
}
