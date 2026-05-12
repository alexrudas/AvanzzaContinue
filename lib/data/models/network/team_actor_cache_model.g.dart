// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_actor_cache_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTeamActorCacheModelCollection on Isar {
  IsarCollection<TeamActorCacheModel> get teamActorCacheModels =>
      this.collection();
}

const TeamActorCacheModelSchema = CollectionSchema(
  name: r'TeamActorCacheModel',
  id: -245268340044077555,
  properties: {
    r'actorRefRaw': PropertySchema(
      id: 0,
      name: r'actorRefRaw',
      type: IsarType.string,
    ),
    r'clientGeneratedId': PropertySchema(
      id: 1,
      name: r'clientGeneratedId',
      type: IsarType.string,
    ),
    r'compositeKey': PropertySchema(
      id: 2,
      name: r'compositeKey',
      type: IsarType.string,
    ),
    r'displayName': PropertySchema(
      id: 3,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'displayNameNormalized': PropertySchema(
      id: 4,
      name: r'displayNameNormalized',
      type: IsarType.string,
    ),
    r'failedSyncReason': PropertySchema(
      id: 5,
      name: r'failedSyncReason',
      type: IsarType.string,
    ),
    r'lastSeenAt': PropertySchema(
      id: 6,
      name: r'lastSeenAt',
      type: IsarType.dateTime,
    ),
    r'membershipId': PropertySchema(
      id: 7,
      name: r'membershipId',
      type: IsarType.string,
    ),
    r'missingInLastSync': PropertySchema(
      id: 8,
      name: r'missingInLastSync',
      type: IsarType.bool,
    ),
    r'projectionJson': PropertySchema(
      id: 9,
      name: r'projectionJson',
      type: IsarType.string,
    ),
    r'projectionSchemaVersion': PropertySchema(
      id: 10,
      name: r'projectionSchemaVersion',
      type: IsarType.long,
    ),
    r'serverConfirmedAt': PropertySchema(
      id: 11,
      name: r'serverConfirmedAt',
      type: IsarType.dateTime,
    ),
    r'source': PropertySchema(
      id: 12,
      name: r'source',
      type: IsarType.string,
      enumMap: _TeamActorCacheModelsourceEnumValueMap,
    ),
    r'syncState': PropertySchema(
      id: 13,
      name: r'syncState',
      type: IsarType.string,
      enumMap: _TeamActorCacheModelsyncStateEnumValueMap,
    ),
    r'syncedAt': PropertySchema(
      id: 14,
      name: r'syncedAt',
      type: IsarType.dateTime,
    ),
    r'updatedAt': PropertySchema(
      id: 15,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 16,
      name: r'userId',
      type: IsarType.string,
    ),
    r'workspaceId': PropertySchema(
      id: 17,
      name: r'workspaceId',
      type: IsarType.string,
    )
  },
  estimateSize: _teamActorCacheModelEstimateSize,
  serialize: _teamActorCacheModelSerialize,
  deserialize: _teamActorCacheModelDeserialize,
  deserializeProp: _teamActorCacheModelDeserializeProp,
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
    r'membershipId': IndexSchema(
      id: 578392508556502073,
      name: r'membershipId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'membershipId',
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
  getId: _teamActorCacheModelGetId,
  getLinks: _teamActorCacheModelGetLinks,
  attach: _teamActorCacheModelAttach,
  version: '3.3.0-dev.1',
);

int _teamActorCacheModelEstimateSize(
  TeamActorCacheModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.actorRefRaw.length * 3;
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
  bytesCount += 3 + object.membershipId.length * 3;
  bytesCount += 3 + object.projectionJson.length * 3;
  bytesCount += 3 + object.source.name.length * 3;
  bytesCount += 3 + object.syncState.name.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  bytesCount += 3 + object.workspaceId.length * 3;
  return bytesCount;
}

void _teamActorCacheModelSerialize(
  TeamActorCacheModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actorRefRaw);
  writer.writeString(offsets[1], object.clientGeneratedId);
  writer.writeString(offsets[2], object.compositeKey);
  writer.writeString(offsets[3], object.displayName);
  writer.writeString(offsets[4], object.displayNameNormalized);
  writer.writeString(offsets[5], object.failedSyncReason);
  writer.writeDateTime(offsets[6], object.lastSeenAt);
  writer.writeString(offsets[7], object.membershipId);
  writer.writeBool(offsets[8], object.missingInLastSync);
  writer.writeString(offsets[9], object.projectionJson);
  writer.writeLong(offsets[10], object.projectionSchemaVersion);
  writer.writeDateTime(offsets[11], object.serverConfirmedAt);
  writer.writeString(offsets[12], object.source.name);
  writer.writeString(offsets[13], object.syncState.name);
  writer.writeDateTime(offsets[14], object.syncedAt);
  writer.writeDateTime(offsets[15], object.updatedAt);
  writer.writeString(offsets[16], object.userId);
  writer.writeString(offsets[17], object.workspaceId);
}

TeamActorCacheModel _teamActorCacheModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TeamActorCacheModel();
  object.actorRefRaw = reader.readString(offsets[0]);
  object.clientGeneratedId = reader.readStringOrNull(offsets[1]);
  object.compositeKey = reader.readString(offsets[2]);
  object.displayName = reader.readString(offsets[3]);
  object.displayNameNormalized = reader.readString(offsets[4]);
  object.failedSyncReason = reader.readStringOrNull(offsets[5]);
  object.isarId = id;
  object.lastSeenAt = reader.readDateTimeOrNull(offsets[6]);
  object.membershipId = reader.readString(offsets[7]);
  object.missingInLastSync = reader.readBool(offsets[8]);
  object.projectionJson = reader.readString(offsets[9]);
  object.projectionSchemaVersion = reader.readLong(offsets[10]);
  object.serverConfirmedAt = reader.readDateTimeOrNull(offsets[11]);
  object.source = _TeamActorCacheModelsourceValueEnumMap[
          reader.readStringOrNull(offsets[12])] ??
      NetworkCacheSource.serverRefresh;
  object.syncState = _TeamActorCacheModelsyncStateValueEnumMap[
          reader.readStringOrNull(offsets[13])] ??
      NetworkCacheSyncState.confirmed;
  object.syncedAt = reader.readDateTime(offsets[14]);
  object.updatedAt = reader.readDateTime(offsets[15]);
  object.userId = reader.readString(offsets[16]);
  object.workspaceId = reader.readString(offsets[17]);
  return object;
}

