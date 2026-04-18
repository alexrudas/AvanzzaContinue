// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_receivable_projection_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAccountReceivableProjectionEntityCollection on Isar {
  IsarCollection<AccountReceivableProjectionEntity>
      get accountReceivableProjectionEntitys => this.collection();
}

const AccountReceivableProjectionEntitySchema = CollectionSchema(
  name: r'AccountReceivableProjectionEntity',
  id: 8611621706829397971,
  properties: {
    r'entityId': PropertySchema(
      id: 0,
      name: r'entityId',
      type: IsarType.string,
    ),
    r'estadoWire': PropertySchema(
      id: 1,
      name: r'estadoWire',
      type: IsarType.string,
    ),
    r'lastEventHash': PropertySchema(
      id: 2,
      name: r'lastEventHash',
      type: IsarType.string,
    ),
    r'saldoActualCop': PropertySchema(
      id: 3,
      name: r'saldoActualCop',
      type: IsarType.long,
    ),
    r'totalRecaudadoCop': PropertySchema(
      id: 4,
      name: r'totalRecaudadoCop',
      type: IsarType.long,
    ),
    r'updatedAtIso': PropertySchema(
      id: 5,
      name: r'updatedAtIso',
      type: IsarType.string,
    )
  },
  estimateSize: _accountReceivableProjectionEntityEstimateSize,
  serialize: _accountReceivableProjectionEntitySerialize,
  deserialize: _accountReceivableProjectionEntityDeserialize,
  deserializeProp: _accountReceivableProjectionEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'entityId': IndexSchema(
      id: 745355021660786263,
      name: r'entityId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'entityId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'estadoWire': IndexSchema(
      id: -8950589124367851628,
      name: r'estadoWire',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'estadoWire',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'updatedAtIso': IndexSchema(
      id: 6055963156911584833,
      name: r'updatedAtIso',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAtIso',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _accountReceivableProjectionEntityGetId,
  getLinks: _accountReceivableProjectionEntityGetLinks,
  attach: _accountReceivableProjectionEntityAttach,
  version: '3.3.0-dev.1',
);

int _accountReceivableProjectionEntityEstimateSize(
  AccountReceivableProjectionEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.entityId.length * 3;
  bytesCount += 3 + object.estadoWire.length * 3;
  {
    final value = object.lastEventHash;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.updatedAtIso.length * 3;
  return bytesCount;
}

void _accountReceivableProjectionEntitySerialize(
  AccountReceivableProjectionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.entityId);
  writer.writeString(offsets[1], object.estadoWire);
  writer.writeString(offsets[2], object.lastEventHash);
  writer.writeLong(offsets[3], object.saldoActualCop);
  writer.writeLong(offsets[4], object.totalRecaudadoCop);
  writer.writeString(offsets[5], object.updatedAtIso);
}

AccountReceivableProjectionEntity _accountReceivableProjectionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AccountReceivableProjectionEntity();
  object.entityId = reader.readString(offsets[0]);
  object.estadoWire = reader.readString(offsets[1]);
  object.id = id;
  object.lastEventHash = reader.readStringOrNull(offsets[2]);
  object.saldoActualCop = reader.readLong(offsets[3]);
  object.totalRecaudadoCop = reader.readLong(offsets[4]);
  object.updatedAtIso = reader.readString(offsets[5]);
  return object;
}

P _accountReceivableProjectionEntityDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _accountReceivableProjectionEntityGetId(
    AccountReceivableProjectionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _accountReceivableProjectionEntityGetLinks(
    AccountReceivableProjectionEntity object) {
  return [];
}

void _accountReceivableProjectionEntityAttach(IsarCollection<dynamic> col,
    Id id, AccountReceivableProjectionEntity object) {
  object.id = id;
}

extension AccountReceivableProjectionEntityByIndex
    on IsarCollection<AccountReceivableProjectionEntity> {
  Future<AccountReceivableProjectionEntity?> getByEntityId(String entityId) {
    return getByIndex(r'entityId', [entityId]);
  }

  AccountReceivableProjectionEntity? getByEntityIdSync(String entityId) {
    return getByIndexSync(r'entityId', [entityId]);
  }

  Future<bool> deleteByEntityId(String entityId) {
    return deleteByIndex(r'entityId', [entityId]);
  }

  bool deleteByEntityIdSync(String entityId) {
    return deleteByIndexSync(r'entityId', [entityId]);
  }

  Future<List<AccountReceivableProjectionEntity?>> getAllByEntityId(
      List<String> entityIdValues) {
    final values = entityIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'entityId', values);
  }

  List<AccountReceivableProjectionEntity?> getAllByEntityIdSync(
      List<String> entityIdValues) {
    final values = entityIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'entityId', values);
  }

  Future<int> deleteAllByEntityId(List<String> entityIdValues) {
    final values = entityIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'entityId', values);
  }

  int deleteAllByEntityIdSync(List<String> entityIdValues) {
    final values = entityIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'entityId', values);
  }

  Future<Id> putByEntityId(AccountReceivableProjectionEntity object) {
    return putByIndex(r'entityId', object);
  }

  Id putByEntityIdSync(AccountReceivableProjectionEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'entityId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEntityId(
      List<AccountReceivableProjectionEntity> objects) {
    return putAllByIndex(r'entityId', objects);
  }

  List<Id> putAllByEntityIdSync(List<AccountReceivableProjectionEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'entityId', objects, saveLinks: saveLinks);
  }
}

