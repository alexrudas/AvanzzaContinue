// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_outbox_entry_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSyncOutboxEntryModelCollection on Isar {
  IsarCollection<SyncOutboxEntryModel> get syncOutboxEntryModels =>
      this.collection();
}

const SyncOutboxEntryModelSchema = CollectionSchema(
  name: r'SyncOutboxEntryModel',
  id: 6812236527809568787,
  properties: {
    r'completedAtIso': PropertySchema(
      id: 0,
      name: r'completedAtIso',
      type: IsarType.string,
    ),
    r'createdAtIso': PropertySchema(
      id: 1,
      name: r'createdAtIso',
      type: IsarType.string,
    ),
    r'entityId': PropertySchema(
      id: 2,
      name: r'entityId',
      type: IsarType.string,
    ),
    r'entityType': PropertySchema(
      id: 3,
      name: r'entityType',
      type: IsarType.string,
      enumMap: _SyncOutboxEntryModelentityTypeEnumValueMap,
    ),
    r'entryId': PropertySchema(
      id: 4,
      name: r'entryId',
      type: IsarType.string,
    ),
    r'firestorePath': PropertySchema(
      id: 5,
      name: r'firestorePath',
      type: IsarType.string,
    ),
    r'lastAttemptAtIso': PropertySchema(
      id: 6,
      name: r'lastAttemptAtIso',
      type: IsarType.string,
    ),
    r'lastError': PropertySchema(
      id: 7,
      name: r'lastError',
      type: IsarType.string,
    ),
    r'maxRetries': PropertySchema(
      id: 8,
      name: r'maxRetries',
      type: IsarType.long,
    ),
    r'metadata': PropertySchema(
      id: 9,
      name: r'metadata',
      type: IsarType.string,
    ),
    r'operationType': PropertySchema(
      id: 10,
      name: r'operationType',
      type: IsarType.string,
      enumMap: _SyncOutboxEntryModeloperationTypeEnumValueMap,
    ),
    r'payload': PropertySchema(
      id: 11,
      name: r'payload',
      type: IsarType.string,
    ),
    r'retryCount': PropertySchema(
      id: 12,
      name: r'retryCount',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 13,
      name: r'status',
      type: IsarType.string,
      enumMap: _SyncOutboxEntryModelstatusEnumValueMap,
    )
  },
  estimateSize: _syncOutboxEntryModelEstimateSize,
  serialize: _syncOutboxEntryModelSerialize,
  deserialize: _syncOutboxEntryModelDeserialize,
  deserializeProp: _syncOutboxEntryModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'entryId': IndexSchema(
      id: 3733379884318738402,
      name: r'entryId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'entryId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'entityId': IndexSchema(
      id: 745355021660786263,
      name: r'entityId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entityId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'createdAtIso': IndexSchema(
      id: 8898886970231457701,
      name: r'createdAtIso',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAtIso',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _syncOutboxEntryModelGetId,
  getLinks: _syncOutboxEntryModelGetLinks,
  attach: _syncOutboxEntryModelAttach,
  version: '3.2.0-dev.2',
);

int _syncOutboxEntryModelEstimateSize(
  SyncOutboxEntryModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.completedAtIso;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.createdAtIso.length * 3;
  bytesCount += 3 + object.entityId.length * 3;
  bytesCount += 3 + object.entityType.name.length * 3;
  bytesCount += 3 + object.entryId.length * 3;
  bytesCount += 3 + object.firestorePath.length * 3;
  {
    final value = object.lastAttemptAtIso;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastError;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.metadata.length * 3;
  bytesCount += 3 + object.operationType.name.length * 3;
  bytesCount += 3 + object.payload.length * 3;
  bytesCount += 3 + object.status.name.length * 3;
  return bytesCount;
}

void _syncOutboxEntryModelSerialize(
  SyncOutboxEntryModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.completedAtIso);
  writer.writeString(offsets[1], object.createdAtIso);
  writer.writeString(offsets[2], object.entityId);
  writer.writeString(offsets[3], object.entityType.name);
  writer.writeString(offsets[4], object.entryId);
  writer.writeString(offsets[5], object.firestorePath);
  writer.writeString(offsets[6], object.lastAttemptAtIso);
  writer.writeString(offsets[7], object.lastError);
  writer.writeLong(offsets[8], object.maxRetries);
  writer.writeString(offsets[9], object.metadata);
  writer.writeString(offsets[10], object.operationType.name);
  writer.writeString(offsets[11], object.payload);
  writer.writeLong(offsets[12], object.retryCount);
  writer.writeString(offsets[13], object.status.name);
}

SyncOutboxEntryModel _syncOutboxEntryModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SyncOutboxEntryModel();
  object.completedAtIso = reader.readStringOrNull(offsets[0]);
  object.createdAtIso = reader.readString(offsets[1]);
  object.entityId = reader.readString(offsets[2]);
  object.entityType = _SyncOutboxEntryModelentityTypeValueEnumMap[
          reader.readStringOrNull(offsets[3])] ??
      SyncEntityType.asset;
  object.entryId = reader.readString(offsets[4]);
  object.firestorePath = reader.readString(offsets[5]);
  object.id = id;
  object.lastAttemptAtIso = reader.readStringOrNull(offsets[6]);
  object.lastError = reader.readStringOrNull(offsets[7]);
  object.maxRetries = reader.readLong(offsets[8]);
  object.metadata = reader.readString(offsets[9]);
  object.operationType = _SyncOutboxEntryModeloperationTypeValueEnumMap[
          reader.readStringOrNull(offsets[10])] ??
      SyncOperationType.create;
  object.payload = reader.readString(offsets[11]);
  object.retryCount = reader.readLong(offsets[12]);
  object.status = _SyncOutboxEntryModelstatusValueEnumMap[
          reader.readStringOrNull(offsets[13])] ??
      SyncStatus.pending;
  return object;
}

P _syncOutboxEntryModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_SyncOutboxEntryModelentityTypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncEntityType.asset) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (_SyncOutboxEntryModeloperationTypeValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncOperationType.create) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (_SyncOutboxEntryModelstatusValueEnumMap[
              reader.readStringOrNull(offset)] ??
          SyncStatus.pending) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _SyncOutboxEntryModelentityTypeEnumValueMap = {
  r'asset': r'asset',
  r'assetDraft': r'assetDraft',
  r'auditLog': r'auditLog',
  r'userAssetRef': r'userAssetRef',
  r'portfolio': r'portfolio',
};
const _SyncOutboxEntryModelentityTypeValueEnumMap = {
  r'asset': SyncEntityType.asset,
  r'assetDraft': SyncEntityType.assetDraft,
  r'auditLog': SyncEntityType.auditLog,
  r'userAssetRef': SyncEntityType.userAssetRef,
  r'portfolio': SyncEntityType.portfolio,
};
const _SyncOutboxEntryModeloperationTypeEnumValueMap = {
  r'create': r'create',
  r'update': r'update',
  r'delete': r'delete',
  r'batch': r'batch',
};
const _SyncOutboxEntryModeloperationTypeValueEnumMap = {
  r'create': SyncOperationType.create,
  r'update': SyncOperationType.update,
  r'delete': SyncOperationType.delete,
  r'batch': SyncOperationType.batch,
};
const _SyncOutboxEntryModelstatusEnumValueMap = {
  r'pending': r'pending',
  r'inProgress': r'inProgress',
  r'completed': r'completed',
  r'failed': r'failed',
  r'deadLetter': r'deadLetter',
};
const _SyncOutboxEntryModelstatusValueEnumMap = {
  r'pending': SyncStatus.pending,
  r'inProgress': SyncStatus.inProgress,
  r'completed': SyncStatus.completed,
  r'failed': SyncStatus.failed,
  r'deadLetter': SyncStatus.deadLetter,
};

