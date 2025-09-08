import 'package:avanzza/core/utils/datetime_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'broadcast_message_entity.freezed.dart';
part 'broadcast_message_entity.g.dart';

@freezed
abstract class BroadcastMessageEntity with _$BroadcastMessageEntity {
  const factory BroadcastMessageEntity({
    required String id,
    required String adminId,
    required String orgId,
    String? rolObjetivo,
    required String message,
    required DateTime timestamp,
    String? countryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BroadcastMessageEntity;

  factory BroadcastMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$BroadcastMessageEntityFromJson(json);
}
