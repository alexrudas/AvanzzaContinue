// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_section_meta_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNetworkSectionMetaModelCollection on Isar {
  IsarCollection<NetworkSectionMetaModel> get networkSectionMetaModels =>
      this.collection();
}

const NetworkSectionMetaModelSchema = CollectionSchema(
  name: r'NetworkSectionMetaModel',
  id: 2304353380246483204,
  properties: {
    r'compositeKey': PropertySchema(
      id: 0,
      name: r'compositeKey',
      type: IsarType.string,
    ),
    r'consecutiveFailures': PropertySchema(
      id: 1,
      name: r'consecutiveFailures',
      type: IsarType.long,
    ),
    r'hasReachedEnd': PropertySchema(
      id: 2,
      name: r'hasReachedEnd',
      type: IsarType.bool,
    ),
    r'itemCountLastSync': PropertySchema(
      id: 3,
      name: r'itemCountLastSync',
      type: IsarType.long,
    ),
    r'lastErrorCode': PropertySchema(
      id: 4,
      name: r'lastErrorCode',
      type: IsarType.string,
    ),
    r'lastSyncAttemptAt': PropertySchema(
      id: 5,
      name: r'lastSyncAttemptAt',
      type: IsarType.dateTime,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 6,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'missingItemCount': PropertySchema(
      id: 7,
      name: r'missingItemCount',
      type: IsarType.long,
    ),
    r'nextCursor': PropertySchema(
      id: 8,
      name: r'nextCursor',
      type: IsarType.string,
    ),
    r'projectionSchemaVersion': PropertySchema(
      id: 9,
      name: r'projectionSchemaVersion',
      type: IsarType.long,
    ),
    r'schemaVersion': PropertySchema(
      id: 10,
      name: r'schemaVersion',
      type: IsarType.long,
    ),
    r'sectionKey': PropertySchema(
      id: 11,
      name: r'sectionKey',
      type: IsarType.string,
    ),
    r'serverTime': PropertySchema(
      id: 12,
      name: r'serverTime',
      type: IsarType.dateTime,
    ),
    r'suspiciousShrinkFlag': PropertySchema(
      id: 13,
      name: r'suspiciousShrinkFlag',
      type: IsarType.bool,
    ),
    r'syncStatus': PropertySchema(
      id: 14,
      name: r'syncStatus',
      type: IsarType.string,
      enumMap: _NetworkSectionMetaModelsyncStatusEnumValueMap,
    ),
    r'workspaceId': PropertySchema(
      id: 15,
      name: r'workspaceId',
      type: IsarType.string,
    )
  },
  estimateSize: _networkSectionMetaModelEstimateSize,
  serialize: _networkSectionMetaModelSerialize,
  deserialize: _networkSectionMetaModelDeserialize,
  deserializeProp: _networkSectionMetaModelDeserializeProp,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _networkSectionMetaModelGetId,
  getLinks: _networkSectionMetaModelGetLinks,
  attach: _networkSectionMetaModelAttach,
  version: '3.3.0-dev.1',
);

int _networkSectionMetaModelEstimateSize(
  NetworkSectionMetaModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.compositeKey.length * 3;
  {
    final value = object.lastErrorCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nextCursor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sectionKey.length * 3;
  bytesCount += 3 + object.syncStatus.name.length * 3;
  bytesCount += 3 + object.workspaceId.length * 3;
  return bytesCount;
}

void _networkSectionMetaModelSerialize(
  NetworkSectionMetaModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.compositeKey);
  writer.writeLong(offsets[1], object.consecutiveFailures);
  writer.writeBool(offsets[2], object.hasReachedEnd);
  writer.writeLong(offsets[3], object.itemCountLastSync);
  writer.writeString(offsets[4], object.lastErrorCode);
  writer.writeDateTime(offsets[5], object.lastSyncAttemptAt);
  writer.writeDateTime(offsets[6], object.lastSyncedAt);
  writer.writeLong(offsets[7], object.missingItemCount);
  writer.writeString(offsets[8], object.nextCursor);
  writer.writeLong(offsets[9], object.projectionSchemaVersion);
  writer.writeLong(offsets[10], object.schemaVersion);
  writer.writeString(offsets[11], object.sectionKey);
  writer.writeDateTime(offsets[12], object.serverTime);
  writer.writeBool(offsets[13], object.suspiciousShrinkFlag);
  writer.writeString(offsets[14], object.syncStatus.name);
  writer.writeString(offsets[15], object.workspaceId);
}

NetworkSectionMetaModel _networkSectionMetaModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NetworkSectionMetaModel();
  object.compositeKey = reader.readString(offsets[0]);
  object.consecutiveFailures = reader.readLong(offsets[1]);
  object.hasReachedEnd = reader.readBool(offsets[2]);
  object.isarId = id;
  object.itemCountLastSync = reader.readLong(offsets[3]);
  object.lastErrorCode = reader.readStringOrNull(offsets[4]);
  object.lastSyncAttemptAt = reader.readDateTimeOrNull(offsets[5]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[6]);
  object.missingItemCount = reader.readLong(offsets[7]);
  object.nextCursor = reader.readStringOrNull(offsets[8]);
  object.projectionSchemaVersion = reader.readLong(offsets[9]);
  object.schemaVersion = reader.readLong(offsets[10]);
  object.sectionKey = reader.readString(offsets[11]);
  object.serverTime = reader.readDateTimeOrNull(offsets[12]);
  object.suspiciousShrinkFlag = reader.readBool(offsets[13]);
  object.syncStatus = _NetworkSectionMetaModelsyncStatusValueEnumMap[
          reader.readStringOrNull(offsets[14])] ??
      NetworkSectionSyncStatus.confirmed;
  object.workspaceId = reader.readString(offsets[15]);
  return object;
}