Id _syncOutboxEntryModelGetId(SyncOutboxEntryModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _syncOutboxEntryModelGetLinks(
    SyncOutboxEntryModel object) {
  return [];
}

void _syncOutboxEntryModelAttach(
    IsarCollection<dynamic> col, Id id, SyncOutboxEntryModel object) {
  object.id = id;
}

extension SyncOutboxEntryModelByIndex on IsarCollection<SyncOutboxEntryModel> {
  Future<SyncOutboxEntryModel?> getByEntryId(String entryId) {
    return getByIndex(r'entryId', [entryId]);
  }

  SyncOutboxEntryModel? getByEntryIdSync(String entryId) {
    return getByIndexSync(r'entryId', [entryId]);
  }

  Future<bool> deleteByEntryId(String entryId) {
    return deleteByIndex(r'entryId', [entryId]);
  }

  bool deleteByEntryIdSync(String entryId) {
    return deleteByIndexSync(r'entryId', [entryId]);
  }

  Future<List<SyncOutboxEntryModel?>> getAllByEntryId(
      List<String> entryIdValues) {
    final values = entryIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'entryId', values);
  }

  List<SyncOutboxEntryModel?> getAllByEntryIdSync(List<String> entryIdValues) {
    final values = entryIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'entryId', values);
  }

  Future<int> deleteAllByEntryId(List<String> entryIdValues) {
    final values = entryIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'entryId', values);
  }

  int deleteAllByEntryIdSync(List<String> entryIdValues) {
    final values = entryIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'entryId', values);
  }

  Future<Id> putByEntryId(SyncOutboxEntryModel object) {
    return putByIndex(r'entryId', object);
  }

  Id putByEntryIdSync(SyncOutboxEntryModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'entryId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEntryId(List<SyncOutboxEntryModel> objects) {
    return putAllByIndex(r'entryId', objects);
  }

  List<Id> putAllByEntryIdSync(List<SyncOutboxEntryModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'entryId', objects, saveLinks: saveLinks);
  }
}

