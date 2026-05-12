// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_actor_cache_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNetworkActorCacheModelCollection on Isar {
  IsarCollection<NetworkActorCacheModel> get networkActorCacheModels =>
      this.collection();
}

const NetworkActorCacheModelSchema = CollectionSchema(
  name: r'NetworkActorCacheModel',
  id: 4570950697312310235,
  properties: {
    r'actorRefId': PropertySchema(
      id: 0,
      name: r'actorRefId',
      type: IsarType.string,
    ),
    r'actorRefKind': PropertySchema(
      id: 1,
      name: r'actorRefKind',
      type: IsarType.string,
    ),
    r'actorRefRaw': PropertySchema(
      id: 2,
      name: r'actorRefRaw',
      type: IsarType.string,
    ),
    r'categoriesAllKeys': PropertySchema(
      id: 3,
      name: r'categoriesAllKeys',
      type: IsarType.stringList,
    ),
    r'clientGeneratedId': PropertySchema(
      id: 4,
      name: r'clientGeneratedId',
      type: IsarType.string,
    ),
    r'compositeKey': PropertySchema(
      id: 5,
      name: r'compositeKey',
      type: IsarType.string,
    ),
    r'displayName': PropertySchema(
      id: 6,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'displayNameNormalized': PropertySchema(
      id: 7,
      name: r'displayNameNormalized',
      type: IsarType.string,
    ),
    r'failedSyncReason': PropertySchema(
      id: 8,
      name: r'failedSyncReason',
      type: IsarType.string,
    ),
    r'isRestricted': PropertySchema(
      id: 9,
      name: r'isRestricted',
      type: IsarType.bool,
    ),
    r'lastSeenAt': PropertySchema(
      id: 10,
      name: r'lastSeenAt',
      type: IsarType.dateTime,
    ),
    r'missingInLastSync': PropertySchema(
      id: 11,
      name: r'missingInLastSync',
      type: IsarType.bool,
    ),
    r'primaryCategoryKey': PropertySchema(
      id: 12,
      name: r'primaryCategoryKey',
      type: IsarType.string,
    ),
    r'projectionJson': PropertySchema(
      id: 13,
      name: r'projectionJson',
      type: IsarType.string,
    ),
    r'projectionSchemaVersion': PropertySchema(
      id: 14,
      name: r'projectionSchemaVersion',
      type: IsarType.long,
    ),
    r'providerProfileId': PropertySchema(
      id: 15,
      name: r'providerProfileId',
      type: IsarType.string,
    ),
    r'relationshipState': PropertySchema(
      id: 16,
      name: r'relationshipState',
      type: IsarType.string,
    ),
    r'serverConfirmedAt': PropertySchema(
      id: 17,
      name: r'serverConfirmedAt',
      type: IsarType.dateTime,
    ),
    r'source': PropertySchema(
      id: 18,
      name: r'source',
      type: IsarType.string,
      enumMap: _NetworkActorCacheModelsourceEnumValueMap,
    ),
    r'syncState': PropertySchema(
      id: 19,
      name: r'syncState',
      type: IsarType.string,
      enumMap: _NetworkActorCacheModelsyncStateEnumValueMap,
    ),
    r'syncedAt': PropertySchema(
      id: 20,
      name: r'syncedAt',
      type: IsarType.dateTime,
    ),
    r'updatedAt': PropertySchema(
      id: 21,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'workspaceId': PropertySchema(
      id: 22,
      name: r'workspaceId',
      type: IsarType.string,
    )
  },
  estimateSize: _networkActorCacheModelEstimateSize,
  serialize: _networkActorCacheModelSerialize,
  deserialize: _networkActorCacheModelDeserialize,
  deserializeProp: _networkActorCacheModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'compositeKey': IndexSchema(
      id: -66619599277560115,
      name: r'compositeKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'compositeKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'workspaceId': IndexSchema(
      id: 4360577223095013563,
      name: r'workspaceId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'workspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'providerProfileId': IndexSchema(
      id: 6443974799848388557,
      name: r'providerProfileId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'providerProfileId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'displayNameNormalized': IndexSchema(
      id: 4513476456196894646,
      name: r'displayNameNormalized',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'displayNameNormalized',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'primaryCategoryKey': IndexSchema(
      id: 4336194394431126520,
      name: r'primaryCategoryKey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'primaryCategoryKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'categoriesAllKeys': IndexSchema(
      id: 7674429763490479361,
      name: r'categoriesAllKeys',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'categoriesAllKeys',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'missingInLastSync': IndexSchema(
      id: 3006198015383069108,
      name: r'missingInLastSync',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'missingInLastSync',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _networkActorCacheModelGetId,
  getLinks: _networkActorCacheModelGetLinks,
  attach: _networkActorCacheModelAttach,
  version: '3.3.0-dev.1',
);

int _networkActorCacheModelEstimateSize(
  NetworkActorCacheModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.actorRefId.length * 3;
  bytesCount += 3 + object.actorRefKind.length * 3;
  bytesCount += 3 + object.actorRefRaw.length * 3;
  bytesCount += 3 + object.categoriesAllKeys.length * 3;
  {
    for (var i = 0; i < object.categoriesAllKeys.length; i++) {
      final value = object.categoriesAllKeys[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.clientGeneratedId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.compositeKey.length * 3;
  bytesCount += 3 + object.displayName.length * 3;
  bytesCount += 3 + object.displayNameNormalized.length * 3;
  {
    final value = object.failedSyncReason;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.primaryCategoryKey.length * 3;
  bytesCount += 3 + object.projectionJson.length * 3;
  {
    final value = object.providerProfileId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.relationshipState.length * 3;
  bytesCount += 3 + object.source.name.length * 3;
  bytesCount += 3 + object.syncState.name.length * 3;
  bytesCount += 3 + object.workspaceId.length * 3;
  return bytesCount;
}

void _networkActorCacheModelSerialize(
  NetworkActorCacheModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actorRefId);
  writer.writeString(offsets[1], object.actorRefKind);
  writer.writeString(offsets[2], object.actorRefRaw);
  writer.writeStringList(offsets[3], object.categoriesAllKeys);
  writer.writeString(offsets[4], object.clientGeneratedId);
  writer.writeString(offsets[5], object.compositeKey);
  writer.writeString(offsets[6], object.displayName);
  writer.writeString(offsets[7], object.displayNameNormalized);
  writer.writeString(offsets[8], object.failedSyncReason);
  writer.writeBool(offsets[9], object.isRestricted);
  writer.writeDateTime(offsets[10], object.lastSeenAt);
  writer.writeBool(offsets[11], object.missingInLastSync);
  writer.writeString(offsets[12], object.primaryCategoryKey);
  writer.writeString(offsets[13], object.projectionJson);
  writer.writeLong(offsets[14], object.projectionSchemaVersion);
  writer.writeString(offsets[15], object.providerProfileId);
  writer.writeString(offsets[16], object.relationshipState);
  writer.writeDateTime(offsets[17], object.serverConfirmedAt);
  writer.writeString(offsets[18], object.source.name);
  writer.writeString(offsets[19], object.syncState.name);
  writer.writeDateTime(offsets[20], object.syncedAt);
  writer.writeDateTime(offsets[21], object.updatedAt);
  writer.writeString(offsets[22], object.workspaceId);
}

NetworkActorCacheModel _networkActorCacheModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NetworkActorCacheModel();
  object.actorRefId = reader.readString(offsets[0]);
  object.actorRefKind = reader.readString(offsets[1]);
  object.actorRefRaw = reader.readString(offsets[2]);
  object.categoriesAllKeys = reader.readStringList(offsets[3]) ?? [];
  object.clientGeneratedId = reader.readStringOrNull(offsets[4]);
  object.compositeKey = reader.readString(offsets[5]);
  object.displayName = reader.readString(offsets[6]);
  object.displayNameNormalized = reader.readString(offsets[7]);
  object.failedSyncReason = reader.readStringOrNull(offsets[8]);
  object.isRestricted = reader.readBool(offsets[9]);
  object.isarId = id;
  object.lastSeenAt = reader.readDateTimeOrNull(offsets[10]);
  object.missingInLastSync = reader.readBool(offsets[11]);
  object.primaryCategoryKey = reader.readString(offsets[12]);
  object.projectionJson = reader.readString(offsets[13]);
  object.projectionSchemaVersion = reader.readLong(offsets[14]);
  object.providerProfileId = reader.readStringOrNull(offsets[15]);
  object.relationshipState = reader.readString(offsets[16]);
  object.serverConfirmedAt = reader.readDateTimeOrNull(offsets[17]);
  object.source = _NetworkActorCacheModelsourceValueEnumMap[
          reader.readStringOrNull(offsets[18])] ??
      NetworkCacheSource.serverRefresh;
  object.syncState = _NetworkActorCacheModelsyncStateValueEnumMap[
          reader.readStringOrNull(offsets[19])] ??
      NetworkCacheSyncState.confirmed;
  object.syncedAt = reader.readDateTime(offsets[20]);
  object.updatedAt = reader.readDateTime(offsets[21]);
  object.workspaceId = reader.readString(offsets[22]);
  return object;
}

P _networkActorCacheModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 18:
      return (_NetworkActorCacheModelsourceValueEnumMap[
              reader.readStringOrNull(offset)] ??
          NetworkCacheSource.serverRefresh) as P;
    case 19:
      return (_NetworkActorCacheModelsyncStateValueEnumMap[
              reader.readStringOrNull(offset)] ??
          NetworkCacheSyncState.confirmed) as P;
    case 20:
      return (reader.readDateTime(offset)) as P;
    case 21:
      return (reader.readDateTime(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _NetworkActorCacheModelsourceEnumValueMap = {
  r'serverRefresh': r'serverRefresh',
  r'localOptimistic': r'localOptimistic',
};
const _NetworkActorCacheModelsourceValueEnumMap = {
  r'serverRefresh': NetworkCacheSource.serverRefresh,
  r'localOptimistic': NetworkCacheSource.localOptimistic,
};
const _NetworkActorCacheModelsyncStateEnumValueMap = {
  r'confirmed': r'confirmed',
  r'pendingCreate': r'pendingCreate',
  r'pendingUpdate': r'pendingUpdate',
  r'pendingDelete': r'pendingDelete',
  r'syncFailed': r'syncFailed',
};
const _NetworkActorCacheModelsyncStateValueEnumMap = {
  r'confirmed': NetworkCacheSyncState.confirmed,
  r'pendingCreate': NetworkCacheSyncState.pendingCreate,
  r'pendingUpdate': NetworkCacheSyncState.pendingUpdate,
  r'pendingDelete': NetworkCacheSyncState.pendingDelete,
  r'syncFailed': NetworkCacheSyncState.syncFailed,
};

Id _networkActorCacheModelGetId(NetworkActorCacheModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _networkActorCacheModelGetLinks(
    NetworkActorCacheModel object) {
  return [];
}

void _networkActorCacheModelAttach(
    IsarCollection<dynamic> col, Id id, NetworkActorCacheModel object) {
  object.isarId = id;
}

extension NetworkActorCacheModelByIndex
    on IsarCollection<NetworkActorCacheModel> {
  Future<NetworkActorCacheModel?> getByCompositeKey(String compositeKey) {
    return getByIndex(r'compositeKey', [compositeKey]);
  }

  NetworkActorCacheModel? getByCompositeKeySync(String compositeKey) {
    return getByIndexSync(r'compositeKey', [compositeKey]);
  }

  Future<bool> deleteByCompositeKey(String compositeKey) {
    return deleteByIndex(r'compositeKey', [compositeKey]);
  }

  bool deleteByCompositeKeySync(String compositeKey) {
    return deleteByIndexSync(r'compositeKey', [compositeKey]);
  }

  Future<List<NetworkActorCacheModel?>> getAllByCompositeKey(
      List<String> compositeKeyValues) {
    final values = compositeKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'compositeKey', values);
  }

  List<NetworkActorCacheModel?> getAllByCompositeKeySync(
      List<String> compositeKeyValues) {
    final values = compositeKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'compositeKey', values);
  }

  Future<int> deleteAllByCompositeKey(List<String> compositeKeyValues) {
    final values = compositeKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'compositeKey', values);
  }

  int deleteAllByCompositeKeySync(List<String> compositeKeyValues) {
    final values = compositeKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'compositeKey', values);
  }

  Future<Id> putByCompositeKey(NetworkActorCacheModel object) {
    return putByIndex(r'compositeKey', object);
  }

  Id putByCompositeKeySync(NetworkActorCacheModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'compositeKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCompositeKey(List<NetworkActorCacheModel> objects) {
    return putAllByIndex(r'compositeKey', objects);
  }

  List<Id> putAllByCompositeKeySync(List<NetworkActorCacheModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'compositeKey', objects, saveLinks: saveLinks);
  }
}

extension NetworkActorCacheModelQueryWhereSort
    on QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QWhere> {
  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterWhere>
      anyDisplayNameNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'displayNameNormalized'),
      );
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterWhere>
      anyCategoriesAllKeysElement() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'categoriesAllKeys'),
      );
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterWhere>
      anyMissingInLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'missingInLastSync'),
      );
    });
  }
}

extension NetworkActorCacheModelQueryWhere on QueryBuilder<
    NetworkActorCacheModel, NetworkActorCacheModel, QWhereClause> {
  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> compositeKeyEqualTo(String compositeKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'compositeKey',
        value: [compositeKey],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> compositeKeyNotEqualTo(String compositeKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'compositeKey',
              lower: [],
              upper: [compositeKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'compositeKey',
              lower: [compositeKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'compositeKey',
              lower: [compositeKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'compositeKey',
              lower: [],
              upper: [compositeKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> workspaceIdEqualTo(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId',
        value: [workspaceId],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> workspaceIdNotEqualTo(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> providerProfileIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'providerProfileId',
        value: [null],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> providerProfileIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'providerProfileId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> providerProfileIdEqualTo(String? providerProfileId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'providerProfileId',
        value: [providerProfileId],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterWhereClause>
      providerProfileIdNotEqualTo(String? providerProfileId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'providerProfileId',
              lower: [],
              upper: [providerProfileId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'providerProfileId',
              lower: [providerProfileId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'providerProfileId',
              lower: [providerProfileId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'providerProfileId',
              lower: [],
              upper: [providerProfileId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterWhereClause>
      displayNameNormalizedEqualTo(String displayNameNormalized) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'displayNameNormalized',
        value: [displayNameNormalized],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterWhereClause>
      displayNameNormalizedNotEqualTo(String displayNameNormalized) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'displayNameNormalized',
              lower: [],
              upper: [displayNameNormalized],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'displayNameNormalized',
              lower: [displayNameNormalized],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'displayNameNormalized',
              lower: [displayNameNormalized],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'displayNameNormalized',
              lower: [],
              upper: [displayNameNormalized],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> displayNameNormalizedGreaterThan(
    String displayNameNormalized, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'displayNameNormalized',
        lower: [displayNameNormalized],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> displayNameNormalizedLessThan(
    String displayNameNormalized, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'displayNameNormalized',
        lower: [],
        upper: [displayNameNormalized],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> displayNameNormalizedBetween(
    String lowerDisplayNameNormalized,
    String upperDisplayNameNormalized, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'displayNameNormalized',
        lower: [lowerDisplayNameNormalized],
        includeLower: includeLower,
        upper: [upperDisplayNameNormalized],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterWhereClause>
      displayNameNormalizedStartsWith(String DisplayNameNormalizedPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'displayNameNormalized',
        lower: [DisplayNameNormalizedPrefix],
        upper: ['$DisplayNameNormalizedPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> displayNameNormalizedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'displayNameNormalized',
        value: [''],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> displayNameNormalizedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'displayNameNormalized',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'displayNameNormalized',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'displayNameNormalized',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'displayNameNormalized',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> primaryCategoryKeyEqualTo(String primaryCategoryKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'primaryCategoryKey',
        value: [primaryCategoryKey],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterWhereClause>
      primaryCategoryKeyNotEqualTo(String primaryCategoryKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'primaryCategoryKey',
              lower: [],
              upper: [primaryCategoryKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'primaryCategoryKey',
              lower: [primaryCategoryKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'primaryCategoryKey',
              lower: [primaryCategoryKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'primaryCategoryKey',
              lower: [],
              upper: [primaryCategoryKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterWhereClause>
      categoriesAllKeysElementEqualTo(String categoriesAllKeysElement) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'categoriesAllKeys',
        value: [categoriesAllKeysElement],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterWhereClause>
      categoriesAllKeysElementNotEqualTo(String categoriesAllKeysElement) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoriesAllKeys',
              lower: [],
              upper: [categoriesAllKeysElement],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoriesAllKeys',
              lower: [categoriesAllKeysElement],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoriesAllKeys',
              lower: [categoriesAllKeysElement],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoriesAllKeys',
              lower: [],
              upper: [categoriesAllKeysElement],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> categoriesAllKeysElementGreaterThan(
    String categoriesAllKeysElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoriesAllKeys',
        lower: [categoriesAllKeysElement],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> categoriesAllKeysElementLessThan(
    String categoriesAllKeysElement, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoriesAllKeys',
        lower: [],
        upper: [categoriesAllKeysElement],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> categoriesAllKeysElementBetween(
    String lowerCategoriesAllKeysElement,
    String upperCategoriesAllKeysElement, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoriesAllKeys',
        lower: [lowerCategoriesAllKeysElement],
        includeLower: includeLower,
        upper: [upperCategoriesAllKeysElement],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterWhereClause>
      categoriesAllKeysElementStartsWith(
          String CategoriesAllKeysElementPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoriesAllKeys',
        lower: [CategoriesAllKeysElementPrefix],
        upper: ['$CategoriesAllKeysElementPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> categoriesAllKeysElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'categoriesAllKeys',
        value: [''],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> categoriesAllKeysElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'categoriesAllKeys',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'categoriesAllKeys',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'categoriesAllKeys',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'categoriesAllKeys',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> missingInLastSyncEqualTo(bool missingInLastSync) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'missingInLastSync',
        value: [missingInLastSync],
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterWhereClause> missingInLastSyncNotEqualTo(bool missingInLastSync) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'missingInLastSync',
              lower: [],
              upper: [missingInLastSync],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'missingInLastSync',
              lower: [missingInLastSync],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'missingInLastSync',
              lower: [missingInLastSync],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'missingInLastSync',
              lower: [],
              upper: [missingInLastSync],
              includeUpper: false,
            ));
      }
    });
  }
}

extension NetworkActorCacheModelQueryFilter on QueryBuilder<
    NetworkActorCacheModel, NetworkActorCacheModel, QFilterCondition> {
  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actorRefId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actorRefId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actorRefId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actorRefId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actorRefId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actorRefId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      actorRefIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actorRefId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      actorRefIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actorRefId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actorRefId',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actorRefId',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefKindEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actorRefKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefKindGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actorRefKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefKindLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actorRefKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefKindBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actorRefKind',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefKindStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actorRefKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefKindEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actorRefKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      actorRefKindContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actorRefKind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      actorRefKindMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actorRefKind',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefKindIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actorRefKind',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefKindIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actorRefKind',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefRawEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actorRefRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefRawGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actorRefRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefRawLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actorRefRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefRawBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actorRefRaw',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefRawStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actorRefRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefRawEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actorRefRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      actorRefRawContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actorRefRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      actorRefRawMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actorRefRaw',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefRawIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actorRefRaw',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> actorRefRawIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actorRefRaw',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoriesAllKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoriesAllKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoriesAllKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoriesAllKeys',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoriesAllKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoriesAllKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      categoriesAllKeysElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoriesAllKeys',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      categoriesAllKeysElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoriesAllKeys',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoriesAllKeys',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoriesAllKeys',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoriesAllKeys',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoriesAllKeys',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoriesAllKeys',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoriesAllKeys',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoriesAllKeys',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> categoriesAllKeysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categoriesAllKeys',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> clientGeneratedIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clientGeneratedId',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> clientGeneratedIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clientGeneratedId',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> clientGeneratedIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientGeneratedId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> clientGeneratedIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clientGeneratedId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> clientGeneratedIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clientGeneratedId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> clientGeneratedIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clientGeneratedId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> clientGeneratedIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clientGeneratedId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> clientGeneratedIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clientGeneratedId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      clientGeneratedIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clientGeneratedId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      clientGeneratedIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clientGeneratedId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> clientGeneratedIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientGeneratedId',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> clientGeneratedIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clientGeneratedId',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> compositeKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'compositeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> compositeKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'compositeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> compositeKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'compositeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> compositeKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'compositeKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> compositeKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'compositeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> compositeKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'compositeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      compositeKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'compositeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      compositeKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'compositeKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> compositeKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'compositeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> compositeKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'compositeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameNormalizedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayNameNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameNormalizedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayNameNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameNormalizedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayNameNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameNormalizedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayNameNormalized',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameNormalizedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayNameNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameNormalizedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayNameNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      displayNameNormalizedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayNameNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      displayNameNormalizedMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayNameNormalized',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameNormalizedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayNameNormalized',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> displayNameNormalizedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayNameNormalized',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> failedSyncReasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'failedSyncReason',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> failedSyncReasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'failedSyncReason',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> failedSyncReasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'failedSyncReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> failedSyncReasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'failedSyncReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> failedSyncReasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'failedSyncReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> failedSyncReasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'failedSyncReason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> failedSyncReasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'failedSyncReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> failedSyncReasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'failedSyncReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      failedSyncReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'failedSyncReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      failedSyncReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'failedSyncReason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> failedSyncReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'failedSyncReason',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> failedSyncReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'failedSyncReason',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> isRestrictedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRestricted',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> isarIdGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> isarIdLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> isarIdBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> lastSeenAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSeenAt',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> lastSeenAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSeenAt',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> lastSeenAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSeenAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> lastSeenAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSeenAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> lastSeenAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSeenAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> lastSeenAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSeenAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> missingInLastSyncEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missingInLastSync',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> primaryCategoryKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryCategoryKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> primaryCategoryKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primaryCategoryKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> primaryCategoryKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primaryCategoryKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> primaryCategoryKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primaryCategoryKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> primaryCategoryKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'primaryCategoryKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> primaryCategoryKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'primaryCategoryKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      primaryCategoryKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryCategoryKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      primaryCategoryKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryCategoryKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> primaryCategoryKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryCategoryKey',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> primaryCategoryKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryCategoryKey',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> projectionJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> projectionJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'projectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> projectionJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'projectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> projectionJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'projectionJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> projectionJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'projectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> projectionJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'projectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      projectionJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'projectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      projectionJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'projectionJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> projectionJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectionJson',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> projectionJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'projectionJson',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> projectionSchemaVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectionSchemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> projectionSchemaVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'projectionSchemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> projectionSchemaVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'projectionSchemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> projectionSchemaVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'projectionSchemaVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> providerProfileIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'providerProfileId',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> providerProfileIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'providerProfileId',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> providerProfileIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerProfileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> providerProfileIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'providerProfileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> providerProfileIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'providerProfileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> providerProfileIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'providerProfileId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> providerProfileIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'providerProfileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> providerProfileIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'providerProfileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      providerProfileIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'providerProfileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      providerProfileIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'providerProfileId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> providerProfileIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerProfileId',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> providerProfileIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'providerProfileId',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> relationshipStateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relationshipState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> relationshipStateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relationshipState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> relationshipStateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relationshipState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> relationshipStateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relationshipState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> relationshipStateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relationshipState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> relationshipStateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relationshipState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      relationshipStateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relationshipState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      relationshipStateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relationshipState',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> relationshipStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relationshipState',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> relationshipStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relationshipState',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> serverConfirmedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverConfirmedAt',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> serverConfirmedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverConfirmedAt',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> serverConfirmedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverConfirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> serverConfirmedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverConfirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> serverConfirmedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverConfirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> serverConfirmedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverConfirmedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> sourceEqualTo(
    NetworkCacheSource value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> sourceGreaterThan(
    NetworkCacheSource value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> sourceLessThan(
    NetworkCacheSource value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> sourceBetween(
    NetworkCacheSource lower,
    NetworkCacheSource upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> syncStateEqualTo(
    NetworkCacheSyncState value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> syncStateGreaterThan(
    NetworkCacheSyncState value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> syncStateLessThan(
    NetworkCacheSyncState value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> syncStateBetween(
    NetworkCacheSyncState lower,
    NetworkCacheSyncState upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> syncStateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> syncStateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      syncStateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      syncStateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncState',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> syncStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncState',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> syncStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncState',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> syncedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> syncedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> syncedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> syncedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> workspaceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> workspaceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> workspaceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> workspaceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workspaceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> workspaceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> workspaceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      workspaceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
          QAfterFilterCondition>
      workspaceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workspaceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> workspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel,
      QAfterFilterCondition> workspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workspaceId',
        value: '',
      ));
    });
  }
}

extension NetworkActorCacheModelQueryObject on QueryBuilder<
    NetworkActorCacheModel, NetworkActorCacheModel, QFilterCondition> {}

extension NetworkActorCacheModelQueryLinks on QueryBuilder<
    NetworkActorCacheModel, NetworkActorCacheModel, QFilterCondition> {}

extension NetworkActorCacheModelQuerySortBy
    on QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QSortBy> {
  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByActorRefId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefId', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByActorRefIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefId', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByActorRefKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefKind', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByActorRefKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefKind', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByActorRefRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefRaw', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByActorRefRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefRaw', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByClientGeneratedId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientGeneratedId', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByClientGeneratedIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientGeneratedId', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByCompositeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByCompositeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByDisplayNameNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayNameNormalized', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByDisplayNameNormalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayNameNormalized', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByFailedSyncReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedSyncReason', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByFailedSyncReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedSyncReason', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByIsRestricted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRestricted', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByIsRestrictedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRestricted', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByLastSeenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByLastSeenAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByMissingInLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missingInLastSync', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByMissingInLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missingInLastSync', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByPrimaryCategoryKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryCategoryKey', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByPrimaryCategoryKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryCategoryKey', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByProjectionJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionJson', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByProjectionJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionJson', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByProjectionSchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionSchemaVersion', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByProjectionSchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionSchemaVersion', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByProviderProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerProfileId', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByProviderProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerProfileId', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByRelationshipState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipState', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByRelationshipStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipState', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByServerConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverConfirmedAt', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByServerConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverConfirmedAt', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      sortByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension NetworkActorCacheModelQuerySortThenBy on QueryBuilder<
    NetworkActorCacheModel, NetworkActorCacheModel, QSortThenBy> {
  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByActorRefId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefId', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByActorRefIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefId', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByActorRefKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefKind', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByActorRefKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefKind', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByActorRefRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefRaw', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByActorRefRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefRaw', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByClientGeneratedId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientGeneratedId', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByClientGeneratedIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientGeneratedId', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByCompositeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByCompositeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByDisplayNameNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayNameNormalized', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByDisplayNameNormalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayNameNormalized', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByFailedSyncReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedSyncReason', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByFailedSyncReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedSyncReason', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByIsRestricted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRestricted', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByIsRestrictedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRestricted', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByLastSeenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByLastSeenAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByMissingInLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missingInLastSync', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByMissingInLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missingInLastSync', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByPrimaryCategoryKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryCategoryKey', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByPrimaryCategoryKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryCategoryKey', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByProjectionJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionJson', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByProjectionJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionJson', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByProjectionSchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionSchemaVersion', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByProjectionSchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionSchemaVersion', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByProviderProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerProfileId', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByProviderProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerProfileId', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByRelationshipState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipState', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByRelationshipStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipState', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByServerConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverConfirmedAt', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByServerConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverConfirmedAt', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QAfterSortBy>
      thenByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension NetworkActorCacheModelQueryWhereDistinct
    on QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct> {
  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByActorRefId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actorRefId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByActorRefKind({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actorRefKind', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByActorRefRaw({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actorRefRaw', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByCategoriesAllKeys() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoriesAllKeys');
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByClientGeneratedId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientGeneratedId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByCompositeKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'compositeKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByDisplayNameNormalized({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayNameNormalized',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByFailedSyncReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'failedSyncReason',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByIsRestricted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRestricted');
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByLastSeenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSeenAt');
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByMissingInLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missingInLastSync');
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByPrimaryCategoryKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryCategoryKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByProjectionJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectionJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByProjectionSchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectionSchemaVersion');
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByProviderProfileId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'providerProfileId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByRelationshipState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relationshipState',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByServerConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverConfirmedAt');
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctBySource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctBySyncState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncState', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedAt');
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkActorCacheModel, QDistinct>
      distinctByWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workspaceId', caseSensitive: caseSensitive);
    });
  }
}

extension NetworkActorCacheModelQueryProperty on QueryBuilder<
    NetworkActorCacheModel, NetworkActorCacheModel, QQueryProperty> {
  QueryBuilder<NetworkActorCacheModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<NetworkActorCacheModel, String, QQueryOperations>
      actorRefIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actorRefId');
    });
  }

  QueryBuilder<NetworkActorCacheModel, String, QQueryOperations>
      actorRefKindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actorRefKind');
    });
  }

  QueryBuilder<NetworkActorCacheModel, String, QQueryOperations>
      actorRefRawProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actorRefRaw');
    });
  }

  QueryBuilder<NetworkActorCacheModel, List<String>, QQueryOperations>
      categoriesAllKeysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoriesAllKeys');
    });
  }

  QueryBuilder<NetworkActorCacheModel, String?, QQueryOperations>
      clientGeneratedIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientGeneratedId');
    });
  }

  QueryBuilder<NetworkActorCacheModel, String, QQueryOperations>
      compositeKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'compositeKey');
    });
  }

  QueryBuilder<NetworkActorCacheModel, String, QQueryOperations>
      displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<NetworkActorCacheModel, String, QQueryOperations>
      displayNameNormalizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayNameNormalized');
    });
  }

  QueryBuilder<NetworkActorCacheModel, String?, QQueryOperations>
      failedSyncReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'failedSyncReason');
    });
  }

  QueryBuilder<NetworkActorCacheModel, bool, QQueryOperations>
      isRestrictedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRestricted');
    });
  }

  QueryBuilder<NetworkActorCacheModel, DateTime?, QQueryOperations>
      lastSeenAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSeenAt');
    });
  }

  QueryBuilder<NetworkActorCacheModel, bool, QQueryOperations>
      missingInLastSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missingInLastSync');
    });
  }

  QueryBuilder<NetworkActorCacheModel, String, QQueryOperations>
      primaryCategoryKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryCategoryKey');
    });
  }

  QueryBuilder<NetworkActorCacheModel, String, QQueryOperations>
      projectionJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectionJson');
    });
  }

  QueryBuilder<NetworkActorCacheModel, int, QQueryOperations>
      projectionSchemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectionSchemaVersion');
    });
  }

  QueryBuilder<NetworkActorCacheModel, String?, QQueryOperations>
      providerProfileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'providerProfileId');
    });
  }

  QueryBuilder<NetworkActorCacheModel, String, QQueryOperations>
      relationshipStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relationshipState');
    });
  }

  QueryBuilder<NetworkActorCacheModel, DateTime?, QQueryOperations>
      serverConfirmedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverConfirmedAt');
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkCacheSource, QQueryOperations>
      sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<NetworkActorCacheModel, NetworkCacheSyncState, QQueryOperations>
      syncStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncState');
    });
  }

  QueryBuilder<NetworkActorCacheModel, DateTime, QQueryOperations>
      syncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedAt');
    });
  }

  QueryBuilder<NetworkActorCacheModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<NetworkActorCacheModel, String, QQueryOperations>
      workspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workspaceId');
    });
  }
}
