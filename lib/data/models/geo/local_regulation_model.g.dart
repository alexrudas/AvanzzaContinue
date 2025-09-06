// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_regulation_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalRegulationModelCollection on Isar {
  IsarCollection<LocalRegulationModel> get localRegulationModels =>
      this.collection();
}

const LocalRegulationModelSchema = CollectionSchema(
  name: r'LocalRegulationModel',
  id: 3465837939489549027,
  properties: {
    r'circulationExceptions': PropertySchema(
      id: 0,
      name: r'circulationExceptions',
      type: IsarType.stringList,
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
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.string,
    ),
    r'maintenanceBlackoutDates': PropertySchema(
      id: 5,
      name: r'maintenanceBlackoutDates',
      type: IsarType.stringList,
    ),
    r'picoYPlacaRules': PropertySchema(
      id: 6,
      name: r'picoYPlacaRules',
      type: IsarType.objectList,
      target: r'PicoYPlacaRuleModel',
    ),
    r'sourceUrl': PropertySchema(
      id: 7,
      name: r'sourceUrl',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'updatedBy': PropertySchema(
      id: 9,
      name: r'updatedBy',
      type: IsarType.string,
    )
  },
  estimateSize: _localRegulationModelEstimateSize,
  serialize: _localRegulationModelSerialize,
  deserialize: _localRegulationModelDeserialize,
  deserializeProp: _localRegulationModelDeserializeProp,
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
    r'countryId': IndexSchema(
      id: -5115696458787596369,
      name: r'countryId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'countryId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'cityId': IndexSchema(
      id: 7617551301138149930,
      name: r'cityId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'cityId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'PicoYPlacaRuleModel': PicoYPlacaRuleModelSchema},
  getId: _localRegulationModelGetId,
  getLinks: _localRegulationModelGetLinks,
  attach: _localRegulationModelAttach,
  version: '3.2.0-dev.2',
);

int _localRegulationModelEstimateSize(
  LocalRegulationModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.circulationExceptions;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  bytesCount += 3 + object.cityId.length * 3;
  bytesCount += 3 + object.countryId.length * 3;
  bytesCount += 3 + object.id.length * 3;
  {
    final list = object.maintenanceBlackoutDates;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.picoYPlacaRules;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[PicoYPlacaRuleModel]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += PicoYPlacaRuleModelSchema.estimateSize(
              value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.sourceUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.updatedBy.length * 3;
  return bytesCount;
}

void _localRegulationModelSerialize(
  LocalRegulationModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.circulationExceptions);
  writer.writeString(offsets[1], object.cityId);
  writer.writeString(offsets[2], object.countryId);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.id);
  writer.writeStringList(offsets[5], object.maintenanceBlackoutDates);
  writer.writeObjectList<PicoYPlacaRuleModel>(
    offsets[6],
    allOffsets,
    PicoYPlacaRuleModelSchema.serialize,
    object.picoYPlacaRules,
  );
  writer.writeString(offsets[7], object.sourceUrl);
  writer.writeDateTime(offsets[8], object.updatedAt);
  writer.writeString(offsets[9], object.updatedBy);
}

LocalRegulationModel _localRegulationModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalRegulationModel(
    circulationExceptions: reader.readStringList(offsets[0]),
    cityId: reader.readString(offsets[1]),
    countryId: reader.readString(offsets[2]),
    createdAt: reader.readDateTimeOrNull(offsets[3]),
    id: reader.readString(offsets[4]),
    isarId: id,
    maintenanceBlackoutDates: reader.readStringList(offsets[5]),
    picoYPlacaRules: reader.readObjectList<PicoYPlacaRuleModel>(
      offsets[6],
      PicoYPlacaRuleModelSchema.deserialize,
      allOffsets,
      PicoYPlacaRuleModel(),
    ),
    sourceUrl: reader.readStringOrNull(offsets[7]),
    updatedAt: reader.readDateTimeOrNull(offsets[8]),
    updatedBy: reader.readString(offsets[9]),
  );
  return object;
}

P _localRegulationModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringList(offset)) as P;
    case 6:
      return (reader.readObjectList<PicoYPlacaRuleModel>(
        offset,
        PicoYPlacaRuleModelSchema.deserialize,
        allOffsets,
        PicoYPlacaRuleModel(),
      )) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localRegulationModelGetId(LocalRegulationModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _localRegulationModelGetLinks(
    LocalRegulationModel object) {
  return [];
}

void _localRegulationModelAttach(
    IsarCollection<dynamic> col, Id id, LocalRegulationModel object) {
  object.isarId = id;
}

extension LocalRegulationModelByIndex on IsarCollection<LocalRegulationModel> {
  Future<LocalRegulationModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  LocalRegulationModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<LocalRegulationModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<LocalRegulationModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(LocalRegulationModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(LocalRegulationModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<LocalRegulationModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<LocalRegulationModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension LocalRegulationModelQueryWhereSort
    on QueryBuilder<LocalRegulationModel, LocalRegulationModel, QWhere> {
  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalRegulationModelQueryWhere
    on QueryBuilder<LocalRegulationModel, LocalRegulationModel, QWhereClause> {
  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterWhereClause>
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterWhereClause>
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterWhereClause>
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterWhereClause>
      countryIdEqualTo(String countryId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'countryId',
        value: [countryId],
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterWhereClause>
      countryIdNotEqualTo(String countryId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'countryId',
              lower: [],
              upper: [countryId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'countryId',
              lower: [countryId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'countryId',
              lower: [countryId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'countryId',
              lower: [],
              upper: [countryId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterWhereClause>
      cityIdEqualTo(String cityId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cityId',
        value: [cityId],
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterWhereClause>
      cityIdNotEqualTo(String cityId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cityId',
              lower: [],
              upper: [cityId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cityId',
              lower: [cityId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cityId',
              lower: [cityId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cityId',
              lower: [],
              upper: [cityId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LocalRegulationModelQueryFilter on QueryBuilder<LocalRegulationModel,
    LocalRegulationModel, QFilterCondition> {
  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'circulationExceptions',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'circulationExceptions',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'circulationExceptions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'circulationExceptions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'circulationExceptions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'circulationExceptions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'circulationExceptions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'circulationExceptions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      circulationExceptionsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'circulationExceptions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      circulationExceptionsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'circulationExceptions',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'circulationExceptions',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'circulationExceptions',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'circulationExceptions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'circulationExceptions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'circulationExceptions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'circulationExceptions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'circulationExceptions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> circulationExceptionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'circulationExceptions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> cityIdEqualTo(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> cityIdGreaterThan(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> cityIdLessThan(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> cityIdBetween(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> cityIdStartsWith(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> cityIdEndsWith(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      cityIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      cityIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cityId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> cityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> cityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cityId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> countryIdEqualTo(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> countryIdGreaterThan(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> countryIdLessThan(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> countryIdBetween(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> countryIdStartsWith(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> countryIdEndsWith(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      countryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'countryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      countryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'countryId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> countryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> countryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'countryId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maintenanceBlackoutDates',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maintenanceBlackoutDates',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maintenanceBlackoutDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maintenanceBlackoutDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maintenanceBlackoutDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maintenanceBlackoutDates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'maintenanceBlackoutDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'maintenanceBlackoutDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      maintenanceBlackoutDatesElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'maintenanceBlackoutDates',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      maintenanceBlackoutDatesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'maintenanceBlackoutDates',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maintenanceBlackoutDates',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'maintenanceBlackoutDates',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'maintenanceBlackoutDates',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'maintenanceBlackoutDates',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'maintenanceBlackoutDates',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'maintenanceBlackoutDates',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'maintenanceBlackoutDates',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> maintenanceBlackoutDatesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'maintenanceBlackoutDates',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> picoYPlacaRulesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'picoYPlacaRules',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> picoYPlacaRulesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'picoYPlacaRules',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> picoYPlacaRulesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'picoYPlacaRules',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> picoYPlacaRulesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'picoYPlacaRules',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> picoYPlacaRulesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'picoYPlacaRules',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> picoYPlacaRulesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'picoYPlacaRules',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> picoYPlacaRulesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'picoYPlacaRules',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> picoYPlacaRulesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'picoYPlacaRules',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> sourceUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceUrl',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> sourceUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceUrl',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> sourceUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> sourceUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> sourceUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> sourceUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> sourceUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> sourceUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      sourceUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      sourceUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> sourceUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> sourceUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedByEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'updatedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'updatedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      updatedByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'updatedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      updatedByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'updatedBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
      QAfterFilterCondition> updatedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'updatedBy',
        value: '',
      ));
    });
  }
}

extension LocalRegulationModelQueryObject on QueryBuilder<LocalRegulationModel,
    LocalRegulationModel, QFilterCondition> {
  QueryBuilder<LocalRegulationModel, LocalRegulationModel,
          QAfterFilterCondition>
      picoYPlacaRulesElement(FilterQuery<PicoYPlacaRuleModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'picoYPlacaRules');
    });
  }
}

extension LocalRegulationModelQueryLinks on QueryBuilder<LocalRegulationModel,
    LocalRegulationModel, QFilterCondition> {}

extension LocalRegulationModelQuerySortBy
    on QueryBuilder<LocalRegulationModel, LocalRegulationModel, QSortBy> {
  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortByCityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortByCityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.desc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortByCountryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.desc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortBySourceUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceUrl', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortBySourceUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceUrl', Sort.desc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortByUpdatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedBy', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      sortByUpdatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedBy', Sort.desc);
    });
  }
}

extension LocalRegulationModelQuerySortThenBy
    on QueryBuilder<LocalRegulationModel, LocalRegulationModel, QSortThenBy> {
  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenByCityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenByCityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.desc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenByCountryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.desc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenBySourceUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceUrl', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenBySourceUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceUrl', Sort.desc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenByUpdatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedBy', Sort.asc);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QAfterSortBy>
      thenByUpdatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedBy', Sort.desc);
    });
  }
}

extension LocalRegulationModelQueryWhereDistinct
    on QueryBuilder<LocalRegulationModel, LocalRegulationModel, QDistinct> {
  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QDistinct>
      distinctByCirculationExceptions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'circulationExceptions');
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QDistinct>
      distinctByCityId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QDistinct>
      distinctByCountryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'countryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QDistinct>
      distinctByMaintenanceBlackoutDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maintenanceBlackoutDates');
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QDistinct>
      distinctBySourceUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<LocalRegulationModel, LocalRegulationModel, QDistinct>
      distinctByUpdatedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedBy', caseSensitive: caseSensitive);
    });
  }
}

