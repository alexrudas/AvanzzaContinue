// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_frequency_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCampaignFrequencyModelCollection on Isar {
  IsarCollection<CampaignFrequencyModel> get campaignFrequencyModels =>
      this.collection();
}

const CampaignFrequencyModelSchema = CollectionSchema(
  name: r'CampaignFrequencyModel',
  id: -1128506341327219610,
  properties: {
    r'campaignId': PropertySchema(
      id: 0,
      name: r'campaignId',
      type: IsarType.string,
    ),
    r'consecutiveManualCloses': PropertySchema(
      id: 1,
      name: r'consecutiveManualCloses',
      type: IsarType.long,
    ),
    r'lastShownAt': PropertySchema(
      id: 2,
      name: r'lastShownAt',
      type: IsarType.dateTime,
    ),
    r'nextEligibleAt': PropertySchema(
      id: 3,
      name: r'nextEligibleAt',
      type: IsarType.dateTime,
    ),
    r'sessionShown': PropertySchema(
      id: 4,
      name: r'sessionShown',
      type: IsarType.bool,
    ),
    r'showsToday': PropertySchema(
      id: 5,
      name: r'showsToday',
      type: IsarType.long,
    )
  },
  estimateSize: _campaignFrequencyModelEstimateSize,
  serialize: _campaignFrequencyModelSerialize,
  deserialize: _campaignFrequencyModelDeserialize,
  deserializeProp: _campaignFrequencyModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'campaignId': IndexSchema(
      id: 2069977803028940998,
      name: r'campaignId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'campaignId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _campaignFrequencyModelGetId,
  getLinks: _campaignFrequencyModelGetLinks,
  attach: _campaignFrequencyModelAttach,
  version: '3.2.0-dev.2',
);

int _campaignFrequencyModelEstimateSize(
  CampaignFrequencyModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.campaignId.length * 3;
  return bytesCount;
}

void _campaignFrequencyModelSerialize(
  CampaignFrequencyModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.campaignId);
  writer.writeLong(offsets[1], object.consecutiveManualCloses);
  writer.writeDateTime(offsets[2], object.lastShownAt);
  writer.writeDateTime(offsets[3], object.nextEligibleAt);
  writer.writeBool(offsets[4], object.sessionShown);
  writer.writeLong(offsets[5], object.showsToday);
}

CampaignFrequencyModel _campaignFrequencyModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CampaignFrequencyModel();
  object.campaignId = reader.readString(offsets[0]);
  object.consecutiveManualCloses = reader.readLong(offsets[1]);
  object.id = id;
  object.lastShownAt = reader.readDateTime(offsets[2]);
  object.nextEligibleAt = reader.readDateTimeOrNull(offsets[3]);
  object.sessionShown = reader.readBool(offsets[4]);
  object.showsToday = reader.readLong(offsets[5]);
  return object;
}

P _campaignFrequencyModelDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _campaignFrequencyModelGetId(CampaignFrequencyModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _campaignFrequencyModelGetLinks(
    CampaignFrequencyModel object) {
  return [];
}

void _campaignFrequencyModelAttach(
    IsarCollection<dynamic> col, Id id, CampaignFrequencyModel object) {
  object.id = id;
}

extension CampaignFrequencyModelByIndex
    on IsarCollection<CampaignFrequencyModel> {
  Future<CampaignFrequencyModel?> getByCampaignId(String campaignId) {
    return getByIndex(r'campaignId', [campaignId]);
  }

  CampaignFrequencyModel? getByCampaignIdSync(String campaignId) {
    return getByIndexSync(r'campaignId', [campaignId]);
  }

  Future<bool> deleteByCampaignId(String campaignId) {
    return deleteByIndex(r'campaignId', [campaignId]);
  }

  bool deleteByCampaignIdSync(String campaignId) {
    return deleteByIndexSync(r'campaignId', [campaignId]);
  }

  Future<List<CampaignFrequencyModel?>> getAllByCampaignId(
      List<String> campaignIdValues) {
    final values = campaignIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'campaignId', values);
  }

  List<CampaignFrequencyModel?> getAllByCampaignIdSync(
      List<String> campaignIdValues) {
    final values = campaignIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'campaignId', values);
  }

  Future<int> deleteAllByCampaignId(List<String> campaignIdValues) {
    final values = campaignIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'campaignId', values);
  }

  int deleteAllByCampaignIdSync(List<String> campaignIdValues) {
    final values = campaignIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'campaignId', values);
  }

  Future<Id> putByCampaignId(CampaignFrequencyModel object) {
    return putByIndex(r'campaignId', object);
  }

  Id putByCampaignIdSync(CampaignFrequencyModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'campaignId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCampaignId(List<CampaignFrequencyModel> objects) {
    return putAllByIndex(r'campaignId', objects);
  }

  List<Id> putAllByCampaignIdSync(List<CampaignFrequencyModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'campaignId', objects, saveLinks: saveLinks);
  }
}

