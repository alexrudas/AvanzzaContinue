// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserSessionModelCollection on Isar {
  IsarCollection<UserSessionModel> get userSessionModels => this.collection();
}

const UserSessionModelSchema = CollectionSchema(
  name: r'UserSessionModel',
  id: 5302808398292509013,
  properties: {
    r'activeContextJson': PropertySchema(
      id: 0,
      name: r'activeContextJson',
      type: IsarType.string,
    ),
    r'deviceId': PropertySchema(
      id: 1,
      name: r'deviceId',
      type: IsarType.string,
    ),
    r'featureFlagsJson': PropertySchema(
      id: 2,
      name: r'featureFlagsJson',
      type: IsarType.string,
    ),
    r'idToken': PropertySchema(
      id: 3,
      name: r'idToken',
      type: IsarType.string,
    ),
    r'lastLoginAt': PropertySchema(
      id: 4,
      name: r'lastLoginAt',
      type: IsarType.dateTime,
    ),
    r'refreshToken': PropertySchema(
      id: 5,
      name: r'refreshToken',
      type: IsarType.string,
    ),
    r'uid': PropertySchema(
      id: 6,
      name: r'uid',
      type: IsarType.string,
    )
  },
  estimateSize: _userSessionModelEstimateSize,
  serialize: _userSessionModelSerialize,
  deserialize: _userSessionModelDeserialize,
  deserializeProp: _userSessionModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _userSessionModelGetId,
  getLinks: _userSessionModelGetLinks,
  attach: _userSessionModelAttach,
  version: '3.2.0-dev.2',
);

int _userSessionModelEstimateSize(
  UserSessionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.activeContextJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.deviceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.featureFlagsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.idToken;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.refreshToken;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _userSessionModelSerialize(
  UserSessionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activeContextJson);
  writer.writeString(offsets[1], object.deviceId);
  writer.writeString(offsets[2], object.featureFlagsJson);
  writer.writeString(offsets[3], object.idToken);
  writer.writeDateTime(offsets[4], object.lastLoginAt);
  writer.writeString(offsets[5], object.refreshToken);
  writer.writeString(offsets[6], object.uid);
}

UserSessionModel _userSessionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserSessionModel();
  object.activeContextJson = reader.readStringOrNull(offsets[0]);
  object.deviceId = reader.readStringOrNull(offsets[1]);
  object.featureFlagsJson = reader.readStringOrNull(offsets[2]);
  object.idToken = reader.readStringOrNull(offsets[3]);
  object.isarId = id;
  object.lastLoginAt = reader.readDateTimeOrNull(offsets[4]);
  object.refreshToken = reader.readStringOrNull(offsets[5]);
  object.uid = reader.readString(offsets[6]);
  return object;
}

P _userSessionModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userSessionModelGetId(UserSessionModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _userSessionModelGetLinks(UserSessionModel object) {
  return [];
}

void _userSessionModelAttach(
    IsarCollection<dynamic> col, Id id, UserSessionModel object) {
  object.isarId = id;
}

extension UserSessionModelByIndex on IsarCollection<UserSessionModel> {
  Future<UserSessionModel?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  UserSessionModel? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<UserSessionModel?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<UserSessionModel?> getAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uid', values);
  }

  Future<int> deleteAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uid', values);
  }

  int deleteAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uid', values);
  }

  Future<Id> putByUid(UserSessionModel object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(UserSessionModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<UserSessionModel> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(List<UserSessionModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension UserSessionModelQueryWhereSort
    on QueryBuilder<UserSessionModel, UserSessionModel, QWhere> {
  QueryBuilder<UserSessionModel, UserSessionModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserSessionModelQueryWhere
    on QueryBuilder<UserSessionModel, UserSessionModel, QWhereClause> {
  QueryBuilder<UserSessionModel, UserSessionModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterWhereClause>
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

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterWhereClause>
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

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterWhereClause>
      uidEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uid',
        value: [uid],
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterWhereClause>
      uidNotEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ));
      }
    });
  }
}