extension LocalRegulationModelQueryProperty on QueryBuilder<
    LocalRegulationModel, LocalRegulationModel, QQueryProperty> {
  QueryBuilder<LocalRegulationModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalRegulationModel, List<String>?, QQueryOperations>
      circulationExceptionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'circulationExceptions');
    });
  }

  QueryBuilder<LocalRegulationModel, String, QQueryOperations>
      cityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cityId');
    });
  }

  QueryBuilder<LocalRegulationModel, String, QQueryOperations>
      countryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'countryId');
    });
  }

  QueryBuilder<LocalRegulationModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LocalRegulationModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalRegulationModel, List<String>?, QQueryOperations>
      maintenanceBlackoutDatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maintenanceBlackoutDates');
    });
  }

  QueryBuilder<LocalRegulationModel, List<PicoYPlacaRuleModel>?,
      QQueryOperations> picoYPlacaRulesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'picoYPlacaRules');
    });
  }

  QueryBuilder<LocalRegulationModel, String?, QQueryOperations>
      sourceUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceUrl');
    });
  }

  QueryBuilder<LocalRegulationModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<LocalRegulationModel, String, QQueryOperations>
      updatedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedBy');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PicoYPlacaRuleModelSchema = Schema(
  name: r'PicoYPlacaRuleModel',
  id: -2450595409067699231,
  properties: {
    r'dayOfWeek': PropertySchema(
      id: 0,
      name: r'dayOfWeek',
      type: IsarType.long,
    ),
    r'digitsRestricted': PropertySchema(
      id: 1,
      name: r'digitsRestricted',
      type: IsarType.stringList,
    ),
    r'endTime': PropertySchema(
      id: 2,
      name: r'endTime',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 3,
      name: r'notes',
      type: IsarType.string,
    ),
    r'startTime': PropertySchema(
      id: 4,
      name: r'startTime',
      type: IsarType.string,
    )
  },
  estimateSize: _picoYPlacaRuleModelEstimateSize,
  serialize: _picoYPlacaRuleModelSerialize,
  deserialize: _picoYPlacaRuleModelDeserialize,
  deserializeProp: _picoYPlacaRuleModelDeserializeProp,
);

