// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_request_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPurchaseRequestModelCollection on Isar {
  IsarCollection<PurchaseRequestModel> get purchaseRequestModels =>
      this.collection();
}

const PurchaseRequestModelSchema = CollectionSchema(
  name: r'PurchaseRequestModel',
  id: -8083435316994038972,
  properties: {
    r'assetId': PropertySchema(
      id: 0,
      name: r'assetId',
      type: IsarType.string,
    ),
    r'cantidad': PropertySchema(
      id: 1,
      name: r'cantidad',
      type: IsarType.long,
    ),
    r'ciudadEntrega': PropertySchema(
      id: 2,
      name: r'ciudadEntrega',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currencyCode': PropertySchema(
      id: 4,
      name: r'currencyCode',
      type: IsarType.string,
    ),
    r'estado': PropertySchema(
      id: 5,
      name: r'estado',
      type: IsarType.string,
    ),
    r'expectedDate': PropertySchema(
      id: 6,
      name: r'expectedDate',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 7,
      name: r'id',
      type: IsarType.string,
    ),
    r'orgId': PropertySchema(
      id: 8,
      name: r'orgId',
      type: IsarType.string,
    ),
    r'proveedorIdsInvitados': PropertySchema(
      id: 9,
      name: r'proveedorIdsInvitados',
      type: IsarType.stringList,
    ),
    r'respuestasCount': PropertySchema(
      id: 10,
      name: r'respuestasCount',
      type: IsarType.long,
    ),
    r'specs': PropertySchema(
      id: 11,
      name: r'specs',
      type: IsarType.string,
    ),
    r'tipoRepuesto': PropertySchema(
      id: 12,
      name: r'tipoRepuesto',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 13,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _purchaseRequestModelEstimateSize,
  serialize: _purchaseRequestModelSerialize,
  deserialize: _purchaseRequestModelDeserialize,
  deserializeProp: _purchaseRequestModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: 3268,
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
    r'ciudadEntrega': IndexSchema(
      id: 1968936498738213552,
      name: r'ciudadEntrega',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'ciudadEntrega',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'estado': IndexSchema(
      id: -4800696143246816208,
      name: r'estado',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'estado',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _purchaseRequestModelGetId,
  getLinks: _purchaseRequestModelGetLinks,
  attach: _purchaseRequestModelAttach,
  version: '3.2.0-dev.2',
);

int _purchaseRequestModelEstimateSize(
  PurchaseRequestModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.assetId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.ciudadEntrega.length * 3;
  bytesCount += 3 + object.currencyCode.length * 3;
  bytesCount += 3 + object.estado.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.orgId.length * 3;
  bytesCount += 3 + object.proveedorIdsInvitados.length * 3;
  {
    for (var i = 0; i < object.proveedorIdsInvitados.length; i++) {
      final value = object.proveedorIdsInvitados[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.specs;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tipoRepuesto.length * 3;
  return bytesCount;
}

void _purchaseRequestModelSerialize(
  PurchaseRequestModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assetId);
  writer.writeLong(offsets[1], object.cantidad);
  writer.writeString(offsets[2], object.ciudadEntrega);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.currencyCode);
  writer.writeString(offsets[5], object.estado);
  writer.writeDateTime(offsets[6], object.expectedDate);
  writer.writeString(offsets[7], object.id);
  writer.writeString(offsets[8], object.orgId);
  writer.writeStringList(offsets[9], object.proveedorIdsInvitados);
  writer.writeLong(offsets[10], object.respuestasCount);
  writer.writeString(offsets[11], object.specs);
  writer.writeString(offsets[12], object.tipoRepuesto);
  writer.writeDateTime(offsets[13], object.updatedAt);
}

PurchaseRequestModel _purchaseRequestModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PurchaseRequestModel(
    assetId: reader.readStringOrNull(offsets[0]),
    cantidad: reader.readLong(offsets[1]),
    ciudadEntrega: reader.readString(offsets[2]),
    createdAt: reader.readDateTimeOrNull(offsets[3]),
    currencyCode: reader.readString(offsets[4]),
    estado: reader.readString(offsets[5]),
    expectedDate: reader.readDateTimeOrNull(offsets[6]),
    id: reader.readString(offsets[7]),
    isarId: id,
    orgId: reader.readString(offsets[8]),
    proveedorIdsInvitados: reader.readStringList(offsets[9]) ?? const [],
    respuestasCount: reader.readLongOrNull(offsets[10]) ?? 0,
    specs: reader.readStringOrNull(offsets[11]),
    tipoRepuesto: reader.readString(offsets[12]),
    updatedAt: reader.readDateTimeOrNull(offsets[13]),
  );
  return object;
}

P _purchaseRequestModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringList(offset) ?? const []) as P;
    case 10:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _purchaseRequestModelGetId(PurchaseRequestModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _purchaseRequestModelGetLinks(
    PurchaseRequestModel object) {
  return [];
}

void _purchaseRequestModelAttach(
    IsarCollection<dynamic> col, Id id, PurchaseRequestModel object) {
  object.isarId = id;
}

extension PurchaseRequestModelByIndex on IsarCollection<PurchaseRequestModel> {
  Future<PurchaseRequestModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  PurchaseRequestModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<PurchaseRequestModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<PurchaseRequestModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(PurchaseRequestModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(PurchaseRequestModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<PurchaseRequestModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<PurchaseRequestModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension PurchaseRequestModelQueryWhereSort
    on QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QWhere> {
  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PurchaseRequestModelQueryWhere
    on QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QWhereClause> {
  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      orgIdEqualTo(String orgId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orgId',
        value: [orgId],
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      orgIdNotEqualTo(String orgId) {
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      assetIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'assetId',
        value: [null],
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      assetIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'assetId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      assetIdEqualTo(String? assetId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'assetId',
        value: [assetId],
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      assetIdNotEqualTo(String? assetId) {
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      ciudadEntregaEqualTo(String ciudadEntrega) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ciudadEntrega',
        value: [ciudadEntrega],
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      ciudadEntregaNotEqualTo(String ciudadEntrega) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ciudadEntrega',
              lower: [],
              upper: [ciudadEntrega],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ciudadEntrega',
              lower: [ciudadEntrega],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ciudadEntrega',
              lower: [ciudadEntrega],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ciudadEntrega',
              lower: [],
              upper: [ciudadEntrega],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      estadoEqualTo(String estado) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'estado',
        value: [estado],
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      estadoNotEqualTo(String estado) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'estado',
              lower: [],
              upper: [estado],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'estado',
              lower: [estado],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'estado',
              lower: [estado],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'estado',
              lower: [],
              upper: [estado],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PurchaseRequestModelQueryFilter on QueryBuilder<PurchaseRequestModel,
    PurchaseRequestModel, QFilterCondition> {
  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> assetIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'assetId',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> assetIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'assetId',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> assetIdEqualTo(
    String? value, {
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> assetIdGreaterThan(
    String? value, {
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> assetIdLessThan(
    String? value, {
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> assetIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> assetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetId',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> assetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetId',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> cantidadEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cantidad',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> cantidadGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cantidad',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> cantidadLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cantidad',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> cantidadBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cantidad',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> ciudadEntregaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ciudadEntrega',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> ciudadEntregaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ciudadEntrega',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> ciudadEntregaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ciudadEntrega',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> ciudadEntregaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ciudadEntrega',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> ciudadEntregaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ciudadEntrega',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> ciudadEntregaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ciudadEntrega',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      ciudadEntregaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ciudadEntrega',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      ciudadEntregaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ciudadEntrega',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> ciudadEntregaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ciudadEntrega',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> ciudadEntregaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ciudadEntrega',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> currencyCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currencyCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> currencyCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currencyCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> currencyCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currencyCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> currencyCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currencyCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> currencyCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currencyCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> currencyCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currencyCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      currencyCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currencyCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      currencyCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currencyCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> currencyCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currencyCode',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> currencyCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currencyCode',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> estadoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> estadoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> estadoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> estadoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estado',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> estadoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> estadoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      estadoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'estado',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      estadoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'estado',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> estadoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estado',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> estadoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'estado',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> expectedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expectedDate',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> expectedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expectedDate',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> expectedDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expectedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> expectedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expectedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> expectedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expectedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> expectedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expectedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> orgIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orgId',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> orgIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orgId',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proveedorIdsInvitados',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proveedorIdsInvitados',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proveedorIdsInvitados',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proveedorIdsInvitados',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'proveedorIdsInvitados',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'proveedorIdsInvitados',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      proveedorIdsInvitadosElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'proveedorIdsInvitados',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      proveedorIdsInvitadosElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'proveedorIdsInvitados',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proveedorIdsInvitados',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'proveedorIdsInvitados',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'proveedorIdsInvitados',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'proveedorIdsInvitados',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'proveedorIdsInvitados',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'proveedorIdsInvitados',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'proveedorIdsInvitados',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> proveedorIdsInvitadosLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'proveedorIdsInvitados',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> respuestasCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'respuestasCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> respuestasCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'respuestasCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> respuestasCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'respuestasCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> respuestasCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'respuestasCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> specsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'specs',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> specsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'specs',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> specsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'specs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> specsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'specs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> specsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'specs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> specsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'specs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> specsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'specs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> specsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'specs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      specsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'specs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      specsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'specs',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> specsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'specs',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> specsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'specs',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> tipoRepuestoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipoRepuesto',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> tipoRepuestoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tipoRepuesto',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> tipoRepuestoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tipoRepuesto',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> tipoRepuestoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tipoRepuesto',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> tipoRepuestoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tipoRepuesto',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> tipoRepuestoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tipoRepuesto',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      tipoRepuestoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tipoRepuesto',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      tipoRepuestoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tipoRepuesto',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> tipoRepuestoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipoRepuesto',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> tipoRepuestoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tipoRepuesto',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

extension PurchaseRequestModelQueryObject on QueryBuilder<PurchaseRequestModel,
    PurchaseRequestModel, QFilterCondition> {}

extension PurchaseRequestModelQueryLinks on QueryBuilder<PurchaseRequestModel,
    PurchaseRequestModel, QFilterCondition> {}

extension PurchaseRequestModelQuerySortBy
    on QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QSortBy> {
  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByCantidad() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cantidad', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByCantidadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cantidad', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByCiudadEntrega() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ciudadEntrega', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByCiudadEntregaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ciudadEntrega', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByCurrencyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByCurrencyCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByExpectedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedDate', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByExpectedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedDate', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByOrgId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByOrgIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByRespuestasCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'respuestasCount', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByRespuestasCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'respuestasCount', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortBySpecs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specs', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortBySpecsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specs', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByTipoRepuesto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoRepuesto', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByTipoRepuestoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoRepuesto', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PurchaseRequestModelQuerySortThenBy
    on QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QSortThenBy> {
  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByCantidad() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cantidad', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByCantidadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cantidad', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByCiudadEntrega() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ciudadEntrega', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByCiudadEntregaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ciudadEntrega', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByCurrencyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByCurrencyCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByEstado() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByEstadoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estado', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByExpectedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedDate', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByExpectedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedDate', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByOrgId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByOrgIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByRespuestasCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'respuestasCount', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByRespuestasCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'respuestasCount', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenBySpecs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specs', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenBySpecsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'specs', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByTipoRepuesto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoRepuesto', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByTipoRepuestoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoRepuesto', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension PurchaseRequestModelQueryWhereDistinct
    on QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct> {
  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByAssetId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByCantidad() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cantidad');
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByCiudadEntrega({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ciudadEntrega',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByCurrencyCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currencyCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByEstado({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estado', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByExpectedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedDate');
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByOrgId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orgId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByProveedorIdsInvitados() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proveedorIdsInvitados');
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByRespuestasCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'respuestasCount');
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctBySpecs({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'specs', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByTipoRepuesto({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tipoRepuesto', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension PurchaseRequestModelQueryProperty on QueryBuilder<
    PurchaseRequestModel, PurchaseRequestModel, QQueryProperty> {
  QueryBuilder<PurchaseRequestModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      assetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetId');
    });
  }

  QueryBuilder<PurchaseRequestModel, int, QQueryOperations> cantidadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cantidad');
    });
  }

  QueryBuilder<PurchaseRequestModel, String, QQueryOperations>
      ciudadEntregaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ciudadEntrega');
    });
  }

  QueryBuilder<PurchaseRequestModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PurchaseRequestModel, String, QQueryOperations>
      currencyCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currencyCode');
    });
  }

  QueryBuilder<PurchaseRequestModel, String, QQueryOperations>
      estadoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estado');
    });
  }

  QueryBuilder<PurchaseRequestModel, DateTime?, QQueryOperations>
      expectedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedDate');
    });
  }

  QueryBuilder<PurchaseRequestModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PurchaseRequestModel, String, QQueryOperations> orgIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orgId');
    });
  }

  QueryBuilder<PurchaseRequestModel, List<String>, QQueryOperations>
      proveedorIdsInvitadosProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proveedorIdsInvitados');
    });
  }

  QueryBuilder<PurchaseRequestModel, int, QQueryOperations>
      respuestasCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'respuestasCount');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      specsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'specs');
    });
  }

  QueryBuilder<PurchaseRequestModel, String, QQueryOperations>
      tipoRepuestoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tipoRepuesto');
    });
  }

  QueryBuilder<PurchaseRequestModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseRequestModel _$PurchaseRequestModelFromJson(
        Map<String, dynamic> json) =>
    PurchaseRequestModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      orgId: json['orgId'] as String,
      assetId: json['assetId'] as String?,
      tipoRepuesto: json['tipoRepuesto'] as String,
      specs: json['specs'] as String?,
      cantidad: (json['cantidad'] as num).toInt(),
      ciudadEntrega: json['ciudadEntrega'] as String,
      proveedorIdsInvitados: (json['proveedorIdsInvitados'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      estado: json['estado'] as String,
      respuestasCount: (json['respuestasCount'] as num?)?.toInt() ?? 0,
      currencyCode: json['currencyCode'] as String,
      expectedDate: json['expectedDate'] == null
          ? null
          : DateTime.parse(json['expectedDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PurchaseRequestModelToJson(
        PurchaseRequestModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'orgId': instance.orgId,
      'assetId': instance.assetId,
      'tipoRepuesto': instance.tipoRepuesto,
      'specs': instance.specs,
      'cantidad': instance.cantidad,
      'ciudadEntrega': instance.ciudadEntrega,
      'proveedorIdsInvitados': instance.proveedorIdsInvitados,
      'estado': instance.estado,
      'respuestasCount': instance.respuestasCount,
      'currencyCode': instance.currencyCode,
      'expectedDate': instance.expectedDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
