// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_session_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOnboardingSessionModelCollection on Isar {
  IsarCollection<OnboardingSessionModel> get onboardingSessionModels =>
      this.collection();
}

const OnboardingSessionModelSchema = CollectionSchema(
  name: r'OnboardingSessionModel',
  id: 7304302718791400864,
  properties: {
    r'currentStep': PropertySchema(
      id: 0,
      name: r'currentStep',
      type: IsarType.long,
    ),
    r'isCompleted': PropertySchema(
      id: 1,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'stateJson': PropertySchema(
      id: 2,
      name: r'stateJson',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 3,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 4,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _onboardingSessionModelEstimateSize,
  serialize: _onboardingSessionModelSerialize,
  deserialize: _onboardingSessionModelDeserialize,
  deserializeProp: _onboardingSessionModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _onboardingSessionModelGetId,
  getLinks: _onboardingSessionModelGetLinks,
  attach: _onboardingSessionModelAttach,
  version: '3.3.0-dev.1',
);

int _onboardingSessionModelEstimateSize(
  OnboardingSessionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.stateJson.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _onboardingSessionModelSerialize(
  OnboardingSessionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentStep);
  writer.writeBool(offsets[1], object.isCompleted);
  writer.writeString(offsets[2], object.stateJson);
  writer.writeDateTime(offsets[3], object.updatedAt);
  writer.writeString(offsets[4], object.userId);
}

OnboardingSessionModel _onboardingSessionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OnboardingSessionModel();
  object.currentStep = reader.readLong(offsets[0]);
  object.isCompleted = reader.readBool(offsets[1]);
  object.isarId = id;
  object.stateJson = reader.readString(offsets[2]);
  object.updatedAt = reader.readDateTime(offsets[3]);
  object.userId = reader.readString(offsets[4]);
  return object;
}

P _onboardingSessionModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _onboardingSessionModelGetId(OnboardingSessionModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _onboardingSessionModelGetLinks(
    OnboardingSessionModel object) {
  return [];
}

void _onboardingSessionModelAttach(
    IsarCollection<dynamic> col, Id id, OnboardingSessionModel object) {
  object.isarId = id;
}

extension OnboardingSessionModelByIndex
    on IsarCollection<OnboardingSessionModel> {
  Future<OnboardingSessionModel?> getByUserId(String userId) {
    return getByIndex(r'userId', [userId]);
  }

  OnboardingSessionModel? getByUserIdSync(String userId) {
    return getByIndexSync(r'userId', [userId]);
  }

  Future<bool> deleteByUserId(String userId) {
    return deleteByIndex(r'userId', [userId]);
  }

  bool deleteByUserIdSync(String userId) {
    return deleteByIndexSync(r'userId', [userId]);
  }

  Future<List<OnboardingSessionModel?>> getAllByUserId(
      List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'userId', values);
  }

  List<OnboardingSessionModel?> getAllByUserIdSync(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'userId', values);
  }

  Future<int> deleteAllByUserId(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'userId', values);
  }

  int deleteAllByUserIdSync(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'userId', values);
  }

  Future<Id> putByUserId(OnboardingSessionModel object) {
    return putByIndex(r'userId', object);
  }

  Id putByUserIdSync(OnboardingSessionModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'userId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUserId(List<OnboardingSessionModel> objects) {
    return putAllByIndex(r'userId', objects);
  }

  List<Id> putAllByUserIdSync(List<OnboardingSessionModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'userId', objects, saveLinks: saveLinks);
  }
}

extension OnboardingSessionModelQueryWhereSort
    on QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QWhere> {
  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OnboardingSessionModelQueryWhere on QueryBuilder<
    OnboardingSessionModel, OnboardingSessionModel, QWhereClause> {
  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterWhereClause> userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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
}

extension OnboardingSessionModelQueryFilter on QueryBuilder<
    OnboardingSessionModel, OnboardingSessionModel, QFilterCondition> {
  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> currentStepEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStep',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> currentStepGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStep',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> currentStepLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStep',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> currentStepBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStep',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> stateJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> stateJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stateJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> stateJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stateJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> stateJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stateJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> stateJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stateJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> stateJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stateJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
          QAfterFilterCondition>
      stateJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stateJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
          QAfterFilterCondition>
      stateJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stateJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> stateJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateJson',
        value: '',
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> stateJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stateJson',
        value: '',
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
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

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel,
      QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension OnboardingSessionModelQueryObject on QueryBuilder<
    OnboardingSessionModel, OnboardingSessionModel, QFilterCondition> {}

extension OnboardingSessionModelQueryLinks on QueryBuilder<
    OnboardingSessionModel, OnboardingSessionModel, QFilterCondition> {}

extension OnboardingSessionModelQuerySortBy
    on QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QSortBy> {
  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      sortByCurrentStep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStep', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      sortByCurrentStepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStep', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      sortByStateJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateJson', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      sortByStateJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateJson', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension OnboardingSessionModelQuerySortThenBy on QueryBuilder<
    OnboardingSessionModel, OnboardingSessionModel, QSortThenBy> {
  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      thenByCurrentStep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStep', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      thenByCurrentStepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStep', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      thenByStateJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateJson', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      thenByStateJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateJson', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension OnboardingSessionModelQueryWhereDistinct
    on QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QDistinct> {
  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QDistinct>
      distinctByCurrentStep() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStep');
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QDistinct>
      distinctByStateJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<OnboardingSessionModel, OnboardingSessionModel, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension OnboardingSessionModelQueryProperty on QueryBuilder<
    OnboardingSessionModel, OnboardingSessionModel, QQueryProperty> {
  QueryBuilder<OnboardingSessionModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<OnboardingSessionModel, int, QQueryOperations>
      currentStepProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStep');
    });
  }

  QueryBuilder<OnboardingSessionModel, bool, QQueryOperations>
      isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<OnboardingSessionModel, String, QQueryOperations>
      stateJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateJson');
    });
  }

  QueryBuilder<OnboardingSessionModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<OnboardingSessionModel, String, QQueryOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
