// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_inmueble_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAssetInmuebleModelCollection on Isar {
  IsarCollection<AssetInmuebleModel> get assetInmuebleModels =>
      this.collection();
}

const AssetInmuebleModelSchema = CollectionSchema(
  name: r'AssetInmuebleModel',
  id: 4972459886534655093,
  properties: {
    r'assetId': PropertySchema(
      id: 0,
      name: r'assetId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'estrato': PropertySchema(
      id: 2,
      name: r'estrato',
      type: IsarType.long,
    ),
    r'matriculaInmobiliaria': PropertySchema(
      id: 3,
      name: r'matriculaInmobiliaria',
      type: IsarType.string,
    ),
    r'metrosCuadrados': PropertySchema(
      id: 4,
      name: r'metrosCuadrados',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'uso': PropertySchema(
      id: 6,
      name: r'uso',
      type: IsarType.string,
    ),
    r'valorCatastral': PropertySchema(
      id: 7,
      name: r'valorCatastral',
      type: IsarType.double,
    )
  },
  estimateSize: _assetInmuebleModelEstimateSize,
  serialize: _assetInmuebleModelSerialize,
  deserialize: _assetInmuebleModelDeserialize,
  deserializeProp: _assetInmuebleModelDeserializeProp,
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
    r'matriculaInmobiliaria': IndexSchema(
      id: 1220323132300573014,
      name: r'matriculaInmobiliaria',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'matriculaInmobiliaria',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'uso': IndexSchema(
      id: -4864125596045213677,
      name: r'uso',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uso',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _assetInmuebleModelGetId,
  getLinks: _assetInmuebleModelGetLinks,
  attach: _assetInmuebleModelAttach,
  version: '3.2.0-dev.2',
);

int _assetInmuebleModelEstimateSize(
  AssetInmuebleModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assetId.length * 3;
  bytesCount += 3 + object.matriculaInmobiliaria.length * 3;
  bytesCount += 3 + object.uso.length * 3;
  return bytesCount;
}

void _assetInmuebleModelSerialize(
  AssetInmuebleModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assetId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.estrato);
  writer.writeString(offsets[3], object.matriculaInmobiliaria);
  writer.writeDouble(offsets[4], object.metrosCuadrados);
  writer.writeDateTime(offsets[5], object.updatedAt);
  writer.writeString(offsets[6], object.uso);
  writer.writeDouble(offsets[7], object.valorCatastral);
}

AssetInmuebleModel _assetInmuebleModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AssetInmuebleModel(
    assetId: reader.readString(offsets[0]),
    createdAt: reader.readDateTimeOrNull(offsets[1]),
    estrato: reader.readLongOrNull(offsets[2]),
    isarId: id,
    matriculaInmobiliaria: reader.readString(offsets[3]),
    metrosCuadrados: reader.readDoubleOrNull(offsets[4]),
    updatedAt: reader.readDateTimeOrNull(offsets[5]),
    uso: reader.readString(offsets[6]),
    valorCatastral: reader.readDoubleOrNull(offsets[7]),
  );
  return object;
}

P _assetInmuebleModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _assetInmuebleModelGetId(AssetInmuebleModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _assetInmuebleModelGetLinks(
    AssetInmuebleModel object) {
  return [];
}

void _assetInmuebleModelAttach(
    IsarCollection<dynamic> col, Id id, AssetInmuebleModel object) {
  object.isarId = id;
}

extension AssetInmuebleModelByIndex on IsarCollection<AssetInmuebleModel> {
  Future<AssetInmuebleModel?> getByAssetId(String assetId) {
    return getByIndex(r'assetId', [assetId]);
  }

  AssetInmuebleModel? getByAssetIdSync(String assetId) {
    return getByIndexSync(r'assetId', [assetId]);
  }

  Future<bool> deleteByAssetId(String assetId) {
    return deleteByIndex(r'assetId', [assetId]);
  }

  bool deleteByAssetIdSync(String assetId) {
    return deleteByIndexSync(r'assetId', [assetId]);
  }

  Future<List<AssetInmuebleModel?>> getAllByAssetId(
      List<String> assetIdValues) {
    final values = assetIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'assetId', values);
  }

  List<AssetInmuebleModel?> getAllByAssetIdSync(List<String> assetIdValues) {
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

  Future<Id> putByAssetId(AssetInmuebleModel object) {
    return putByIndex(r'assetId', object);
  }

  Id putByAssetIdSync(AssetInmuebleModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'assetId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAssetId(List<AssetInmuebleModel> objects) {
    return putAllByIndex(r'assetId', objects);
  }

  List<Id> putAllByAssetIdSync(List<AssetInmuebleModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'assetId', objects, saveLinks: saveLinks);
  }
}

extension AssetInmuebleModelQueryWhereSort
    on QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QWhere> {
  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AssetInmuebleModelQueryWhere
    on QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QWhereClause> {
  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterWhereClause>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterWhereClause>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterWhereClause>
      assetIdEqualTo(String assetId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'assetId',
        value: [assetId],
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterWhereClause>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterWhereClause>
      matriculaInmobiliariaEqualTo(String matriculaInmobiliaria) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'matriculaInmobiliaria',
        value: [matriculaInmobiliaria],
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterWhereClause>
      matriculaInmobiliariaNotEqualTo(String matriculaInmobiliaria) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matriculaInmobiliaria',
              lower: [],
              upper: [matriculaInmobiliaria],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matriculaInmobiliaria',
              lower: [matriculaInmobiliaria],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matriculaInmobiliaria',
              lower: [matriculaInmobiliaria],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'matriculaInmobiliaria',
              lower: [],
              upper: [matriculaInmobiliaria],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterWhereClause>
      usoEqualTo(String uso) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uso',
        value: [uso],
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterWhereClause>
      usoNotEqualTo(String uso) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uso',
              lower: [],
              upper: [uso],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uso',
              lower: [uso],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uso',
              lower: [uso],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uso',
              lower: [],
              upper: [uso],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AssetInmuebleModelQueryFilter
    on QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QFilterCondition> {
  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      assetIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      assetIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assetId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      assetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      assetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      estratoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'estrato',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      estratoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'estrato',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      estratoEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estrato',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      estratoGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estrato',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      estratoLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estrato',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      estratoBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estrato',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      matriculaInmobiliariaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matriculaInmobiliaria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      matriculaInmobiliariaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matriculaInmobiliaria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      matriculaInmobiliariaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matriculaInmobiliaria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      matriculaInmobiliariaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matriculaInmobiliaria',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      matriculaInmobiliariaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'matriculaInmobiliaria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      matriculaInmobiliariaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'matriculaInmobiliaria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      matriculaInmobiliariaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'matriculaInmobiliaria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      matriculaInmobiliariaMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'matriculaInmobiliaria',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      matriculaInmobiliariaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matriculaInmobiliaria',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      matriculaInmobiliariaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'matriculaInmobiliaria',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      metrosCuadradosIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'metrosCuadrados',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      metrosCuadradosIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'metrosCuadrados',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      metrosCuadradosEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metrosCuadrados',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      metrosCuadradosGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metrosCuadrados',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      metrosCuadradosLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metrosCuadrados',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      metrosCuadradosBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metrosCuadrados',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
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

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      usoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      usoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      usoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      usoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      usoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      usoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      usoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      usoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      usoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uso',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      usoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uso',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      valorCatastralIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'valorCatastral',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      valorCatastralIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'valorCatastral',
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      valorCatastralEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valorCatastral',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      valorCatastralGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valorCatastral',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      valorCatastralLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valorCatastral',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterFilterCondition>
      valorCatastralBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valorCatastral',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension AssetInmuebleModelQueryObject
    on QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QFilterCondition> {}

extension AssetInmuebleModelQueryLinks
    on QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QFilterCondition> {}

extension AssetInmuebleModelQuerySortBy
    on QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QSortBy> {
  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByEstrato() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estrato', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByEstratoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estrato', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByMatriculaInmobiliaria() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculaInmobiliaria', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByMatriculaInmobiliariaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculaInmobiliaria', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByMetrosCuadrados() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metrosCuadrados', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByMetrosCuadradosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metrosCuadrados', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByUso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uso', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByUsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uso', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByValorCatastral() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorCatastral', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      sortByValorCatastralDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorCatastral', Sort.desc);
    });
  }
}

extension AssetInmuebleModelQuerySortThenBy
    on QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QSortThenBy> {
  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByEstrato() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estrato', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByEstratoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estrato', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByMatriculaInmobiliaria() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculaInmobiliaria', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByMatriculaInmobiliariaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matriculaInmobiliaria', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByMetrosCuadrados() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metrosCuadrados', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByMetrosCuadradosDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metrosCuadrados', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByUso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uso', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByUsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uso', Sort.desc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByValorCatastral() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorCatastral', Sort.asc);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QAfterSortBy>
      thenByValorCatastralDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorCatastral', Sort.desc);
    });
  }
}

