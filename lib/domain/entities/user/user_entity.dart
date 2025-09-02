import 'package:freezed_annotation/freezed_annotation.dart';
import '../geo/address_entity.dart';
import 'active_context.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String uid,
    required String name,
    required String email,
    String? phone,
    String? tipoDoc,
    String? numDoc,
    String? countryId,
    String? preferredLanguage,
    ActiveContext? activeContext,
    List<AddressEntity>? addresses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}
