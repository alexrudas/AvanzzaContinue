// lib/domain/publications/entities/payloads/driver_seek_payload.dart
// Payload específico para publicaciones tipo DRIVER_SEEK (conductor buscando vehículo).
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

import 'package:avanzza/domain/shared/shared.dart';

// ══════════════════════════════════════════════════════════════════════════════
// ENTIDAD PRINCIPAL
// ══════════════════════════════════════════════════════════════════════════════

// Comentarios en el código: entidad inmutable para búsqueda de vehículo por conductor con validación fuerte y superficie pública compatible con JSON.
class DriverSeekPayload {
  final String? vehicleCategory;
  final String? employmentMode;
  final String? description;
  final List<String> preferredCities;
  final bool flexibleLocation;
  final int? experienceYearsMin;
  final int? experienceYearsMax;
  final bool hasLicense;
  final String? licenseType;
  final bool immediateAvailability;

  DriverSeekPayload._({
    this.vehicleCategory,
    this.employmentMode,
    this.description,
    required List<String> preferredCities,
    this.flexibleLocation = false,
    this.experienceYearsMin,
    this.experienceYearsMax,
    this.hasLicense = false,
    this.licenseType,
    this.immediateAvailability = false,
  }) : preferredCities = List.unmodifiable(preferredCities);

  // Comentarios en el código: helpers públicos que calculan derivados desde campos normalizados.
  bool get hasExperienceRange =>
      experienceYearsMin != null || experienceYearsMax != null;

  bool cityPreferred(String city) {
    final norm = city.trim().toLowerCase();
    return preferredCities.any((c) => c.toLowerCase() == norm);
  }

  // Comentarios en el código: fábrica que delega en tryCreate y lanza ArgumentError con errores acumulados.
  factory DriverSeekPayload.create({
    String? vehicleCategory,
    String? employmentMode,
    String? description,
    List<String> preferredCities = const [],
    bool flexibleLocation = false,
    int? experienceYearsMin,
    int? experienceYearsMax,
    bool hasLicense = false,
    String? licenseType,
    bool immediateAvailability = false,
  }) {
    final result = tryCreate(
      vehicleCategory: vehicleCategory,
      employmentMode: employmentMode,
      description: description,
      preferredCities: preferredCities,
      flexibleLocation: flexibleLocation,
      experienceYearsMin: experienceYearsMin,
      experienceYearsMax: experienceYearsMax,
      hasLicense: hasLicense,
      licenseType: licenseType,
      immediateAvailability: immediateAvailability,
    );

    if (result.isFailure) {
      throw ArgumentError(
        result.errors.map((e) => e.toString()).join('; '),
      );
    }

    return result.value;
  }

  // Comentarios en el código: fábrica sin lanzamiento que valida con VOs y devuelve Result con lista completa de errores.
  static CreationResult<DriverSeekPayload> tryCreate({
    String? vehicleCategory,
    String? employmentMode,
    String? description,
    List<String> preferredCities = const [],
    bool flexibleLocation = false,
    int? experienceYearsMin,
    int? experienceYearsMax,
    bool hasLicense = false,
    String? licenseType,
    bool immediateAvailability = false,
  }) {
    final errors = <ValidationError>[];

    final normVehicle = vehicleCategory?.trim();
    final normMode = employmentMode?.trim();
    final normDesc = description?.trim();
    final normLicense = licenseType?.trim();

    final enumVehicle = VehicleCategoryWire.fromWire(normVehicle);
    final enumMode = EmploymentModeWire.fromWire(normMode);

    final hasContent = normVehicle != null ||
        normMode != null ||
        (normDesc != null && normDesc.isNotEmpty) ||
        preferredCities.isNotEmpty ||
        experienceYearsMin != null ||
        experienceYearsMax != null ||
        hasLicense ||
        normLicense != null ||
        immediateAvailability;

    if (!hasContent) {
      errors.add(
        const ValidationError(
            '_payload', 'Al menos un campo debe estar informado'),
      );
    }

    if (normDesc != null && normDesc.length > 2000) {
      errors.add(const ValidationError(
          'description', 'No puede exceder 2000 caracteres'));
    }

    CityList? cities;
    try {
      cities = CityList(preferredCities);
    } catch (e) {
      errors.add(ValidationError('preferredCities', e.toString()));
    }

    try {
      ExperienceRange(min: experienceYearsMin, max: experienceYearsMax)
          .validate();
    } catch (e) {
      errors.add(ValidationError('experienceYears', e.toString()));
    }

    if (normLicense != null && normLicense.length > 10) {
      errors.add(const ValidationError(
          'licenseType', 'No puede exceder 10 caracteres'));
    }

    if (errors.isNotEmpty) {
      return CreationResult.failure(errors);
    }

    return CreationResult.success(
      DriverSeekPayload._(
        vehicleCategory: normVehicle != null ? enumVehicle.wireName : null,
        employmentMode: normMode != null ? enumMode.wireName : null,
        description: normDesc,
        preferredCities: cities!.values,
        flexibleLocation: flexibleLocation,
        experienceYearsMin: experienceYearsMin,
        experienceYearsMax: experienceYearsMax,
        hasLicense: hasLicense,
        licenseType: normLicense,
        immediateAvailability: immediateAvailability,
      ),
    );
  }

