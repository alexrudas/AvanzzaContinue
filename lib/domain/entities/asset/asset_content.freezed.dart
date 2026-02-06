// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
AssetContent _$AssetContentFromJson(Map<String, dynamic> json) {
  switch (json['kind']) {
    case 'vehicle':
      return VehicleContent.fromJson(json);
    case 'real_estate':
      return RealEstateContent.fromJson(json);
    case 'machinery':
      return MachineryContent.fromJson(json);
    case 'equipment':
      return EquipmentContent.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'kind', 'AssetContent',
          'Invalid union type "${json['kind']}"!');
  }
}

/// @nodoc
mixin _$AssetContent {
  /// Placa (normalizada). En CO típicamente 6 chars alfanuméricos.
  @AssetKeyNormalizerConverter()
  String get assetKey;

  /// Create a copy of AssetContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetContentCopyWith<AssetContent> get copyWith =>
      _$AssetContentCopyWithImpl<AssetContent>(
          this as AssetContent, _$identity);

  /// Serializes this AssetContent to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetContent &&
            (identical(other.assetKey, assetKey) ||
                other.assetKey == assetKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, assetKey);

  @override
  String toString() {
    return 'AssetContent(assetKey: $assetKey)';
  }
}

/// @nodoc
abstract mixin class $AssetContentCopyWith<$Res> {
  factory $AssetContentCopyWith(
          AssetContent value, $Res Function(AssetContent) _then) =
      _$AssetContentCopyWithImpl;
  @useResult
  $Res call({@AssetKeyNormalizerConverter() String assetKey});
}

/// @nodoc
class _$AssetContentCopyWithImpl<$Res> implements $AssetContentCopyWith<$Res> {
  _$AssetContentCopyWithImpl(this._self, this._then);

  final AssetContent _self;
  final $Res Function(AssetContent) _then;

