// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleContent _$VehicleContentFromJson(Map<String, dynamic> json) =>
    VehicleContent(
      assetKey: const AssetKeyNormalizerConverter()
          .fromJson(json['assetKey'] as String),
      brand: const UpperNormalizerConverter().fromJson(json['brand'] as String),
      model: const UpperNormalizerConverter().fromJson(json['model'] as String),
      color: const UpperNormalizerConverter().fromJson(json['color'] as String),
      engineDisplacement: (json['engineDisplacement'] as num).toDouble(),
      mileage: (json['mileage'] as num?)?.toInt() ?? 0,
      vin: const UpperNullableConverter().fromJson(json['vin'] as String?),
      engineNumber: const UpperNullableConverter()
          .fromJson(json['engineNumber'] as String?),
      chassisNumber: const UpperNullableConverter()
          .fromJson(json['chassisNumber'] as String?),
      line: const UpperNullableConverter().fromJson(json['line'] as String?),
      serviceType: const UpperNullableConverter()
          .fromJson(json['serviceType'] as String?),
      vehicleClass: const UpperNullableConverter()
          .fromJson(json['vehicleClass'] as String?),
      fuelType:
          const UpperNullableConverter().fromJson(json['fuelType'] as String?),
      bodyType:
          const UpperNullableConverter().fromJson(json['bodyType'] as String?),
      passengerCapacity: (json['passengerCapacity'] as num?)?.toInt(),
      loadCapacityKg:
          const SafeDoubleConverter().fromJson(json['loadCapacityKg']),
      grossWeightKg:
          const SafeDoubleConverter().fromJson(json['grossWeightKg']),
      axles: (json['axles'] as num?)?.toInt(),
      transitAuthority: const UpperNullableConverter()
          .fromJson(json['transitAuthority'] as String?),
      initialRegistrationDate: json['initialRegistrationDate'] as String?,
      $type: json['kind'] as String?,
    );

Map<String, dynamic> _$VehicleContentToJson(VehicleContent instance) =>
    <String, dynamic>{
      'assetKey': const AssetKeyNormalizerConverter().toJson(instance.assetKey),
      'brand': const UpperNormalizerConverter().toJson(instance.brand),
      'model': const UpperNormalizerConverter().toJson(instance.model),
      'color': const UpperNormalizerConverter().toJson(instance.color),
      'engineDisplacement': instance.engineDisplacement,
      'mileage': instance.mileage,
      'vin': const UpperNullableConverter().toJson(instance.vin),
      'engineNumber':
          const UpperNullableConverter().toJson(instance.engineNumber),
      'chassisNumber':
          const UpperNullableConverter().toJson(instance.chassisNumber),
      'line': const UpperNullableConverter().toJson(instance.line),
      'serviceType':
          const UpperNullableConverter().toJson(instance.serviceType),
      'vehicleClass':
          const UpperNullableConverter().toJson(instance.vehicleClass),
      'fuelType': const UpperNullableConverter().toJson(instance.fuelType),
      'bodyType': const UpperNullableConverter().toJson(instance.bodyType),
      'passengerCapacity': instance.passengerCapacity,
      'loadCapacityKg':
          const SafeDoubleConverter().toJson(instance.loadCapacityKg),
      'grossWeightKg':
          const SafeDoubleConverter().toJson(instance.grossWeightKg),
      'axles': instance.axles,
      'transitAuthority':
          const UpperNullableConverter().toJson(instance.transitAuthority),
      'initialRegistrationDate': instance.initialRegistrationDate,
      'kind': instance.$type,
    };

RealEstateContent _$RealEstateContentFromJson(Map<String, dynamic> json) =>
    RealEstateContent(
      assetKey: const AssetKeyNormalizerConverter()
          .fromJson(json['assetKey'] as String),
      address: const TrimStringConverter().fromJson(json['address'] as String),
      city: const UpperNormalizerConverter().fromJson(json['city'] as String),
      area: (json['area'] as num).toDouble(),
      usage: const UpperNormalizerConverter().fromJson(json['usage'] as String),
      propertyType: const UpperNullableConverter()
          .fromJson(json['propertyType'] as String?),
      stratum: (json['stratum'] as num?)?.toInt(),
      cadastralValue:
          const SafeDoubleConverter().fromJson(json['cadastralValue']),
      floors: (json['floors'] as num?)?.toInt(),
      constructionYear: (json['constructionYear'] as num?)?.toInt(),
      hasParking: json['hasParking'] as bool? ?? false,
      parkingSpaces: (json['parkingSpaces'] as num?)?.toInt(),
      department: const TrimStringNullableConverter()
          .fromJson(json['department'] as String?),
      neighborhood: const TrimStringNullableConverter()
          .fromJson(json['neighborhood'] as String?),
      $type: json['kind'] as String?,
    );

