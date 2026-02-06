// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetSnapshot _$AssetSnapshotFromJson(Map<String, dynamic> json) =>
    _AssetSnapshot(
      id: json['id'] as String,
      assetId: json['assetId'] as String?,
      source: $enumDecode(_$SnapshotSourceEnumMap, json['source']),
      payloadRaw: json['payloadRaw'] as Map<String, dynamic>,
      payloadNormalized: json['payloadNormalized'] as Map<String, dynamic>,
      schemaVersion: json['schemaVersion'] as String? ?? '1.0',
      fetchedAt:
          const SafeDateTimeConverter().fromJson(json['fetchedAt'] as Object),
      hash: json['hash'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );

Map<String, dynamic> _$AssetSnapshotToJson(_AssetSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assetId': instance.assetId,
      'source': _$SnapshotSourceEnumMap[instance.source]!,
      'payloadRaw': instance.payloadRaw,
      'payloadNormalized': instance.payloadNormalized,
      'schemaVersion': instance.schemaVersion,
      'fetchedAt': const SafeDateTimeConverter().toJson(instance.fetchedAt),
      'hash': instance.hash,
      'metadata': instance.metadata,
    };

const _$SnapshotSourceEnumMap = {
  SnapshotSource.runt: 'RUNT',
  SnapshotSource.catastro: 'CATASTRO',
  SnapshotSource.manual: 'MANUAL',
  SnapshotSource.apiExterna: 'API_EXTERNA',
  SnapshotSource.import_: 'IMPORT',
};
