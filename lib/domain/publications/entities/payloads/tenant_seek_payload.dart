// lib/domain/publications/entities/payloads/tenant_seek_payload.dart
// Payload específico para publicaciones tipo TENANT_SEEK (inquilinos buscando inmueble).
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

import 'package:avanzza/domain/shared/shared.dart';

// ══════════════════════════════════════════════════════════════════════════════
// ENTIDAD PRINCIPAL
// ══════════════════════════════════════════════════════════════════════════════

// Comentarios en el código: entidad inmutable para búsqueda de inmuebles con validación fuerte y superficie pública compatible con JSON.
class TenantSeekPayload {
  final String? propertyType;
  final int? budgetMin;
  final int? budgetMax;
  final String? currencyCode;
  final String? description;
  final List<String> preferredCities;
  final bool flexibleLocation;
  final int? bedroomsMin;
  final int? bathroomsMin;
  final double? areaMin;
  final double? areaMax;
  final bool parkingRequired;
  final String? leaseDuration;

  TenantSeekPayload._({
    this.propertyType,
    this.budgetMin,
    this.budgetMax,
    this.currencyCode,
    this.description,
    required List<String> preferredCities,
    this.flexibleLocation = false,
    this.bedroomsMin,
    this.bathroomsMin,
    this.areaMin,
    this.areaMax,
    this.parkingRequired = false,
    this.leaseDuration,
  }) : preferredCities = List.unmodifiable(preferredCities);

  // Comentarios en el código: helpers públicos que calculan derivados desde campos normalizados.
  bool get hasBudget => budgetMin != null || budgetMax != null;

  int? get budgetSpan => (budgetMin != null && budgetMax != null)
      ? (budgetMax! - budgetMin!)
      : null;

  bool get hasArea => areaMin != null || areaMax != null;

  double? get areaSpan =>
      (areaMin != null && areaMax != null) ? (areaMax! - areaMin!) : null;

  bool cityPreferred(String city) {
    final norm = city.trim().toLowerCase();
    return preferredCities.any((c) => c.toLowerCase() == norm);
  }

  // Comentarios en el código: fábrica que delega en tryCreate y lanza ArgumentError con errores acumulados.
  factory TenantSeekPayload.create({
    String? propertyType,
    int? budgetMin,
    int? budgetMax,
    String? currencyCode,
    String? description,
    List<String> preferredCities = const [],
    bool flexibleLocation = false,
    int? bedroomsMin,
    int? bathroomsMin,
    double? areaMin,
    double? areaMax,
    bool parkingRequired = false,
    String? leaseDuration,
  }) {
    final result = tryCreate(
      propertyType: propertyType,
      budgetMin: budgetMin,
      budgetMax: budgetMax,
      currencyCode: currencyCode,
      description: description,
      preferredCities: preferredCities,
      flexibleLocation: flexibleLocation,
      bedroomsMin: bedroomsMin,
      bathroomsMin: bathroomsMin,
      areaMin: areaMin,
      areaMax: areaMax,
      parkingRequired: parkingRequired,
      leaseDuration: leaseDuration,
    );

    if (result.isFailure) {
      throw ArgumentError(
        result.errors.map((e) => e.toString()).join('; '),
      );
    }

    return result.value;
  }

