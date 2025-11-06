// lib/domain/publications/entities/payloads/product_offer_payload.dart
// Payload específico para publicaciones tipo PRODUCT_OFFER (proveedor ofrece productos).
// Dominio puro: solo dart:core. Sin async, sin Flutter, sin DS.

import 'package:avanzza/domain/shared/shared.dart';

// ══════════════════════════════════════════════════════════════════════════════
// ENTIDAD PRINCIPAL
// ══════════════════════════════════════════════════════════════════════════════

// Comentarios en el código: entidad inmutable para oferta de productos con validación fuerte y superficie pública compatible con JSON.
class ProductOfferPayload {
  final String? productCategory;
  final String productName;
  final String? description;
  final String? condition;
  final int unitPrice;
  final String currencyCode;
  final int stockQuantity;
  final List<String> coverageAreas;
  final bool offersDelivery;
  final int? warrantyMonths;
  final String? brand;
  final String? model;

  ProductOfferPayload._({
    this.productCategory,
    required this.productName,
    this.description,
    this.condition,
    required this.unitPrice,
    required this.currencyCode,
    required this.stockQuantity,
    required List<String> coverageAreas,
    this.offersDelivery = false,
    this.warrantyMonths,
    this.brand,
    this.model,
  }) : coverageAreas = List.unmodifiable(coverageAreas);

  // Comentarios en el código: helpers públicos que calculan derivados desde campos normalizados.
  bool get hasWarranty => warrantyMonths != null && warrantyMonths! > 0;

  bool coverageIncludes(String area) {
    final norm = area.trim().toLowerCase();
    return coverageAreas.any((c) => c.toLowerCase() == norm);
  }

  // Comentarios en el código: fábrica que delega en tryCreate y lanza ArgumentError con errores acumulados.
  factory ProductOfferPayload.create({
    String? productCategory,
    required String productName,
    String? description,
    String? condition,
    required int unitPrice,
    required String currencyCode,
    required int stockQuantity,
    List<String> coverageAreas = const [],
    bool offersDelivery = false,
    int? warrantyMonths,
    String? brand,
    String? model,
  }) {
    final result = tryCreate(
      productCategory: productCategory,
      productName: productName,
      description: description,
      condition: condition,
      unitPrice: unitPrice,
      currencyCode: currencyCode,
      stockQuantity: stockQuantity,
      coverageAreas: coverageAreas,
      offersDelivery: offersDelivery,
      warrantyMonths: warrantyMonths,
      brand: brand,
      model: model,
    );

    if (result.isFailure) {
      throw ArgumentError(
        result.errors.map((e) => e.toString()).join('; '),
      );
    }

    return result.value;
  }

  // Comentarios en el código: fábrica sin lanzamiento que valida con VOs y devuelve Result con lista completa de errores.
  static CreationResult<ProductOfferPayload> tryCreate({
    String? productCategory,
    required String productName,
    String? description,
    String? condition,
    required int unitPrice,
    required String currencyCode,
    required int stockQuantity,
    List<String> coverageAreas = const [],
    bool offersDelivery = false,
    int? warrantyMonths,
    String? brand,
    String? model,
  }) {
    final errors = <ValidationError>[];

    final normCategory = productCategory?.trim();
    final normName = productName.trim();
    final normDesc = description?.trim();
    final normCondition = condition?.trim();
    final normCurrency = currencyCode.trim().toUpperCase();
    final normBrand = brand?.trim();
    final normModel = model?.trim();

    ProductCategory? enumCategory;
    if (normCategory != null && normCategory.isNotEmpty) {
      enumCategory = ProductCategoryWire.fromWire(normCategory);
    }

    ProductCondition? enumCondition;
    if (normCondition != null && normCondition.isNotEmpty) {
      enumCondition = ProductConditionWire.fromWire(normCondition);
    }

    if (normName.isEmpty) {
      errors.add(const ValidationError('productName', 'No puede estar vacío'));
    } else if (normName.length > 200) {
      errors.add(const ValidationError(
          'productName', 'No puede exceder 200 caracteres'));
    }

    if (normDesc != null && normDesc.length > 2000) {
      errors.add(const ValidationError(
          'description', 'No puede exceder 2000 caracteres'));
    }

    if (unitPrice < 0) {
      errors.add(const ValidationError('unitPrice', 'No puede ser negativo'));
    }

    CurrencyCode? currency;
    try {
      currency = CurrencyCode(normCurrency);
    } catch (e) {
      errors.add(ValidationError('currencyCode', e.toString()));
    }

    if (stockQuantity < 0) {
      errors
          .add(const ValidationError('stockQuantity', 'No puede ser negativo'));
    }

    CoverageAreaList? areas;
    try {
      areas = CoverageAreaList(coverageAreas);
    } catch (e) {
      errors.add(ValidationError('coverageAreas', e.toString()));
    }

    if (warrantyMonths != null && warrantyMonths < 0) {
      errors.add(
          const ValidationError('warrantyMonths', 'No puede ser negativo'));
    }

    if (normBrand != null && normBrand.length > 100) {
      errors.add(
          const ValidationError('brand', 'No puede exceder 100 caracteres'));
    }

    if (normModel != null && normModel.length > 100) {
      errors.add(
          const ValidationError('model', 'No puede exceder 100 caracteres'));
    }

    if (errors.isNotEmpty) {
      return CreationResult.failure(errors);
    }

    return CreationResult.success(
      ProductOfferPayload._(
        productCategory: enumCategory?.wireName,
        productName: normName,
        description: normDesc,
        condition: enumCondition?.wireName,
        unitPrice: unitPrice,
        currencyCode: currency!.value,
        stockQuantity: stockQuantity,
        coverageAreas: areas!.values,
        offersDelivery: offersDelivery,
        warrantyMonths: warrantyMonths,
        brand: normBrand,
        model: normModel,
      ),
    );
  }

