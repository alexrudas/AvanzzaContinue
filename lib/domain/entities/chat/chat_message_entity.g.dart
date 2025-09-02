// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessageEntity _$ChatMessageEntityFromJson(Map<String, dynamic> json) =>
    _ChatMessageEntity(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String?,
      groupId: json['groupId'] as String?,
      message: json['message'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      timestamp: DateTime.parse(json['timestamp'] as String),
      orgId: json['orgId'] as String?,
      cityId: json['cityId'] as String?,
      assetId: json['assetId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ChatMessageEntityToJson(_ChatMessageEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'groupId': instance.groupId,
      'message': instance.message,
      'attachments': instance.attachments,
      'timestamp': instance.timestamp.toIso8601String(),
      'orgId': instance.orgId,
      'cityId': instance.cityId,
      'assetId': instance.assetId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
