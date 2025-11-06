// lib/domain/publications/entities/payloads/service_offer_payload.dart
// Payload específico para publicaciones tipo SERVICE_OFFER (proveedor ofrece servicios).
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

import 'package:avanzza/domain/shared/shared.dart';

// ══════════════════════════════════════════════════════════════════════════════
// ENTIDAD PRINCIPAL
// ══════════════════════════════════════════════════════════════════════════════

// Comentarios en el código: entidad inmutable para oferta de servicios con validación fuerte y superficie pública compatible con JSON.
class ServiceOfferPayload {
  final String? serviceCategory;
  final String serviceName;
  final String? description;
  final int? basePrice;
  final String? currencyCode;
  final List<String> coverageAreas;
  final bool onSite;
  final bool mobileService;
  final int? slaHours;
  final int? warrantyDays;

  ServiceOfferPayload._({
    this.serviceCategory,
    required this.serviceName,
    this.description,
    this.basePrice,
    this.currencyCode,
    required List<String> coverageAreas,
    this.onSite = false,
    this.mobileService = false,
    this.slaHours,
    this.warrantyDays,
  }) : coverageAreas = List.unmodifiable(coverageAreas);

  // Comentarios en el código: helpers públicos que calculan derivados desde campos normalizados.
  bool get hasBasePrice => basePrice != null && basePrice! > 0;

  bool get hasWarranty => warrantyDays != null && warrantyDays! > 0;

  bool coverageIncludes(String area) {
    final norm = area.trim().toLowerCase();
    return coverageAreas.any((c) => c.toLowerCase() == norm);
  }

  // Comentarios en el código: fábrica que delega en tryCreate y lanza ArgumentError con errores acumulados.
  factory ServiceOfferPayload.create({
    String? serviceCategory,
    required String serviceName,
    String? description,
    int? basePrice,
    String? currencyCode,
    List<String> coverageAreas = const [],
    bool onSite = false,
    bool mobileService = false,
    int? slaHours,
    int? warrantyDays,
  }) {
    final result = tryCreate(
      serviceCategory: serviceCategory,
      serviceName: serviceName,
      description: description,
      basePrice: basePrice,
      currencyCode: currencyCode,
      coverageAreas: coverageAreas,
      onSite: onSite,
      mobileService: mobileService,
      slaHours: slaHours,
      warrantyDays: warrantyDays,
    );

    if (result.isFailure) {
      throw ArgumentError(
        result.errors.map((e) => e.toString()).join('; '),
      );
    }

    return result.value;
  }

  // Comentarios en el código: fábrica sin lanzamiento que valida con VOs y devuelve Result con lista completa de errores.
  static CreationResult<ServiceOfferPayload> tryCreate({
    String? serviceCategory,
    required String serviceName,
    String? description,
    int? basePrice,
    String? currencyCode,
    List<String> coverageAreas = const [],
    bool onSite = false,
    bool mobileService = false,
    int? slaHours,
    int? warrantyDays,
  }) {
    final errors = <ValidationError>[];

    final normCategory = serviceCategory?.trim();
    final normName = serviceName.trim();
    final normDesc = description?.trim();
    final normCurrency = currencyCode?.trim().toUpperCase();

    ServiceCategory? enumCategory;
    if (normCategory != null && normCategory.isNotEmpty) {
      enumCategory = ServiceCategoryWire.fromWire(normCategory);
    }

    if (normName.isEmpty) {
      errors.add(const ValidationError('serviceName', 'No puede estar vacío'));
    } else if (normName.length > 200) {
      errors.add(const ValidationError(
          'serviceName', 'No puede exceder 200 caracteres'));
    }

    if (normDesc != null && normDesc.length > 2000) {
      errors.add(const ValidationError(
          'description', 'No puede exceder 2000 caracteres'));
    }

    if (basePrice != null && basePrice < 0) {
      errors.add(const ValidationError('basePrice', 'No puede ser negativo'));
    }

    CurrencyCode? currency;
    if (basePrice != null && basePrice > 0) {
      if (normCurrency == null || normCurrency.isEmpty) {
        errors.add(const ValidationError(
            'currencyCode', 'Requerido cuando se especifica basePrice'));
      } else {
        try {
          currency = CurrencyCode(normCurrency);
        } catch (e) {
          errors.add(ValidationError('currencyCode', e.toString()));
        }
      }
    } else if (normCurrency != null && normCurrency.isNotEmpty) {
      try {
        currency = CurrencyCode(normCurrency);
      } catch (e) {
        errors.add(ValidationError('currencyCode', e.toString()));
      }
    }

    CoverageAreaList? areas;
    try {
      areas = CoverageAreaList(coverageAreas);
    } catch (e) {
      errors.add(ValidationError('coverageAreas', e.toString()));
    }

    if (slaHours != null && slaHours < 0) {
      errors.add(const ValidationError('slaHours', 'No puede ser negativo'));
    }

    if (warrantyDays != null && warrantyDays < 0) {
      errors
          .add(const ValidationError('warrantyDays', 'No puede ser negativo'));
    }

    if (errors.isNotEmpty) {
      return CreationResult.failure(errors);
    }

    return CreationResult.success(
      ServiceOfferPayload._(
        serviceCategory: enumCategory?.wireName,
        serviceName: normName,
        description: normDesc,
        basePrice: basePrice,
        currencyCode: currency?.value,
        coverageAreas: areas!.values,
        onSite: onSite,
        mobileService: mobileService,
        slaHours: slaHours,
        warrantyDays: warrantyDays,
      ),
    );
  }