  // Comentarios en el código: parser robusto desde JSON con casteo seguro num→int y validación vía tryCreate.
  static ProductOfferPayload fromJson(Map<String, Object?> json) {
    final unitPriceVal = (json['unitPrice'] as num?)?.toInt();
    final stockVal = (json['stockQuantity'] as num?)?.toInt();
    final warrantyVal = (json['warrantyMonths'] as num?)?.toInt();

    final category = (json['productCategory'] as String?)?.trim();
    final name = (json['productName'] as String?)?.trim();
    final desc = (json['description'] as String?)?.trim();
    final cond = (json['condition'] as String?)?.trim();
    final currency = (json['currencyCode'] as String?)?.trim();
    final brandVal = (json['brand'] as String?)?.trim();
    final modelVal = (json['model'] as String?)?.trim();

    final areas = (json['coverageAreas'] as List<dynamic>?)
            ?.map((e) => e.toString().trim())
            .where((s) => s.isNotEmpty && s.toLowerCase() != 'null')
            .toList() ??
        const <String>[];

    final delivery = json['offersDelivery'] as bool? ?? false;

    final result = tryCreate(
      productCategory: category,
      productName: name ?? '',
      description: desc,
      condition: cond,
      unitPrice: unitPriceVal ?? 0,
      currencyCode: currency ?? '',
      stockQuantity: stockVal ?? 0,
      coverageAreas: areas,
      offersDelivery: delivery,
      warrantyMonths: warrantyVal,
      brand: brandVal,
      model: modelVal,
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
        'productCategory': productCategory,
        'productName': productName,
        'description': description,
        'condition': condition,
        'unitPrice': unitPrice,
        'currencyCode': currencyCode,
        'stockQuantity': stockQuantity,
        'coverageAreas': coverageAreas,
        'offersDelivery': offersDelivery,
        'warrantyMonths': warrantyMonths,
        'brand': brand,
        'model': model,
      };

  // Comentarios en el código: copy-with que pasa por create para revalidar con VOs.
  ProductOfferPayload copyWith({
    String? productCategory,
    String? productName,
    String? description,
    String? condition,
    int? unitPrice,
    String? currencyCode,
    int? stockQuantity,
    List<String>? coverageAreas,
    bool? offersDelivery,
    int? warrantyMonths,
    String? brand,
    String? model,
  }) {
    return ProductOfferPayload.create(
      productCategory: productCategory ?? this.productCategory,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      unitPrice: unitPrice ?? this.unitPrice,
      currencyCode: currencyCode ?? this.currencyCode,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      coverageAreas: coverageAreas ?? this.coverageAreas,
      offersDelivery: offersDelivery ?? this.offersDelivery,
      warrantyMonths: warrantyMonths ?? this.warrantyMonths,
      brand: brand ?? this.brand,
      model: model ?? this.model,
    );
  }

  // Comentarios en el código: igualdad y hash con comparación orden-sensible de coverageAreas por diseño.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductOfferPayload) return false;

    if (coverageAreas.length != other.coverageAreas.length) return false;
    for (int i = 0; i < coverageAreas.length; i++) {
      if (coverageAreas[i] != other.coverageAreas[i]) return false;
    }

    return productCategory == other.productCategory &&
        productName == other.productName &&
        description == other.description &&
        condition == other.condition &&
        unitPrice == other.unitPrice &&
        currencyCode == other.currencyCode &&
        stockQuantity == other.stockQuantity &&
        offersDelivery == other.offersDelivery &&
        warrantyMonths == other.warrantyMonths &&
        brand == other.brand &&
        model == other.model;
  }

  @override
  int get hashCode => Object.hash(
        productCategory,
        productName,
        description,
        condition,
        unitPrice,
        currencyCode,
        stockQuantity,
        Object.hashAll(coverageAreas),
        offersDelivery,
        warrantyMonths,
        brand,
        model,
      );

  @override
  String toString() => 'ProductOfferPayload('
      'productCategory: $productCategory, '
      'productName: $productName, '
      'condition: $condition, '
      'unitPrice: $unitPrice $currencyCode, '
      'stock: $stockQuantity, '
      'areas: ${coverageAreas.length}, '
      'warranty: $warrantyMonths months)';
}