extension UserSessionModelQueryFilter
    on QueryBuilder<UserSessionModel, UserSessionModel, QFilterCondition> {
  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      activeContextJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activeContextJson',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      activeContextJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activeContextJson',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      activeContextJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeContextJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      activeContextJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activeContextJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      activeContextJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activeContextJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      activeContextJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activeContextJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      activeContextJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activeContextJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      activeContextJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activeContextJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      activeContextJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activeContextJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      activeContextJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activeContextJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      activeContextJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeContextJson',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      activeContextJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activeContextJson',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      deviceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deviceId',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      deviceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deviceId',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      deviceIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      deviceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      deviceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      deviceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      deviceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      deviceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      deviceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      deviceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      deviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      deviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      featureFlagsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'featureFlagsJson',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      featureFlagsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'featureFlagsJson',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      featureFlagsJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featureFlagsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      featureFlagsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'featureFlagsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      featureFlagsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'featureFlagsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      featureFlagsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'featureFlagsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      featureFlagsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'featureFlagsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      featureFlagsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'featureFlagsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      featureFlagsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'featureFlagsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      featureFlagsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'featureFlagsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      featureFlagsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featureFlagsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      featureFlagsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'featureFlagsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      idTokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'idToken',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      idTokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'idToken',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      idTokenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      idTokenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      idTokenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      idTokenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      idTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      idTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      idTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      idTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      idTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idToken',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      idTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idToken',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
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

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
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

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
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

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      lastLoginAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastLoginAt',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      lastLoginAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastLoginAt',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      lastLoginAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastLoginAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      lastLoginAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastLoginAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      lastLoginAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastLoginAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      lastLoginAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastLoginAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      refreshTokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'refreshToken',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      refreshTokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'refreshToken',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      refreshTokenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'refreshToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      refreshTokenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'refreshToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      refreshTokenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'refreshToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      refreshTokenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'refreshToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      refreshTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'refreshToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      refreshTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'refreshToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      refreshTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'refreshToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      refreshTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'refreshToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      refreshTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'refreshToken',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      refreshTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'refreshToken',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      uidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      uidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      uidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      uidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      uidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      uidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      uidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      uidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterFilterCondition>
      uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uid',
        value: '',
      ));
    });
  }
}

extension UserSessionModelQueryObject
    on QueryBuilder<UserSessionModel, UserSessionModel, QFilterCondition> {}

extension UserSessionModelQueryLinks
    on QueryBuilder<UserSessionModel, UserSessionModel, QFilterCondition> {}

extension UserSessionModelQuerySortBy
    on QueryBuilder<UserSessionModel, UserSessionModel, QSortBy> {
  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      sortByActiveContextJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeContextJson', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      sortByActiveContextJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeContextJson', Sort.desc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      sortByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      sortByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      sortByFeatureFlagsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureFlagsJson', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      sortByFeatureFlagsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureFlagsJson', Sort.desc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      sortByIdToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idToken', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      sortByIdTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idToken', Sort.desc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      sortByLastLoginAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLoginAt', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      sortByLastLoginAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLoginAt', Sort.desc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      sortByRefreshToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refreshToken', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      sortByRefreshTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refreshToken', Sort.desc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension UserSessionModelQuerySortThenBy
    on QueryBuilder<UserSessionModel, UserSessionModel, QSortThenBy> {
  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByActiveContextJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeContextJson', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByActiveContextJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeContextJson', Sort.desc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByFeatureFlagsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureFlagsJson', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByFeatureFlagsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureFlagsJson', Sort.desc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByIdToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idToken', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByIdTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idToken', Sort.desc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByLastLoginAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLoginAt', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByLastLoginAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastLoginAt', Sort.desc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByRefreshToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refreshToken', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByRefreshTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refreshToken', Sort.desc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QAfterSortBy>
      thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }
}

extension UserSessionModelQueryWhereDistinct
    on QueryBuilder<UserSessionModel, UserSessionModel, QDistinct> {
  QueryBuilder<UserSessionModel, UserSessionModel, QDistinct>
      distinctByActiveContextJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeContextJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QDistinct>
      distinctByDeviceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QDistinct>
      distinctByFeatureFlagsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'featureFlagsJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QDistinct> distinctByIdToken(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idToken', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QDistinct>
      distinctByLastLoginAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastLoginAt');
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QDistinct>
      distinctByRefreshToken({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'refreshToken', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserSessionModel, UserSessionModel, QDistinct> distinctByUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }
}

extension UserSessionModelQueryProperty
    on QueryBuilder<UserSessionModel, UserSessionModel, QQueryProperty> {
  QueryBuilder<UserSessionModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<UserSessionModel, String?, QQueryOperations>
      activeContextJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeContextJson');
    });
  }

  QueryBuilder<UserSessionModel, String?, QQueryOperations> deviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceId');
    });
  }

  QueryBuilder<UserSessionModel, String?, QQueryOperations>
      featureFlagsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'featureFlagsJson');
    });
  }

  QueryBuilder<UserSessionModel, String?, QQueryOperations> idTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idToken');
    });
  }

  QueryBuilder<UserSessionModel, DateTime?, QQueryOperations>
      lastLoginAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastLoginAt');
    });
  }

  QueryBuilder<UserSessionModel, String?, QQueryOperations>
      refreshTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'refreshToken');
    });
  }

  QueryBuilder<UserSessionModel, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }
}