  // Comentarios en el código: parser robusto desde JSON con casteo seguro num→int y validación vía tryCreate.
  static ServiceOfferPayload fromJson(Map<String, Object?> json) {
    final basePriceVal = (json['basePrice'] as num?)?.toInt();
    final slaVal = (json['slaHours'] as num?)?.toInt();
    final warrantyVal = (json['warrantyDays'] as num?)?.toInt();

    final category = (json['serviceCategory'] as String?)?.trim();
    final name = (json['serviceName'] as String?)?.trim();
    final desc = (json['description'] as String?)?.trim();
    final currency = (json['currencyCode'] as String?)?.trim();

    final areas = (json['coverageAreas'] as List<dynamic>?)
            ?.map((e) => e.toString().trim())
            .where((s) => s.isNotEmpty && s.toLowerCase() != 'null')
            .toList() ??
        const <String>[];

    final site = json['onSite'] as bool? ?? false;
    final mobile = json['mobileService'] as bool? ?? false;

    final result = tryCreate(
      serviceCategory: category,
      serviceName: name ?? '',
      description: desc,
      basePrice: basePriceVal,
      currencyCode: currency,
      coverageAreas: areas,
      onSite: site,
      mobileService: mobile,
      slaHours: slaVal,
      warrantyDays: warrantyVal,
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
        'serviceCategory': serviceCategory,
        'serviceName': serviceName,
        'description': description,
        'basePrice': basePrice,
        'currencyCode': currencyCode,
        'coverageAreas': coverageAreas,
        'onSite': onSite,
        'mobileService': mobileService,
        'slaHours': slaHours,
        'warrantyDays': warrantyDays,
      };

  // Comentarios en el código: copy-with que pasa por create para revalidar con VOs.
  ServiceOfferPayload copyWith({
    String? serviceCategory,
    String? serviceName,
    String? description,
    int? basePrice,
    String? currencyCode,
    List<String>? coverageAreas,
    bool? onSite,
    bool? mobileService,
    int? slaHours,
    int? warrantyDays,
  }) {
    return ServiceOfferPayload.create(
      serviceCategory: serviceCategory ?? this.serviceCategory,
      serviceName: serviceName ?? this.serviceName,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      currencyCode: currencyCode ?? this.currencyCode,
      coverageAreas: coverageAreas ?? this.coverageAreas,
      onSite: onSite ?? this.onSite,
      mobileService: mobileService ?? this.mobileService,
      slaHours: slaHours ?? this.slaHours,
      warrantyDays: warrantyDays ?? this.warrantyDays,
    );
  }

  // Comentarios en el código: igualdad y hash con comparación orden-sensible de coverageAreas por diseño.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ServiceOfferPayload) return false;

    if (coverageAreas.length != other.coverageAreas.length) return false;
    for (int i = 0; i < coverageAreas.length; i++) {
      if (coverageAreas[i] != other.coverageAreas[i]) return false;
    }

    return serviceCategory == other.serviceCategory &&
        serviceName == other.serviceName &&
        description == other.description &&
        basePrice == other.basePrice &&
        currencyCode == other.currencyCode &&
        onSite == other.onSite &&
        mobileService == other.mobileService &&
        slaHours == other.slaHours &&
        warrantyDays == other.warrantyDays;
  }

  @override
  int get hashCode => Object.hash(
        serviceCategory,
        serviceName,
        description,
        basePrice,
        currencyCode,
        Object.hashAll(coverageAreas),
        onSite,
        mobileService,
        slaHours,
        warrantyDays,
      );

  @override
  String toString() => 'ServiceOfferPayload('
      'serviceCategory: $serviceCategory, '
      'serviceName: $serviceName, '
      'basePrice: ${basePrice != null ? '$basePrice $currencyCode' : 'cotizable'}, '
      'onSite: $onSite, '
      'mobile: $mobileService, '
      'areas: ${coverageAreas.length})';
}