extension AccountReceivableProjectionEntityQueryWhereSort on QueryBuilder<
    AccountReceivableProjectionEntity,
    AccountReceivableProjectionEntity,
    QWhere> {
  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AccountReceivableProjectionEntityQueryWhere on QueryBuilder<
    AccountReceivableProjectionEntity,
    AccountReceivableProjectionEntity,
    QWhereClause> {
  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterWhereClause> entityIdEqualTo(String entityId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entityId',
        value: [entityId],
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterWhereClause> entityIdNotEqualTo(String entityId) {
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

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterWhereClause> estadoWireEqualTo(String estadoWire) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'estadoWire',
        value: [estadoWire],
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterWhereClause> estadoWireNotEqualTo(String estadoWire) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'estadoWire',
              lower: [],
              upper: [estadoWire],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'estadoWire',
              lower: [estadoWire],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'estadoWire',
              lower: [estadoWire],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'estadoWire',
              lower: [],
              upper: [estadoWire],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterWhereClause> updatedAtIsoEqualTo(String updatedAtIso) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAtIso',
        value: [updatedAtIso],
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterWhereClause> updatedAtIsoNotEqualTo(String updatedAtIso) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAtIso',
              lower: [],
              upper: [updatedAtIso],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAtIso',
              lower: [updatedAtIso],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAtIso',
              lower: [updatedAtIso],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAtIso',
              lower: [],
              upper: [updatedAtIso],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AccountReceivableProjectionEntityQueryFilter on QueryBuilder<
    AccountReceivableProjectionEntity,
    AccountReceivableProjectionEntity,
    QFilterCondition> {
  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterFilterCondition> entityIdEqualTo(
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

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
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

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
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

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterFilterCondition> entityIdBetween(
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

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
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

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
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

  QueryBuilder<AccountReceivableProjectionEntity,
          AccountReceivableProjectionEntity, QAfterFilterCondition>
      entityIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
          AccountReceivableProjectionEntity, QAfterFilterCondition>
      entityIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entityId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> entityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityId',
        value: '',
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> entityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entityId',
        value: '',
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> estadoWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estadoWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> estadoWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estadoWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> estadoWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estadoWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> estadoWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estadoWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> estadoWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'estadoWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> estadoWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'estadoWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
          AccountReceivableProjectionEntity, QAfterFilterCondition>
      estadoWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'estadoWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
          AccountReceivableProjectionEntity, QAfterFilterCondition>
      estadoWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'estadoWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> estadoWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estadoWire',
        value: '',
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> estadoWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'estadoWire',
        value: '',
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> lastEventHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastEventHash',
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> lastEventHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastEventHash',
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> lastEventHashEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastEventHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> lastEventHashGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastEventHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> lastEventHashLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastEventHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> lastEventHashBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastEventHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> lastEventHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastEventHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> lastEventHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastEventHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
          AccountReceivableProjectionEntity, QAfterFilterCondition>
      lastEventHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastEventHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
          AccountReceivableProjectionEntity, QAfterFilterCondition>
      lastEventHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastEventHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> lastEventHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastEventHash',
        value: '',
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> lastEventHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastEventHash',
        value: '',
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> saldoActualCopEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'saldoActualCop',
        value: value,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> saldoActualCopGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'saldoActualCop',
        value: value,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> saldoActualCopLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'saldoActualCop',
        value: value,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> saldoActualCopBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'saldoActualCop',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> totalRecaudadoCopEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalRecaudadoCop',
        value: value,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> totalRecaudadoCopGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalRecaudadoCop',
        value: value,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> totalRecaudadoCopLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalRecaudadoCop',
        value: value,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> totalRecaudadoCopBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalRecaudadoCop',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> updatedAtIsoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> updatedAtIsoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> updatedAtIsoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> updatedAtIsoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAtIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> updatedAtIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'updatedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> updatedAtIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'updatedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
          AccountReceivableProjectionEntity, QAfterFilterCondition>
      updatedAtIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'updatedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
          AccountReceivableProjectionEntity, QAfterFilterCondition>
      updatedAtIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'updatedAtIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> updatedAtIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterFilterCondition> updatedAtIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'updatedAtIso',
        value: '',
      ));
    });
  }
}

extension AccountReceivableProjectionEntityQueryObject on QueryBuilder<
    AccountReceivableProjectionEntity,
    AccountReceivableProjectionEntity,
    QFilterCondition> {}

extension AccountReceivableProjectionEntityQueryLinks on QueryBuilder<
    AccountReceivableProjectionEntity,
    AccountReceivableProjectionEntity,
    QFilterCondition> {}

extension AccountReceivableProjectionEntityQuerySortBy on QueryBuilder<
    AccountReceivableProjectionEntity,
    AccountReceivableProjectionEntity,
    QSortBy> {
  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> sortByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> sortByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> sortByEstadoWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estadoWire', Sort.asc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> sortByEstadoWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estadoWire', Sort.desc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> sortByLastEventHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEventHash', Sort.asc);
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterSortBy> sortByLastEventHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEventHash', Sort.desc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> sortBySaldoActualCop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saldoActualCop', Sort.asc);
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterSortBy> sortBySaldoActualCopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saldoActualCop', Sort.desc);
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterSortBy> sortByTotalRecaudadoCop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRecaudadoCop', Sort.asc);
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterSortBy> sortByTotalRecaudadoCopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRecaudadoCop', Sort.desc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> sortByUpdatedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtIso', Sort.asc);
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterSortBy> sortByUpdatedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtIso', Sort.desc);
    });
  }
}