  /// Create a copy of AssetContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetKey = null,
  }) {
    return _then(_self.copyWith(
      assetKey: null == assetKey
          ? _self.assetKey
          : assetKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [AssetContent].
extension AssetContentPatterns on AssetContent {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(VehicleContent value)? vehicle,
    TResult Function(RealEstateContent value)? realEstate,
    TResult Function(MachineryContent value)? machinery,
    TResult Function(EquipmentContent value)? equipment,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case VehicleContent() when vehicle != null:
        return vehicle(_that);
      case RealEstateContent() when realEstate != null:
        return realEstate(_that);
      case MachineryContent() when machinery != null:
        return machinery(_that);
      case EquipmentContent() when equipment != null:
        return equipment(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(VehicleContent value) vehicle,
    required TResult Function(RealEstateContent value) realEstate,
    required TResult Function(MachineryContent value) machinery,
    required TResult Function(EquipmentContent value) equipment,
  }) {
    final _that = this;
    switch (_that) {
      case VehicleContent():
        return vehicle(_that);
      case RealEstateContent():
        return realEstate(_that);
      case MachineryContent():
        return machinery(_that);
      case EquipmentContent():
        return equipment(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(VehicleContent value)? vehicle,
    TResult? Function(RealEstateContent value)? realEstate,
    TResult? Function(MachineryContent value)? machinery,
    TResult? Function(EquipmentContent value)? equipment,
  }) {
    final _that = this;
    switch (_that) {
      case VehicleContent() when vehicle != null:
        return vehicle(_that);
      case RealEstateContent() when realEstate != null:
        return realEstate(_that);
      case MachineryContent() when machinery != null:
        return machinery(_that);
      case EquipmentContent() when equipment != null:
        return equipment(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            @AssetKeyNormalizerConverter() String assetKey,
            @UpperNormalizerConverter() String brand,
            @UpperNormalizerConverter() String model,
            @UpperNormalizerConverter() String color,
            @SafeDoubleConverter() double engineDisplacement,
            int mileage,
            @UpperNullableConverter() String? vin,
            @UpperNullableConverter() String? engineNumber,
            @UpperNullableConverter() String? chassisNumber,
            @UpperNullableConverter() String? line,
            @UpperNullableConverter() String? serviceType,
            @UpperNullableConverter() String? vehicleClass,
            @UpperNullableConverter() String? fuelType,
            @UpperNullableConverter() String? bodyType,
            int? passengerCapacity,
            @SafeDoubleConverter() double? loadCapacityKg,
            @SafeDoubleConverter() double? grossWeightKg,
            int? axles,
            @UpperNullableConverter() String? transitAuthority,
            String? initialRegistrationDate)?
        vehicle,
    TResult Function(
            @AssetKeyNormalizerConverter() String assetKey,
            @TrimStringConverter() String address,
            @UpperNormalizerConverter() String city,
            @SafeDoubleConverter() double area,
            @UpperNormalizerConverter() String usage,
            @UpperNullableConverter() String? propertyType,
            int? stratum,
            @SafeDoubleConverter() double? cadastralValue,
            int? floors,
            int? constructionYear,
            bool hasParking,
            int? parkingSpaces,
            @TrimStringNullableConverter() String? department,
            @TrimStringNullableConverter() String? neighborhood)?
        realEstate,
    TResult Function(
            @AssetKeyNormalizerConverter() String assetKey,
            @UpperNormalizerConverter() String brand,
            @UpperNormalizerConverter() String model,
            @UpperNullableConverter() String? category,
            @UpperNullableConverter() String? capacity,
            @UpperNullableConverter() String? operationCertificate,
            int? manufacturingYear,
            @TrimStringNullableConverter() String? countryOfOrigin,
            @SafeDoubleConverter() double? operatingHours,
            @SafeDoubleConverter() double? acquisitionValue,
            String currency)?
        machinery,
    TResult Function(
            @AssetKeyNormalizerConverter() String assetKey,
            @TrimStringConverter() String name,
            @UpperNullableConverter() String? brand,
            @UpperNullableConverter() String? model,
            @UpperNullableConverter() String? category,
            @UpperNullableConverter() String? inventoryNumber,
            @TrimStringNullableConverter() String? location,
            int? acquisitionYear,
            int? usefulLifeYears,
            @SafeDoubleConverter() double? acquisitionValue,
            String currency)?
        equipment,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case VehicleContent() when vehicle != null:
        return vehicle(
            _that.assetKey,
            _that.brand,
            _that.model,
            _that.color,
            _that.engineDisplacement,
            _that.mileage,
            _that.vin,
            _that.engineNumber,
            _that.chassisNumber,
            _that.line,
            _that.serviceType,
            _that.vehicleClass,
            _that.fuelType,
            _that.bodyType,
            _that.passengerCapacity,
            _that.loadCapacityKg,
            _that.grossWeightKg,
            _that.axles,
            _that.transitAuthority,
            _that.initialRegistrationDate);
      case RealEstateContent() when realEstate != null:
        return realEstate(
            _that.assetKey,
            _that.address,
            _that.city,
            _that.area,
            _that.usage,
            _that.propertyType,
            _that.stratum,
            _that.cadastralValue,
            _that.floors,
            _that.constructionYear,
            _that.hasParking,
            _that.parkingSpaces,
            _that.department,
            _that.neighborhood);
      case MachineryContent() when machinery != null:
        return machinery(
            _that.assetKey,
            _that.brand,
            _that.model,
            _that.category,
            _that.capacity,
            _that.operationCertificate,
            _that.manufacturingYear,
            _that.countryOfOrigin,
            _that.operatingHours,
            _that.acquisitionValue,
            _that.currency);
      case EquipmentContent() when equipment != null:
        return equipment(
            _that.assetKey,
            _that.name,
            _that.brand,
            _that.model,
            _that.category,
            _that.inventoryNumber,
            _that.location,
            _that.acquisitionYear,
            _that.usefulLifeYears,
            _that.acquisitionValue,
            _that.currency);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            @AssetKeyNormalizerConverter() String assetKey,
            @UpperNormalizerConverter() String brand,
            @UpperNormalizerConverter() String model,
            @UpperNormalizerConverter() String color,
            @SafeDoubleConverter() double engineDisplacement,
            int mileage,
            @UpperNullableConverter() String? vin,
            @UpperNullableConverter() String? engineNumber,
            @UpperNullableConverter() String? chassisNumber,
            @UpperNullableConverter() String? line,
            @UpperNullableConverter() String? serviceType,
            @UpperNullableConverter() String? vehicleClass,
            @UpperNullableConverter() String? fuelType,
            @UpperNullableConverter() String? bodyType,
            int? passengerCapacity,
            @SafeDoubleConverter() double? loadCapacityKg,
            @SafeDoubleConverter() double? grossWeightKg,
            int? axles,
            @UpperNullableConverter() String? transitAuthority,
            String? initialRegistrationDate)
        vehicle,
    required TResult Function(
            @AssetKeyNormalizerConverter() String assetKey,
            @TrimStringConverter() String address,
            @UpperNormalizerConverter() String city,
            @SafeDoubleConverter() double area,
            @UpperNormalizerConverter() String usage,
            @UpperNullableConverter() String? propertyType,
            int? stratum,
            @SafeDoubleConverter() double? cadastralValue,
            int? floors,
            int? constructionYear,
            bool hasParking,
            int? parkingSpaces,
            @TrimStringNullableConverter() String? department,
            @TrimStringNullableConverter() String? neighborhood)
        realEstate,
    required TResult Function(
            @AssetKeyNormalizerConverter() String assetKey,
            @UpperNormalizerConverter() String brand,
            @UpperNormalizerConverter() String model,
            @UpperNullableConverter() String? category,
            @UpperNullableConverter() String? capacity,
            @UpperNullableConverter() String? operationCertificate,
            int? manufacturingYear,
            @TrimStringNullableConverter() String? countryOfOrigin,
            @SafeDoubleConverter() double? operatingHours,
            @SafeDoubleConverter() double? acquisitionValue,
            String currency)
        machinery,
    required TResult Function(
            @AssetKeyNormalizerConverter() String assetKey,
            @TrimStringConverter() String name,
            @UpperNullableConverter() String? brand,
            @UpperNullableConverter() String? model,
            @UpperNullableConverter() String? category,
            @UpperNullableConverter() String? inventoryNumber,
            @TrimStringNullableConverter() String? location,
            int? acquisitionYear,
            int? usefulLifeYears,
            @SafeDoubleConverter() double? acquisitionValue,
            String currency)
        equipment,
  }) {
    final _that = this;
    switch (_that) {
      case VehicleContent():
        return vehicle(
            _that.assetKey,
            _that.brand,
            _that.model,
            _that.color,
            _that.engineDisplacement,
            _that.mileage,
            _that.vin,
            _that.engineNumber,
            _that.chassisNumber,
            _that.line,
            _that.serviceType,
            _that.vehicleClass,
            _that.fuelType,
            _that.bodyType,
            _that.passengerCapacity,
            _that.loadCapacityKg,
            _that.grossWeightKg,
            _that.axles,
            _that.transitAuthority,
            _that.initialRegistrationDate);
      case RealEstateContent():
        return realEstate(
            _that.assetKey,
            _that.address,
            _that.city,
            _that.area,
            _that.usage,
            _that.propertyType,
            _that.stratum,
            _that.cadastralValue,
            _that.floors,
            _that.constructionYear,
            _that.hasParking,
            _that.parkingSpaces,
            _that.department,
            _that.neighborhood);
      case MachineryContent():
        return machinery(
            _that.assetKey,
            _that.brand,
            _that.model,
            _that.category,
            _that.capacity,
            _that.operationCertificate,
            _that.manufacturingYear,
            _that.countryOfOrigin,
            _that.operatingHours,
            _that.acquisitionValue,
            _that.currency);
      case EquipmentContent():
        return equipment(
            _that.assetKey,
            _that.name,
            _that.brand,
            _that.model,
            _that.category,
            _that.inventoryNumber,
            _that.location,
            _that.acquisitionYear,
            _that.usefulLifeYears,
            _that.acquisitionValue,
            _that.currency);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            @AssetKeyNormalizerConverter() String assetKey,
            @UpperNormalizerConverter() String brand,
            @UpperNormalizerConverter() String model,
            @UpperNormalizerConverter() String color,
            @SafeDoubleConverter() double engineDisplacement,
            int mileage,
            @UpperNullableConverter() String? vin,
            @UpperNullableConverter() String? engineNumber,
            @UpperNullableConverter() String? chassisNumber,
            @UpperNullableConverter() String? line,
            @UpperNullableConverter() String? serviceType,
            @UpperNullableConverter() String? vehicleClass,
            @UpperNullableConverter() String? fuelType,
            @UpperNullableConverter() String? bodyType,
            int? passengerCapacity,
            @SafeDoubleConverter() double? loadCapacityKg,
            @SafeDoubleConverter() double? grossWeightKg,
            int? axles,
            @UpperNullableConverter() String? transitAuthority,
            String? initialRegistrationDate)?
        vehicle,
    TResult? Function(
            @AssetKeyNormalizerConverter() String assetKey,
            @TrimStringConverter() String address,
            @UpperNormalizerConverter() String city,
            @SafeDoubleConverter() double area,
            @UpperNormalizerConverter() String usage,
            @UpperNullableConverter() String? propertyType,
            int? stratum,
            @SafeDoubleConverter() double? cadastralValue,
            int? floors,
            int? constructionYear,
            bool hasParking,
            int? parkingSpaces,
            @TrimStringNullableConverter() String? department,
            @TrimStringNullableConverter() String? neighborhood)?
        realEstate,
    TResult? Function(
            @AssetKeyNormalizerConverter() String assetKey,
            @UpperNormalizerConverter() String brand,
            @UpperNormalizerConverter() String model,
            @UpperNullableConverter() String? category,
            @UpperNullableConverter() String? capacity,
            @UpperNullableConverter() String? operationCertificate,
            int? manufacturingYear,
            @TrimStringNullableConverter() String? countryOfOrigin,
            @SafeDoubleConverter() double? operatingHours,
            @SafeDoubleConverter() double? acquisitionValue,
            String currency)?
        machinery,
    TResult? Function(
            @AssetKeyNormalizerConverter() String assetKey,
            @TrimStringConverter() String name,
            @UpperNullableConverter() String? brand,
            @UpperNullableConverter() String? model,
            @UpperNullableConverter() String? category,
            @UpperNullableConverter() String? inventoryNumber,
            @TrimStringNullableConverter() String? location,
            int? acquisitionYear,
            int? usefulLifeYears,
            @SafeDoubleConverter() double? acquisitionValue,
            String currency)?
        equipment,
  }) {
    final _that = this;
    switch (_that) {
      case VehicleContent() when vehicle != null:
        return vehicle(
            _that.assetKey,
            _that.brand,
            _that.model,
            _that.color,
            _that.engineDisplacement,
            _that.mileage,
            _that.vin,
            _that.engineNumber,
            _that.chassisNumber,
            _that.line,
            _that.serviceType,
            _that.vehicleClass,
            _that.fuelType,
            _that.bodyType,
            _that.passengerCapacity,
            _that.loadCapacityKg,
            _that.grossWeightKg,
            _that.axles,
            _that.transitAuthority,
            _that.initialRegistrationDate);
      case RealEstateContent() when realEstate != null:
        return realEstate(
            _that.assetKey,
            _that.address,
            _that.city,
            _that.area,
            _that.usage,
            _that.propertyType,
            _that.stratum,
            _that.cadastralValue,
            _that.floors,
            _that.constructionYear,
            _that.hasParking,
            _that.parkingSpaces,
            _that.department,
            _that.neighborhood);
      case MachineryContent() when machinery != null:
        return machinery(
            _that.assetKey,
            _that.brand,
            _that.model,
            _that.category,
            _that.capacity,
            _that.operationCertificate,
            _that.manufacturingYear,
            _that.countryOfOrigin,
            _that.operatingHours,
            _that.acquisitionValue,
            _that.currency);
      case EquipmentContent() when equipment != null:
        return equipment(
            _that.assetKey,
            _that.name,
            _that.brand,
            _that.model,
            _that.category,
            _that.inventoryNumber,
            _that.location,
            _that.acquisitionYear,
            _that.usefulLifeYears,
            _that.acquisitionValue,
            _that.currency);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class VehicleContent extends AssetContent {
  const VehicleContent(
      {@AssetKeyNormalizerConverter() required this.assetKey,
      @UpperNormalizerConverter() required this.brand,
      @UpperNormalizerConverter() required this.model,
      @UpperNormalizerConverter() required this.color,
      @SafeDoubleConverter() required this.engineDisplacement,
      this.mileage = 0,
      @UpperNullableConverter() this.vin,
      @UpperNullableConverter() this.engineNumber,
      @UpperNullableConverter() this.chassisNumber,
      @UpperNullableConverter() this.line,
      @UpperNullableConverter() this.serviceType,
      @UpperNullableConverter() this.vehicleClass,
      @UpperNullableConverter() this.fuelType,
      @UpperNullableConverter() this.bodyType,
      this.passengerCapacity,
      @SafeDoubleConverter() this.loadCapacityKg,
      @SafeDoubleConverter() this.grossWeightKg,
      this.axles,
      @UpperNullableConverter() this.transitAuthority,
      this.initialRegistrationDate,
      final String? $type})
      : $type = $type ?? 'vehicle',
        super._();
  factory VehicleContent.fromJson(Map<String, dynamic> json) =>
      _$VehicleContentFromJson(json);

  /// Placa (normalizada). En CO típicamente 6 chars alfanuméricos.
  @override
  @AssetKeyNormalizerConverter()
  final String assetKey;
  @UpperNormalizerConverter()
  final String brand;

  /// V2: model es String (ej: "2024", "2020", etc.)
  @UpperNormalizerConverter()
  final String model;
  @UpperNormalizerConverter()
  final String color;

  /// V2: engineDisplacement obligatorio (cc o litros, define tu estándar).
  /// Recomendación: usar cc como double (ej: 1600.0).
  @SafeDoubleConverter()
  final double engineDisplacement;
  @JsonKey()
  final int mileage;
// Opcionales (alineados a tu versión avanzada previa)
  @UpperNullableConverter()
  final String? vin;
  @UpperNullableConverter()
  final String? engineNumber;
  @UpperNullableConverter()
  final String? chassisNumber;
  @UpperNullableConverter()
  final String? line;
  @UpperNullableConverter()
  final String? serviceType;
  @UpperNullableConverter()
  final String? vehicleClass;
  @UpperNullableConverter()
  final String? fuelType;
  @UpperNullableConverter()
  final String? bodyType;
  final int? passengerCapacity;
  @SafeDoubleConverter()
  final double? loadCapacityKg;
  @SafeDoubleConverter()
  final double? grossWeightKg;
  final int? axles;
  @UpperNullableConverter()
  final String? transitAuthority;
  final String? initialRegistrationDate;

  @JsonKey(name: 'kind')
  final String $type;

  /// Create a copy of AssetContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VehicleContentCopyWith<VehicleContent> get copyWith =>
      _$VehicleContentCopyWithImpl<VehicleContent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VehicleContentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VehicleContent &&
            (identical(other.assetKey, assetKey) ||
                other.assetKey == assetKey) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.engineDisplacement, engineDisplacement) ||
                other.engineDisplacement == engineDisplacement) &&
            (identical(other.mileage, mileage) || other.mileage == mileage) &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.engineNumber, engineNumber) ||
                other.engineNumber == engineNumber) &&
            (identical(other.chassisNumber, chassisNumber) ||
                other.chassisNumber == chassisNumber) &&
            (identical(other.line, line) || other.line == line) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.vehicleClass, vehicleClass) ||
                other.vehicleClass == vehicleClass) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(other.bodyType, bodyType) ||
                other.bodyType == bodyType) &&
            (identical(other.passengerCapacity, passengerCapacity) ||
                other.passengerCapacity == passengerCapacity) &&
            (identical(other.loadCapacityKg, loadCapacityKg) ||
                other.loadCapacityKg == loadCapacityKg) &&
            (identical(other.grossWeightKg, grossWeightKg) ||
                other.grossWeightKg == grossWeightKg) &&
            (identical(other.axles, axles) || other.axles == axles) &&
            (identical(other.transitAuthority, transitAuthority) ||
                other.transitAuthority == transitAuthority) &&
            (identical(
                    other.initialRegistrationDate, initialRegistrationDate) ||
                other.initialRegistrationDate == initialRegistrationDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        assetKey,
        brand,
        model,
        color,
        engineDisplacement,
        mileage,
        vin,
        engineNumber,
        chassisNumber,
        line,
        serviceType,
        vehicleClass,
        fuelType,
        bodyType,
        passengerCapacity,
        loadCapacityKg,
        grossWeightKg,
        axles,
        transitAuthority,
        initialRegistrationDate
      ]);

  @override
  String toString() {
    return 'AssetContent.vehicle(assetKey: $assetKey, brand: $brand, model: $model, color: $color, engineDisplacement: $engineDisplacement, mileage: $mileage, vin: $vin, engineNumber: $engineNumber, chassisNumber: $chassisNumber, line: $line, serviceType: $serviceType, vehicleClass: $vehicleClass, fuelType: $fuelType, bodyType: $bodyType, passengerCapacity: $passengerCapacity, loadCapacityKg: $loadCapacityKg, grossWeightKg: $grossWeightKg, axles: $axles, transitAuthority: $transitAuthority, initialRegistrationDate: $initialRegistrationDate)';
  }
}

