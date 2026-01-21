// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPortfolioModelCollection on Isar {
  IsarCollection<PortfolioModel> get portfolioModels => this.collection();
}

const PortfolioModelSchema = CollectionSchema(
  name: r'PortfolioModel',
  id: -3714341079121698232,
  properties: {
    r'assetsCount': PropertySchema(
      id: 0,
      name: r'assetsCount',
      type: IsarType.long,
    ),
    r'cityId': PropertySchema(
      id: 1,
      name: r'cityId',
      type: IsarType.string,
    ),
    r'countryId': PropertySchema(
      id: 2,
      name: r'countryId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdBy': PropertySchema(
      id: 4,
      name: r'createdBy',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 5,
      name: r'id',
      type: IsarType.string,
    ),
    r'portfolioName': PropertySchema(
      id: 6,
      name: r'portfolioName',
      type: IsarType.string,
    ),
    r'portfolioType': PropertySchema(
      id: 7,
      name: r'portfolioType',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _portfolioModelEstimateSize,
  serialize: _portfolioModelSerialize,
  deserialize: _portfolioModelDeserialize,
  deserializeProp: _portfolioModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'portfolioType': IndexSchema(
      id: -8839405075784601663,
      name: r'portfolioType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'portfolioType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'createdBy': IndexSchema(
      id: -5864534510598149324,
      name: r'createdBy',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdBy',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _portfolioModelGetId,
  getLinks: _portfolioModelGetLinks,
  attach: _portfolioModelAttach,
  version: '3.2.0-dev.2',
);

int _portfolioModelEstimateSize(
  PortfolioModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cityId.length * 3;
  bytesCount += 3 + object.countryId.length * 3;
  bytesCount += 3 + object.createdBy.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.portfolioName.length * 3;
  bytesCount += 3 + object.portfolioType.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _portfolioModelSerialize(
  PortfolioModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.assetsCount);
  writer.writeString(offsets[1], object.cityId);
  writer.writeString(offsets[2], object.countryId);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.createdBy);
  writer.writeString(offsets[5], object.id);
  writer.writeString(offsets[6], object.portfolioName);
  writer.writeString(offsets[7], object.portfolioType);
  writer.writeString(offsets[8], object.status);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

PortfolioModel _portfolioModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PortfolioModel(
    assetsCount: reader.readLong(offsets[0]),
    cityId: reader.readString(offsets[1]),
    countryId: reader.readString(offsets[2]),
    createdAt: reader.readDateTimeOrNull(offsets[3]),
    createdBy: reader.readString(offsets[4]),
    id: reader.readString(offsets[5]),
    isarId: id,
    portfolioName: reader.readString(offsets[6]),
    portfolioType: reader.readString(offsets[7]),
    status: reader.readString(offsets[8]),
    updatedAt: reader.readDateTimeOrNull(offsets[9]),
  );
  return object;
}

P _portfolioModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _portfolioModelGetId(PortfolioModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _portfolioModelGetLinks(PortfolioModel object) {
  return [];
}

void _portfolioModelAttach(
    IsarCollection<dynamic> col, Id id, PortfolioModel object) {
  object.isarId = id;
}

extension PortfolioModelByIndex on IsarCollection<PortfolioModel> {
  Future<PortfolioModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  PortfolioModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<PortfolioModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<PortfolioModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(PortfolioModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(PortfolioModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<PortfolioModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<PortfolioModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension PortfolioModelQueryWhereSort
    on QueryBuilder<PortfolioModel, PortfolioModel, QWhere> {
  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PortfolioModelQueryWhere
    on QueryBuilder<PortfolioModel, PortfolioModel, QWhereClause> {
  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhereClause>
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhereClause> idNotEqualTo(
      String id) {
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhereClause>
      portfolioTypeEqualTo(String portfolioType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'portfolioType',
        value: [portfolioType],
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhereClause>
      portfolioTypeNotEqualTo(String portfolioType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'portfolioType',
              lower: [],
              upper: [portfolioType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'portfolioType',
              lower: [portfolioType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'portfolioType',
              lower: [portfolioType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'portfolioType',
              lower: [],
              upper: [portfolioType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhereClause> statusEqualTo(
      String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhereClause>
      statusNotEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhereClause>
      createdByEqualTo(String createdBy) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdBy',
        value: [createdBy],
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterWhereClause>
      createdByNotEqualTo(String createdBy) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdBy',
              lower: [],
              upper: [createdBy],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdBy',
              lower: [createdBy],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdBy',
              lower: [createdBy],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdBy',
              lower: [],
              upper: [createdBy],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PortfolioModelQueryFilter
    on QueryBuilder<PortfolioModel, PortfolioModel, QFilterCondition> {
  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      assetsCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      assetsCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assetsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      assetsCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assetsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      assetsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assetsCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      cityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      cityIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      cityIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      cityIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      cityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      cityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      cityIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      cityIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cityId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      cityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityId',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      cityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cityId',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      countryIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      countryIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'countryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      countryIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'countryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      countryIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'countryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      countryIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'countryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      countryIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'countryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      countryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'countryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      countryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'countryId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      countryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryId',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      countryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'countryId',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value, {
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdByEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      createdByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'portfolioName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'portfolioName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'portfolioName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'portfolioName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'portfolioName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'portfolioName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'portfolioName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'portfolioName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'portfolioName',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'portfolioName',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'portfolioType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'portfolioType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'portfolioType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'portfolioType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'portfolioType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'portfolioType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'portfolioType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'portfolioType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'portfolioType',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      portfolioTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'portfolioType',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      statusEqualTo(
    String value, {
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      statusLessThan(
    String value, {
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      statusBetween(
    String lower,
    String upper, {
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      statusStartsWith(
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      statusEndsWith(
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime? value, {
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime? value, {
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

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterFilterCondition>
      updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
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

extension PortfolioModelQueryObject
    on QueryBuilder<PortfolioModel, PortfolioModel, QFilterCondition> {}

extension PortfolioModelQueryLinks
    on QueryBuilder<PortfolioModel, PortfolioModel, QFilterCondition> {}

extension PortfolioModelQuerySortBy
    on QueryBuilder<PortfolioModel, PortfolioModel, QSortBy> {
  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      sortByAssetsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetsCount', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      sortByAssetsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetsCount', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> sortByCityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      sortByCityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> sortByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      sortByCountryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> sortByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      sortByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      sortByPortfolioName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portfolioName', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      sortByPortfolioNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portfolioName', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      sortByPortfolioType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portfolioType', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      sortByPortfolioTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portfolioType', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PortfolioModelQuerySortThenBy
    on QueryBuilder<PortfolioModel, PortfolioModel, QSortThenBy> {
  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      thenByAssetsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetsCount', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      thenByAssetsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetsCount', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> thenByCityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      thenByCityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> thenByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      thenByCountryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> thenByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      thenByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      thenByPortfolioName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portfolioName', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      thenByPortfolioNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portfolioName', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      thenByPortfolioType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portfolioType', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      thenByPortfolioTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portfolioType', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PortfolioModelQueryWhereDistinct
    on QueryBuilder<PortfolioModel, PortfolioModel, QDistinct> {
  QueryBuilder<PortfolioModel, PortfolioModel, QDistinct>
      distinctByAssetsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetsCount');
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QDistinct> distinctByCityId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QDistinct> distinctByCountryId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'countryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QDistinct> distinctByCreatedBy(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QDistinct>
      distinctByPortfolioName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'portfolioName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QDistinct>
      distinctByPortfolioType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'portfolioType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PortfolioModel, PortfolioModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension PortfolioModelQueryProperty
    on QueryBuilder<PortfolioModel, PortfolioModel, QQueryProperty> {
  QueryBuilder<PortfolioModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<PortfolioModel, int, QQueryOperations> assetsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetsCount');
    });
  }

  QueryBuilder<PortfolioModel, String, QQueryOperations> cityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cityId');
    });
  }

  QueryBuilder<PortfolioModel, String, QQueryOperations> countryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'countryId');
    });
  }

  QueryBuilder<PortfolioModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PortfolioModel, String, QQueryOperations> createdByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdBy');
    });
  }

  QueryBuilder<PortfolioModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PortfolioModel, String, QQueryOperations>
      portfolioNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'portfolioName');
    });
  }

  QueryBuilder<PortfolioModel, String, QQueryOperations>
      portfolioTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'portfolioType');
    });
  }

  QueryBuilder<PortfolioModel, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<PortfolioModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PortfolioModel _$PortfolioModelFromJson(Map<String, dynamic> json) =>
    PortfolioModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      portfolioType: json['portfolioType'] as String,
      portfolioName: json['portfolioName'] as String,
      countryId: json['countryId'] as String,
      cityId: json['cityId'] as String,
      status: json['status'] as String,
      assetsCount: (json['assetsCount'] as num).toInt(),
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PortfolioModelToJson(PortfolioModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'portfolioType': instance.portfolioType,
      'portfolioName': instance.portfolioName,
      'countryId': instance.countryId,
      'cityId': instance.cityId,
      'status': instance.status,
      'assetsCount': instance.assetsCount,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