P _teamActorCacheModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (_TeamActorCacheModelsourceValueEnumMap[
              reader.readStringOrNull(offset)] ??
          NetworkCacheSource.serverRefresh) as P;
    case 13:
      return (_TeamActorCacheModelsyncStateValueEnumMap[
              reader.readStringOrNull(offset)] ??
          NetworkCacheSyncState.confirmed) as P;
    case 14:
      return (reader.readDateTime(offset)) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TeamActorCacheModelsourceEnumValueMap = {
  r'serverRefresh': r'serverRefresh',
  r'localOptimistic': r'localOptimistic',
};
const _TeamActorCacheModelsourceValueEnumMap = {
  r'serverRefresh': NetworkCacheSource.serverRefresh,
  r'localOptimistic': NetworkCacheSource.localOptimistic,
};
const _TeamActorCacheModelsyncStateEnumValueMap = {
  r'confirmed': r'confirmed',
  r'pendingCreate': r'pendingCreate',
  r'pendingUpdate': r'pendingUpdate',
  r'pendingDelete': r'pendingDelete',
  r'syncFailed': r'syncFailed',
};
const _TeamActorCacheModelsyncStateValueEnumMap = {
  r'confirmed': NetworkCacheSyncState.confirmed,
  r'pendingCreate': NetworkCacheSyncState.pendingCreate,
  r'pendingUpdate': NetworkCacheSyncState.pendingUpdate,
  r'pendingDelete': NetworkCacheSyncState.pendingDelete,
  r'syncFailed': NetworkCacheSyncState.syncFailed,
};