int _picoYPlacaRuleModelEstimateSize(
  PicoYPlacaRuleModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.digitsRestricted;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.endTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.startTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _picoYPlacaRuleModelSerialize(
  PicoYPlacaRuleModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dayOfWeek);
  writer.writeStringList(offsets[1], object.digitsRestricted);
  writer.writeString(offsets[2], object.endTime);
  writer.writeString(offsets[3], object.notes);
  writer.writeString(offsets[4], object.startTime);
}

PicoYPlacaRuleModel _picoYPlacaRuleModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PicoYPlacaRuleModel(
    dayOfWeek: reader.readLongOrNull(offsets[0]),
    digitsRestricted: reader.readStringList(offsets[1]),
    endTime: reader.readStringOrNull(offsets[2]),
    notes: reader.readStringOrNull(offsets[3]),
    startTime: reader.readStringOrNull(offsets[4]),
  );
  return object;
}

P _picoYPlacaRuleModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringList(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PicoYPlacaRuleModelQueryFilter on QueryBuilder<PicoYPlacaRuleModel,
    PicoYPlacaRuleModel, QFilterCondition> {
  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      dayOfWeekIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dayOfWeek',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      dayOfWeekIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dayOfWeek',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      dayOfWeekEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      dayOfWeekGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      dayOfWeekLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      dayOfWeekBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayOfWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'digitsRestricted',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'digitsRestricted',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'digitsRestricted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'digitsRestricted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'digitsRestricted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'digitsRestricted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'digitsRestricted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'digitsRestricted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'digitsRestricted',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'digitsRestricted',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'digitsRestricted',
        value: '',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'digitsRestricted',
        value: '',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'digitsRestricted',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'digitsRestricted',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'digitsRestricted',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'digitsRestricted',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'digitsRestricted',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      digitsRestrictedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'digitsRestricted',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      endTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      endTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      endTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      endTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      endTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      endTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      endTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'endTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      endTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'endTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      endTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: '',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      endTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'endTime',
        value: '',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      startTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startTime',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      startTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startTime',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      startTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      startTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      startTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      startTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      startTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      startTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      startTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'startTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      startTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'startTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      startTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: '',
      ));
    });
  }

  QueryBuilder<PicoYPlacaRuleModel, PicoYPlacaRuleModel, QAfterFilterCondition>
      startTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'startTime',
        value: '',
      ));
    });
  }
}

