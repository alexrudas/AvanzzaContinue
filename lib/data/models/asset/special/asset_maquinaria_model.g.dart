// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_maquinaria_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAssetMaquinariaModelCollection on Isar {
  IsarCollection<AssetMaquinariaModel> get assetMaquinariaModels =>
      this.collection();
}

const AssetMaquinariaModelSchema = CollectionSchema(
  name: r'AssetMaquinariaModel',
  id: -4168502842781591889,
  properties: {
    r'assetId': PropertySchema(
      id: 0,
      name: r'assetId',
      type: IsarType.string,
    ),
    r'capacidad': PropertySchema(
      id: 1,
      name: r'capacidad',
      type: IsarType.string,
    ),
    r'categoria': PropertySchema(
      id: 2,
      name: r'categoria',
      type: IsarType.string,
    ),
    r'certificadoOperacion': PropertySchema(
      id: 3,
      name: r'certificadoOperacion',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'marca': PropertySchema(
      id: 5,
      name: r'marca',
      type: IsarType.string,
    ),
    r'serie': PropertySchema(
      id: 6,
      name: r'serie',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _assetMaquinariaModelEstimateSize,
  serialize: _assetMaquinariaModelSerialize,
  deserialize: _assetMaquinariaModelDeserialize,
  deserializeProp: _assetMaquinariaModelDeserializeProp,
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
    r'serie': IndexSchema(
      id: 9157006907932630484,
      name: r'serie',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'serie',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'categoria': IndexSchema(
      id: -697249392299839610,
      name: r'categoria',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'categoria',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _assetMaquinariaModelGetId,
  getLinks: _assetMaquinariaModelGetLinks,
  attach: _assetMaquinariaModelAttach,
  version: '3.2.0-dev.2',
);

int _assetMaquinariaModelEstimateSize(
  AssetMaquinariaModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assetId.length * 3;
  bytesCount += 3 + object.capacidad.length * 3;
  bytesCount += 3 + object.categoria.length * 3;
  {
    final value = object.certificadoOperacion;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.marca.length * 3;
  bytesCount += 3 + object.serie.length * 3;
  return bytesCount;
}

void _assetMaquinariaModelSerialize(
  AssetMaquinariaModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assetId);
  writer.writeString(offsets[1], object.capacidad);
  writer.writeString(offsets[2], object.categoria);
  writer.writeString(offsets[3], object.certificadoOperacion);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.marca);
  writer.writeString(offsets[6], object.serie);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

AssetMaquinariaModel _assetMaquinariaModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AssetMaquinariaModel(
    assetId: reader.readString(offsets[0]),
    capacidad: reader.readString(offsets[1]),
    categoria: reader.readString(offsets[2]),
    certificadoOperacion: reader.readStringOrNull(offsets[3]),
    createdAt: reader.readDateTimeOrNull(offsets[4]),
    isarId: id,
    marca: reader.readString(offsets[5]),
    serie: reader.readString(offsets[6]),
    updatedAt: reader.readDateTimeOrNull(offsets[7]),
  );
  return object;
}

P _assetMaquinariaModelDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
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

Id _assetMaquinariaModelGetId(AssetMaquinariaModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _assetMaquinariaModelGetLinks(
    AssetMaquinariaModel object) {
  return [];
}

void _assetMaquinariaModelAttach(
    IsarCollection<dynamic> col, Id id, AssetMaquinariaModel object) {
  object.isarId = id;
}

extension AssetMaquinariaModelByIndex on IsarCollection<AssetMaquinariaModel> {
  Future<AssetMaquinariaModel?> getByAssetId(String assetId) {
    return getByIndex(r'assetId', [assetId]);
  }

  AssetMaquinariaModel? getByAssetIdSync(String assetId) {
    return getByIndexSync(r'assetId', [assetId]);
  }

  Future<bool> deleteByAssetId(String assetId) {
    return deleteByIndex(r'assetId', [assetId]);
  }

  bool deleteByAssetIdSync(String assetId) {
    return deleteByIndexSync(r'assetId', [assetId]);
  }

  Future<List<AssetMaquinariaModel?>> getAllByAssetId(
      List<String> assetIdValues) {
    final values = assetIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'assetId', values);
  }

  List<AssetMaquinariaModel?> getAllByAssetIdSync(List<String> assetIdValues) {
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

  Future<Id> putByAssetId(AssetMaquinariaModel object) {
    return putByIndex(r'assetId', object);
  }

  Id putByAssetIdSync(AssetMaquinariaModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'assetId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAssetId(List<AssetMaquinariaModel> objects) {
    return putAllByIndex(r'assetId', objects);
  }

  List<Id> putAllByAssetIdSync(List<AssetMaquinariaModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'assetId', objects, saveLinks: saveLinks);
  }
}

extension AssetMaquinariaModelQueryWhereSort
    on QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QWhere> {
  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AssetMaquinariaModelQueryWhere
    on QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QWhereClause> {
  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterWhereClause>
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterWhereClause>
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterWhereClause>
      assetIdEqualTo(String assetId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'assetId',
        value: [assetId],
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterWhereClause>
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterWhereClause>
      serieEqualTo(String serie) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'serie',
        value: [serie],
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterWhereClause>
      serieNotEqualTo(String serie) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serie',
              lower: [],
              upper: [serie],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serie',
              lower: [serie],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serie',
              lower: [serie],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'serie',
              lower: [],
              upper: [serie],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterWhereClause>
      categoriaEqualTo(String categoria) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'categoria',
        value: [categoria],
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterWhereClause>
      categoriaNotEqualTo(String categoria) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoria',
              lower: [],
              upper: [categoria],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoria',
              lower: [categoria],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoria',
              lower: [categoria],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoria',
              lower: [],
              upper: [categoria],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AssetMaquinariaModelQueryFilter on QueryBuilder<AssetMaquinariaModel,
    AssetMaquinariaModel, QFilterCondition> {
  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> assetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> assetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> capacidadEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capacidad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> capacidadGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'capacidad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> capacidadLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'capacidad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> capacidadBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'capacidad',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> capacidadStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'capacidad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> capacidadEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'capacidad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
          QAfterFilterCondition>
      capacidadContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'capacidad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
          QAfterFilterCondition>
      capacidadMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'capacidad',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> capacidadIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capacidad',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> capacidadIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'capacidad',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> categoriaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> categoriaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> categoriaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> categoriaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoria',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> categoriaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> categoriaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
          QAfterFilterCondition>
      categoriaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
          QAfterFilterCondition>
      categoriaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoria',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> categoriaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoria',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> categoriaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoria',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> certificadoOperacionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'certificadoOperacion',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> certificadoOperacionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'certificadoOperacion',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> certificadoOperacionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'certificadoOperacion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> certificadoOperacionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'certificadoOperacion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> certificadoOperacionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'certificadoOperacion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> certificadoOperacionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'certificadoOperacion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> certificadoOperacionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'certificadoOperacion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> certificadoOperacionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'certificadoOperacion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
          QAfterFilterCondition>
      certificadoOperacionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'certificadoOperacion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
          QAfterFilterCondition>
      certificadoOperacionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'certificadoOperacion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> certificadoOperacionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'certificadoOperacion',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> certificadoOperacionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'certificadoOperacion',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> marcaEqualTo(
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> marcaGreaterThan(
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> marcaLessThan(
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> marcaBetween(
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> marcaStartsWith(
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> marcaEndsWith(
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
          QAfterFilterCondition>
      marcaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'marca',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
          QAfterFilterCondition>
      marcaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'marca',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> marcaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'marca',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> marcaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'marca',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> serieEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> serieGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> serieLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> serieBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serie',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> serieStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'serie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> serieEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'serie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
          QAfterFilterCondition>
      serieContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serie',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
          QAfterFilterCondition>
      serieMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serie',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> serieIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serie',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> serieIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serie',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel,
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

extension AssetMaquinariaModelQueryObject on QueryBuilder<AssetMaquinariaModel,
    AssetMaquinariaModel, QFilterCondition> {}

extension AssetMaquinariaModelQueryLinks on QueryBuilder<AssetMaquinariaModel,
    AssetMaquinariaModel, QFilterCondition> {}

extension AssetMaquinariaModelQuerySortBy
    on QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QSortBy> {
  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByCapacidad() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacidad', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByCapacidadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacidad', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByCategoria() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoria', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByCategoriaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoria', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByCertificadoOperacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'certificadoOperacion', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByCertificadoOperacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'certificadoOperacion', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByMarca() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marca', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByMarcaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marca', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortBySerie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serie', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortBySerieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serie', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AssetMaquinariaModelQuerySortThenBy
    on QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QSortThenBy> {
  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByCapacidad() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacidad', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByCapacidadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capacidad', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByCategoria() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoria', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByCategoriaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoria', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByCertificadoOperacion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'certificadoOperacion', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByCertificadoOperacionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'certificadoOperacion', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByMarca() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marca', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByMarcaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marca', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenBySerie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serie', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenBySerieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serie', Sort.desc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AssetMaquinariaModelQueryWhereDistinct
    on QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QDistinct> {
  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QDistinct>
      distinctByAssetId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QDistinct>
      distinctByCapacidad({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capacidad', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QDistinct>
      distinctByCategoria({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoria', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QDistinct>
      distinctByCertificadoOperacion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'certificadoOperacion',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QDistinct>
      distinctByMarca({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'marca', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QDistinct>
      distinctBySerie({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serie', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetMaquinariaModel, AssetMaquinariaModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension AssetMaquinariaModelQueryProperty on QueryBuilder<
    AssetMaquinariaModel, AssetMaquinariaModel, QQueryProperty> {
  QueryBuilder<AssetMaquinariaModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<AssetMaquinariaModel, String, QQueryOperations>
      assetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetId');
    });
  }

  QueryBuilder<AssetMaquinariaModel, String, QQueryOperations>
      capacidadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capacidad');
    });
  }

  QueryBuilder<AssetMaquinariaModel, String, QQueryOperations>
      categoriaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoria');
    });
  }

  QueryBuilder<AssetMaquinariaModel, String?, QQueryOperations>
      certificadoOperacionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'certificadoOperacion');
    });
  }

  QueryBuilder<AssetMaquinariaModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AssetMaquinariaModel, String, QQueryOperations> marcaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'marca');
    });
  }

  QueryBuilder<AssetMaquinariaModel, String, QQueryOperations> serieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serie');
    });
  }

  QueryBuilder<AssetMaquinariaModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetMaquinariaModel _$AssetMaquinariaModelFromJson(
        Map<String, dynamic> json) =>
    AssetMaquinariaModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      assetId: json['assetId'] as String,
      serie: json['serie'] as String,
      marca: json['marca'] as String,
      capacidad: json['capacidad'] as String,
      categoria: json['categoria'] as String,
      certificadoOperacion: json['certificadoOperacion'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AssetMaquinariaModelToJson(
        AssetMaquinariaModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'assetId': instance.assetId,
      'serie': instance.serie,
      'marca': instance.marca,
      'capacidad': instance.capacidad,
      'categoria': instance.categoria,
      'certificadoOperacion': instance.certificadoOperacion,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