Id _teamActorCacheModelGetId(TeamActorCacheModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _teamActorCacheModelGetLinks(
    TeamActorCacheModel object) {
  return [];
}

void _teamActorCacheModelAttach(
    IsarCollection<dynamic> col, Id id, TeamActorCacheModel object) {
  object.isarId = id;
}

extension TeamActorCacheModelByIndex on IsarCollection<TeamActorCacheModel> {
  Future<TeamActorCacheModel?> getByCompositeKey(String compositeKey) {
    return getByIndex(r'compositeKey', [compositeKey]);
  }

  TeamActorCacheModel? getByCompositeKeySync(String compositeKey) {
    return getByIndexSync(r'compositeKey', [compositeKey]);
  }

  Future<bool> deleteByCompositeKey(String compositeKey) {
    return deleteByIndex(r'compositeKey', [compositeKey]);
  }

  bool deleteByCompositeKeySync(String compositeKey) {
    return deleteByIndexSync(r'compositeKey', [compositeKey]);
  }

  Future<List<TeamActorCacheModel?>> getAllByCompositeKey(
      List<String> compositeKeyValues) {
    final values = compositeKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'compositeKey', values);
  }

  List<TeamActorCacheModel?> getAllByCompositeKeySync(
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

  Future<Id> putByCompositeKey(TeamActorCacheModel object) {
    return putByIndex(r'compositeKey', object);
  }

  Id putByCompositeKeySync(TeamActorCacheModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'compositeKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCompositeKey(List<TeamActorCacheModel> objects) {
    return putAllByIndex(r'compositeKey', objects);
  }

  List<Id> putAllByCompositeKeySync(List<TeamActorCacheModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'compositeKey', objects, saveLinks: saveLinks);
  }
}

extension TeamActorCacheModelQueryWhereSort
    on QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QWhere> {
  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhere>
      anyDisplayNameNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'displayNameNormalized'),
      );
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhere>
      anyMissingInLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'missingInLastSync'),
      );
    });
  }
}