Map<String, dynamic> _$RealEstateContentToJson(RealEstateContent instance) =>
    <String, dynamic>{
      'assetKey': const AssetKeyNormalizerConverter().toJson(instance.assetKey),
      'address': const TrimStringConverter().toJson(instance.address),
      'city': const UpperNormalizerConverter().toJson(instance.city),
      'area': instance.area,
      'usage': const UpperNormalizerConverter().toJson(instance.usage),
      'propertyType':
          const UpperNullableConverter().toJson(instance.propertyType),
      'stratum': instance.stratum,
      'cadastralValue':
          const SafeDoubleConverter().toJson(instance.cadastralValue),
      'floors': instance.floors,
      'constructionYear': instance.constructionYear,
      'hasParking': instance.hasParking,
      'parkingSpaces': instance.parkingSpaces,
      'department':
          const TrimStringNullableConverter().toJson(instance.department),
      'neighborhood':
          const TrimStringNullableConverter().toJson(instance.neighborhood),
      'kind': instance.$type,
    };

MachineryContent _$MachineryContentFromJson(Map<String, dynamic> json) =>
    MachineryContent(
      assetKey: const AssetKeyNormalizerConverter()
          .fromJson(json['assetKey'] as String),
      brand: const UpperNormalizerConverter().fromJson(json['brand'] as String),
      model: const UpperNormalizerConverter().fromJson(json['model'] as String),
      category:
          const UpperNullableConverter().fromJson(json['category'] as String?),
      capacity:
          const UpperNullableConverter().fromJson(json['capacity'] as String?),
      operationCertificate: const UpperNullableConverter()
          .fromJson(json['operationCertificate'] as String?),
      manufacturingYear: (json['manufacturingYear'] as num?)?.toInt(),
      countryOfOrigin: const TrimStringNullableConverter()
          .fromJson(json['countryOfOrigin'] as String?),
      operatingHours:
          const SafeDoubleConverter().fromJson(json['operatingHours']),
      acquisitionValue:
          const SafeDoubleConverter().fromJson(json['acquisitionValue']),
      currency: json['currency'] as String? ?? 'COP',
      $type: json['kind'] as String?,
    );

Map<String, dynamic> _$MachineryContentToJson(MachineryContent instance) =>
    <String, dynamic>{
      'assetKey': const AssetKeyNormalizerConverter().toJson(instance.assetKey),
      'brand': const UpperNormalizerConverter().toJson(instance.brand),
      'model': const UpperNormalizerConverter().toJson(instance.model),
      'category': const UpperNullableConverter().toJson(instance.category),
      'capacity': const UpperNullableConverter().toJson(instance.capacity),
      'operationCertificate':
          const UpperNullableConverter().toJson(instance.operationCertificate),
      'manufacturingYear': instance.manufacturingYear,
      'countryOfOrigin':
          const TrimStringNullableConverter().toJson(instance.countryOfOrigin),
      'operatingHours':
          const SafeDoubleConverter().toJson(instance.operatingHours),
      'acquisitionValue':
          const SafeDoubleConverter().toJson(instance.acquisitionValue),
      'currency': instance.currency,
      'kind': instance.$type,
    };

EquipmentContent _$EquipmentContentFromJson(Map<String, dynamic> json) =>
    EquipmentContent(
      assetKey: const AssetKeyNormalizerConverter()
          .fromJson(json['assetKey'] as String),
      name: const TrimStringConverter().fromJson(json['name'] as String),
      brand: const UpperNullableConverter().fromJson(json['brand'] as String?),
      model: const UpperNullableConverter().fromJson(json['model'] as String?),
      category:
          const UpperNullableConverter().fromJson(json['category'] as String?),
      inventoryNumber: const UpperNullableConverter()
          .fromJson(json['inventoryNumber'] as String?),
      location: const TrimStringNullableConverter()
          .fromJson(json['location'] as String?),
      acquisitionYear: (json['acquisitionYear'] as num?)?.toInt(),
      usefulLifeYears: (json['usefulLifeYears'] as num?)?.toInt(),
      acquisitionValue:
          const SafeDoubleConverter().fromJson(json['acquisitionValue']),
      currency: json['currency'] as String? ?? 'COP',
      $type: json['kind'] as String?,
    );

Map<String, dynamic> _$EquipmentContentToJson(EquipmentContent instance) =>
    <String, dynamic>{
      'assetKey': const AssetKeyNormalizerConverter().toJson(instance.assetKey),
      'name': const TrimStringConverter().toJson(instance.name),
      'brand': const UpperNullableConverter().toJson(instance.brand),
      'model': const UpperNullableConverter().toJson(instance.model),
      'category': const UpperNullableConverter().toJson(instance.category),
      'inventoryNumber':
          const UpperNullableConverter().toJson(instance.inventoryNumber),
      'location': const TrimStringNullableConverter().toJson(instance.location),
      'acquisitionYear': instance.acquisitionYear,
      'usefulLifeYears': instance.usefulLifeYears,
      'acquisitionValue':
          const SafeDoubleConverter().toJson(instance.acquisitionValue),
      'currency': instance.currency,
      'kind': instance.$type,
    };
