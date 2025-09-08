// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_vehiculo_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAssetVehiculoModelCollection on Isar {
  IsarCollection<AssetVehiculoModel> get assetVehiculoModels =>
      this.collection();
}

const AssetVehiculoModelSchema = CollectionSchema(
  name: r'AssetVehiculoModel',
  id: 445573579651451043,
  properties: {
    r'anio': PropertySchema(
      id: 0,
      name: r'anio',
      type: IsarType.long,
    ),
    r'assetId': PropertySchema(
      id: 1,
      name: r'assetId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'marca': PropertySchema(
      id: 3,
      name: r'marca',
      type: IsarType.string,
    ),
    r'modelo': PropertySchema(
      id: 4,
      name: r'modelo',
      type: IsarType.string,
    ),
    r'placa': PropertySchema(
      id: 5,
      name: r'placa',
      type: IsarType.string,
    ),
    r'refCode': PropertySchema(
      id: 6,
      name: r'refCode',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _assetVehiculoModelEstimateSize,
  serialize: _assetVehiculoModelSerialize,
  deserialize: _assetVehiculoModelDeserialize,
  deserializeProp: _assetVehiculoModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'assetId': IndexSchema(
      id: 174362542210192109,
      name: r'assetId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'assetId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'refCode': IndexSchema(
      id: 1128405496072864630,
      name: r'refCode',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'refCode',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'placa': IndexSchema(
      id: 3507459132299045558,
      name: r'placa',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'placa',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _assetVehiculoModelGetId,
  getLinks: _assetVehiculoModelGetLinks,
  attach: _assetVehiculoModelAttach,
  version: '3.2.0-dev.2',
);

int _assetVehiculoModelEstimateSize(
  AssetVehiculoModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assetId.length * 3;
  bytesCount += 3 + object.marca.length * 3;
  bytesCount += 3 + object.modelo.length * 3;
  bytesCount += 3 + object.placa.length * 3;
  bytesCount += 3 + object.refCode.length * 3;
  return bytesCount;
}

void _assetVehiculoModelSerialize(
  AssetVehiculoModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.anio);
  writer.writeString(offsets[1], object.assetId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.marca);
  writer.writeString(offsets[4], object.modelo);
  writer.writeString(offsets[5], object.placa);
  writer.writeString(offsets[6], object.refCode);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

AssetVehiculoModel _assetVehiculoModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AssetVehiculoModel(
    anio: reader.readLong(offsets[0]),
    assetId: reader.readString(offsets[1]),
    createdAt: reader.readDateTimeOrNull(offsets[2]),
    isarId: id,
    marca: reader.readString(offsets[3]),
    modelo: reader.readString(offsets[4]),
    placa: reader.readString(offsets[5]),
    refCode: reader.readString(offsets[6]),
    updatedAt: reader.readDateTimeOrNull(offsets[7]),
  );
  return object;
}

P _assetVehiculoModelDeserializeProp<P>(
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
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _assetVehiculoModelGetId(AssetVehiculoModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _assetVehiculoModelGetLinks(
    AssetVehiculoModel object) {
  return [];
}

void _assetVehiculoModelAttach(
    IsarCollection<dynamic> col, Id id, AssetVehiculoModel object) {
  object.isarId = id;
}

extension AssetVehiculoModelByIndex on IsarCollection<AssetVehiculoModel> {
  Future<AssetVehiculoModel?> getByAssetId(String assetId) {
    return getByIndex(r'assetId', [assetId]);
  }

  AssetVehiculoModel? getByAssetIdSync(String assetId) {
    return getByIndexSync(r'assetId', [assetId]);
  }

  Future<bool> deleteByAssetId(String assetId) {
    return deleteByIndex(r'assetId', [assetId]);
  }

  bool deleteByAssetIdSync(String assetId) {
    return deleteByIndexSync(r'assetId', [assetId]);
  }

  Future<List<AssetVehiculoModel?>> getAllByAssetId(
      List<String> assetIdValues) {
    final values = assetIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'assetId', values);
  }

  List<AssetVehiculoModel?> getAllByAssetIdSync(List<String> assetIdValues) {
    final values = assetIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'assetId', values);
  }

  Future<int> deleteAllByAssetId(List<String> assetIdValues) {
    final values = assetIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'assetId', values);
  }

  int deleteAllByAssetIdSync(List<String> assetIdValues) {
    final values = assetIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'assetId', values);
  }

  Future<Id> putByAssetId(AssetVehiculoModel object) {
    return putByIndex(r'assetId', object);
  }

  Id putByAssetIdSync(AssetVehiculoModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'assetId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAssetId(List<AssetVehiculoModel> objects) {
    return putAllByIndex(r'assetId', objects);
  }

  List<Id> putAllByAssetIdSync(List<AssetVehiculoModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'assetId', objects, saveLinks: saveLinks);
  }
}

extension AssetVehiculoModelQueryWhereSort
    on QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QWhere> {
  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AssetVehiculoModelQueryWhere
    on QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QWhereClause> {
  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterWhereClause>
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterWhereClause>
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterWhereClause>
      assetIdEqualTo(String assetId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'assetId',
        value: [assetId],
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterWhereClause>
      assetIdNotEqualTo(String assetId) {
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterWhereClause>
      refCodeEqualTo(String refCode) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'refCode',
        value: [refCode],
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterWhereClause>
      refCodeNotEqualTo(String refCode) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'refCode',
              lower: [],
              upper: [refCode],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'refCode',
              lower: [refCode],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'refCode',
              lower: [refCode],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'refCode',
              lower: [],
              upper: [refCode],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterWhereClause>
      placaEqualTo(String placa) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'placa',
        value: [placa],
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterWhereClause>
      placaNotEqualTo(String placa) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'placa',
              lower: [],
              upper: [placa],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'placa',
              lower: [placa],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'placa',
              lower: [placa],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'placa',
              lower: [],
              upper: [placa],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AssetVehiculoModelQueryFilter
    on QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QFilterCondition> {
  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      anioEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'anio',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      anioGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'anio',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      anioLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'anio',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      anioBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'anio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      assetIdEqualTo(
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      assetIdGreaterThan(
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      assetIdLessThan(
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      assetIdBetween(
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      assetIdStartsWith(
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      assetIdEndsWith(
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      assetIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      assetIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assetId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      assetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      assetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      marcaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'marca',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      marcaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'marca',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      marcaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'marca',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      marcaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'marca',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      marcaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'marca',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      marcaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'marca',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      marcaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'marca',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      marcaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'marca',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      marcaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'marca',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      marcaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'marca',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      modeloEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      modeloGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modelo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      modeloLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modelo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      modeloBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modelo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      modeloStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modelo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      modeloEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modelo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      modeloContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modelo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      modeloMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modelo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      modeloIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelo',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      modeloIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modelo',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      placaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'placa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      placaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'placa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      placaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'placa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      placaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'placa',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      placaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'placa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      placaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'placa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      placaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'placa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      placaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'placa',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      placaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'placa',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      placaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'placa',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      refCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'refCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      refCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'refCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      refCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'refCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      refCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'refCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      refCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'refCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      refCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'refCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      refCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'refCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      refCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'refCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      refCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'refCode',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      refCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'refCode',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
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

extension AssetVehiculoModelQueryObject
    on QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QFilterCondition> {}

extension AssetVehiculoModelQueryLinks
    on QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QFilterCondition> {}

extension AssetVehiculoModelQuerySortBy
    on QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QSortBy> {
  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByAnio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anio', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByAnioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anio', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByMarca() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marca', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByMarcaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marca', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByModelo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelo', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByModeloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelo', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByPlaca() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placa', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByPlacaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placa', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByRefCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refCode', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByRefCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refCode', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AssetVehiculoModelQuerySortThenBy
    on QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QSortThenBy> {
  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByAnio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anio', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByAnioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anio', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByMarca() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marca', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByMarcaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marca', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByModelo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelo', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByModeloDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelo', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByPlaca() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placa', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByPlacaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placa', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByRefCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refCode', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByRefCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refCode', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AssetVehiculoModelQueryWhereDistinct
    on QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct> {
  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByAnio() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'anio');
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByAssetId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByMarca({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'marca', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByModelo({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByPlaca({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'placa', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByRefCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'refCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension AssetVehiculoModelQueryProperty
    on QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QQueryProperty> {
  QueryBuilder<AssetVehiculoModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<AssetVehiculoModel, int, QQueryOperations> anioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'anio');
    });
  }

  QueryBuilder<AssetVehiculoModel, String, QQueryOperations> assetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetId');
    });
  }

  QueryBuilder<AssetVehiculoModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AssetVehiculoModel, String, QQueryOperations> marcaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'marca');
    });
  }

  QueryBuilder<AssetVehiculoModel, String, QQueryOperations> modeloProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelo');
    });
  }

  QueryBuilder<AssetVehiculoModel, String, QQueryOperations> placaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'placa');
    });
  }

  QueryBuilder<AssetVehiculoModel, String, QQueryOperations> refCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'refCode');
    });
  }

  QueryBuilder<AssetVehiculoModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetVehiculoModel _$AssetVehiculoModelFromJson(Map<String, dynamic> json) =>
    AssetVehiculoModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      assetId: json['assetId'] as String,
      refCode: json['refCode'] as String,
      placa: json['placa'] as String,
      marca: json['marca'] as String,
      modelo: json['modelo'] as String,
      anio: (json['anio'] as num).toInt(),
      createdAt: const DateTimeTimestampConverter().fromJson(json['createdAt']),
      updatedAt: const DateTimeTimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$AssetVehiculoModelToJson(AssetVehiculoModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'assetId': instance.assetId,
      'refCode': instance.refCode,
      'placa': instance.placa,
      'marca': instance.marca,
      'modelo': instance.modelo,
      'anio': instance.anio,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const DateTimeTimestampConverter().toJson(instance.updatedAt),
    };