  // Comentarios en el código: parser robusto desde JSON con casteo seguro num→int y validación vía tryCreate.
  static DriverSeekPayload fromJson(Map<String, Object?> json) {
    final experienceMin = (json['experienceYearsMin'] as num?)?.toInt();
    final experienceMax = (json['experienceYearsMax'] as num?)?.toInt();

    final vehicle = (json['vehicleCategory'] as String?)?.trim();
    final mode = (json['employmentMode'] as String?)?.trim();
    final desc = (json['description'] as String?)?.trim();
    final license = (json['licenseType'] as String?)?.trim();

    final cities = (json['preferredCities'] as List<dynamic>?)
            ?.map((e) => e.toString().trim())
            .where((s) => s.isNotEmpty && s.toLowerCase() != 'null')
            .toList() ??
        const <String>[];

    final flexLoc = json['flexibleLocation'] as bool? ?? false;
    final hasLic = json['hasLicense'] as bool? ?? false;
    final immediate = json['immediateAvailability'] as bool? ?? false;

    final result = tryCreate(
      vehicleCategory: vehicle,
      employmentMode: mode,
      description: desc,
      preferredCities: cities,
      flexibleLocation: flexLoc,
      experienceYearsMin: experienceMin,
      experienceYearsMax: experienceMax,
      hasLicense: hasLic,
      licenseType: license,
      immediateAvailability: immediate,
    );

    if (result.isFailure) {
      throw ArgumentError(
        'Validación JSON falló: ${result.errors.map((e) => e.toString()).join('; ')}',
      );
    }

    return result.value;
  }

  // Comentarios en el código: serialización a JSON con wire names estables y campos primitivos.
  Map<String, Object?> toJson() => {
        'vehicleCategory': vehicleCategory,
        'employmentMode': employmentMode,
        'description': description,
        'preferredCities': preferredCities,
        'flexibleLocation': flexibleLocation,
        'experienceYearsMin': experienceYearsMin,
        'experienceYearsMax': experienceYearsMax,
        'hasLicense': hasLicense,
        'licenseType': licenseType,
        'immediateAvailability': immediateAvailability,
      };

  // Comentarios en el código: copy-with que pasa por create para revalidar con VOs.
  DriverSeekPayload copyWith({
    String? vehicleCategory,
    String? employmentMode,
    String? description,
    List<String>? preferredCities,
    bool? flexibleLocation,
    int? experienceYearsMin,
    int? experienceYearsMax,
    bool? hasLicense,
    String? licenseType,
    bool? immediateAvailability,
  }) {
    return DriverSeekPayload.create(
      vehicleCategory: vehicleCategory ?? this.vehicleCategory,
      employmentMode: employmentMode ?? this.employmentMode,
      description: description ?? this.description,
      preferredCities: preferredCities ?? this.preferredCities,
      flexibleLocation: flexibleLocation ?? this.flexibleLocation,
      experienceYearsMin: experienceYearsMin ?? this.experienceYearsMin,
      experienceYearsMax: experienceYearsMax ?? this.experienceYearsMax,
      hasLicense: hasLicense ?? this.hasLicense,
      licenseType: licenseType ?? this.licenseType,
      immediateAvailability:
          immediateAvailability ?? this.immediateAvailability,
    );
  }

  // Comentarios en el código: igualdad y hash con comparación orden-sensible de preferredCities por diseño.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DriverSeekPayload) return false;

    if (preferredCities.length != other.preferredCities.length) return false;
    for (int i = 0; i < preferredCities.length; i++) {
      if (preferredCities[i] != other.preferredCities[i]) return false;
    }

    return vehicleCategory == other.vehicleCategory &&
        employmentMode == other.employmentMode &&
        description == other.description &&
        flexibleLocation == other.flexibleLocation &&
        experienceYearsMin == other.experienceYearsMin &&
        experienceYearsMax == other.experienceYearsMax &&
        hasLicense == other.hasLicense &&
        licenseType == other.licenseType &&
        immediateAvailability == other.immediateAvailability;
  }

  @override
  int get hashCode => Object.hash(
        vehicleCategory,
        employmentMode,
        description,
        Object.hashAll(preferredCities),
        flexibleLocation,
        experienceYearsMin,
        experienceYearsMax,
        hasLicense,
        licenseType,
        immediateAvailability,
      );

  @override
  String toString() => 'DriverSeekPayload('
      'vehicleCategory: $vehicleCategory, '
      'employmentMode: $employmentMode, '
      'cities: ${preferredCities.length}, '
      'experience: $experienceYearsMin-$experienceYearsMax, '
      'hasLicense: $hasLicense, '
      'licenseType: $licenseType, '
      'immediateAvailability: $immediateAvailability)';
}
