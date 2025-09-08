import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/accounting/adjustment_entity.dart' as domain;

part 'adjustment_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class AdjustmentModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String entryId;
  final String tipo;
  final double valor;
  final String motivo;
  @DateTimeTimestampConverter()
  final DateTime? createdAt;
  @DateTimeTimestampConverter()
  final DateTime? updatedAt;

  AdjustmentModel({
    this.isarId,
    required this.id,
    required this.entryId,
    required this.tipo,
    required this.valor,
    required this.motivo,
    this.createdAt,
    this.updatedAt,
  });

  factory AdjustmentModel.fromJson(Map<String, dynamic> json) =>
      _$AdjustmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$AdjustmentModelToJson(this);
  factory AdjustmentModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      AdjustmentModel.fromJson({...json, 'id': docId});

  factory AdjustmentModel.fromEntity(domain.AdjustmentEntity e) =>
      AdjustmentModel(
        id: e.id,
        entryId: e.entryId,
        tipo: e.tipo,
        valor: e.valor,
        motivo: e.motivo,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.AdjustmentEntity toEntity() => domain.AdjustmentEntity(
        id: id,
        entryId: entryId,
        tipo: tipo,
        valor: valor,
        motivo: motivo,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
