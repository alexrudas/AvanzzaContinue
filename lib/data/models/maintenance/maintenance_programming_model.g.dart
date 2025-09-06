// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_programming_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMaintenanceProgrammingModelCollection on Isar {
  IsarCollection<MaintenanceProgrammingModel>
      get maintenanceProgrammingModels => this.collection();
}

const MaintenanceProgrammingModelSchema = CollectionSchema(
  name: r'MaintenanceProgrammingModel',
  id: -2519863760702963790,
  properties: {
    r'assetId': PropertySchema(
      id: 0,
      name: r'assetId',
      type: IsarType.string,
    ),
    r'assignedToTechId': PropertySchema(
      id: 1,
      name: r'assignedToTechId',
      type: IsarType.string,
    ),
    r'cityId': PropertySchema(
      id: 2,
      name: r'cityId',
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
    r'incidenciasIds': PropertySchema(
      id: 5,
      name: r'incidenciasIds',
      type: IsarType.stringList,
    ),
    r'notes': PropertySchema(
      id: 6,
      name: r'notes',
      type: IsarType.string,
    ),
    r'orgId': PropertySchema(
      id: 7,
      name: r'orgId',
      type: IsarType.string,
    ),
    r'programmingDates': PropertySchema(
      id: 8,
      name: r'programmingDates',
      type: IsarType.dateTimeList,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _maintenanceProgrammingModelEstimateSize,
  serialize: _maintenanceProgrammingModelSerialize,
  deserialize: _maintenanceProgrammingModelDeserialize,
  deserializeProp: _maintenanceProgrammingModelDeserializeProp,
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
    r'orgId': IndexSchema(
      id: 4612512750172861184,
      name: r'orgId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'orgId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'assetId': IndexSchema(
      id: 174362542210192109,
      name: r'assetId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'assetId',
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
  embeddedSchemas: {},
  getId: _maintenanceProgrammingModelGetId,
  getLinks: _maintenanceProgrammingModelGetLinks,
  attach: _maintenanceProgrammingModelAttach,
  version: '3.2.0-dev.2',
);

int _maintenanceProgrammingModelEstimateSize(
  MaintenanceProgrammingModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assetId.length * 3;
  {
    final value = object.assignedToTechId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.cityId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.incidenciasIds.length * 3;
  {
    for (var i = 0; i < object.incidenciasIds.length; i++) {
      final value = object.incidenciasIds[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.orgId.length * 3;
  bytesCount += 3 + object.programmingDates.length * 8;
  return bytesCount;
}

void _maintenanceProgrammingModelSerialize(
  MaintenanceProgrammingModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assetId);
  writer.writeString(offsets[1], object.assignedToTechId);
  writer.writeString(offsets[2], object.cityId);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.id);
  writer.writeStringList(offsets[5], object.incidenciasIds);
  writer.writeString(offsets[6], object.notes);
  writer.writeString(offsets[7], object.orgId);
  writer.writeDateTimeList(offsets[8], object.programmingDates);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

MaintenanceProgrammingModel _maintenanceProgrammingModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MaintenanceProgrammingModel(
    assetId: reader.readString(offsets[0]),
    assignedToTechId: reader.readStringOrNull(offsets[1]),
    cityId: reader.readStringOrNull(offsets[2]),
    createdAt: reader.readDateTimeOrNull(offsets[3]),
    id: reader.readString(offsets[4]),
    incidenciasIds: reader.readStringList(offsets[5]) ?? const [],
    isarId: id,
    notes: reader.readStringOrNull(offsets[6]),
    orgId: reader.readString(offsets[7]),
    programmingDates: reader.readDateTimeList(offsets[8]) ?? const [],
    updatedAt: reader.readDateTimeOrNull(offsets[9]),
  );
  return object;
}

P _maintenanceProgrammingModelDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? const []) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTimeList(offset) ?? const []) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _maintenanceProgrammingModelGetId(MaintenanceProgrammingModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _maintenanceProgrammingModelGetLinks(
    MaintenanceProgrammingModel object) {
  return [];
}

void _maintenanceProgrammingModelAttach(
    IsarCollection<dynamic> col, Id id, MaintenanceProgrammingModel object) {
  object.isarId = id;
}

extension MaintenanceProgrammingModelByIndex
    on IsarCollection<MaintenanceProgrammingModel> {
  Future<MaintenanceProgrammingModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  MaintenanceProgrammingModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<MaintenanceProgrammingModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<MaintenanceProgrammingModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(MaintenanceProgrammingModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(MaintenanceProgrammingModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<MaintenanceProgrammingModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<MaintenanceProgrammingModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension MaintenanceProgrammingModelQueryWhereSort on QueryBuilder<
    MaintenanceProgrammingModel, MaintenanceProgrammingModel, QWhere> {
  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MaintenanceProgrammingModelQueryWhere on QueryBuilder<
    MaintenanceProgrammingModel, MaintenanceProgrammingModel, QWhereClause> {
  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhereClause> idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhereClause> idNotEqualTo(String id) {
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhereClause> orgIdEqualTo(String orgId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orgId',
        value: [orgId],
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhereClause> orgIdNotEqualTo(String orgId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orgId',
              lower: [],
              upper: [orgId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orgId',
              lower: [orgId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orgId',
              lower: [orgId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orgId',
              lower: [],
              upper: [orgId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhereClause> assetIdEqualTo(String assetId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'assetId',
        value: [assetId],
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhereClause> assetIdNotEqualTo(String assetId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'assetId',
              lower: [],
              upper: [assetId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'assetId',
              lower: [assetId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'assetId',
              lower: [assetId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'assetId',
              lower: [],
              upper: [assetId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhereClause> cityIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cityId',
        value: [null],
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhereClause> cityIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cityId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhereClause> cityIdEqualTo(String? cityId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cityId',
        value: [cityId],
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterWhereClause> cityIdNotEqualTo(String? cityId) {
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

extension MaintenanceProgrammingModelQueryFilter on QueryBuilder<
    MaintenanceProgrammingModel,
    MaintenanceProgrammingModel,
    QFilterCondition> {
  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assetIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assetIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assetIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assetIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assetId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assetIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assetIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
          QAfterFilterCondition>
      assetIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
          QAfterFilterCondition>
      assetIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assetId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetId',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetId',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assignedToTechIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'assignedToTechId',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assignedToTechIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'assignedToTechId',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assignedToTechIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assignedToTechId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assignedToTechIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assignedToTechId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assignedToTechIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assignedToTechId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assignedToTechIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assignedToTechId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assignedToTechIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assignedToTechId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assignedToTechIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assignedToTechId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
          QAfterFilterCondition>
      assignedToTechIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assignedToTechId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
          QAfterFilterCondition>
      assignedToTechIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assignedToTechId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assignedToTechIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assignedToTechId',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> assignedToTechIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assignedToTechId',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> cityIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cityId',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> cityIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cityId',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> cityIdEqualTo(
    String? value, {
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> cityIdGreaterThan(
    String? value, {
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> cityIdLessThan(
    String? value, {
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> cityIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> cityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityId',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> cityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cityId',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'incidenciasIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'incidenciasIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'incidenciasIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'incidenciasIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'incidenciasIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'incidenciasIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
          QAfterFilterCondition>
      incidenciasIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'incidenciasIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
          QAfterFilterCondition>
      incidenciasIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'incidenciasIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'incidenciasIds',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'incidenciasIds',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'incidenciasIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'incidenciasIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'incidenciasIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'incidenciasIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'incidenciasIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> incidenciasIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'incidenciasIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> notesEqualTo(
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> notesGreaterThan(
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> notesLessThan(
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> notesBetween(
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> notesStartsWith(
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> notesEndsWith(
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
          QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
          QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> orgIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orgId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> orgIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orgId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> orgIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orgId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> orgIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orgId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> orgIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'orgId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> orgIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'orgId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
          QAfterFilterCondition>
      orgIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'orgId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
          QAfterFilterCondition>
      orgIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'orgId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> orgIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orgId',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> orgIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orgId',
        value: '',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> programmingDatesElementEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'programmingDates',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> programmingDatesElementGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'programmingDates',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> programmingDatesElementLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'programmingDates',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> programmingDatesElementBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'programmingDates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> programmingDatesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'programmingDates',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> programmingDatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'programmingDates',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> programmingDatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'programmingDates',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> programmingDatesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'programmingDates',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> programmingDatesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'programmingDates',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> programmingDatesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'programmingDates',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
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
}

extension MaintenanceProgrammingModelQueryObject on QueryBuilder<
    MaintenanceProgrammingModel,
    MaintenanceProgrammingModel,
    QFilterCondition> {}

extension MaintenanceProgrammingModelQueryLinks on QueryBuilder<
    MaintenanceProgrammingModel,
    MaintenanceProgrammingModel,
    QFilterCondition> {}

extension MaintenanceProgrammingModelQuerySortBy on QueryBuilder<
    MaintenanceProgrammingModel, MaintenanceProgrammingModel, QSortBy> {
  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByAssignedToTechId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedToTechId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByAssignedToTechIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedToTechId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByCityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByCityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByOrgId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByOrgIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MaintenanceProgrammingModelQuerySortThenBy on QueryBuilder<
    MaintenanceProgrammingModel, MaintenanceProgrammingModel, QSortThenBy> {
  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByAssignedToTechId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedToTechId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByAssignedToTechIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedToTechId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByCityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByCityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByOrgId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByOrgIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.desc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MaintenanceProgrammingModelQueryWhereDistinct on QueryBuilder<
    MaintenanceProgrammingModel, MaintenanceProgrammingModel, QDistinct> {
  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QDistinct> distinctByAssetId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QDistinct> distinctByAssignedToTechId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assignedToTechId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QDistinct> distinctByCityId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QDistinct> distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QDistinct> distinctByIncidenciasIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'incidenciasIds');
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QDistinct> distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QDistinct> distinctByOrgId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orgId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QDistinct> distinctByProgrammingDates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'programmingDates');
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, MaintenanceProgrammingModel,
      QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension MaintenanceProgrammingModelQueryProperty on QueryBuilder<
    MaintenanceProgrammingModel, MaintenanceProgrammingModel, QQueryProperty> {
  QueryBuilder<MaintenanceProgrammingModel, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, String, QQueryOperations>
      assetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetId');
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, String?, QQueryOperations>
      assignedToTechIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assignedToTechId');
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, String?, QQueryOperations>
      cityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cityId');
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, String, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, List<String>, QQueryOperations>
      incidenciasIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'incidenciasIds');
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, String?, QQueryOperations>
      notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, String, QQueryOperations>
      orgIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orgId');
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, List<DateTime>, QQueryOperations>
      programmingDatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'programmingDates');
    });
  }

  QueryBuilder<MaintenanceProgrammingModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaintenanceProgrammingModel _$MaintenanceProgrammingModelFromJson(
        Map<String, dynamic> json) =>
    MaintenanceProgrammingModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      assetId: json['assetId'] as String,
      incidenciasIds: (json['incidenciasIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      programmingDates: (json['programmingDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          const [],
      assignedToTechId: json['assignedToTechId'] as String?,
      notes: json['notes'] as String?,
      cityId: json['cityId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MaintenanceProgrammingModelToJson(
        MaintenanceProgrammingModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'orgId': instance.orgId,
      'assetId': instance.assetId,
      'incidenciasIds': instance.incidenciasIds,
      'programmingDates':
          instance.programmingDates.map((e) => e.toIso8601String()).toList(),
      'assignedToTechId': instance.assignedToTechId,
      'notes': instance.notes,
      'cityId': instance.cityId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
