import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/chat/chat_message_entity.dart' as domain;

part 'chat_message_model.g.dart';

@Collection()
@JsonSerializable(explicitToJson: true)
class ChatMessageModel {
  Id? isarId;

  @Index(unique: true, replace: true)
  final String id;
  @Index()
  final String chatId;
  @Index()
  final String senderId;
  final String? receiverId;
  @Index()
  final String? groupId;
  final String message;
  final List<String> attachments;
  @Index()
  final DateTime timestamp;
  @Index()
  final String? orgId;
  @Index()
  final String? cityId;
  @Index()
  final String? assetId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatMessageModel({
    this.isarId,
    required this.id,
    required this.chatId,
    required this.senderId,
    this.receiverId,
    this.groupId,
    required this.message,
    this.attachments = const [],
    required this.timestamp,
    this.orgId,
    this.cityId,
    this.assetId,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
  factory ChatMessageModel.fromFirestore(
          String docId, Map<String, dynamic> json) =>
      ChatMessageModel.fromJson({...json, 'id': docId});

  factory ChatMessageModel.fromEntity(domain.ChatMessageEntity e) =>
      ChatMessageModel(
        id: e.id,
        chatId: e.chatId,
        senderId: e.senderId,
        receiverId: e.receiverId,
        groupId: e.groupId,
        message: e.message,
        attachments: e.attachments,
        timestamp: e.timestamp,
        orgId: e.orgId,
        cityId: e.cityId,
        assetId: e.assetId,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
      );

  domain.ChatMessageEntity toEntity() => domain.ChatMessageEntity(
        id: id,
        chatId: chatId,
        senderId: senderId,
        receiverId: receiverId,
        groupId: groupId,
        message: message,
        attachments: attachments,
        timestamp: timestamp,
        orgId: orgId,
        cityId: cityId,
        assetId: assetId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
