// ============================================================================
// lib/domain/value/capability/provider_spec.dart
// ProviderSpec — spec de un CapabilityProfile con kind == provider
// ============================================================================
// QUÉ HACE:
//   - Describe la oferta operativa de un Workspace que actúa como proveedor:
//     tipo de oferta (artículos | servicios), mercado primario al que aplica
//     y categoría de negocio (FK a taxonomía externa).
//   - Tipado fuerte: ningún string libre en campos de catálogo cerrado.
//   - Inmutable, comparable por valor, serializable.
//
// QUÉ NO HACE:
//   - NO valida la existencia del businessCategoryId en el taxonomy externo;
//     eso es responsabilidad de la capa que consulte la taxonomía.
//   - NO modela cobertura geográfica ni assetTypeIds; esos campos viven en
//     CapabilityProfile (común a todos los kinds).
// ============================================================================

import '../../shared/enums/asset_type.dart';
import 'provider_type.dart';
import 'refs/business_category_ref.dart';

class ProviderSpec {
  /// Tipo de oferta: artículos (productos) o servicios (mano de obra).
  final ProviderType providerType;

  /// Mercado primario al que aplica la oferta. Null = sin mercado declarado
  /// (oferta transversal). Cuando se declara, debe ser uno de los tipos
  /// canónicos de activo soportados por la plataforma.
  final AssetRegistrationType? market;

  /// FK opcional a la taxonomía externa de business categories. Es un
  /// value object tipado con validación sintáctica garantizada en
  /// construcción; la validación de existencia contra el catálogo se hace
  /// vía BusinessCategoryRegistry en boundary, no aquí.
  final BusinessCategoryRef? businessCategoryRef;

  const ProviderSpec({
    required this.providerType,
    this.market,
    this.businessCategoryRef,
  });

  ProviderSpec copyWith({
    ProviderType? providerType,
    AssetRegistrationType? market,
    BusinessCategoryRef? businessCategoryRef,
  }) =>
      ProviderSpec(
        providerType: providerType ?? this.providerType,
        market: market ?? this.market,
        businessCategoryRef: businessCategoryRef ?? this.businessCategoryRef,
      );

  Map<String, dynamic> toJson() => {
        'providerType': providerType.wireName,
        if (market != null) 'market': market!.wireName,
        if (businessCategoryRef != null)
          'businessCategoryId': businessCategoryRef!.toJson(),
      };

  factory ProviderSpec.fromJson(Map<String, dynamic> json) {
    final providerTypeRaw = json['providerType'];
    if (providerTypeRaw is! String) {
      throw ArgumentError(
        'ProviderSpec.fromJson: providerType requerido (String wire name)',
      );
    }
    final marketRaw = json['market'];
    final categoryRaw = json['businessCategoryId'];
    return ProviderSpec(
      providerType: ProviderTypeX.fromWire(providerTypeRaw),
      market: marketRaw is String
          ? AssetRegistrationTypeWire.fromWire(marketRaw)
          : null,
      businessCategoryRef: categoryRaw is String
          ? BusinessCategoryRef.fromJson(categoryRaw)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProviderSpec &&
          other.providerType == providerType &&
          other.market == market &&
          other.businessCategoryRef == businessCategoryRef);

  @override
  int get hashCode => Object.hash(providerType, market, businessCategoryRef);

  @override
  String toString() =>
      'ProviderSpec(providerType: ${providerType.wireName}, '
      'market: ${market?.wireName}, '
      'businessCategoryRef: $businessCategoryRef)';
}
