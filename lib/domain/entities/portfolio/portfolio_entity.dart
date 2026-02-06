import 'package:freezed_annotation/freezed_annotation.dart';

part 'portfolio_entity.freezed.dart';
part 'portfolio_entity.g.dart';

/// Estado del portafolio
/// - DRAFT: Recién creado, sin activos (no aparece en Home)
/// - ACTIVE: Con al menos 1 activo (aparece en Home)
enum PortfolioStatus {
  @JsonValue('DRAFT')
  draft,
  @JsonValue('ACTIVE')
  active,
}

/// Tipo de portafolio
enum PortfolioType {
  @JsonValue('VEHICULOS')
  vehiculos,
  @JsonValue('INMUEBLES')
  inmuebles,
  @JsonValue('OPERACION_GENERAL')
  operacionGeneral,
}

/// Entidad de Portafolio
/// Agrupa activos del mismo tipo bajo un contenedor lógico
@freezed
abstract class PortfolioEntity with _$PortfolioEntity {
  const factory PortfolioEntity({
    required String id,
    required PortfolioType portfolioType,
    required String portfolioName,
    required String countryId,
    required String cityId,
    @Default(PortfolioStatus.draft) PortfolioStatus status,
    @Default(0) int assetsCount,
    required String createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PortfolioEntity;

  factory PortfolioEntity.fromJson(Map<String, dynamic> json) =>
      _$PortfolioEntityFromJson(json);
}
