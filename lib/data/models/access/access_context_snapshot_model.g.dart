// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_context_snapshot_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAccessContextSnapshotModelCollection on Isar {
  IsarCollection<AccessContextSnapshotModel> get accessContextSnapshotModels =>
      this.collection();
}

const AccessContextSnapshotModelSchema = CollectionSchema(
  name: r'AccessContextSnapshotModel',
  id: -4330134314646580338,
  properties: {
    r'capabilities': PropertySchema(
      id: 0,
      name: r'capabilities',
      type: IsarType.stringList,
    ),
    r'compositeKey': PropertySchema(
      id: 1,
      name: r'compositeKey',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'expiresAt': PropertySchema(
      id: 3,
      name: r'expiresAt',
      type: IsarType.dateTime,
    ),
    r'fetchedAt': PropertySchema(
      id: 4,
      name: r'fetchedAt',
      type: IsarType.dateTime,
    ),
    r'isOwner': PropertySchema(
      id: 5,
      name: r'isOwner',
      type: IsarType.bool,
    ),
    r'isProvider': PropertySchema(
      id: 6,
      name: r'isProvider',
      type: IsarType.bool,
    ),
    r'lastError': PropertySchema(
      id: 7,
      name: r'lastError',
      type: IsarType.string,
    ),
    r'localWorkspaceId': PropertySchema(
      id: 8,
      name: r'localWorkspaceId',
      type: IsarType.string,
    ),
    r'membershipId': PropertySchema(
      id: 9,
      name: r'membershipId',
      type: IsarType.string,
    ),
    r'platformActorId': PropertySchema(
      id: 10,
      name: r'platformActorId',
      type: IsarType.string,
    ),
    r'providerProfileId': PropertySchema(
      id: 11,
      name: r'providerProfileId',
      type: IsarType.string,
    ),
    r'providerWorkspaceId': PropertySchema(
      id: 12,
      name: r'providerWorkspaceId',
      type: IsarType.string,
    ),
    r'role': PropertySchema(
      id: 13,
      name: r'role',
      type: IsarType.string,
    ),
    r'source': PropertySchema(
      id: 14,
      name: r'source',
      type: IsarType.string,
      enumMap: _AccessContextSnapshotModelsourceEnumValueMap,
    ),
    r'staleAt': PropertySchema(
      id: 15,
      name: r'staleAt',
      type: IsarType.dateTime,
    ),
    r'syncStatus': PropertySchema(
      id: 16,
      name: r'syncStatus',
      type: IsarType.string,
      enumMap: _AccessContextSnapshotModelsyncStatusEnumValueMap,
    ),
    r'userId': PropertySchema(
      id: 17,
      name: r'userId',
      type: IsarType.string,
    ),
    r'versionTag': PropertySchema(
      id: 18,
      name: r'versionTag',
      type: IsarType.string,
    ),
    r'workspaceId': PropertySchema(
      id: 19,
      name: r'workspaceId',
      type: IsarType.string,
    )
  },
  estimateSize: _accessContextSnapshotModelEstimateSize,
  serialize: _accessContextSnapshotModelSerialize,
  deserialize: _accessContextSnapshotModelDeserialize,
  deserializeProp: _accessContextSnapshotModelDeserializeProp,
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
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _accessContextSnapshotModelGetId,
  getLinks: _accessContextSnapshotModelGetLinks,
  attach: _accessContextSnapshotModelAttach,
  version: '3.3.0-dev.1',
);

int _accessContextSnapshotModelEstimateSize(
  AccessContextSnapshotModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.capabilities.length * 3;
  {
    for (var i = 0; i < object.capabilities.length; i++) {
      final value = object.capabilities[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.compositeKey.length * 3;
  {
    final value = object.lastError;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.localWorkspaceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.membershipId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.platformActorId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.providerProfileId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.providerWorkspaceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.role;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.source.name.length * 3;
  bytesCount += 3 + object.syncStatus.name.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  {
    final value = object.versionTag;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.workspaceId.length * 3;
  return bytesCount;
}

void _accessContextSnapshotModelSerialize(
  AccessContextSnapshotModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.capabilities);
  writer.writeString(offsets[1], object.compositeKey);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeDateTime(offsets[3], object.expiresAt);
  writer.writeDateTime(offsets[4], object.fetchedAt);
  writer.writeBool(offsets[5], object.isOwner);
  writer.writeBool(offsets[6], object.isProvider);
  writer.writeString(offsets[7], object.lastError);
  writer.writeString(offsets[8], object.localWorkspaceId);
  writer.writeString(offsets[9], object.membershipId);
  writer.writeString(offsets[10], object.platformActorId);
  writer.writeString(offsets[11], object.providerProfileId);
  writer.writeString(offsets[12], object.providerWorkspaceId);
  writer.writeString(offsets[13], object.role);
  writer.writeString(offsets[14], object.source.name);
  writer.writeDateTime(offsets[15], object.staleAt);
  writer.writeString(offsets[16], object.syncStatus.name);
  writer.writeString(offsets[17], object.userId);
  writer.writeString(offsets[18], object.versionTag);
  writer.writeString(offsets[19], object.workspaceId);
}

AccessContextSnapshotModel _accessContextSnapshotModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AccessContextSnapshotModel();
  object.capabilities = reader.readStringList(offsets[0]) ?? [];
  object.compositeKey = reader.readString(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.expiresAt = reader.readDateTime(offsets[3]);
  object.fetchedAt = reader.readDateTime(offsets[4]);
  object.isOwner = reader.readBool(offsets[5]);
  object.isProvider = reader.readBool(offsets[6]);
  object.isarId = id;
  object.lastError = reader.readStringOrNull(offsets[7]);
  object.localWorkspaceId = reader.readStringOrNull(offsets[8]);
  object.membershipId = reader.readStringOrNull(offsets[9]);
  object.platformActorId = reader.readStringOrNull(offsets[10]);
  object.providerProfileId = reader.readStringOrNull(offsets[11]);
  object.providerWorkspaceId = reader.readStringOrNull(offsets[12]);
  object.role = reader.readStringOrNull(offsets[13]);
  object.source = _AccessContextSnapshotModelsourceValueEnumMap[
          reader.readStringOrNull(offsets[14])] ??
      AccessSnapshotSource.localBootstrap;
  object.staleAt = reader.readDateTime(offsets[15]);
  object.syncStatus = _AccessContextSnapshotModelsyncStatusValueEnumMap[
          reader.readStringOrNull(offsets[16])] ??
      AccessSyncStatus.confirmed;
  object.userId = reader.readString(offsets[17]);
  object.versionTag = reader.readStringOrNull(offsets[18]);
  object.workspaceId = reader.readString(offsets[19]);
  return object;
}

P _accessContextSnapshotModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (_AccessContextSnapshotModelsourceValueEnumMap[
              reader.readStringOrNull(offset)] ??
          AccessSnapshotSource.localBootstrap) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    case 16:
      return (_AccessContextSnapshotModelsyncStatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          AccessSyncStatus.confirmed) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AccessContextSnapshotModelsourceEnumValueMap = {
  r'localBootstrap': r'localBootstrap',
  r'serverRefresh': r'serverRefresh',
};
const _AccessContextSnapshotModelsourceValueEnumMap = {
  r'localBootstrap': AccessSnapshotSource.localBootstrap,
  r'serverRefresh': AccessSnapshotSource.serverRefresh,
};
const _AccessContextSnapshotModelsyncStatusEnumValueMap = {
  r'confirmed': r'confirmed',
  r'pendingSync': r'pendingSync',
  r'syncFailed': r'syncFailed',
};
const _AccessContextSnapshotModelsyncStatusValueEnumMap = {
  r'confirmed': AccessSyncStatus.confirmed,
  r'pendingSync': AccessSyncStatus.pendingSync,
  r'syncFailed': AccessSyncStatus.syncFailed,
};

Id _accessContextSnapshotModelGetId(AccessContextSnapshotModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _accessContextSnapshotModelGetLinks(
    AccessContextSnapshotModel object) {
  return [];
}

void _accessContextSnapshotModelAttach(
    IsarCollection<dynamic> col, Id id, AccessContextSnapshotModel object) {
  object.isarId = id;
}

extension AccessContextSnapshotModelByIndex
    on IsarCollection<AccessContextSnapshotModel> {
  Future<AccessContextSnapshotModel?> getByCompositeKey(String compositeKey) {
    return getByIndex(r'compositeKey', [compositeKey]);
  }

  AccessContextSnapshotModel? getByCompositeKeySync(String compositeKey) {
    return getByIndexSync(r'compositeKey', [compositeKey]);
  }

  Future<bool> deleteByCompositeKey(String compositeKey) {
    return deleteByIndex(r'compositeKey', [compositeKey]);
  }

  bool deleteByCompositeKeySync(String compositeKey) {
    return deleteByIndexSync(r'compositeKey', [compositeKey]);
  }

  Future<List<AccessContextSnapshotModel?>> getAllByCompositeKey(
      List<String> compositeKeyValues) {
    final values = compositeKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'compositeKey', values);
  }

  List<AccessContextSnapshotModel?> getAllByCompositeKeySync(
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

  Future<Id> putByCompositeKey(AccessContextSnapshotModel object) {
    return putByIndex(r'compositeKey', object);
  }

  Id putByCompositeKeySync(AccessContextSnapshotModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'compositeKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCompositeKey(
      List<AccessContextSnapshotModel> objects) {
    return putAllByIndex(r'compositeKey', objects);
  }

  List<Id> putAllByCompositeKeySync(List<AccessContextSnapshotModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'compositeKey', objects, saveLinks: saveLinks);
  }
}

extension AccessContextSnapshotModelQueryWhereSort on QueryBuilder<
    AccessContextSnapshotModel, AccessContextSnapshotModel, QWhere> {
  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AccessContextSnapshotModelQueryWhere on QueryBuilder<
    AccessContextSnapshotModel, AccessContextSnapshotModel, QWhereClause> {
  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterWhereClause> compositeKeyEqualTo(String compositeKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'compositeKey',
        value: [compositeKey],
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterWhereClause> userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterWhereClause> userIdNotEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterWhereClause> workspaceIdEqualTo(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId',
        value: [workspaceId],
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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
}

extension AccessContextSnapshotModelQueryFilter on QueryBuilder<
    AccessContextSnapshotModel, AccessContextSnapshotModel, QFilterCondition> {
  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capabilities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'capabilities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'capabilities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'capabilities',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'capabilities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'capabilities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      capabilitiesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'capabilities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      capabilitiesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'capabilities',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capabilities',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'capabilities',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'capabilities',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'capabilities',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'capabilities',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'capabilities',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'capabilities',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> capabilitiesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'capabilities',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> compositeKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'compositeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> compositeKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'compositeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> expiresAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> expiresAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> expiresAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> expiresAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiresAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> fetchedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> fetchedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> fetchedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fetchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> fetchedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fetchedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> isOwnerEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOwner',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> isProviderEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isProvider',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> lastErrorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastError',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> lastErrorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastError',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> lastErrorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> lastErrorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> lastErrorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> lastErrorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastError',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> lastErrorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> lastErrorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      lastErrorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      lastErrorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastError',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> lastErrorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastError',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> lastErrorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastError',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> localWorkspaceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'localWorkspaceId',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> localWorkspaceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'localWorkspaceId',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> localWorkspaceIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> localWorkspaceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> localWorkspaceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> localWorkspaceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localWorkspaceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> localWorkspaceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'localWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> localWorkspaceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'localWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      localWorkspaceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'localWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      localWorkspaceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'localWorkspaceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> localWorkspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> localWorkspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'localWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> membershipIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'membershipId',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> membershipIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'membershipId',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> membershipIdEqualTo(
    String? value, {
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> membershipIdGreaterThan(
    String? value, {
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> membershipIdLessThan(
    String? value, {
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> membershipIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> membershipIdStartsWith(
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> membershipIdEndsWith(
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      membershipIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'membershipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      membershipIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'membershipId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> membershipIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'membershipId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> membershipIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'membershipId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> platformActorIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'platformActorId',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> platformActorIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'platformActorId',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> platformActorIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'platformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> platformActorIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'platformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> platformActorIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'platformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> platformActorIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'platformActorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> platformActorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'platformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> platformActorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'platformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      platformActorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'platformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      platformActorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'platformActorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> platformActorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'platformActorId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> platformActorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'platformActorId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerProfileIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'providerProfileId',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerProfileIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'providerProfileId',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerProfileIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerProfileId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerProfileIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'providerProfileId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerWorkspaceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'providerWorkspaceId',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerWorkspaceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'providerWorkspaceId',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerWorkspaceIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerWorkspaceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'providerWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerWorkspaceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'providerWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerWorkspaceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'providerWorkspaceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerWorkspaceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'providerWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerWorkspaceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'providerWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      providerWorkspaceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'providerWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      providerWorkspaceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'providerWorkspaceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerWorkspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> providerWorkspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'providerWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> roleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'role',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> roleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'role',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> roleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> roleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> roleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> roleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'role',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> roleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> roleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      roleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      roleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'role',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> roleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'role',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> roleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'role',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> sourceEqualTo(
    AccessSnapshotSource value, {
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> sourceGreaterThan(
    AccessSnapshotSource value, {
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> sourceLessThan(
    AccessSnapshotSource value, {
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> sourceBetween(
    AccessSnapshotSource lower,
    AccessSnapshotSource upper, {
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> staleAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'staleAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> staleAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'staleAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> staleAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'staleAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> staleAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'staleAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> syncStatusEqualTo(
    AccessSyncStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> syncStatusGreaterThan(
    AccessSyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> syncStatusLessThan(
    AccessSyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> syncStatusBetween(
    AccessSyncStatus lower,
    AccessSyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> syncStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> syncStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      syncStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'syncStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      syncStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'syncStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> userIdEqualTo(
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> userIdGreaterThan(
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> userIdLessThan(
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> userIdBetween(
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> userIdStartsWith(
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> userIdEndsWith(
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> versionTagIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'versionTag',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> versionTagIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'versionTag',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> versionTagEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'versionTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> versionTagGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'versionTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> versionTagLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'versionTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> versionTagBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'versionTag',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> versionTagStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'versionTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> versionTagEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'versionTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      versionTagContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'versionTag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
          QAfterFilterCondition>
      versionTagMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'versionTag',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> versionTagIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'versionTag',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> versionTagIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'versionTag',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
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

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> workspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterFilterCondition> workspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workspaceId',
        value: '',
      ));
    });
  }
}

extension AccessContextSnapshotModelQueryObject on QueryBuilder<
    AccessContextSnapshotModel, AccessContextSnapshotModel, QFilterCondition> {}

extension AccessContextSnapshotModelQueryLinks on QueryBuilder<
    AccessContextSnapshotModel, AccessContextSnapshotModel, QFilterCondition> {}

extension AccessContextSnapshotModelQuerySortBy on QueryBuilder<
    AccessContextSnapshotModel, AccessContextSnapshotModel, QSortBy> {
  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByCompositeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByCompositeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByIsOwner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOwner', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByIsOwnerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOwner', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByIsProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProvider', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByIsProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProvider', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByLocalWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByLocalWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByMembershipId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membershipId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByMembershipIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membershipId', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByPlatformActorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformActorId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByPlatformActorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformActorId', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByProviderProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerProfileId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByProviderProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerProfileId', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByProviderWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByProviderWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByStaleAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staleAt', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByStaleAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staleAt', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByVersionTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versionTag', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByVersionTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versionTag', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> sortByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension AccessContextSnapshotModelQuerySortThenBy on QueryBuilder<
    AccessContextSnapshotModel, AccessContextSnapshotModel, QSortThenBy> {
  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByCompositeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByCompositeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fetchedAt', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByIsOwner() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOwner', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByIsOwnerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOwner', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByIsProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProvider', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByIsProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isProvider', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByLocalWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByLocalWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByMembershipId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membershipId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByMembershipIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'membershipId', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByPlatformActorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformActorId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByPlatformActorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformActorId', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByProviderProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerProfileId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByProviderProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerProfileId', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByProviderWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByProviderWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByStaleAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staleAt', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByStaleAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'staleAt', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByVersionTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versionTag', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByVersionTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versionTag', Sort.desc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QAfterSortBy> thenByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension AccessContextSnapshotModelQueryWhereDistinct on QueryBuilder<
    AccessContextSnapshotModel, AccessContextSnapshotModel, QDistinct> {
  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByCapabilities() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capabilities');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByCompositeKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'compositeKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiresAt');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fetchedAt');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByIsOwner() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOwner');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByIsProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isProvider');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByLastError({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastError', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByLocalWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localWorkspaceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByMembershipId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'membershipId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByPlatformActorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'platformActorId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByProviderProfileId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'providerProfileId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByProviderWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'providerWorkspaceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByRole({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'role', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctBySource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByStaleAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'staleAt');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctBySyncStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByVersionTag({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'versionTag', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessContextSnapshotModel,
      QDistinct> distinctByWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workspaceId', caseSensitive: caseSensitive);
    });
  }
}

extension AccessContextSnapshotModelQueryProperty on QueryBuilder<
    AccessContextSnapshotModel, AccessContextSnapshotModel, QQueryProperty> {
  QueryBuilder<AccessContextSnapshotModel, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, List<String>, QQueryOperations>
      capabilitiesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capabilities');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, String, QQueryOperations>
      compositeKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'compositeKey');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, DateTime, QQueryOperations>
      expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiresAt');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, DateTime, QQueryOperations>
      fetchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fetchedAt');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, bool, QQueryOperations>
      isOwnerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOwner');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, bool, QQueryOperations>
      isProviderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isProvider');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, String?, QQueryOperations>
      lastErrorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastError');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, String?, QQueryOperations>
      localWorkspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localWorkspaceId');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, String?, QQueryOperations>
      membershipIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'membershipId');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, String?, QQueryOperations>
      platformActorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'platformActorId');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, String?, QQueryOperations>
      providerProfileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'providerProfileId');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, String?, QQueryOperations>
      providerWorkspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'providerWorkspaceId');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, String?, QQueryOperations>
      roleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'role');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessSnapshotSource,
      QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, DateTime, QQueryOperations>
      staleAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'staleAt');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, AccessSyncStatus, QQueryOperations>
      syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, String, QQueryOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, String?, QQueryOperations>
      versionTagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'versionTag');
    });
  }

  QueryBuilder<AccessContextSnapshotModel, String, QQueryOperations>
      workspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workspaceId');
    });
  }
}