extension TeamActorCacheModelQueryWhere
    on QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QWhereClause> {
  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      isarIdBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      compositeKeyEqualTo(String compositeKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'compositeKey',
        value: [compositeKey],
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      compositeKeyNotEqualTo(String compositeKey) {
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      workspaceIdEqualTo(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId',
        value: [workspaceId],
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      workspaceIdNotEqualTo(String workspaceId) {
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      membershipIdEqualTo(String membershipId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'membershipId',
        value: [membershipId],
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      membershipIdNotEqualTo(String membershipId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'membershipId',
              lower: [],
              upper: [membershipId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'membershipId',
              lower: [membershipId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'membershipId',
              lower: [membershipId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'membershipId',
              lower: [],
              upper: [membershipId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      displayNameNormalizedEqualTo(String displayNameNormalized) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'displayNameNormalized',
        value: [displayNameNormalized],
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      displayNameNormalizedGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      displayNameNormalizedLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      displayNameNormalizedBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      displayNameNormalizedStartsWith(String DisplayNameNormalizedPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'displayNameNormalized',
        lower: [DisplayNameNormalizedPrefix],
        upper: ['$DisplayNameNormalizedPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      displayNameNormalizedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'displayNameNormalized',
        value: [''],
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      displayNameNormalizedIsNotEmpty() {
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      missingInLastSyncEqualTo(bool missingInLastSync) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'missingInLastSync',
        value: [missingInLastSync],
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterWhereClause>
      missingInLastSyncNotEqualTo(bool missingInLastSync) {
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

extension TeamActorCacheModelQueryFilter on QueryBuilder<TeamActorCacheModel,
    TeamActorCacheModel, QFilterCondition> {
  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      actorRefRawEqualTo(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      actorRefRawGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      actorRefRawLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      actorRefRawBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      actorRefRawStartsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      actorRefRawEndsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      actorRefRawContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actorRefRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      actorRefRawMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actorRefRaw',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      actorRefRawIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actorRefRaw',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      actorRefRawIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actorRefRaw',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      clientGeneratedIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clientGeneratedId',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      clientGeneratedIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clientGeneratedId',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      clientGeneratedIdEqualTo(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      clientGeneratedIdGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      clientGeneratedIdLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      clientGeneratedIdBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      clientGeneratedIdStartsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      clientGeneratedIdEndsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      clientGeneratedIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clientGeneratedId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      clientGeneratedIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clientGeneratedId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      clientGeneratedIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientGeneratedId',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      clientGeneratedIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clientGeneratedId',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      compositeKeyEqualTo(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      compositeKeyGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      compositeKeyLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      compositeKeyBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      compositeKeyStartsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      compositeKeyEndsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      compositeKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'compositeKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      compositeKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'compositeKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      compositeKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'compositeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      compositeKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'compositeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameEqualTo(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameStartsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameEndsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameNormalizedEqualTo(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameNormalizedGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameNormalizedLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameNormalizedBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameNormalizedStartsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameNormalizedEndsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameNormalizedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayNameNormalized',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameNormalizedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayNameNormalized',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      displayNameNormalizedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayNameNormalized',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      failedSyncReasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'failedSyncReason',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      failedSyncReasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'failedSyncReason',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      failedSyncReasonEqualTo(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      failedSyncReasonGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      failedSyncReasonLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      failedSyncReasonBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      failedSyncReasonStartsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      failedSyncReasonEndsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      failedSyncReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'failedSyncReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      failedSyncReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'failedSyncReason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      failedSyncReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'failedSyncReason',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      failedSyncReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'failedSyncReason',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      isarIdGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      isarIdLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      isarIdBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      lastSeenAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSeenAt',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      lastSeenAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSeenAt',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      lastSeenAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSeenAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      lastSeenAtGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      lastSeenAtLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      lastSeenAtBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      membershipIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'membershipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      membershipIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'membershipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      membershipIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'membershipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      membershipIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'membershipId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      membershipIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'membershipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      membershipIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'membershipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      membershipIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'membershipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      membershipIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'membershipId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      membershipIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'membershipId',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      membershipIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'membershipId',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      missingInLastSyncEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missingInLastSync',
        value: value,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionJsonEqualTo(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionJsonGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionJsonLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionJsonBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionJsonStartsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionJsonEndsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'projectionJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'projectionJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectionJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'projectionJson',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionSchemaVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectionSchemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionSchemaVersionGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionSchemaVersionLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      projectionSchemaVersionBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      serverConfirmedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverConfirmedAt',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      serverConfirmedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverConfirmedAt',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      serverConfirmedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverConfirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      serverConfirmedAtGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      serverConfirmedAtLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      serverConfirmedAtBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      sourceEqualTo(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      sourceGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      sourceLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      sourceBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      sourceStartsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      sourceEndsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncStateEqualTo(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncStateGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncStateLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncStateBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncStateStartsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncStateEndsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncStateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncStateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncState',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncState',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncState',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncedAtGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncedAtLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      syncedAtBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      updatedAtGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      updatedAtBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      workspaceIdEqualTo(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      workspaceIdGreaterThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      workspaceIdLessThan(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      workspaceIdBetween(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      workspaceIdStartsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      workspaceIdEndsWith(
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

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      workspaceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      workspaceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workspaceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      workspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterFilterCondition>
      workspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workspaceId',
        value: '',
      ));
    });
  }
}

extension TeamActorCacheModelQueryObject on QueryBuilder<TeamActorCacheModel,
    TeamActorCacheModel, QFilterCondition> {}

extension TeamActorCacheModelQueryLinks on QueryBuilder<TeamActorCacheModel,
    TeamActorCacheModel, QFilterCondition> {}

extension TeamActorCacheModelQuerySortBy
    on QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QSortBy> {
  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByActorRefRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefRaw', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByActorRefRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefRaw', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByClientGeneratedId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientGeneratedId', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByClientGeneratedIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientGeneratedId', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByCompositeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByCompositeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByDisplayNameNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayNameNormalized', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByDisplayNameNormalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayNameNormalized', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByFailedSyncReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedSyncReason', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByFailedSyncReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedSyncReason', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByLastSeenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByLastSeenAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByMembershipId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membershipId', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByMembershipIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membershipId', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByMissingInLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missingInLastSync', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByMissingInLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missingInLastSync', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByProjectionJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionJson', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByProjectionJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionJson', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByProjectionSchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionSchemaVersion', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByProjectionSchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionSchemaVersion', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByServerConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverConfirmedAt', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByServerConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverConfirmedAt', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      sortByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension TeamActorCacheModelQuerySortThenBy
    on QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QSortThenBy> {
  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByActorRefRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefRaw', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByActorRefRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorRefRaw', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByClientGeneratedId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientGeneratedId', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByClientGeneratedIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientGeneratedId', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByCompositeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByCompositeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByDisplayNameNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayNameNormalized', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByDisplayNameNormalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayNameNormalized', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByFailedSyncReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedSyncReason', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByFailedSyncReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedSyncReason', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByLastSeenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByLastSeenAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByMembershipId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membershipId', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByMembershipIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membershipId', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByMissingInLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missingInLastSync', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByMissingInLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missingInLastSync', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByProjectionJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionJson', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByProjectionJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionJson', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByProjectionSchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionSchemaVersion', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByProjectionSchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionSchemaVersion', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByServerConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverConfirmedAt', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByServerConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverConfirmedAt', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenBySyncState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenBySyncStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncState', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QAfterSortBy>
      thenByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension TeamActorCacheModelQueryWhereDistinct
    on QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct> {
  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByActorRefRaw({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actorRefRaw', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByClientGeneratedId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientGeneratedId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByCompositeKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'compositeKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByDisplayNameNormalized({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayNameNormalized',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByFailedSyncReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'failedSyncReason',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByLastSeenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSeenAt');
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByMembershipId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'membershipId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByMissingInLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missingInLastSync');
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByProjectionJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectionJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByProjectionSchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectionSchemaVersion');
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByServerConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverConfirmedAt');
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctBySource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctBySyncState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncState', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedAt');
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QDistinct>
      distinctByWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workspaceId', caseSensitive: caseSensitive);
    });
  }
}

extension TeamActorCacheModelQueryProperty
    on QueryBuilder<TeamActorCacheModel, TeamActorCacheModel, QQueryProperty> {
  QueryBuilder<TeamActorCacheModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<TeamActorCacheModel, String, QQueryOperations>
      actorRefRawProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actorRefRaw');
    });
  }

  QueryBuilder<TeamActorCacheModel, String?, QQueryOperations>
      clientGeneratedIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientGeneratedId');
    });
  }

  QueryBuilder<TeamActorCacheModel, String, QQueryOperations>
      compositeKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'compositeKey');
    });
  }

  QueryBuilder<TeamActorCacheModel, String, QQueryOperations>
      displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<TeamActorCacheModel, String, QQueryOperations>
      displayNameNormalizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayNameNormalized');
    });
  }

  QueryBuilder<TeamActorCacheModel, String?, QQueryOperations>
      failedSyncReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'failedSyncReason');
    });
  }

  QueryBuilder<TeamActorCacheModel, DateTime?, QQueryOperations>
      lastSeenAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSeenAt');
    });
  }

  QueryBuilder<TeamActorCacheModel, String, QQueryOperations>
      membershipIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'membershipId');
    });
  }

  QueryBuilder<TeamActorCacheModel, bool, QQueryOperations>
      missingInLastSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missingInLastSync');
    });
  }

  QueryBuilder<TeamActorCacheModel, String, QQueryOperations>
      projectionJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectionJson');
    });
  }

  QueryBuilder<TeamActorCacheModel, int, QQueryOperations>
      projectionSchemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectionSchemaVersion');
    });
  }

  QueryBuilder<TeamActorCacheModel, DateTime?, QQueryOperations>
      serverConfirmedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverConfirmedAt');
    });
  }

  QueryBuilder<TeamActorCacheModel, NetworkCacheSource, QQueryOperations>
      sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<TeamActorCacheModel, NetworkCacheSyncState, QQueryOperations>
      syncStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncState');
    });
  }

  QueryBuilder<TeamActorCacheModel, DateTime, QQueryOperations>
      syncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedAt');
    });
  }

  QueryBuilder<TeamActorCacheModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<TeamActorCacheModel, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<TeamActorCacheModel, String, QQueryOperations>
      workspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workspaceId');
    });
  }
}
