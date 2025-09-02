import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/geo/local_regulation_entity.dart' as domain;

part 'local_regulation_model.g.dart';

@embedded
@JsonSerializable(explicitToJson: true)
class PicoYPlacaRuleModel {
  int? dayOfWeek;
  List<String>? digitsRestricted;
  String? startTime;
  String? endTime;
  String? notes;

  PicoYPlacaRuleModel({
    this.dayOfWeek,
    this.digitsRestricted,
    this.startTime,
    this.endTime,
    this.notes,
  });

  factory PicoYPlacaRuleModel.fromJson(Map<String, dynamic> json) =>
      _$PicoYPlacaRuleModelFromJson(json);
  Map<String, dynamic> toJson() => _$PicoYPlacaRuleModelToJson(this);

  factory PicoYPlacaRuleModel.fromEntity(domain.PicoYPlacaRule e) =>
      PicoYPlacaRuleModel(
        dayOfWeek: e.dayOfWeek,
        digitsRestricted: e.digitsRestricted,
        startTime: e.startTime,
        endTime: e.endTime,
        notes: e.notes,
      );

  domain.PicoYPlacaRule toEntity() => domain.PicoYPlacaRule(
        dayOfWeek: dayOfWeek ?? 1,
        digitsRestricted: digitsRestricted ?? const [],
        startTime: startTime ?? '',
        endTime: endTime ?? '',
        notes: notes,
      );
}

@Collection()
@JsonSerializable(explicitToJson: true)
class LocalRegulationModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  String id;
  @Index()
  String countryId;
  @Index()
  String cityId;

  List<PicoYPlacaRuleModel>? picoYPlacaRules;
  List<String>? circulationExceptions;
  List<String>? maintenanceBlackoutDates;

  String updatedBy;
  String? sourceUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  LocalRegulationModel({
    this.isarId,
    required this.id,
    required this.countryId,
    required this.cityId,
    this.picoYPlacaRules,
    this.circulationExceptions,
    this.maintenanceBlackoutDates,
    required this.updatedBy,
    this.sourceUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory LocalRegulationModel.fromJson(Map<String, dynamic> json) =>
      _$LocalRegulationModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocalRegulationModelToJson(this);

  factory LocalRegulationModel.fromFirestore(
    String docId,
    Map<String, dynamic> json,
  ) =>
      LocalRegulationModel.fromJson({...json, 'id': docId});

  factory LocalRegulationModel.fromEntity(domain.LocalRegulationEntity e) =>
      LocalRegulationModel(
        id: e.id,
        countryId: e.countryId,
        cityId: e.cityId,
        picoYPlacaRules:
            e.picoYPlacaRules.map(PicoYPlacaRuleModel.fromEntity).toList(),
        circulationExceptions: e.circulationExceptions,
        maintenanceBlackoutDates: e.maintenanceBlackoutDates,
        updatedBy: e.updatedBy,
        sourceUrl: e.sourceUrl,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.LocalRegulationEntity toEntity() => domain.LocalRegulationEntity(
        id: id,
        countryId: countryId,
        cityId: cityId,
        picoYPlacaRules:
            (picoYPlacaRules ?? const []).map((e) => e.toEntity()).toList(),
        circulationExceptions: circulationExceptions ?? const [],
        maintenanceBlackoutDates: maintenanceBlackoutDates ?? const [],
        updatedBy: updatedBy,
        sourceUrl: sourceUrl,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
