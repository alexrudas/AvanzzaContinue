import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_entity.freezed.dart';
part 'chat_message_entity.g.dart';

@freezed
abstract class ChatMessageEntity with _$ChatMessageEntity {
  const factory ChatMessageEntity({
    required String id,
    required String chatId,
    required String senderId,
    String? receiverId,
    String? groupId,
    required String message,
    @Default(<String>[]) List<String> attachments,
    required DateTime timestamp,
    String? orgId,
    String? cityId,
    String? assetId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ChatMessageEntity;

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageEntityFromJson(json);
}
