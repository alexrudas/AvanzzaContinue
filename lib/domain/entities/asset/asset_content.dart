// ============================================================================
// lib/domain/entities/asset/asset_content.dart
// SEALED CLASS POLIMÓRFICA (V2 CONSOLIDADA) — NORMALIZADA Y ANTI-CRASH
//
// V2 PRINCIPIO:
// - assetKey es el IDENTIFICADOR PRINCIPAL por tipo (placa, matrícula, serial, etc.)
// - Campos obligatorios por tipo se respetan (para evitar "null hell").
// - Normalización y converters tolerantes para evitar crashes con JSON heterogéneo.
//
// NOTA:
// - Para vehículos, assetKey corresponde a PLACA normalizada (sin guiones, solo A-Z0-9).
// - Para inmuebles/maquinaria/equipos, assetKey es su identificador natural normalizado.
// ============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_content.freezed.dart';
part 'asset_content.g.dart';

// ============================================================================
// HELPERS ANTI-CRASH
// ============================================================================

double? _toDoubleSafe(Object? v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v.trim());
  return null;
}

/// Normaliza clave principal (assetKey) permitiendo guión (útil para matrículas/seriales).
/// - Trim
/// - Uppercase
/// - Solo A-Z 0-9 y '-'
String _normalizeAssetKey(String s) {
  return s.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9-]'), '');
}

/// Normaliza texto uppercase (brand/model/color/etc).
String _normalizeUpper(String s) => s.trim().toUpperCase();

String? _normalizeUpperNullable(String? s) {
  if (s == null || s.trim().isEmpty) return null;
  return s.trim().toUpperCase();
}

/// Trim para texto libre (direcciones, ubicaciones).
String _trim(String s) => s.trim();

String? _trimNullable(String? s) {
  if (s == null || s.trim().isEmpty) return null;
  return s.trim();
}

// ============================================================================
// JSON CONVERTERS
// ============================================================================

class SafeDoubleConverter implements JsonConverter<double?, Object?> {
  const SafeDoubleConverter();

  @override
  double? fromJson(Object? json) => _toDoubleSafe(json);

  @override
  double? toJson(double? object) => object;
}

class AssetKeyNormalizerConverter implements JsonConverter<String, String> {
  const AssetKeyNormalizerConverter();

  @override
  String fromJson(String json) => _normalizeAssetKey(json);

  @override
  String toJson(String object) => _normalizeAssetKey(object);
}

class UpperNormalizerConverter implements JsonConverter<String, String> {
  const UpperNormalizerConverter();

  @override
  String fromJson(String json) => _normalizeUpper(json);

  @override
  String toJson(String object) => _normalizeUpper(object);
}

class UpperNullableConverter implements JsonConverter<String?, String?> {
  const UpperNullableConverter();

  @override
  String? fromJson(String? json) => _normalizeUpperNullable(json);

  @override
  String? toJson(String? object) => _normalizeUpperNullable(object);
}

class TrimStringConverter implements JsonConverter<String, String> {
  const TrimStringConverter();

  @override
  String fromJson(String json) => _trim(json);

  @override
  String toJson(String object) => _trim(object);
}

class TrimStringNullableConverter implements JsonConverter<String?, String?> {
  const TrimStringNullableConverter();

  @override
  String? fromJson(String? json) => _trimNullable(json);

  @override
  String? toJson(String? object) => _trimNullable(object);
}

// ============================================================================
// SEALED CLASS: AssetContent (V2)
// ============================================================================

@Freezed(unionKey: 'kind')
sealed class AssetContent with _$AssetContent {
  const AssetContent._();

  // --------------------------------------------------------------------------
  // VEHICLE (V2)
  // --------------------------------------------------------------------------
  @FreezedUnionValue('vehicle')
  const factory AssetContent.vehicle({
    /// Placa (normalizada). En CO típicamente 6 chars alfanuméricos.
    @AssetKeyNormalizerConverter() required String assetKey,

    @UpperNormalizerConverter() required String brand,

    /// V2: model es String (ej: "2024", "2020", etc.)
    @UpperNormalizerConverter() required String model,

    @UpperNormalizerConverter() required String color,

    /// V2: engineDisplacement obligatorio (cc o litros, define tu estándar).
    /// Recomendación: usar cc como double (ej: 1600.0).
    @SafeDoubleConverter() required double engineDisplacement,

    @Default(0) int mileage,

    // Opcionales (alineados a tu versión avanzada previa)
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
    String? initialRegistrationDate,
  }) = VehicleContent;