/// @nodoc
abstract mixin class $VehicleContentCopyWith<$Res>
    implements $AssetContentCopyWith<$Res> {
  factory $VehicleContentCopyWith(
          VehicleContent value, $Res Function(VehicleContent) _then) =
      _$VehicleContentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@AssetKeyNormalizerConverter() String assetKey,
      @UpperNormalizerConverter() String brand,
      @UpperNormalizerConverter() String model,
      @UpperNormalizerConverter() String color,
      @SafeDoubleConverter() double engineDisplacement,
      int mileage,
      @UpperNullableConverter() String? vin,
      @UpperNullableConverter() String? engineNumber,
      @UpperNullableConverter() String? chassisNumber,
      @UpperNullableConverter() String? line,
      @UpperNullableConverter() String? serviceType,
      @UpperNullableConverter() String? vehicleClass,
      @UpperNullableConverter() String? fuelType,
      @UpperNullableConverter() String? bodyType,
      int? passengerCapacity,
      @SafeDoubleConverter() double? loadCapacityKg,
      @SafeDoubleConverter() double? grossWeightKg,
      int? axles,
      @UpperNullableConverter() String? transitAuthority,
      String? initialRegistrationDate});
}

/// @nodoc
class _$VehicleContentCopyWithImpl<$Res>
    implements $VehicleContentCopyWith<$Res> {
  _$VehicleContentCopyWithImpl(this._self, this._then);

  final VehicleContent _self;
  final $Res Function(VehicleContent) _then;

  /// Create a copy of AssetContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? assetKey = null,
    Object? brand = null,
    Object? model = null,
    Object? color = null,
    Object? engineDisplacement = null,
    Object? mileage = null,
    Object? vin = freezed,
    Object? engineNumber = freezed,
    Object? chassisNumber = freezed,
    Object? line = freezed,
    Object? serviceType = freezed,
    Object? vehicleClass = freezed,
    Object? fuelType = freezed,
    Object? bodyType = freezed,
    Object? passengerCapacity = freezed,
    Object? loadCapacityKg = freezed,
    Object? grossWeightKg = freezed,
    Object? axles = freezed,
    Object? transitAuthority = freezed,
    Object? initialRegistrationDate = freezed,
  }) {
    return _then(VehicleContent(
      assetKey: null == assetKey
          ? _self.assetKey
          : assetKey // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _self.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      engineDisplacement: null == engineDisplacement
          ? _self.engineDisplacement
          : engineDisplacement // ignore: cast_nullable_to_non_nullable
              as double,
      mileage: null == mileage
          ? _self.mileage
          : mileage // ignore: cast_nullable_to_non_nullable
              as int,
      vin: freezed == vin
          ? _self.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      engineNumber: freezed == engineNumber
          ? _self.engineNumber
          : engineNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      chassisNumber: freezed == chassisNumber
          ? _self.chassisNumber
          : chassisNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      line: freezed == line
          ? _self.line
          : line // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceType: freezed == serviceType
          ? _self.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleClass: freezed == vehicleClass
          ? _self.vehicleClass
          : vehicleClass // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelType: freezed == fuelType
          ? _self.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String?,
      bodyType: freezed == bodyType
          ? _self.bodyType
          : bodyType // ignore: cast_nullable_to_non_nullable
              as String?,
      passengerCapacity: freezed == passengerCapacity
          ? _self.passengerCapacity
          : passengerCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      loadCapacityKg: freezed == loadCapacityKg
          ? _self.loadCapacityKg
          : loadCapacityKg // ignore: cast_nullable_to_non_nullable
              as double?,
      grossWeightKg: freezed == grossWeightKg
          ? _self.grossWeightKg
          : grossWeightKg // ignore: cast_nullable_to_non_nullable
              as double?,
      axles: freezed == axles
          ? _self.axles
          : axles // ignore: cast_nullable_to_non_nullable
              as int?,
      transitAuthority: freezed == transitAuthority
          ? _self.transitAuthority
          : transitAuthority // ignore: cast_nullable_to_non_nullable
              as String?,
      initialRegistrationDate: freezed == initialRegistrationDate
          ? _self.initialRegistrationDate
          : initialRegistrationDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class RealEstateContent extends AssetContent {
  const RealEstateContent(
      {@AssetKeyNormalizerConverter() required this.assetKey,
      @TrimStringConverter() required this.address,
      @UpperNormalizerConverter() required this.city,
      @SafeDoubleConverter() required this.area,
      @UpperNormalizerConverter() required this.usage,
      @UpperNullableConverter() this.propertyType,
      this.stratum,
      @SafeDoubleConverter() this.cadastralValue,
      this.floors,
      this.constructionYear,
      this.hasParking = false,
      this.parkingSpaces,
      @TrimStringNullableConverter() this.department,
      @TrimStringNullableConverter() this.neighborhood,
      final String? $type})
      : $type = $type ?? 'real_estate',
        super._();
  factory RealEstateContent.fromJson(Map<String, dynamic> json) =>
      _$RealEstateContentFromJson(json);

  /// Matrícula inmobiliaria / identificador natural (longitud variable).
  @override
  @AssetKeyNormalizerConverter()
  final String assetKey;
  @TrimStringConverter()
  final String address;
  @UpperNormalizerConverter()
  final String city;
  @SafeDoubleConverter()
  final double area;
  @UpperNormalizerConverter()
  final String usage;
// Opcionales útiles
  @UpperNullableConverter()
  final String? propertyType;
  final int? stratum;
  @SafeDoubleConverter()
  final double? cadastralValue;
  final int? floors;
  final int? constructionYear;
  @JsonKey()
  final bool hasParking;
  final int? parkingSpaces;
  @TrimStringNullableConverter()
  final String? department;
  @TrimStringNullableConverter()
  final String? neighborhood;

  @JsonKey(name: 'kind')
  final String $type;

  /// Create a copy of AssetContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RealEstateContentCopyWith<RealEstateContent> get copyWith =>
      _$RealEstateContentCopyWithImpl<RealEstateContent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RealEstateContentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RealEstateContent &&
            (identical(other.assetKey, assetKey) ||
                other.assetKey == assetKey) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.area, area) || other.area == area) &&
            (identical(other.usage, usage) || other.usage == usage) &&
            (identical(other.propertyType, propertyType) ||
                other.propertyType == propertyType) &&
            (identical(other.stratum, stratum) || other.stratum == stratum) &&
            (identical(other.cadastralValue, cadastralValue) ||
                other.cadastralValue == cadastralValue) &&
            (identical(other.floors, floors) || other.floors == floors) &&
            (identical(other.constructionYear, constructionYear) ||
                other.constructionYear == constructionYear) &&
            (identical(other.hasParking, hasParking) ||
                other.hasParking == hasParking) &&
            (identical(other.parkingSpaces, parkingSpaces) ||
                other.parkingSpaces == parkingSpaces) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.neighborhood, neighborhood) ||
                other.neighborhood == neighborhood));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      assetKey,
      address,
      city,
      area,
      usage,
      propertyType,
      stratum,
      cadastralValue,
      floors,
      constructionYear,
      hasParking,
      parkingSpaces,
      department,
      neighborhood);

  @override
  String toString() {
    return 'AssetContent.realEstate(assetKey: $assetKey, address: $address, city: $city, area: $area, usage: $usage, propertyType: $propertyType, stratum: $stratum, cadastralValue: $cadastralValue, floors: $floors, constructionYear: $constructionYear, hasParking: $hasParking, parkingSpaces: $parkingSpaces, department: $department, neighborhood: $neighborhood)';
  }
}

