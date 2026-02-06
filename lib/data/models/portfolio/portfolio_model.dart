import 'package:isar_community/isar.dart' as isar;
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/portfolio/portfolio_entity.dart';

part 'portfolio_model.g.dart';

@isar.collection
@JsonSerializable(explicitToJson: true)
class PortfolioModel {
  /// Isar internal ID (auto-increment)
  isar.Id? isarId;

  /// String ID (domain ID, único, indexado)
  @isar.Index(unique: true, replace: true)
  final String id;

  @isar.Index()
  final String portfolioType; // 'VEHICULOS' | 'INMUEBLES'

  final String portfolioName;
  final String countryId;
  final String cityId;

  @isar.Index()
  final String status; // 'DRAFT' | 'ACTIVE'

  final int assetsCount;

  @isar.Index()
  final String createdBy;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  PortfolioModel({
    this.isarId,
    required this.id,
    required this.portfolioType,
    required this.portfolioName,
    required this.countryId,
    required this.cityId,
    required this.status,
    required this.assetsCount,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  /// Mapper: Model -> Entity
  PortfolioEntity toEntity() {
    return PortfolioEntity(
      id: id,
      portfolioType: _parsePortfolioType(portfolioType),
      portfolioName: portfolioName,
      countryId: countryId,
      cityId: cityId,
      status: _parsePortfolioStatus(status),
      assetsCount: assetsCount,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Mapper: Entity -> Model
  factory PortfolioModel.fromEntity(PortfolioEntity entity) {
    return PortfolioModel(
      id: entity.id,
      portfolioType: _serializePortfolioType(entity.portfolioType),
      portfolioName: entity.portfolioName,
      countryId: entity.countryId,
      cityId: entity.cityId,
      status: _serializePortfolioStatus(entity.status),
      assetsCount: entity.assetsCount,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt?.toUtc(),
      updatedAt: entity.updatedAt?.toUtc(),
    );
  }

  /// JSON serialization
  factory PortfolioModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioModelFromJson(json);

  Map<String, dynamic> toJson() => _$PortfolioModelToJson(this);

  // Helper parsers
  static PortfolioType _parsePortfolioType(String value) {
    switch (value) {
      case 'VEHICULOS':
        return PortfolioType.vehiculos;
      case 'INMUEBLES':
        return PortfolioType.inmuebles;
      case 'OPERACION_GENERAL':
        return PortfolioType.operacionGeneral;
      default:
        return PortfolioType.operacionGeneral;
    }
  }

  static String _serializePortfolioType(PortfolioType type) {
    switch (type) {
      case PortfolioType.vehiculos:
        return 'VEHICULOS';
      case PortfolioType.inmuebles:
        return 'INMUEBLES';
      case PortfolioType.operacionGeneral:
        return 'OPERACION_GENERAL';
    }
  }

  static PortfolioStatus _parsePortfolioStatus(String value) {
    switch (value) {
      case 'DRAFT':
        return PortfolioStatus.draft;
      case 'ACTIVE':
        return PortfolioStatus.active;
      default:
        return PortfolioStatus.draft;
    }
  }

  static String _serializePortfolioStatus(PortfolioStatus status) {
    switch (status) {
      case PortfolioStatus.draft:
        return 'DRAFT';
      case PortfolioStatus.active:
        return 'ACTIVE';
    }
  }
}
