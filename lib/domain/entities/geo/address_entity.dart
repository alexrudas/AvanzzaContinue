import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_entity.freezed.dart';
part 'address_entity.g.dart';

@freezed
abstract class AddressEntity with _$AddressEntity {
  const factory AddressEntity({
    required String countryId,
    String? regionId,
    String? cityId,
    required String line1,
    String? line2,
    String? postalCode,
    double? lat,
    double? lng,
  }) = _AddressEntity;

  factory AddressEntity.fromJson(Map<String, dynamic> json) =>
      _$AddressEntityFromJson(json);
}