  // Comentarios en el código: fábrica sin lanzamiento que valida con VOs y devuelve Result con lista completa de errores.
  static CreationResult<TenantSeekPayload> tryCreate({
    String? propertyType,
    int? budgetMin,
    int? budgetMax,
    String? currencyCode,
    String? description,
    List<String> preferredCities = const [],
    bool flexibleLocation = false,
    int? bedroomsMin,
    int? bathroomsMin,
    double? areaMin,
    double? areaMax,
    bool parkingRequired = false,
    String? leaseDuration,
  }) {
    final errors = <ValidationError>[];

    final normPtype = propertyType?.trim();
    final normDesc = description?.trim();
    final normCurrency = currencyCode?.trim().toUpperCase();
    final normLease = leaseDuration?.trim();

    final enumProp = PropertyTypeWire.fromWire(normPtype);
    final enumLease = LeaseDurationWire.fromWire(normLease);

    final hasContent = normPtype != null ||
        budgetMin != null ||
        budgetMax != null ||
        normCurrency != null ||
        (normDesc != null && normDesc.isNotEmpty) ||
        preferredCities.isNotEmpty ||
        bedroomsMin != null ||
        bathroomsMin != null ||
        areaMin != null ||
        areaMax != null ||
        parkingRequired ||
        normLease != null;

    if (!hasContent) {
      errors.add(
        const ValidationError(
            '_payload', 'Al menos un campo debe estar informado'),
      );
    }

    MoneyRange? budgetRange;
    try {
      budgetRange = MoneyRange(min: budgetMin, max: budgetMax).validate();
    } catch (e) {
      errors.add(ValidationError('budget', e.toString()));
    }

    CurrencyCode? currency;
    if (budgetRange != null && budgetRange.hasAny) {
      if (normCurrency == null) {
        errors.add(
          const ValidationError(
              'currencyCode', 'Requerido cuando se especifica presupuesto'),
        );
      } else {
        try {
          currency = CurrencyCode(normCurrency);
        } catch (e) {
          errors.add(ValidationError('currencyCode', e.toString()));
        }
      }
    } else if (normCurrency != null) {
      try {
        currency = CurrencyCode(normCurrency);
      } catch (e) {
        errors.add(ValidationError('currencyCode', e.toString()));
      }
    }

    if (bedroomsMin != null && bedroomsMin < 0) {
      errors.add(const ValidationError('bedroomsMin', 'No puede ser negativo'));
    }
    if (bathroomsMin != null && bathroomsMin < 0) {
      errors
          .add(const ValidationError('bathroomsMin', 'No puede ser negativo'));
    }

    try {
      AreaRange(min: areaMin, max: areaMax).validate();
    } catch (e) {
      errors.add(ValidationError('area', e.toString()));
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

    if (errors.isNotEmpty) {
      return CreationResult.failure(errors);
    }

    return CreationResult.success(
      TenantSeekPayload._(
        propertyType: normPtype != null ? enumProp.wireName : null,
        budgetMin: budgetMin,
        budgetMax: budgetMax,
        currencyCode: currency?.value,
        description: normDesc,
        preferredCities: cities!.values,
        flexibleLocation: flexibleLocation,
        bedroomsMin: bedroomsMin,
        bathroomsMin: bathroomsMin,
        areaMin: areaMin,
        areaMax: areaMax,
        parkingRequired: parkingRequired,
        leaseDuration: normLease != null ? enumLease.wireName : null,
      ),
    );
  }

  // Comentarios en el código: parser robusto desde JSON con casteo seguro num→int/double y validación vía tryCreate.
  static TenantSeekPayload fromJson(Map<String, Object?> json) {
    final budgetMin = (json['budgetMin'] as num?)?.toInt();
    final budgetMax = (json['budgetMax'] as num?)?.toInt();
    final bedroomsMin = (json['bedroomsMin'] as num?)?.toInt();
    final bathroomsMin = (json['bathroomsMin'] as num?)?.toInt();
    final areaMin = (json['areaMin'] as num?)?.toDouble();
    final areaMax = (json['areaMax'] as num?)?.toDouble();

    final ptype = (json['propertyType'] as String?)?.trim();
    final currency = (json['currencyCode'] as String?)?.trim().toUpperCase();
    final desc = (json['description'] as String?)?.trim();
    final lease = (json['leaseDuration'] as String?)?.trim();

    final cities = (json['preferredCities'] as List<dynamic>?)
            ?.map((e) => e.toString().trim())
            .where((s) => s.isNotEmpty && s.toLowerCase() != 'null')
            .toList() ??
        const <String>[];

    final flexLoc = json['flexibleLocation'] as bool? ?? false;
    final parking = json['parkingRequired'] as bool? ?? false;

    final result = tryCreate(
      propertyType: ptype,
      budgetMin: budgetMin,
      budgetMax: budgetMax,
      currencyCode: currency,
      description: desc,
      preferredCities: cities,
      flexibleLocation: flexLoc,
      bedroomsMin: bedroomsMin,
      bathroomsMin: bathroomsMin,
      areaMin: areaMin,
      areaMax: areaMax,
      parkingRequired: parking,
      leaseDuration: lease,
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
        'propertyType': propertyType,
        'budgetMin': budgetMin,
        'budgetMax': budgetMax,
        'currencyCode': currencyCode,
        'description': description,
        'preferredCities': preferredCities,
        'flexibleLocation': flexibleLocation,
        'bedroomsMin': bedroomsMin,
        'bathroomsMin': bathroomsMin,
        'areaMin': areaMin,
        'areaMax': areaMax,
        'parkingRequired': parkingRequired,
        'leaseDuration': leaseDuration,
      };

  // Comentarios en el código: copy-with que pasa por create para revalidar con VOs.
  TenantSeekPayload copyWith({
    String? propertyType,
    int? budgetMin,
    int? budgetMax,
    String? currencyCode,
    String? description,
    List<String>? preferredCities,
    bool? flexibleLocation,
    int? bedroomsMin,
    int? bathroomsMin,
    double? areaMin,
    double? areaMax,
    bool? parkingRequired,
    String? leaseDuration,
  }) {
    return TenantSeekPayload.create(
      propertyType: propertyType ?? this.propertyType,
      budgetMin: budgetMin ?? this.budgetMin,
      budgetMax: budgetMax ?? this.budgetMax,
      currencyCode: currencyCode ?? this.currencyCode,
      description: description ?? this.description,
      preferredCities: preferredCities ?? this.preferredCities,
      flexibleLocation: flexibleLocation ?? this.flexibleLocation,
      bedroomsMin: bedroomsMin ?? this.bedroomsMin,
      bathroomsMin: bathroomsMin ?? this.bathroomsMin,
      areaMin: areaMin ?? this.areaMin,
      areaMax: areaMax ?? this.areaMax,
      parkingRequired: parkingRequired ?? this.parkingRequired,
      leaseDuration: leaseDuration ?? this.leaseDuration,
    );
  }

  // Comentarios en el código: igualdad y hash con comparación orden-sensible de preferredCities por diseño.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TenantSeekPayload) return false;

    if (preferredCities.length != other.preferredCities.length) return false;
    for (int i = 0; i < preferredCities.length; i++) {
      if (preferredCities[i] != other.preferredCities[i]) return false;
    }

    return propertyType == other.propertyType &&
        budgetMin == other.budgetMin &&
        budgetMax == other.budgetMax &&
        currencyCode == other.currencyCode &&
        description == other.description &&
        flexibleLocation == other.flexibleLocation &&
        bedroomsMin == other.bedroomsMin &&
        bathroomsMin == other.bathroomsMin &&
        areaMin == other.areaMin &&
        areaMax == other.areaMax &&
        parkingRequired == other.parkingRequired &&
        leaseDuration == other.leaseDuration;
  }

  @override
  int get hashCode => Object.hash(
        propertyType,
        budgetMin,
        budgetMax,
        currencyCode,
        description,
        Object.hashAll(preferredCities),
        flexibleLocation,
        bedroomsMin,
        bathroomsMin,
        areaMin,
        areaMax,
        parkingRequired,
        leaseDuration,
      );

  @override
  String toString() => 'TenantSeekPayload('
      'propertyType: $propertyType, '
      'budget: $budgetMin-$budgetMax $currencyCode, '
      'cities: ${preferredCities.length}, '
      'bedrooms: $bedroomsMin, '
      'bathrooms: $bathroomsMin, '
      'area: $areaMin-$areaMax, '
      'parking: $parkingRequired, '
      'lease: $leaseDuration)';
}
