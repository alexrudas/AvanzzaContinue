// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_outbox_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncOutboxEntry _$SyncOutboxEntryFromJson(Map<String, dynamic> json) =>
    _SyncOutboxEntry(
      id: json['id'] as String,
      idempotencyKey: json['idempotencyKey'] as String,
      partitionKey: json['partitionKey'] as String,
      operationType:
          $enumDecode(_$SyncOperationTypeEnumMap, json['operationType']),
      entityType: $enumDecode(_$SyncEntityTypeEnumMap, json['entityType']),
      entityId: json['entityId'] as String,
      firestorePath: json['firestorePath'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
      status: $enumDecodeNullable(_$SyncStatusEnumMap, json['status']) ??
          SyncStatus.pending,
      retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
      maxRetries: (json['maxRetries'] as num?)?.toInt() ?? 6,
      nextAttemptAt:
          const SafeDateTimeNullableConverter().fromJson(json['nextAttemptAt']),
      lastError: json['lastError'] as String?,
      lastErrorCode:
          $enumDecodeNullable(_$SyncErrorCodeEnumMap, json['lastErrorCode']),
      lastHttpStatus: (json['lastHttpStatus'] as num?)?.toInt(),
      lockToken: json['lockToken'] as String?,
      lockedUntil:
          const SafeDateTimeNullableConverter().fromJson(json['lockedUntil']),
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
      'idempotencyKey': instance.idempotencyKey,
      'partitionKey': instance.partitionKey,
      'operationType': _$SyncOperationTypeEnumMap[instance.operationType]!,
      'entityType': _$SyncEntityTypeEnumMap[instance.entityType]!,
      'entityId': instance.entityId,
      'firestorePath': instance.firestorePath,
      'payload': instance.payload,
      'schemaVersion': instance.schemaVersion,
      'status': _$SyncStatusEnumMap[instance.status]!,
      'retryCount': instance.retryCount,
      'maxRetries': instance.maxRetries,
      'nextAttemptAt':
          const SafeDateTimeNullableConverter().toJson(instance.nextAttemptAt),
      'lastError': instance.lastError,
      'lastErrorCode': _$SyncErrorCodeEnumMap[instance.lastErrorCode],
      'lastHttpStatus': instance.lastHttpStatus,
      'lockToken': instance.lockToken,
      'lockedUntil':
          const SafeDateTimeNullableConverter().toJson(instance.lockedUntil),
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

const _$SyncErrorCodeEnumMap = {
  SyncErrorCode.networkUnavailable: 'NETWORK_UNAVAILABLE',
  SyncErrorCode.networkTimeout: 'NETWORK_TIMEOUT',
  SyncErrorCode.dnsFailure: 'DNS_FAILURE',
  SyncErrorCode.tlsFailure: 'TLS_FAILURE',
  SyncErrorCode.http429RateLimit: 'HTTP_429_RATE_LIMIT',
  SyncErrorCode.http500ServerError: 'HTTP_500_SERVER_ERROR',
  SyncErrorCode.http502BadGateway: 'HTTP_502_BAD_GATEWAY',
  SyncErrorCode.http503ServiceUnavailable: 'HTTP_503_SERVICE_UNAVAILABLE',
  SyncErrorCode.http504GatewayTimeout: 'HTTP_504_GATEWAY_TIMEOUT',
  SyncErrorCode.auth401Unauthorized: 'AUTH_401_UNAUTHORIZED',
  SyncErrorCode.authRefreshFailed: 'AUTH_REFRESH_FAILED',
  SyncErrorCode.http400BadRequest: 'HTTP_400_BAD_REQUEST',
  SyncErrorCode.http403Forbidden: 'HTTP_403_FORBIDDEN',
  SyncErrorCode.http404NotFound: 'HTTP_404_NOT_FOUND',
  SyncErrorCode.http409Conflict: 'HTTP_409_CONFLICT',
  SyncErrorCode.http422Validation: 'HTTP_422_VALIDATION',
  SyncErrorCode.schemaMismatch: 'SCHEMA_MISMATCH',
  SyncErrorCode.unknown: 'UNKNOWN',
};