P _networkSectionMetaModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (_NetworkSectionMetaModelsyncStatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          NetworkSectionSyncStatus.confirmed) as P;
    case 15:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _NetworkSectionMetaModelsyncStatusEnumValueMap = {
  r'confirmed': r'confirmed',
  r'syncFailed': r'syncFailed',
};
const _NetworkSectionMetaModelsyncStatusValueEnumMap = {
  r'confirmed': NetworkSectionSyncStatus.confirmed,
  r'syncFailed': NetworkSectionSyncStatus.syncFailed,
};

Id _networkSectionMetaModelGetId(NetworkSectionMetaModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _networkSectionMetaModelGetLinks(
    NetworkSectionMetaModel object) {
  return [];
}

void _networkSectionMetaModelAttach(
    IsarCollection<dynamic> col, Id id, NetworkSectionMetaModel object) {
  object.isarId = id;
}

extension NetworkSectionMetaModelByIndex
    on IsarCollection<NetworkSectionMetaModel> {
  Future<NetworkSectionMetaModel?> getByCompositeKey(String compositeKey) {
    return getByIndex(r'compositeKey', [compositeKey]);
  }

  NetworkSectionMetaModel? getByCompositeKeySync(String compositeKey) {
    return getByIndexSync(r'compositeKey', [compositeKey]);
  }

  Future<bool> deleteByCompositeKey(String compositeKey) {
    return deleteByIndex(r'compositeKey', [compositeKey]);
  }

  bool deleteByCompositeKeySync(String compositeKey) {
    return deleteByIndexSync(r'compositeKey', [compositeKey]);
  }

  Future<List<NetworkSectionMetaModel?>> getAllByCompositeKey(
      List<String> compositeKeyValues) {
    final values = compositeKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'compositeKey', values);
  }

  List<NetworkSectionMetaModel?> getAllByCompositeKeySync(
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

  Future<Id> putByCompositeKey(NetworkSectionMetaModel object) {
    return putByIndex(r'compositeKey', object);
  }

  Id putByCompositeKeySync(NetworkSectionMetaModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'compositeKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCompositeKey(List<NetworkSectionMetaModel> objects) {
    return putAllByIndex(r'compositeKey', objects);
  }

  List<Id> putAllByCompositeKeySync(List<NetworkSectionMetaModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'compositeKey', objects, saveLinks: saveLinks);
  }
}

