// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_outbox_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncOutboxEntry _$SyncOutboxEntryFromJson(Map<String, dynamic> json) =>
    _SyncOutboxEntry(
      id: json['id'] as String,
      operationType:
          $enumDecode(_$SyncOperationTypeEnumMap, json['operationType']),
      entityType: $enumDecode(_$SyncEntityTypeEnumMap, json['entityType']),
      entityId: json['entityId'] as String,
      firestorePath: json['firestorePath'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      status: $enumDecodeNullable(_$SyncStatusEnumMap, json['status']) ??
          SyncStatus.pending,
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      maxRetries: (json['maxRetries'] as num?)?.toInt() ?? 5,
      lastError: json['lastError'] as String?,
      createdAt:
          const SafeDateTimeConverter().fromJson(json['createdAt'] as Object),
      lastAttemptAt:
          const SafeDateTimeNullableConverter().fromJson(json['lastAttemptAt']),
      completedAt:
          const SafeDateTimeNullableConverter().fromJson(json['completedAt']),
      metadata: json['metadata'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );

Map<String, dynamic> _$SyncOutboxEntryToJson(_SyncOutboxEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'operationType': _$SyncOperationTypeEnumMap[instance.operationType]!,
      'entityType': _$SyncEntityTypeEnumMap[instance.entityType]!,
      'entityId': instance.entityId,
      'firestorePath': instance.firestorePath,
      'payload': instance.payload,
      'status': _$SyncStatusEnumMap[instance.status]!,
      'retryCount': instance.retryCount,
      'maxRetries': instance.maxRetries,
      'lastError': instance.lastError,
      'createdAt': const SafeDateTimeConverter().toJson(instance.createdAt),
      'lastAttemptAt':
          const SafeDateTimeNullableConverter().toJson(instance.lastAttemptAt),
      'completedAt':
          const SafeDateTimeNullableConverter().toJson(instance.completedAt),
      'metadata': instance.metadata,
    };

const _$SyncOperationTypeEnumMap = {
  SyncOperationType.create: 'CREATE',
  SyncOperationType.update: 'UPDATE',
  SyncOperationType.delete: 'DELETE',
  SyncOperationType.batch: 'BATCH',
};

const _$SyncEntityTypeEnumMap = {
  SyncEntityType.asset: 'ASSET',
  SyncEntityType.assetDraft: 'ASSET_DRAFT',
  SyncEntityType.auditLog: 'AUDIT_LOG',
  SyncEntityType.userAssetRef: 'USER_ASSET_REF',
  SyncEntityType.portfolio: 'PORTFOLIO',
};

const _$SyncStatusEnumMap = {
  SyncStatus.pending: 'PENDING',
  SyncStatus.inProgress: 'IN_PROGRESS',
  SyncStatus.completed: 'COMPLETED',
  SyncStatus.failed: 'FAILED',
  SyncStatus.deadLetter: 'DEAD_LETTER',
};