extension AssetInmuebleModelQueryWhereDistinct
    on QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QDistinct> {
  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QDistinct>
      distinctByAssetId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QDistinct>
      distinctByEstrato() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estrato');
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QDistinct>
      distinctByMatriculaInmobiliaria({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matriculaInmobiliaria',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QDistinct>
      distinctByMetrosCuadrados() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metrosCuadrados');
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QDistinct> distinctByUso(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uso', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QDistinct>
      distinctByValorCatastral() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valorCatastral');
    });
  }
}

extension AssetInmuebleModelQueryProperty
    on QueryBuilder<AssetInmuebleModel, AssetInmuebleModel, QQueryProperty> {
  QueryBuilder<AssetInmuebleModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<AssetInmuebleModel, String, QQueryOperations> assetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetId');
    });
  }

  QueryBuilder<AssetInmuebleModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AssetInmuebleModel, int?, QQueryOperations> estratoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estrato');
    });
  }

  QueryBuilder<AssetInmuebleModel, String, QQueryOperations>
      matriculaInmobiliariaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matriculaInmobiliaria');
    });
  }

  QueryBuilder<AssetInmuebleModel, double?, QQueryOperations>
      metrosCuadradosProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metrosCuadrados');
    });
  }

  QueryBuilder<AssetInmuebleModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<AssetInmuebleModel, String, QQueryOperations> usoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uso');
    });
  }

  QueryBuilder<AssetInmuebleModel, double?, QQueryOperations>
      valorCatastralProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valorCatastral');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetInmuebleModel _$AssetInmuebleModelFromJson(Map<String, dynamic> json) =>
    AssetInmuebleModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      assetId: json['assetId'] as String,
      matriculaInmobiliaria: json['matriculaInmobiliaria'] as String,
      estrato: (json['estrato'] as num?)?.toInt(),
      metrosCuadrados: (json['metrosCuadrados'] as num?)?.toDouble(),
      uso: json['uso'] as String,
      valorCatastral: (json['valorCatastral'] as num?)?.toDouble(),
      createdAt: const DateTimeTimestampConverter().fromJson(json['createdAt']),
      updatedAt: const DateTimeTimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$AssetInmuebleModelToJson(AssetInmuebleModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'assetId': instance.assetId,
      'matriculaInmobiliaria': instance.matriculaInmobiliaria,
      'estrato': instance.estrato,
      'metrosCuadrados': instance.metrosCuadrados,
      'uso': instance.uso,
      'valorCatastral': instance.valorCatastral,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const DateTimeTimestampConverter().toJson(instance.updatedAt),
    };
