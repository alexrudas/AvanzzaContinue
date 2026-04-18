// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_actor_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlatformActorModelCollection on Isar {
  IsarCollection<PlatformActorModel> get platformActorModels =>
      this.collection();
}

const PlatformActorModelSchema = CollectionSchema(
  name: r'PlatformActorModel',
  id: 4365109833864308705,
  properties: {
    r'actorKindWire': PropertySchema(
      id: 0,
      name: r'actorKindWire',
      type: IsarType.string,
    ),
    r'avatarRef': PropertySchema(
      id: 1,
      name: r'avatarRef',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'displayName': PropertySchema(
      id: 3,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'fullLegalName': PropertySchema(
      id: 4,
      name: r'fullLegalName',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 5,
      name: r'id',
      type: IsarType.string,
    ),
    r'legalName': PropertySchema(
      id: 6,
      name: r'legalName',
      type: IsarType.string,
    ),
    r'linkedUserId': PropertySchema(
      id: 7,
      name: r'linkedUserId',
      type: IsarType.string,
    ),
    r'primaryVerifiedKeyId': PropertySchema(
      id: 8,
      name: r'primaryVerifiedKeyId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _platformActorModelEstimateSize,
  serialize: _platformActorModelSerialize,
  deserialize: _platformActorModelDeserialize,
  deserializeProp: _platformActorModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _platformActorModelGetId,
  getLinks: _platformActorModelGetLinks,
  attach: _platformActorModelAttach,
  version: '3.3.0-dev.1',
);

int _platformActorModelEstimateSize(
  PlatformActorModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.actorKindWire.length * 3;
  {
    final value = object.avatarRef;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.displayName.length * 3;
  {
    final value = object.fullLegalName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.legalName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.linkedUserId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.primaryVerifiedKeyId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _platformActorModelSerialize(
  PlatformActorModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actorKindWire);
  writer.writeString(offsets[1], object.avatarRef);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.displayName);
  writer.writeString(offsets[4], object.fullLegalName);
  writer.writeString(offsets[5], object.id);
  writer.writeString(offsets[6], object.legalName);
  writer.writeString(offsets[7], object.linkedUserId);
  writer.writeString(offsets[8], object.primaryVerifiedKeyId);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

PlatformActorModel _platformActorModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlatformActorModel(
    actorKindWire: reader.readString(offsets[0]),
    avatarRef: reader.readStringOrNull(offsets[1]),
    createdAt: reader.readDateTime(offsets[2]),
    displayName: reader.readString(offsets[3]),
    fullLegalName: reader.readStringOrNull(offsets[4]),
    id: reader.readString(offsets[5]),
    isarId: id,
    legalName: reader.readStringOrNull(offsets[6]),
    linkedUserId: reader.readStringOrNull(offsets[7]),
    primaryVerifiedKeyId: reader.readStringOrNull(offsets[8]),
    updatedAt: reader.readDateTime(offsets[9]),
  );
  return object;
}

P _platformActorModelDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _platformActorModelGetId(PlatformActorModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _platformActorModelGetLinks(
    PlatformActorModel object) {
  return [];
}

void _platformActorModelAttach(
    IsarCollection<dynamic> col, Id id, PlatformActorModel object) {
  object.isarId = id;
}

extension PlatformActorModelByIndex on IsarCollection<PlatformActorModel> {
  Future<PlatformActorModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  PlatformActorModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<PlatformActorModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<PlatformActorModel?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(PlatformActorModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(PlatformActorModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<PlatformActorModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<PlatformActorModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension PlatformActorModelQueryWhereSort
    on QueryBuilder<PlatformActorModel, PlatformActorModel, QWhere> {
  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlatformActorModelQueryWhere
    on QueryBuilder<PlatformActorModel, PlatformActorModel, QWhereClause> {
  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterWhereClause>
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterWhereClause>
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterWhereClause>
      idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PlatformActorModelQueryFilter
    on QueryBuilder<PlatformActorModel, PlatformActorModel, QFilterCondition> {
  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      actorKindWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actorKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      actorKindWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actorKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      actorKindWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actorKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      actorKindWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actorKindWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      actorKindWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actorKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      actorKindWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actorKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      actorKindWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actorKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      actorKindWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actorKindWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      actorKindWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actorKindWire',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      actorKindWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actorKindWire',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      avatarRefIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'avatarRef',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      avatarRefIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'avatarRef',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      avatarRefEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatarRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      avatarRefGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avatarRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      avatarRefLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avatarRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      avatarRefBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avatarRef',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      avatarRefStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'avatarRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      avatarRefEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'avatarRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      avatarRefContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'avatarRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      avatarRefMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'avatarRef',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      avatarRefIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatarRef',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      avatarRefIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'avatarRef',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      fullLegalNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fullLegalName',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      fullLegalNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fullLegalName',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      fullLegalNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullLegalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      fullLegalNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullLegalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      fullLegalNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullLegalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      fullLegalNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullLegalName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      fullLegalNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullLegalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      fullLegalNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullLegalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      fullLegalNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullLegalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      fullLegalNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullLegalName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      fullLegalNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullLegalName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      fullLegalNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullLegalName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      legalNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'legalName',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      legalNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'legalName',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      legalNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      legalNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      legalNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      legalNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'legalName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      legalNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      legalNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      legalNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      legalNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'legalName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      legalNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'legalName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      legalNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'legalName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      linkedUserIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'linkedUserId',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      linkedUserIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'linkedUserId',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      linkedUserIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      linkedUserIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'linkedUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      linkedUserIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'linkedUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      linkedUserIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'linkedUserId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      linkedUserIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'linkedUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      linkedUserIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'linkedUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      linkedUserIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'linkedUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      linkedUserIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'linkedUserId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      linkedUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      linkedUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'linkedUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      primaryVerifiedKeyIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'primaryVerifiedKeyId',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      primaryVerifiedKeyIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'primaryVerifiedKeyId',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      primaryVerifiedKeyIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryVerifiedKeyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      primaryVerifiedKeyIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primaryVerifiedKeyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      primaryVerifiedKeyIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primaryVerifiedKeyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      primaryVerifiedKeyIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primaryVerifiedKeyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      primaryVerifiedKeyIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'primaryVerifiedKeyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      primaryVerifiedKeyIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'primaryVerifiedKeyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      primaryVerifiedKeyIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryVerifiedKeyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      primaryVerifiedKeyIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryVerifiedKeyId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      primaryVerifiedKeyIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryVerifiedKeyId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      primaryVerifiedKeyIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryVerifiedKeyId',
        value: '',
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
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

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterFilterCondition>
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
}

extension PlatformActorModelQueryObject
    on QueryBuilder<PlatformActorModel, PlatformActorModel, QFilterCondition> {}

extension PlatformActorModelQueryLinks
    on QueryBuilder<PlatformActorModel, PlatformActorModel, QFilterCondition> {}

extension PlatformActorModelQuerySortBy
    on QueryBuilder<PlatformActorModel, PlatformActorModel, QSortBy> {
  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByActorKindWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorKindWire', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByActorKindWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorKindWire', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByAvatarRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarRef', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByAvatarRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarRef', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByFullLegalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullLegalName', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByFullLegalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullLegalName', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByLegalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legalName', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByLegalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legalName', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByLinkedUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedUserId', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByLinkedUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedUserId', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByPrimaryVerifiedKeyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryVerifiedKeyId', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByPrimaryVerifiedKeyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryVerifiedKeyId', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PlatformActorModelQuerySortThenBy
    on QueryBuilder<PlatformActorModel, PlatformActorModel, QSortThenBy> {
  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByActorKindWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorKindWire', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByActorKindWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorKindWire', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByAvatarRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarRef', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByAvatarRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarRef', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByFullLegalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullLegalName', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByFullLegalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullLegalName', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByLegalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legalName', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByLegalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legalName', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByLinkedUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedUserId', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByLinkedUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedUserId', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByPrimaryVerifiedKeyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryVerifiedKeyId', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByPrimaryVerifiedKeyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryVerifiedKeyId', Sort.desc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PlatformActorModelQueryWhereDistinct
    on QueryBuilder<PlatformActorModel, PlatformActorModel, QDistinct> {
  QueryBuilder<PlatformActorModel, PlatformActorModel, QDistinct>
      distinctByActorKindWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actorKindWire',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QDistinct>
      distinctByAvatarRef({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avatarRef', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QDistinct>
      distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QDistinct>
      distinctByFullLegalName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullLegalName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QDistinct>
      distinctByLegalName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'legalName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QDistinct>
      distinctByLinkedUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linkedUserId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QDistinct>
      distinctByPrimaryVerifiedKeyId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryVerifiedKeyId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlatformActorModel, PlatformActorModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension PlatformActorModelQueryProperty
    on QueryBuilder<PlatformActorModel, PlatformActorModel, QQueryProperty> {
  QueryBuilder<PlatformActorModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<PlatformActorModel, String, QQueryOperations>
      actorKindWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actorKindWire');
    });
  }

  QueryBuilder<PlatformActorModel, String?, QQueryOperations>
      avatarRefProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avatarRef');
    });
  }

  QueryBuilder<PlatformActorModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PlatformActorModel, String, QQueryOperations>
      displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<PlatformActorModel, String?, QQueryOperations>
      fullLegalNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullLegalName');
    });
  }

  QueryBuilder<PlatformActorModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlatformActorModel, String?, QQueryOperations>
      legalNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'legalName');
    });
  }

  QueryBuilder<PlatformActorModel, String?, QQueryOperations>
      linkedUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkedUserId');
    });
  }

  QueryBuilder<PlatformActorModel, String?, QQueryOperations>
      primaryVerifiedKeyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryVerifiedKeyId');
    });
  }

  QueryBuilder<PlatformActorModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlatformActorModel _$PlatformActorModelFromJson(Map<String, dynamic> json) =>
    PlatformActorModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      actorKindWire: json['actorKindWire'] as String,
      displayName: json['displayName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      legalName: json['legalName'] as String?,
      fullLegalName: json['fullLegalName'] as String?,
      avatarRef: json['avatarRef'] as String?,
      primaryVerifiedKeyId: json['primaryVerifiedKeyId'] as String?,
      linkedUserId: json['linkedUserId'] as String?,
    );

Map<String, dynamic> _$PlatformActorModelToJson(PlatformActorModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'actorKindWire': instance.actorKindWire,
      'displayName': instance.displayName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'legalName': instance.legalName,
      'fullLegalName': instance.fullLegalName,
      'avatarRef': instance.avatarRef,
      'primaryVerifiedKeyId': instance.primaryVerifiedKeyId,
      'linkedUserId': instance.linkedUserId,
    };