extension NetworkSectionMetaModelQueryWhereSort
    on QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QWhere> {
  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NetworkSectionMetaModelQueryWhere on QueryBuilder<
    NetworkSectionMetaModel, NetworkSectionMetaModel, QWhereClause> {
  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterWhereClause> compositeKeyEqualTo(String compositeKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'compositeKey',
        value: [compositeKey],
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterWhereClause> workspaceIdEqualTo(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId',
        value: [workspaceId],
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

extension NetworkSectionMetaModelQueryFilter on QueryBuilder<
    NetworkSectionMetaModel, NetworkSectionMetaModel, QFilterCondition> {
  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> compositeKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'compositeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> compositeKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'compositeKey',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> consecutiveFailuresEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'consecutiveFailures',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> consecutiveFailuresGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'consecutiveFailures',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> consecutiveFailuresLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'consecutiveFailures',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> consecutiveFailuresBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'consecutiveFailures',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> hasReachedEndEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasReachedEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> itemCountLastSyncEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemCountLastSync',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> itemCountLastSyncGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemCountLastSync',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> itemCountLastSyncLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemCountLastSync',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> itemCountLastSyncBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemCountLastSync',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastErrorCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastErrorCode',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastErrorCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastErrorCode',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastErrorCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastErrorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastErrorCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastErrorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastErrorCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastErrorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastErrorCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastErrorCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastErrorCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastErrorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastErrorCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastErrorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
          QAfterFilterCondition>
      lastErrorCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastErrorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
          QAfterFilterCondition>
      lastErrorCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastErrorCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastErrorCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastErrorCode',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastErrorCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastErrorCode',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastSyncAttemptAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncAttemptAt',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastSyncAttemptAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncAttemptAt',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastSyncAttemptAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncAttemptAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastSyncAttemptAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSyncAttemptAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastSyncAttemptAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSyncAttemptAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastSyncAttemptAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSyncAttemptAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastSyncedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastSyncedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> lastSyncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSyncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> missingItemCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missingItemCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> missingItemCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'missingItemCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> missingItemCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'missingItemCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> missingItemCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'missingItemCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> nextCursorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextCursor',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> nextCursorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextCursor',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> nextCursorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextCursor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> nextCursorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextCursor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> nextCursorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextCursor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> nextCursorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextCursor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> nextCursorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nextCursor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> nextCursorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nextCursor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
          QAfterFilterCondition>
      nextCursorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nextCursor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
          QAfterFilterCondition>
      nextCursorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nextCursor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> nextCursorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextCursor',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> nextCursorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nextCursor',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> projectionSchemaVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectionSchemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> schemaVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> schemaVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'schemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> schemaVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'schemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> schemaVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'schemaVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> sectionKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sectionKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> sectionKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sectionKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> sectionKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sectionKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> sectionKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sectionKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> sectionKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sectionKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> sectionKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sectionKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
          QAfterFilterCondition>
      sectionKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sectionKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
          QAfterFilterCondition>
      sectionKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sectionKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> sectionKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sectionKey',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> sectionKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sectionKey',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> serverTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serverTime',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> serverTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serverTime',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> serverTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serverTime',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> serverTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serverTime',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> serverTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serverTime',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> serverTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serverTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> suspiciousShrinkFlagEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'suspiciousShrinkFlag',
        value: value,
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> syncStatusEqualTo(
    NetworkSectionSyncStatus value, {
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> syncStatusGreaterThan(
    NetworkSectionSyncStatus value, {
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> syncStatusLessThan(
    NetworkSectionSyncStatus value, {
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> syncStatusBetween(
    NetworkSectionSyncStatus lower,
    NetworkSectionSyncStatus upper, {
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> syncStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> syncStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'syncStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
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

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> workspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel,
      QAfterFilterCondition> workspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workspaceId',
        value: '',
      ));
    });
  }
}

extension NetworkSectionMetaModelQueryObject on QueryBuilder<
    NetworkSectionMetaModel, NetworkSectionMetaModel, QFilterCondition> {}

extension NetworkSectionMetaModelQueryLinks on QueryBuilder<
    NetworkSectionMetaModel, NetworkSectionMetaModel, QFilterCondition> {}

extension NetworkSectionMetaModelQuerySortBy
    on QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QSortBy> {
  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByCompositeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByCompositeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByConsecutiveFailures() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveFailures', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByConsecutiveFailuresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveFailures', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByHasReachedEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReachedEnd', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByHasReachedEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReachedEnd', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByItemCountLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCountLastSync', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByItemCountLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCountLastSync', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByLastErrorCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastErrorCode', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByLastErrorCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastErrorCode', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByLastSyncAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByLastSyncAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByMissingItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missingItemCount', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByMissingItemCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missingItemCount', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByNextCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextCursor', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByNextCursorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextCursor', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByProjectionSchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionSchemaVersion', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByProjectionSchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionSchemaVersion', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortBySectionKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectionKey', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortBySectionKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectionKey', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByServerTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverTime', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByServerTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverTime', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortBySuspiciousShrinkFlag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suspiciousShrinkFlag', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortBySuspiciousShrinkFlagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suspiciousShrinkFlag', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      sortByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension NetworkSectionMetaModelQuerySortThenBy on QueryBuilder<
    NetworkSectionMetaModel, NetworkSectionMetaModel, QSortThenBy> {
  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByCompositeKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByCompositeKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compositeKey', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByConsecutiveFailures() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveFailures', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByConsecutiveFailuresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveFailures', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByHasReachedEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReachedEnd', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByHasReachedEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReachedEnd', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByItemCountLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCountLastSync', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByItemCountLastSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCountLastSync', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByLastErrorCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastErrorCode', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByLastErrorCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastErrorCode', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByLastSyncAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByLastSyncAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByMissingItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missingItemCount', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByMissingItemCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missingItemCount', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByNextCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextCursor', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByNextCursorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextCursor', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByProjectionSchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionSchemaVersion', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByProjectionSchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectionSchemaVersion', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenBySectionKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectionKey', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenBySectionKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sectionKey', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByServerTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverTime', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByServerTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverTime', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenBySuspiciousShrinkFlag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suspiciousShrinkFlag', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenBySuspiciousShrinkFlagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suspiciousShrinkFlag', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QAfterSortBy>
      thenByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension NetworkSectionMetaModelQueryWhereDistinct on QueryBuilder<
    NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct> {
  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctByCompositeKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'compositeKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctByConsecutiveFailures() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'consecutiveFailures');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctByHasReachedEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasReachedEnd');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctByItemCountLastSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemCountLastSync');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctByLastErrorCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastErrorCode',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctByLastSyncAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncAttemptAt');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctByMissingItemCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missingItemCount');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctByNextCursor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextCursor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctByProjectionSchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectionSchemaVersion');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schemaVersion');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctBySectionKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sectionKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctByServerTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverTime');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctBySuspiciousShrinkFlag() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'suspiciousShrinkFlag');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctBySyncStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionMetaModel, QDistinct>
      distinctByWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workspaceId', caseSensitive: caseSensitive);
    });
  }
}

extension NetworkSectionMetaModelQueryProperty on QueryBuilder<
    NetworkSectionMetaModel, NetworkSectionMetaModel, QQueryProperty> {
  QueryBuilder<NetworkSectionMetaModel, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, String, QQueryOperations>
      compositeKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'compositeKey');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, int, QQueryOperations>
      consecutiveFailuresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'consecutiveFailures');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, bool, QQueryOperations>
      hasReachedEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasReachedEnd');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, int, QQueryOperations>
      itemCountLastSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemCountLastSync');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, String?, QQueryOperations>
      lastErrorCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastErrorCode');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, DateTime?, QQueryOperations>
      lastSyncAttemptAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncAttemptAt');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, DateTime?, QQueryOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, int, QQueryOperations>
      missingItemCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missingItemCount');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, String?, QQueryOperations>
      nextCursorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextCursor');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, int, QQueryOperations>
      projectionSchemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectionSchemaVersion');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, int, QQueryOperations>
      schemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schemaVersion');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, String, QQueryOperations>
      sectionKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sectionKey');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, DateTime?, QQueryOperations>
      serverTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverTime');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, bool, QQueryOperations>
      suspiciousShrinkFlagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'suspiciousShrinkFlag');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, NetworkSectionSyncStatus,
      QQueryOperations> syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<NetworkSectionMetaModel, String, QQueryOperations>
      workspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workspaceId');
    });
  }
}