extension PicoYPlacaRuleModelQueryObject on QueryBuilder<PicoYPlacaRuleModel,
    PicoYPlacaRuleModel, QFilterCondition> {}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PicoYPlacaRuleModel _$PicoYPlacaRuleModelFromJson(Map<String, dynamic> json) =>
    PicoYPlacaRuleModel(
      dayOfWeek: (json['dayOfWeek'] as num?)?.toInt(),
      digitsRestricted: (json['digitsRestricted'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$PicoYPlacaRuleModelToJson(
        PicoYPlacaRuleModel instance) =>
    <String, dynamic>{
      'dayOfWeek': instance.dayOfWeek,
      'digitsRestricted': instance.digitsRestricted,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'notes': instance.notes,
    };

LocalRegulationModel _$LocalRegulationModelFromJson(
        Map<String, dynamic> json) =>
    LocalRegulationModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      countryId: json['countryId'] as String,
      cityId: json['cityId'] as String,
      picoYPlacaRules: (json['picoYPlacaRules'] as List<dynamic>?)
          ?.map((e) => PicoYPlacaRuleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      circulationExceptions: (json['circulationExceptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      maintenanceBlackoutDates:
          (json['maintenanceBlackoutDates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      updatedBy: json['updatedBy'] as String,
      sourceUrl: json['sourceUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LocalRegulationModelToJson(
        LocalRegulationModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'countryId': instance.countryId,
      'cityId': instance.cityId,
      'picoYPlacaRules':
          instance.picoYPlacaRules?.map((e) => e.toJson()).toList(),
      'circulationExceptions': instance.circulationExceptions,
      'maintenanceBlackoutDates': instance.maintenanceBlackoutDates,
      'updatedBy': instance.updatedBy,
      'sourceUrl': instance.sourceUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