  // --------------------------------------------------------------------------
  // REAL ESTATE (V2)
  // --------------------------------------------------------------------------
  @FreezedUnionValue('real_estate')
  const factory AssetContent.realEstate({
    /// Matrícula inmobiliaria / identificador natural (longitud variable).
    @AssetKeyNormalizerConverter() required String assetKey,

    @TrimStringConverter() required String address,

    @UpperNormalizerConverter() required String city,

    @SafeDoubleConverter() required double area,

    @UpperNormalizerConverter() required String usage,

    // Opcionales útiles
    @UpperNullableConverter() String? propertyType,
    int? stratum,
    @SafeDoubleConverter() double? cadastralValue,
    int? floors,
    int? constructionYear,
    @Default(false) bool hasParking,
    int? parkingSpaces,
    @TrimStringNullableConverter() String? department,
    @TrimStringNullableConverter() String? neighborhood,
  }) = RealEstateContent;

  // --------------------------------------------------------------------------
  // MACHINERY (V2)
  // --------------------------------------------------------------------------
  @FreezedUnionValue('machinery')
  const factory AssetContent.machinery({
    /// Serial / identificador natural
    @AssetKeyNormalizerConverter() required String assetKey,

    @UpperNormalizerConverter() required String brand,
    @UpperNormalizerConverter() required String model,

    // Opcionales
    @UpperNullableConverter() String? category,
    @UpperNullableConverter() String? capacity,
    @UpperNullableConverter() String? operationCertificate,
    int? manufacturingYear,
    @TrimStringNullableConverter() String? countryOfOrigin,
    @SafeDoubleConverter() double? operatingHours,
    @SafeDoubleConverter() double? acquisitionValue,
    @Default('COP') String currency,
  }) = MachineryContent;

  // --------------------------------------------------------------------------
  // EQUIPMENT (V2)
  // --------------------------------------------------------------------------
  @FreezedUnionValue('equipment')
  const factory AssetContent.equipment({
    /// Serial/Inventario natural
    @AssetKeyNormalizerConverter() required String assetKey,

    /// Nombre descriptivo (no necesariamente uppercase)
    @TrimStringConverter() required String name,

    // Opcionales
    @UpperNullableConverter() String? brand,
    @UpperNullableConverter() String? model,
    @UpperNullableConverter() String? category,
    @UpperNullableConverter() String? inventoryNumber,
    @TrimStringNullableConverter() String? location,
    int? acquisitionYear,
    int? usefulLifeYears,
    @SafeDoubleConverter() double? acquisitionValue,
    @Default('COP') String currency,
  }) = EquipmentContent;

  factory AssetContent.fromJson(Map<String, dynamic> json) =>
      _$AssetContentFromJson(json);
}

// ============================================================================
// HELPERS DERIVADOS (NO SERIALIZAN)
// ============================================================================

extension AssetContentHelpers on AssetContent {
  String get typeDiscriminator => switch (this) {
        VehicleContent() => 'vehicle',
        RealEstateContent() => 'real_estate',
        MachineryContent() => 'machinery',
        EquipmentContent() => 'equipment',
      };

  /// assetKey ya es campo V2 en todos los tipos.
  String get assetKeyValue => switch (this) {
        VehicleContent(:final assetKey) => assetKey,
        RealEstateContent(:final assetKey) => assetKey,
        MachineryContent(:final assetKey) => assetKey,
        EquipmentContent(:final assetKey) => assetKey,
      };

  /// Clave global determinista (útil para indexar/paths):
  /// VEH-PLACA / EST-MATRICULA / MAC-SERIAL / EQU-SERIAL
  String get globalAssetKey {
    final prefix = switch (this) {
      VehicleContent() => 'VEH',
      RealEstateContent() => 'EST',
      MachineryContent() => 'MAC',
      EquipmentContent() => 'EQU',
    };
    return '$prefix-$assetKeyValue';
  }

  String get displayName => switch (this) {
        VehicleContent(:final brand, :final model, :final assetKey) =>
          '$brand $model ($assetKey)',
        RealEstateContent(:final city, :final address) => '$city - $address',
        MachineryContent(:final brand, :final model) => '$brand $model',
        EquipmentContent(:final name, :final assetKey) => '$name ($assetKey)',
      };
}