/// @nodoc
abstract mixin class $RealEstateContentCopyWith<$Res>
    implements $AssetContentCopyWith<$Res> {
  factory $RealEstateContentCopyWith(
          RealEstateContent value, $Res Function(RealEstateContent) _then) =
      _$RealEstateContentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@AssetKeyNormalizerConverter() String assetKey,
      @TrimStringConverter() String address,
      @UpperNormalizerConverter() String city,
      @SafeDoubleConverter() double area,
      @UpperNormalizerConverter() String usage,
      @UpperNullableConverter() String? propertyType,
      int? stratum,
      @SafeDoubleConverter() double? cadastralValue,
      int? floors,
      int? constructionYear,
      bool hasParking,
      int? parkingSpaces,
      @TrimStringNullableConverter() String? department,
      @TrimStringNullableConverter() String? neighborhood});
}

/// @nodoc
class _$RealEstateContentCopyWithImpl<$Res>
    implements $RealEstateContentCopyWith<$Res> {
  _$RealEstateContentCopyWithImpl(this._self, this._then);

  final RealEstateContent _self;
  final $Res Function(RealEstateContent) _then;

  /// Create a copy of AssetContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? assetKey = null,
    Object? address = null,
    Object? city = null,
    Object? area = null,
    Object? usage = null,
    Object? propertyType = freezed,
    Object? stratum = freezed,
    Object? cadastralValue = freezed,
    Object? floors = freezed,
    Object? constructionYear = freezed,
    Object? hasParking = null,
    Object? parkingSpaces = freezed,
    Object? department = freezed,
    Object? neighborhood = freezed,
  }) {
    return _then(RealEstateContent(
      assetKey: null == assetKey
          ? _self.assetKey
          : assetKey // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      area: null == area
          ? _self.area
          : area // ignore: cast_nullable_to_non_nullable
              as double,
      usage: null == usage
          ? _self.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as String,
      propertyType: freezed == propertyType
          ? _self.propertyType
          : propertyType // ignore: cast_nullable_to_non_nullable
              as String?,
      stratum: freezed == stratum
          ? _self.stratum
          : stratum // ignore: cast_nullable_to_non_nullable
              as int?,
      cadastralValue: freezed == cadastralValue
          ? _self.cadastralValue
          : cadastralValue // ignore: cast_nullable_to_non_nullable
              as double?,
      floors: freezed == floors
          ? _self.floors
          : floors // ignore: cast_nullable_to_non_nullable
              as int?,
      constructionYear: freezed == constructionYear
          ? _self.constructionYear
          : constructionYear // ignore: cast_nullable_to_non_nullable
              as int?,
      hasParking: null == hasParking
          ? _self.hasParking
          : hasParking // ignore: cast_nullable_to_non_nullable
              as bool,
      parkingSpaces: freezed == parkingSpaces
          ? _self.parkingSpaces
          : parkingSpaces // ignore: cast_nullable_to_non_nullable
              as int?,
      department: freezed == department
          ? _self.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      neighborhood: freezed == neighborhood
          ? _self.neighborhood
          : neighborhood // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class MachineryContent extends AssetContent {
  const MachineryContent(
      {@AssetKeyNormalizerConverter() required this.assetKey,
      @UpperNormalizerConverter() required this.brand,
      @UpperNormalizerConverter() required this.model,
      @UpperNullableConverter() this.category,
      @UpperNullableConverter() this.capacity,
      @UpperNullableConverter() this.operationCertificate,
      this.manufacturingYear,
      @TrimStringNullableConverter() this.countryOfOrigin,
      @SafeDoubleConverter() this.operatingHours,
      @SafeDoubleConverter() this.acquisitionValue,
      this.currency = 'COP',
      final String? $type})
      : $type = $type ?? 'machinery',
        super._();
  factory MachineryContent.fromJson(Map<String, dynamic> json) =>
      _$MachineryContentFromJson(json);

  /// Serial / identificador natural
  @override
  @AssetKeyNormalizerConverter()
  final String assetKey;
  @UpperNormalizerConverter()
  final String brand;
  @UpperNormalizerConverter()
  final String model;
// Opcionales
  @UpperNullableConverter()
  final String? category;
  @UpperNullableConverter()
  final String? capacity;
  @UpperNullableConverter()
  final String? operationCertificate;
  final int? manufacturingYear;
  @TrimStringNullableConverter()
  final String? countryOfOrigin;
  @SafeDoubleConverter()
  final double? operatingHours;
  @SafeDoubleConverter()
  final double? acquisitionValue;
  @JsonKey()
  final String currency;

  @JsonKey(name: 'kind')
  final String $type;

  /// Create a copy of AssetContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MachineryContentCopyWith<MachineryContent> get copyWith =>
      _$MachineryContentCopyWithImpl<MachineryContent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MachineryContentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MachineryContent &&
            (identical(other.assetKey, assetKey) ||
                other.assetKey == assetKey) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.operationCertificate, operationCertificate) ||
                other.operationCertificate == operationCertificate) &&
            (identical(other.manufacturingYear, manufacturingYear) ||
                other.manufacturingYear == manufacturingYear) &&
            (identical(other.countryOfOrigin, countryOfOrigin) ||
                other.countryOfOrigin == countryOfOrigin) &&
            (identical(other.operatingHours, operatingHours) ||
                other.operatingHours == operatingHours) &&
            (identical(other.acquisitionValue, acquisitionValue) ||
                other.acquisitionValue == acquisitionValue) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      assetKey,
      brand,
      model,
      category,
      capacity,
      operationCertificate,
      manufacturingYear,
      countryOfOrigin,
      operatingHours,
      acquisitionValue,
      currency);

  @override
  String toString() {
    return 'AssetContent.machinery(assetKey: $assetKey, brand: $brand, model: $model, category: $category, capacity: $capacity, operationCertificate: $operationCertificate, manufacturingYear: $manufacturingYear, countryOfOrigin: $countryOfOrigin, operatingHours: $operatingHours, acquisitionValue: $acquisitionValue, currency: $currency)';
  }
}

