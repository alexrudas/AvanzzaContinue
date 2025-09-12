import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/datetime_timestamp_converter.dart';

part 'user_profile_entity.freezed.dart';
part 'user_profile_entity.g.dart';

@freezed
abstract class UserProfileEntity with _$UserProfileEntity {
  const factory UserProfileEntity({
    required String uid,
    required String phone,
    String? countryId,
    String? cityId,
    @Default(<String>[]) List<String> roles,
    @Default(<String>[]) List<String> orgIds,
    @Default('active') String status,
    @DateTimeTimestampConverter() DateTime? createdAt,
    @DateTimeTimestampConverter() DateTime? updatedAt,
  }) = _UserProfileEntity;

  factory UserProfileEntity.fromJson(Map<String, dynamic> json) => _$UserProfileEntityFromJson(json);
}
