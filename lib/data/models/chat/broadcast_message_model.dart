import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/chat/broadcast_message_entity.dart' as domain;

part 'broadcast_message_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class BroadcastMessageModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String adminId;
  @Index()
  final String orgId;
  @Index()
  final String? rolObjetivo;
  final String message;
  @Index()
  final DateTime timestamp;
  @Index()
  final String? countryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BroadcastMessageModel({
    this.isarId,
    required this.id,
    required this.adminId,
    required this.orgId,
    this.rolObjetivo,
    required this.message,
    required this.timestamp,
    this.countryId,
    this.createdAt,
    this.updatedAt,
  });

  factory BroadcastMessageModel.fromJson(Map<String, dynamic> json) =>
      _$BroadcastMessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$BroadcastMessageModelToJson(this);
  factory BroadcastMessageModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      BroadcastMessageModel.fromJson({...json, 'id': docId});

  factory BroadcastMessageModel.fromEntity(domain.BroadcastMessageEntity e) =>
      BroadcastMessageModel(
        id: e.id,
        adminId: e.adminId,
        orgId: e.orgId,
        rolObjetivo: e.rolObjetivo,
        message: e.message,
        timestamp: e.timestamp,
        countryId: e.countryId,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.BroadcastMessageEntity toEntity() => domain.BroadcastMessageEntity(
        id: id,
        adminId: adminId,
        orgId: orgId,
        rolObjetivo: rolObjetivo,
        message: message,
        timestamp: timestamp,
        countryId: countryId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