/// @nodoc
abstract mixin class $MachineryContentCopyWith<$Res>
    implements $AssetContentCopyWith<$Res> {
  factory $MachineryContentCopyWith(
          MachineryContent value, $Res Function(MachineryContent) _then) =
      _$MachineryContentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@AssetKeyNormalizerConverter() String assetKey,
      @UpperNormalizerConverter() String brand,
      @UpperNormalizerConverter() String model,
      @UpperNullableConverter() String? category,
      @UpperNullableConverter() String? capacity,
      @UpperNullableConverter() String? operationCertificate,
      int? manufacturingYear,
      @TrimStringNullableConverter() String? countryOfOrigin,
      @SafeDoubleConverter() double? operatingHours,
      @SafeDoubleConverter() double? acquisitionValue,
      String currency});
}

/// @nodoc
class _$MachineryContentCopyWithImpl<$Res>
    implements $MachineryContentCopyWith<$Res> {
  _$MachineryContentCopyWithImpl(this._self, this._then);

  final MachineryContent _self;
  final $Res Function(MachineryContent) _then;

  /// Create a copy of AssetContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? assetKey = null,
    Object? brand = null,
    Object? model = null,
    Object? category = freezed,
    Object? capacity = freezed,
    Object? operationCertificate = freezed,
    Object? manufacturingYear = freezed,
    Object? countryOfOrigin = freezed,
    Object? operatingHours = freezed,
    Object? acquisitionValue = freezed,
    Object? currency = null,
  }) {
    return _then(MachineryContent(
      assetKey: null == assetKey
          ? _self.assetKey
          : assetKey // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _self.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      capacity: freezed == capacity
          ? _self.capacity
          : capacity // ignore: cast_nullable_to_non_nullable
              as String?,
      operationCertificate: freezed == operationCertificate
          ? _self.operationCertificate
          : operationCertificate // ignore: cast_nullable_to_non_nullable
              as String?,
      manufacturingYear: freezed == manufacturingYear
          ? _self.manufacturingYear
          : manufacturingYear // ignore: cast_nullable_to_non_nullable
              as int?,
      countryOfOrigin: freezed == countryOfOrigin
          ? _self.countryOfOrigin
          : countryOfOrigin // ignore: cast_nullable_to_non_nullable
              as String?,
      operatingHours: freezed == operatingHours
          ? _self.operatingHours
          : operatingHours // ignore: cast_nullable_to_non_nullable
              as double?,
      acquisitionValue: freezed == acquisitionValue
          ? _self.acquisitionValue
          : acquisitionValue // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class EquipmentContent extends AssetContent {
  const EquipmentContent(
      {@AssetKeyNormalizerConverter() required this.assetKey,
      @TrimStringConverter() required this.name,
      @UpperNullableConverter() this.brand,
      @UpperNullableConverter() this.model,
      @UpperNullableConverter() this.category,
      @UpperNullableConverter() this.inventoryNumber,
      @TrimStringNullableConverter() this.location,
      this.acquisitionYear,
      this.usefulLifeYears,
      @SafeDoubleConverter() this.acquisitionValue,
      this.currency = 'COP',
      final String? $type})
      : $type = $type ?? 'equipment',
        super._();
  factory EquipmentContent.fromJson(Map<String, dynamic> json) =>
      _$EquipmentContentFromJson(json);

  /// Serial/Inventario natural
  @override
  @AssetKeyNormalizerConverter()
  final String assetKey;

  /// Nombre descriptivo (no necesariamente uppercase)
  @TrimStringConverter()
  final String name;
// Opcionales
  @UpperNullableConverter()
  final String? brand;
  @UpperNullableConverter()
  final String? model;
  @UpperNullableConverter()
  final String? category;
  @UpperNullableConverter()
  final String? inventoryNumber;
  @TrimStringNullableConverter()
  final String? location;
  final int? acquisitionYear;
  final int? usefulLifeYears;
  @SafeDoubleConverter()
  final double? acquisitionValue;
  @JsonKey()
  final String currency;

  @JsonKey(name: 'kind')
  final String $type;

  /// Create a copy of AssetContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EquipmentContentCopyWith<EquipmentContent> get copyWith =>
      _$EquipmentContentCopyWithImpl<EquipmentContent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EquipmentContentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EquipmentContent &&
            (identical(other.assetKey, assetKey) ||
                other.assetKey == assetKey) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.inventoryNumber, inventoryNumber) ||
                other.inventoryNumber == inventoryNumber) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.acquisitionYear, acquisitionYear) ||
                other.acquisitionYear == acquisitionYear) &&
            (identical(other.usefulLifeYears, usefulLifeYears) ||
                other.usefulLifeYears == usefulLifeYears) &&
            (identical(other.acquisitionValue, acquisitionValue) ||
                other.acquisitionValue == acquisitionValue) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      assetKey,
      name,
      brand,
      model,
      category,
      inventoryNumber,
      location,
      acquisitionYear,
      usefulLifeYears,
      acquisitionValue,
      currency);

  @override
  String toString() {
    return 'AssetContent.equipment(assetKey: $assetKey, name: $name, brand: $brand, model: $model, category: $category, inventoryNumber: $inventoryNumber, location: $location, acquisitionYear: $acquisitionYear, usefulLifeYears: $usefulLifeYears, acquisitionValue: $acquisitionValue, currency: $currency)';
  }
}