extension CampaignFrequencyModelQueryWhereSort
    on QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QWhere> {
  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CampaignFrequencyModelQueryWhere on QueryBuilder<
    CampaignFrequencyModel, CampaignFrequencyModel, QWhereClause> {
  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
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

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterWhereClause> campaignIdEqualTo(String campaignId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'campaignId',
        value: [campaignId],
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterWhereClause> campaignIdNotEqualTo(String campaignId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'campaignId',
              lower: [],
              upper: [campaignId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'campaignId',
              lower: [campaignId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'campaignId',
              lower: [campaignId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'campaignId',
              lower: [],
              upper: [campaignId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CampaignFrequencyModelQueryFilter on QueryBuilder<
    CampaignFrequencyModel, CampaignFrequencyModel, QFilterCondition> {
  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> campaignIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'campaignId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> campaignIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'campaignId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> campaignIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'campaignId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> campaignIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'campaignId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> campaignIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'campaignId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> campaignIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'campaignId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
          QAfterFilterCondition>
      campaignIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'campaignId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
          QAfterFilterCondition>
      campaignIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'campaignId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> campaignIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'campaignId',
        value: '',
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> campaignIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'campaignId',
        value: '',
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> consecutiveManualClosesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'consecutiveManualCloses',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> consecutiveManualClosesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'consecutiveManualCloses',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> consecutiveManualClosesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'consecutiveManualCloses',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> consecutiveManualClosesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'consecutiveManualCloses',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
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

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
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

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
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

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> lastShownAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastShownAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> lastShownAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastShownAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> lastShownAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastShownAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> lastShownAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastShownAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> nextEligibleAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextEligibleAt',
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> nextEligibleAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextEligibleAt',
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> nextEligibleAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextEligibleAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> nextEligibleAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextEligibleAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> nextEligibleAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextEligibleAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> nextEligibleAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextEligibleAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> sessionShownEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionShown',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> showsTodayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showsToday',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> showsTodayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'showsToday',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> showsTodayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'showsToday',
        value: value,
      ));
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel,
      QAfterFilterCondition> showsTodayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'showsToday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CampaignFrequencyModelQueryObject on QueryBuilder<
    CampaignFrequencyModel, CampaignFrequencyModel, QFilterCondition> {}

extension CampaignFrequencyModelQueryLinks on QueryBuilder<
    CampaignFrequencyModel, CampaignFrequencyModel, QFilterCondition> {}

extension CampaignFrequencyModelQuerySortBy
    on QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QSortBy> {
  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      sortByCampaignId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignId', Sort.asc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      sortByCampaignIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignId', Sort.desc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      sortByConsecutiveManualCloses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveManualCloses', Sort.asc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      sortByConsecutiveManualClosesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveManualCloses', Sort.desc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      sortByLastShownAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastShownAt', Sort.asc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      sortByLastShownAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastShownAt', Sort.desc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      sortByNextEligibleAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextEligibleAt', Sort.asc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      sortByNextEligibleAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextEligibleAt', Sort.desc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      sortBySessionShown() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionShown', Sort.asc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      sortBySessionShownDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionShown', Sort.desc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      sortByShowsToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showsToday', Sort.asc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      sortByShowsTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showsToday', Sort.desc);
    });
  }
}

extension CampaignFrequencyModelQuerySortThenBy on QueryBuilder<
    CampaignFrequencyModel, CampaignFrequencyModel, QSortThenBy> {
  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenByCampaignId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignId', Sort.asc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenByCampaignIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'campaignId', Sort.desc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenByConsecutiveManualCloses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveManualCloses', Sort.asc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenByConsecutiveManualClosesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveManualCloses', Sort.desc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenByLastShownAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastShownAt', Sort.asc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenByLastShownAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastShownAt', Sort.desc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenByNextEligibleAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextEligibleAt', Sort.asc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenByNextEligibleAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextEligibleAt', Sort.desc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenBySessionShown() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionShown', Sort.asc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenBySessionShownDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionShown', Sort.desc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenByShowsToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showsToday', Sort.asc);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QAfterSortBy>
      thenByShowsTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showsToday', Sort.desc);
    });
  }
}

extension CampaignFrequencyModelQueryWhereDistinct
    on QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QDistinct> {
  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QDistinct>
      distinctByCampaignId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'campaignId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QDistinct>
      distinctByConsecutiveManualCloses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'consecutiveManualCloses');
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QDistinct>
      distinctByLastShownAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastShownAt');
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QDistinct>
      distinctByNextEligibleAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextEligibleAt');
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QDistinct>
      distinctBySessionShown() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionShown');
    });
  }

  QueryBuilder<CampaignFrequencyModel, CampaignFrequencyModel, QDistinct>
      distinctByShowsToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showsToday');
    });
  }
}

extension CampaignFrequencyModelQueryProperty on QueryBuilder<
    CampaignFrequencyModel, CampaignFrequencyModel, QQueryProperty> {
  QueryBuilder<CampaignFrequencyModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CampaignFrequencyModel, String, QQueryOperations>
      campaignIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'campaignId');
    });
  }

  QueryBuilder<CampaignFrequencyModel, int, QQueryOperations>
      consecutiveManualClosesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'consecutiveManualCloses');
    });
  }

  QueryBuilder<CampaignFrequencyModel, DateTime, QQueryOperations>
      lastShownAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastShownAt');
    });
  }

  QueryBuilder<CampaignFrequencyModel, DateTime?, QQueryOperations>
      nextEligibleAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextEligibleAt');
    });
  }

  QueryBuilder<CampaignFrequencyModel, bool, QQueryOperations>
      sessionShownProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionShown');
    });
  }

  QueryBuilder<CampaignFrequencyModel, int, QQueryOperations>
      showsTodayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showsToday');
    });
  }
}