extension SyncOutboxEntryModelQueryWhereSort
    on QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QWhere> {
  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SyncOutboxEntryModelQueryWhere
    on QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QWhereClause> {
  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterWhereClause>
      entryIdEqualTo(String entryId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entryId',
        value: [entryId],
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterWhereClause>
      entryIdNotEqualTo(String entryId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entryId',
              lower: [],
              upper: [entryId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entryId',
              lower: [entryId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entryId',
              lower: [entryId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entryId',
              lower: [],
              upper: [entryId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterWhereClause>
      entityIdEqualTo(String entityId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entityId',
        value: [entityId],
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterWhereClause>
      entityIdNotEqualTo(String entityId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [],
              upper: [entityId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [entityId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [entityId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [],
              upper: [entityId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterWhereClause>
      createdAtIsoEqualTo(String createdAtIso) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAtIso',
        value: [createdAtIso],
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterWhereClause>
      createdAtIsoNotEqualTo(String createdAtIso) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAtIso',
              lower: [],
              upper: [createdAtIso],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAtIso',
              lower: [createdAtIso],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAtIso',
              lower: [createdAtIso],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAtIso',
              lower: [],
              upper: [createdAtIso],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SyncOutboxEntryModelQueryFilter on QueryBuilder<SyncOutboxEntryModel,
    SyncOutboxEntryModel, QFilterCondition> {
  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> completedAtIsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAtIso',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> completedAtIsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAtIso',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> completedAtIsoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> completedAtIsoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> completedAtIsoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> completedAtIsoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAtIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> completedAtIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'completedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> completedAtIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'completedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      completedAtIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'completedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      completedAtIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'completedAtIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> completedAtIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> completedAtIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'completedAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> createdAtIsoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> createdAtIsoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> createdAtIsoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> createdAtIsoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAtIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> createdAtIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> createdAtIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      createdAtIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      createdAtIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdAtIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> createdAtIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> createdAtIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      entityIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      entityIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entityId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entityId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityTypeEqualTo(
    SyncEntityType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityTypeGreaterThan(
    SyncEntityType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityTypeLessThan(
    SyncEntityType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityTypeBetween(
    SyncEntityType lower,
    SyncEntityType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entityType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      entityTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      entityTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entityType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityType',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entityTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entityType',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entryIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entryIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entryIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entryIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entryIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entryIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      entryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      entryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entryId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entryId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> entryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entryId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> firestorePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firestorePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> firestorePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firestorePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> firestorePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firestorePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> firestorePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firestorePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> firestorePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'firestorePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> firestorePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'firestorePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      firestorePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'firestorePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      firestorePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'firestorePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> firestorePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firestorePath',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> firestorePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'firestorePath',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastAttemptAtIsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastAttemptAtIso',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastAttemptAtIsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastAttemptAtIso',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastAttemptAtIsoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAttemptAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastAttemptAtIsoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAttemptAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastAttemptAtIsoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAttemptAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastAttemptAtIsoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAttemptAtIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastAttemptAtIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastAttemptAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastAttemptAtIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastAttemptAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      lastAttemptAtIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastAttemptAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      lastAttemptAtIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastAttemptAtIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastAttemptAtIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAttemptAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastAttemptAtIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastAttemptAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastErrorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastError',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastErrorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastError',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
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

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
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

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
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

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
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

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
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

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
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

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
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

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
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

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastErrorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastError',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> lastErrorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastError',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> maxRetriesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxRetries',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> maxRetriesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxRetries',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> maxRetriesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxRetries',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> maxRetriesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxRetries',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> metadataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> metadataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> metadataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> metadataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metadata',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> metadataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> metadataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      metadataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      metadataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'metadata',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> metadataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadata',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> metadataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'metadata',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> operationTypeEqualTo(
    SyncOperationType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> operationTypeGreaterThan(
    SyncOperationType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'operationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> operationTypeLessThan(
    SyncOperationType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'operationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> operationTypeBetween(
    SyncOperationType lower,
    SyncOperationType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'operationType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> operationTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'operationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> operationTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'operationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      operationTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'operationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      operationTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'operationType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> operationTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operationType',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> operationTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'operationType',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> payloadEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> payloadGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'payload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> payloadLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'payload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> payloadBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'payload',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> payloadStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'payload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> payloadEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'payload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      payloadContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'payload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      payloadMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'payload',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> payloadIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payload',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> payloadIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'payload',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> retryCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> retryCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> retryCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> retryCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retryCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> statusEqualTo(
    SyncStatus value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> statusGreaterThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> statusLessThan(
    SyncStatus value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> statusBetween(
    SyncStatus lower,
    SyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
          QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel,
      QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }
}

extension SyncOutboxEntryModelQueryObject on QueryBuilder<SyncOutboxEntryModel,
    SyncOutboxEntryModel, QFilterCondition> {}

extension SyncOutboxEntryModelQueryLinks on QueryBuilder<SyncOutboxEntryModel,
    SyncOutboxEntryModel, QFilterCondition> {}

extension SyncOutboxEntryModelQuerySortBy
    on QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QSortBy> {
  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByCompletedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAtIso', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByCompletedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAtIso', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByCreatedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtIso', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByCreatedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtIso', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryId', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryId', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByFirestorePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firestorePath', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByFirestorePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firestorePath', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByLastAttemptAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAtIso', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByLastAttemptAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAtIso', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByMaxRetries() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxRetries', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByMaxRetriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxRetries', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByOperationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByOperationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByPayload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payload', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByPayloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payload', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension SyncOutboxEntryModelQuerySortThenBy
    on QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QSortThenBy> {
  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByCompletedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAtIso', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByCompletedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAtIso', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByCreatedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtIso', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByCreatedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtIso', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByEntryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryId', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByEntryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entryId', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByFirestorePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firestorePath', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByFirestorePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firestorePath', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByLastAttemptAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAtIso', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByLastAttemptAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAtIso', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByMaxRetries() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxRetries', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByMaxRetriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxRetries', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByOperationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByOperationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationType', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByPayload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payload', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByPayloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payload', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension SyncOutboxEntryModelQueryWhereDistinct
    on QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct> {
  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByCompletedAtIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAtIso',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByCreatedAtIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAtIso', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByEntityId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByEntityType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByEntryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByFirestorePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firestorePath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByLastAttemptAtIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAttemptAtIso',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByLastError({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastError', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByMaxRetries() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxRetries');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByMetadata({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metadata', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByOperationType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'operationType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByPayload({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payload', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retryCount');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOutboxEntryModel, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }
}

extension SyncOutboxEntryModelQueryProperty on QueryBuilder<
    SyncOutboxEntryModel, SyncOutboxEntryModel, QQueryProperty> {
  QueryBuilder<SyncOutboxEntryModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, String?, QQueryOperations>
      completedAtIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAtIso');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, String, QQueryOperations>
      createdAtIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAtIso');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, String, QQueryOperations>
      entityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityId');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncEntityType, QQueryOperations>
      entityTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityType');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, String, QQueryOperations>
      entryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entryId');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, String, QQueryOperations>
      firestorePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firestorePath');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, String?, QQueryOperations>
      lastAttemptAtIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAttemptAtIso');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, String?, QQueryOperations>
      lastErrorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastError');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, int, QQueryOperations>
      maxRetriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxRetries');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, String, QQueryOperations>
      metadataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metadata');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncOperationType, QQueryOperations>
      operationTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'operationType');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, String, QQueryOperations>
      payloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payload');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, int, QQueryOperations>
      retryCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retryCount');
    });
  }

  QueryBuilder<SyncOutboxEntryModel, SyncStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