/// @nodoc
abstract mixin class $EquipmentContentCopyWith<$Res>
    implements $AssetContentCopyWith<$Res> {
  factory $EquipmentContentCopyWith(
          EquipmentContent value, $Res Function(EquipmentContent) _then) =
      _$EquipmentContentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@AssetKeyNormalizerConverter() String assetKey,
      @TrimStringConverter() String name,
      @UpperNullableConverter() String? brand,
      @UpperNullableConverter() String? model,
      @UpperNullableConverter() String? category,
      @UpperNullableConverter() String? inventoryNumber,
      @TrimStringNullableConverter() String? location,
      int? acquisitionYear,
      int? usefulLifeYears,
      @SafeDoubleConverter() double? acquisitionValue,
      String currency});
}

/// @nodoc
class _$EquipmentContentCopyWithImpl<$Res>
    implements $EquipmentContentCopyWith<$Res> {
  _$EquipmentContentCopyWithImpl(this._self, this._then);

  final EquipmentContent _self;
  final $Res Function(EquipmentContent) _then;

  /// Create a copy of AssetContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? assetKey = null,
    Object? name = null,
    Object? brand = freezed,
    Object? model = freezed,
    Object? category = freezed,
    Object? inventoryNumber = freezed,
    Object? location = freezed,
    Object? acquisitionYear = freezed,
    Object? usefulLifeYears = freezed,
    Object? acquisitionValue = freezed,
    Object? currency = null,
  }) {
    return _then(EquipmentContent(
      assetKey: null == assetKey
          ? _self.assetKey
          : assetKey // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _self.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _self.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      inventoryNumber: freezed == inventoryNumber
          ? _self.inventoryNumber
          : inventoryNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      acquisitionYear: freezed == acquisitionYear
          ? _self.acquisitionYear
          : acquisitionYear // ignore: cast_nullable_to_non_nullable
              as int?,
      usefulLifeYears: freezed == usefulLifeYears
          ? _self.usefulLifeYears
          : usefulLifeYears // ignore: cast_nullable_to_non_nullable
              as int?,
      acquisitionValue: freezed == acquisitionValue
          ? _self.acquisitionValue
          : acquisitionValue // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
