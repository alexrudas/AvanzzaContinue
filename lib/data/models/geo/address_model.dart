import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/geo/address_entity.dart' as domain;

part 'address_model.g.dart';

@embedded
@JsonSerializable(explicitToJson: true)
class AddressModel {
  String? countryId;
  String? regionId;
  String? cityId;
  String? line1;
  String? line2;
  String? postalCode;
  double? lat;
  double? lng;

  AddressModel({
    this.countryId,
    this.regionId,
    this.cityId,
    this.line1,
    this.line2,
    this.postalCode,
    this.lat,
    this.lng,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  factory AddressModel.fromEntity(domain.AddressEntity e) => AddressModel(
        countryId: e.countryId,
        regionId: e.regionId,
        cityId: e.cityId,
        line1: e.line1,
        line2: e.line2,
        postalCode: e.postalCode,
        lat: e.lat,
        lng: e.lng,
      );

  domain.AddressEntity toEntity() => domain.AddressEntity(
        countryId: countryId ?? '',
        regionId: regionId,
        cityId: cityId,
        line1: line1 ?? '',
        line2: line2,
        postalCode: postalCode,
        lat: lat,
        lng: lng,
      );
}