extension AccountReceivableProjectionEntityQuerySortThenBy on QueryBuilder<
    AccountReceivableProjectionEntity,
    AccountReceivableProjectionEntity,
    QSortThenBy> {
  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> thenByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> thenByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> thenByEstadoWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estadoWire', Sort.asc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> thenByEstadoWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estadoWire', Sort.desc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> thenByLastEventHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEventHash', Sort.asc);
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterSortBy> thenByLastEventHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEventHash', Sort.desc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> thenBySaldoActualCop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saldoActualCop', Sort.asc);
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterSortBy> thenBySaldoActualCopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'saldoActualCop', Sort.desc);
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterSortBy> thenByTotalRecaudadoCop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRecaudadoCop', Sort.asc);
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterSortBy> thenByTotalRecaudadoCopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRecaudadoCop', Sort.desc);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QAfterSortBy> thenByUpdatedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtIso', Sort.asc);
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QAfterSortBy> thenByUpdatedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtIso', Sort.desc);
    });
  }
}

extension AccountReceivableProjectionEntityQueryWhereDistinct on QueryBuilder<
    AccountReceivableProjectionEntity,
    AccountReceivableProjectionEntity,
    QDistinct> {
  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QDistinct> distinctByEntityId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QDistinct> distinctByEstadoWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estadoWire', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QDistinct> distinctByLastEventHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastEventHash',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity, QDistinct> distinctBySaldoActualCop() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'saldoActualCop');
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QDistinct> distinctByTotalRecaudadoCop() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalRecaudadoCop');
    });
  }

  QueryBuilder<
      AccountReceivableProjectionEntity,
      AccountReceivableProjectionEntity,
      QDistinct> distinctByUpdatedAtIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAtIso', caseSensitive: caseSensitive);
    });
  }
}

extension AccountReceivableProjectionEntityQueryProperty on QueryBuilder<
    AccountReceivableProjectionEntity,
    AccountReceivableProjectionEntity,
    QQueryProperty> {
  QueryBuilder<AccountReceivableProjectionEntity, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity, String, QQueryOperations>
      entityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityId');
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity, String, QQueryOperations>
      estadoWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estadoWire');
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity, String?, QQueryOperations>
      lastEventHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastEventHash');
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity, int, QQueryOperations>
      saldoActualCopProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'saldoActualCop');
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity, int, QQueryOperations>
      totalRecaudadoCopProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalRecaudadoCop');
    });
  }

  QueryBuilder<AccountReceivableProjectionEntity, String, QQueryOperations>
      updatedAtIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAtIso');
    });
  }
}
