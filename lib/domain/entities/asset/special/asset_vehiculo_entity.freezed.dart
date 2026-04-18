// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_vehiculo_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetVehiculoEntity {
  String get assetId;
  String get refCode; // 3 letters + 3 numbers
  String get placa;
  String get marca;
  String get modelo;
  int get anio; // ── Campos enriquecidos desde RUNT ────────────────────────────────────
// Null para activos registrados antes de la Fase RUNT Grid (2026-03).
// Se persisten durante el registro; leídos de regreso en _toEnrichedEntity().
  String? get color;
  double? get engineDisplacement;
  String? get vin;
  String? get engineNumber;
  String? get chassisNumber;
  String? get line;
  String? get serviceType;
  String? get vehicleClass;
  String? get bodyType;
  String? get fuelType;
  int? get passengerCapacity;
  double? get loadCapacityKg;
  double? get grossWeightKg;
  int? get axles;
  String? get transitAuthority;
  String? get initialRegistrationDate;
  String?
      get propertyLiens; // ── Propietario registrado en RUNT ───────────────────────────────────────
// Null para activos registrados antes de la Fase Propietario (2026-03).
  /// Nombre completo del propietario.
  String? get ownerName;

  /// Tipo de documento del propietario (ej. 'CC', 'CE').
  String? get ownerDocumentType;

  /// Número de documento del propietario.
  String? get ownerDocument;

  /// JSON serializado de snapshots RTM, limitaciones y garantías.
  ///
  /// Formato: {'runt_rtm': [...], 'runt_limitations': [...],
  ///           'runt_warranties': [...]}
  /// Null si no hay datos RUNT disponibles en el momento del registro.
  String? get runtMetaJson;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of AssetVehiculoEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AssetVehiculoEntityCopyWith<AssetVehiculoEntity> get copyWith =>
      _$AssetVehiculoEntityCopyWithImpl<AssetVehiculoEntity>(
          this as AssetVehiculoEntity, _$identity);

  /// Serializes this AssetVehiculoEntity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AssetVehiculoEntity &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.refCode, refCode) || other.refCode == refCode) &&
            (identical(other.placa, placa) || other.placa == placa) &&
            (identical(other.marca, marca) || other.marca == marca) &&
            (identical(other.modelo, modelo) || other.modelo == modelo) &&
            (identical(other.anio, anio) || other.anio == anio) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.engineDisplacement, engineDisplacement) ||
                other.engineDisplacement == engineDisplacement) &&
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
            (identical(other.bodyType, bodyType) ||
                other.bodyType == bodyType) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
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
                other.initialRegistrationDate == initialRegistrationDate) &&
            (identical(other.propertyLiens, propertyLiens) ||
                other.propertyLiens == propertyLiens) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.ownerDocumentType, ownerDocumentType) ||
                other.ownerDocumentType == ownerDocumentType) &&
            (identical(other.ownerDocument, ownerDocument) ||
                other.ownerDocument == ownerDocument) &&
            (identical(other.runtMetaJson, runtMetaJson) ||
                other.runtMetaJson == runtMetaJson) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        assetId,
        refCode,
        placa,
        marca,
        modelo,
        anio,
        color,
        engineDisplacement,
        vin,
        engineNumber,
        chassisNumber,
        line,
        serviceType,
        vehicleClass,
        bodyType,
        fuelType,
        passengerCapacity,
        loadCapacityKg,
        grossWeightKg,
        axles,
        transitAuthority,
        initialRegistrationDate,
        propertyLiens,
        ownerName,
        ownerDocumentType,
        ownerDocument,
        runtMetaJson,
        createdAt,
        updatedAt
      ]);

  @override
  String toString() {
    return 'AssetVehiculoEntity(assetId: $assetId, refCode: $refCode, placa: $placa, marca: $marca, modelo: $modelo, anio: $anio, color: $color, engineDisplacement: $engineDisplacement, vin: $vin, engineNumber: $engineNumber, chassisNumber: $chassisNumber, line: $line, serviceType: $serviceType, vehicleClass: $vehicleClass, bodyType: $bodyType, fuelType: $fuelType, passengerCapacity: $passengerCapacity, loadCapacityKg: $loadCapacityKg, grossWeightKg: $grossWeightKg, axles: $axles, transitAuthority: $transitAuthority, initialRegistrationDate: $initialRegistrationDate, propertyLiens: $propertyLiens, ownerName: $ownerName, ownerDocumentType: $ownerDocumentType, ownerDocument: $ownerDocument, runtMetaJson: $runtMetaJson, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AssetVehiculoEntityCopyWith<$Res> {
  factory $AssetVehiculoEntityCopyWith(
          AssetVehiculoEntity value, $Res Function(AssetVehiculoEntity) _then) =
      _$AssetVehiculoEntityCopyWithImpl;
  @useResult
  $Res call(
      {String assetId,
      String refCode,
      String placa,
      String marca,
      String modelo,
      int anio,
      String? color,
      double? engineDisplacement,
      String? vin,
      String? engineNumber,
      String? chassisNumber,
      String? line,
      String? serviceType,
      String? vehicleClass,
      String? bodyType,
      String? fuelType,
      int? passengerCapacity,
      double? loadCapacityKg,
      double? grossWeightKg,
      int? axles,
      String? transitAuthority,
      String? initialRegistrationDate,
      String? propertyLiens,
      String? ownerName,
      String? ownerDocumentType,
      String? ownerDocument,
      String? runtMetaJson,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$AssetVehiculoEntityCopyWithImpl<$Res>
    implements $AssetVehiculoEntityCopyWith<$Res> {
  _$AssetVehiculoEntityCopyWithImpl(this._self, this._then);

  final AssetVehiculoEntity _self;
  final $Res Function(AssetVehiculoEntity) _then;

  /// Create a copy of AssetVehiculoEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetId = null,
    Object? refCode = null,
    Object? placa = null,
    Object? marca = null,
    Object? modelo = null,
    Object? anio = null,
    Object? color = freezed,
    Object? engineDisplacement = freezed,
    Object? vin = freezed,
    Object? engineNumber = freezed,
    Object? chassisNumber = freezed,
    Object? line = freezed,
    Object? serviceType = freezed,
    Object? vehicleClass = freezed,
    Object? bodyType = freezed,
    Object? fuelType = freezed,
    Object? passengerCapacity = freezed,
    Object? loadCapacityKg = freezed,
    Object? grossWeightKg = freezed,
    Object? axles = freezed,
    Object? transitAuthority = freezed,
    Object? initialRegistrationDate = freezed,
    Object? propertyLiens = freezed,
    Object? ownerName = freezed,
    Object? ownerDocumentType = freezed,
    Object? ownerDocument = freezed,
    Object? runtMetaJson = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      refCode: null == refCode
          ? _self.refCode
          : refCode // ignore: cast_nullable_to_non_nullable
              as String,
      placa: null == placa
          ? _self.placa
          : placa // ignore: cast_nullable_to_non_nullable
              as String,
      marca: null == marca
          ? _self.marca
          : marca // ignore: cast_nullable_to_non_nullable
              as String,
      modelo: null == modelo
          ? _self.modelo
          : modelo // ignore: cast_nullable_to_non_nullable
              as String,
      anio: null == anio
          ? _self.anio
          : anio // ignore: cast_nullable_to_non_nullable
              as int,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      engineDisplacement: freezed == engineDisplacement
          ? _self.engineDisplacement
          : engineDisplacement // ignore: cast_nullable_to_non_nullable
              as double?,
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
      bodyType: freezed == bodyType
          ? _self.bodyType
          : bodyType // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelType: freezed == fuelType
          ? _self.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
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
      propertyLiens: freezed == propertyLiens
          ? _self.propertyLiens
          : propertyLiens // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerName: freezed == ownerName
          ? _self.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerDocumentType: freezed == ownerDocumentType
          ? _self.ownerDocumentType
          : ownerDocumentType // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerDocument: freezed == ownerDocument
          ? _self.ownerDocument
          : ownerDocument // ignore: cast_nullable_to_non_nullable
              as String?,
      runtMetaJson: freezed == runtMetaJson
          ? _self.runtMetaJson
          : runtMetaJson // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AssetVehiculoEntity].
extension AssetVehiculoEntityPatterns on AssetVehiculoEntity {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AssetVehiculoEntity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetVehiculoEntity() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_AssetVehiculoEntity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetVehiculoEntity():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AssetVehiculoEntity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetVehiculoEntity() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String assetId,
            String refCode,
            String placa,
            String marca,
            String modelo,
            int anio,
            String? color,
            double? engineDisplacement,
            String? vin,
            String? engineNumber,
            String? chassisNumber,
            String? line,
            String? serviceType,
            String? vehicleClass,
            String? bodyType,
            String? fuelType,
            int? passengerCapacity,
            double? loadCapacityKg,
            double? grossWeightKg,
            int? axles,
            String? transitAuthority,
            String? initialRegistrationDate,
            String? propertyLiens,
            String? ownerName,
            String? ownerDocumentType,
            String? ownerDocument,
            String? runtMetaJson,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AssetVehiculoEntity() when $default != null:
        return $default(
            _that.assetId,
            _that.refCode,
            _that.placa,
            _that.marca,
            _that.modelo,
            _that.anio,
            _that.color,
            _that.engineDisplacement,
            _that.vin,
            _that.engineNumber,
            _that.chassisNumber,
            _that.line,
            _that.serviceType,
            _that.vehicleClass,
            _that.bodyType,
            _that.fuelType,
            _that.passengerCapacity,
            _that.loadCapacityKg,
            _that.grossWeightKg,
            _that.axles,
            _that.transitAuthority,
            _that.initialRegistrationDate,
            _that.propertyLiens,
            _that.ownerName,
            _that.ownerDocumentType,
            _that.ownerDocument,
            _that.runtMetaJson,
            _that.createdAt,
            _that.updatedAt);
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
  TResult when<TResult extends Object?>(
    TResult Function(
            String assetId,
            String refCode,
            String placa,
            String marca,
            String modelo,
            int anio,
            String? color,
            double? engineDisplacement,
            String? vin,
            String? engineNumber,
            String? chassisNumber,
            String? line,
            String? serviceType,
            String? vehicleClass,
            String? bodyType,
            String? fuelType,
            int? passengerCapacity,
            double? loadCapacityKg,
            double? grossWeightKg,
            int? axles,
            String? transitAuthority,
            String? initialRegistrationDate,
            String? propertyLiens,
            String? ownerName,
            String? ownerDocumentType,
            String? ownerDocument,
            String? runtMetaJson,
            DateTime? createdAt,
            DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetVehiculoEntity():
        return $default(
            _that.assetId,
            _that.refCode,
            _that.placa,
            _that.marca,
            _that.modelo,
            _that.anio,
            _that.color,
            _that.engineDisplacement,
            _that.vin,
            _that.engineNumber,
            _that.chassisNumber,
            _that.line,
            _that.serviceType,
            _that.vehicleClass,
            _that.bodyType,
            _that.fuelType,
            _that.passengerCapacity,
            _that.loadCapacityKg,
            _that.grossWeightKg,
            _that.axles,
            _that.transitAuthority,
            _that.initialRegistrationDate,
            _that.propertyLiens,
            _that.ownerName,
            _that.ownerDocumentType,
            _that.ownerDocument,
            _that.runtMetaJson,
            _that.createdAt,
            _that.updatedAt);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String assetId,
            String refCode,
            String placa,
            String marca,
            String modelo,
            int anio,
            String? color,
            double? engineDisplacement,
            String? vin,
            String? engineNumber,
            String? chassisNumber,
            String? line,
            String? serviceType,
            String? vehicleClass,
            String? bodyType,
            String? fuelType,
            int? passengerCapacity,
            double? loadCapacityKg,
            double? grossWeightKg,
            int? axles,
            String? transitAuthority,
            String? initialRegistrationDate,
            String? propertyLiens,
            String? ownerName,
            String? ownerDocumentType,
            String? ownerDocument,
            String? runtMetaJson,
            DateTime? createdAt,
            DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AssetVehiculoEntity() when $default != null:
        return $default(
            _that.assetId,
            _that.refCode,
            _that.placa,
            _that.marca,
            _that.modelo,
            _that.anio,
            _that.color,
            _that.engineDisplacement,
            _that.vin,
            _that.engineNumber,
            _that.chassisNumber,
            _that.line,
            _that.serviceType,
            _that.vehicleClass,
            _that.bodyType,
            _that.fuelType,
            _that.passengerCapacity,
            _that.loadCapacityKg,
            _that.grossWeightKg,
            _that.axles,
            _that.transitAuthority,
            _that.initialRegistrationDate,
            _that.propertyLiens,
            _that.ownerName,
            _that.ownerDocumentType,
            _that.ownerDocument,
            _that.runtMetaJson,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AssetVehiculoEntity implements AssetVehiculoEntity {
  const _AssetVehiculoEntity(
      {required this.assetId,
      required this.refCode,
      required this.placa,
      required this.marca,
      required this.modelo,
      required this.anio,
      this.color,
      this.engineDisplacement,
      this.vin,
      this.engineNumber,
      this.chassisNumber,
      this.line,
      this.serviceType,
      this.vehicleClass,
      this.bodyType,
      this.fuelType,
      this.passengerCapacity,
      this.loadCapacityKg,
      this.grossWeightKg,
      this.axles,
      this.transitAuthority,
      this.initialRegistrationDate,
      this.propertyLiens,
      this.ownerName,
      this.ownerDocumentType,
      this.ownerDocument,
      this.runtMetaJson,
      this.createdAt,
      this.updatedAt});
  factory _AssetVehiculoEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetVehiculoEntityFromJson(json);

  @override
  final String assetId;
  @override
  final String refCode;
// 3 letters + 3 numbers
  @override
  final String placa;
  @override
  final String marca;
  @override
  final String modelo;
  @override
  final int anio;
// ── Campos enriquecidos desde RUNT ────────────────────────────────────
// Null para activos registrados antes de la Fase RUNT Grid (2026-03).
// Se persisten durante el registro; leídos de regreso en _toEnrichedEntity().
  @override
  final String? color;
  @override
  final double? engineDisplacement;
  @override
  final String? vin;
  @override
  final String? engineNumber;
  @override
  final String? chassisNumber;
  @override
  final String? line;
  @override
  final String? serviceType;
  @override
  final String? vehicleClass;
  @override
  final String? bodyType;
  @override
  final String? fuelType;
  @override
  final int? passengerCapacity;
  @override
  final double? loadCapacityKg;
  @override
  final double? grossWeightKg;
  @override
  final int? axles;
  @override
  final String? transitAuthority;
  @override
  final String? initialRegistrationDate;
  @override
  final String? propertyLiens;
// ── Propietario registrado en RUNT ───────────────────────────────────────
// Null para activos registrados antes de la Fase Propietario (2026-03).
  /// Nombre completo del propietario.
  @override
  final String? ownerName;

  /// Tipo de documento del propietario (ej. 'CC', 'CE').
  @override
  final String? ownerDocumentType;

  /// Número de documento del propietario.
  @override
  final String? ownerDocument;

  /// JSON serializado de snapshots RTM, limitaciones y garantías.
  ///
  /// Formato: {'runt_rtm': [...], 'runt_limitations': [...],
  ///           'runt_warranties': [...]}
  /// Null si no hay datos RUNT disponibles en el momento del registro.
  @override
  final String? runtMetaJson;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of AssetVehiculoEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AssetVehiculoEntityCopyWith<_AssetVehiculoEntity> get copyWith =>
      __$AssetVehiculoEntityCopyWithImpl<_AssetVehiculoEntity>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AssetVehiculoEntityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AssetVehiculoEntity &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.refCode, refCode) || other.refCode == refCode) &&
            (identical(other.placa, placa) || other.placa == placa) &&
            (identical(other.marca, marca) || other.marca == marca) &&
            (identical(other.modelo, modelo) || other.modelo == modelo) &&
            (identical(other.anio, anio) || other.anio == anio) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.engineDisplacement, engineDisplacement) ||
                other.engineDisplacement == engineDisplacement) &&
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
            (identical(other.bodyType, bodyType) ||
                other.bodyType == bodyType) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
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
                other.initialRegistrationDate == initialRegistrationDate) &&
            (identical(other.propertyLiens, propertyLiens) ||
                other.propertyLiens == propertyLiens) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.ownerDocumentType, ownerDocumentType) ||
                other.ownerDocumentType == ownerDocumentType) &&
            (identical(other.ownerDocument, ownerDocument) ||
                other.ownerDocument == ownerDocument) &&
            (identical(other.runtMetaJson, runtMetaJson) ||
                other.runtMetaJson == runtMetaJson) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        assetId,
        refCode,
        placa,
        marca,
        modelo,
        anio,
        color,
        engineDisplacement,
        vin,
        engineNumber,
        chassisNumber,
        line,
        serviceType,
        vehicleClass,
        bodyType,
        fuelType,
        passengerCapacity,
        loadCapacityKg,
        grossWeightKg,
        axles,
        transitAuthority,
        initialRegistrationDate,
        propertyLiens,
        ownerName,
        ownerDocumentType,
        ownerDocument,
        runtMetaJson,
        createdAt,
        updatedAt
      ]);

  @override
  String toString() {
    return 'AssetVehiculoEntity(assetId: $assetId, refCode: $refCode, placa: $placa, marca: $marca, modelo: $modelo, anio: $anio, color: $color, engineDisplacement: $engineDisplacement, vin: $vin, engineNumber: $engineNumber, chassisNumber: $chassisNumber, line: $line, serviceType: $serviceType, vehicleClass: $vehicleClass, bodyType: $bodyType, fuelType: $fuelType, passengerCapacity: $passengerCapacity, loadCapacityKg: $loadCapacityKg, grossWeightKg: $grossWeightKg, axles: $axles, transitAuthority: $transitAuthority, initialRegistrationDate: $initialRegistrationDate, propertyLiens: $propertyLiens, ownerName: $ownerName, ownerDocumentType: $ownerDocumentType, ownerDocument: $ownerDocument, runtMetaJson: $runtMetaJson, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AssetVehiculoEntityCopyWith<$Res>
    implements $AssetVehiculoEntityCopyWith<$Res> {
  factory _$AssetVehiculoEntityCopyWith(_AssetVehiculoEntity value,
          $Res Function(_AssetVehiculoEntity) _then) =
      __$AssetVehiculoEntityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String assetId,
      String refCode,
      String placa,
      String marca,
      String modelo,
      int anio,
      String? color,
      double? engineDisplacement,
      String? vin,
      String? engineNumber,
      String? chassisNumber,
      String? line,
      String? serviceType,
      String? vehicleClass,
      String? bodyType,
      String? fuelType,
      int? passengerCapacity,
      double? loadCapacityKg,
      double? grossWeightKg,
      int? axles,
      String? transitAuthority,
      String? initialRegistrationDate,
      String? propertyLiens,
      String? ownerName,
      String? ownerDocumentType,
      String? ownerDocument,
      String? runtMetaJson,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$AssetVehiculoEntityCopyWithImpl<$Res>
    implements _$AssetVehiculoEntityCopyWith<$Res> {
  __$AssetVehiculoEntityCopyWithImpl(this._self, this._then);

  final _AssetVehiculoEntity _self;
  final $Res Function(_AssetVehiculoEntity) _then;

  /// Create a copy of AssetVehiculoEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? assetId = null,
    Object? refCode = null,
    Object? placa = null,
    Object? marca = null,
    Object? modelo = null,
    Object? anio = null,
    Object? color = freezed,
    Object? engineDisplacement = freezed,
    Object? vin = freezed,
    Object? engineNumber = freezed,
    Object? chassisNumber = freezed,
    Object? line = freezed,
    Object? serviceType = freezed,
    Object? vehicleClass = freezed,
    Object? bodyType = freezed,
    Object? fuelType = freezed,
    Object? passengerCapacity = freezed,
    Object? loadCapacityKg = freezed,
    Object? grossWeightKg = freezed,
    Object? axles = freezed,
    Object? transitAuthority = freezed,
    Object? initialRegistrationDate = freezed,
    Object? propertyLiens = freezed,
    Object? ownerName = freezed,
    Object? ownerDocumentType = freezed,
    Object? ownerDocument = freezed,
    Object? runtMetaJson = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_AssetVehiculoEntity(
      assetId: null == assetId
          ? _self.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      refCode: null == refCode
          ? _self.refCode
          : refCode // ignore: cast_nullable_to_non_nullable
              as String,
      placa: null == placa
          ? _self.placa
          : placa // ignore: cast_nullable_to_non_nullable
              as String,
      marca: null == marca
          ? _self.marca
          : marca // ignore: cast_nullable_to_non_nullable
              as String,
      modelo: null == modelo
          ? _self.modelo
          : modelo // ignore: cast_nullable_to_non_nullable
              as String,
      anio: null == anio
          ? _self.anio
          : anio // ignore: cast_nullable_to_non_nullable
              as int,
      color: freezed == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      engineDisplacement: freezed == engineDisplacement
          ? _self.engineDisplacement
          : engineDisplacement // ignore: cast_nullable_to_non_nullable
              as double?,
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
      bodyType: freezed == bodyType
          ? _self.bodyType
          : bodyType // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelType: freezed == fuelType
          ? _self.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
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
      propertyLiens: freezed == propertyLiens
          ? _self.propertyLiens
          : propertyLiens // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerName: freezed == ownerName
          ? _self.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerDocumentType: freezed == ownerDocumentType
          ? _self.ownerDocumentType
          : ownerDocumentType // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerDocument: freezed == ownerDocument
          ? _self.ownerDocument
          : ownerDocument // ignore: cast_nullable_to_non_nullable
              as String?,
      runtMetaJson: freezed == runtMetaJson
          ? _self.runtMetaJson
          : runtMetaJson // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
