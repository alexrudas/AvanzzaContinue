// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_response_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSupplierResponseModelCollection on Isar {
  IsarCollection<SupplierResponseModel> get supplierResponseModels =>
      this.collection();
}

const SupplierResponseModelSchema = CollectionSchema(
  name: r'SupplierResponseModel',
  id: 6237119431742514614,
  properties: {
    r'catalogoUrl': PropertySchema(
      id: 0,
      name: r'catalogoUrl',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currencyCode': PropertySchema(
      id: 2,
      name: r'currencyCode',
      type: IsarType.string,
    ),
    r'disponibilidad': PropertySchema(
      id: 3,
      name: r'disponibilidad',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.string,
    ),
    r'leadTimeDays': PropertySchema(
      id: 5,
      name: r'leadTimeDays',
      type: IsarType.long,
    ),
    r'notas': PropertySchema(
      id: 6,
      name: r'notas',
      type: IsarType.string,
    ),
    r'precio': PropertySchema(
      id: 7,
      name: r'precio',
      type: IsarType.double,
    ),
    r'proveedorId': PropertySchema(
      id: 8,
      name: r'proveedorId',
      type: IsarType.string,
    ),
    r'purchaseRequestId': PropertySchema(
      id: 9,
      name: r'purchaseRequestId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _supplierResponseModelEstimateSize,
  serialize: _supplierResponseModelSerialize,
  deserialize: _supplierResponseModelDeserialize,
  deserializeProp: _supplierResponseModelDeserializeProp,
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
    r'purchaseRequestId': IndexSchema(
      id: 5100831415560349256,
      name: r'purchaseRequestId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'purchaseRequestId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'proveedorId': IndexSchema(
      id: -4481421140714930621,
      name: r'proveedorId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'proveedorId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _supplierResponseModelGetId,
  getLinks: _supplierResponseModelGetLinks,
  attach: _supplierResponseModelAttach,
  version: '3.2.0-dev.2',
);

int _supplierResponseModelEstimateSize(
  SupplierResponseModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.catalogoUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.currencyCode.length * 3;
  bytesCount += 3 + object.disponibilidad.length * 3;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.notas;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.proveedorId.length * 3;
  bytesCount += 3 + object.purchaseRequestId.length * 3;
  return bytesCount;
}

void _supplierResponseModelSerialize(
  SupplierResponseModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.catalogoUrl);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.currencyCode);
  writer.writeString(offsets[3], object.disponibilidad);
  writer.writeString(offsets[4], object.id);
  writer.writeLong(offsets[5], object.leadTimeDays);
  writer.writeString(offsets[6], object.notas);
  writer.writeDouble(offsets[7], object.precio);
  writer.writeString(offsets[8], object.proveedorId);
  writer.writeString(offsets[9], object.purchaseRequestId);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

SupplierResponseModel _supplierResponseModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SupplierResponseModel(
    catalogoUrl: reader.readStringOrNull(offsets[0]),
    createdAt: reader.readDateTimeOrNull(offsets[1]),
    currencyCode: reader.readString(offsets[2]),
    disponibilidad: reader.readString(offsets[3]),
    id: reader.readString(offsets[4]),
    isarId: id,
    leadTimeDays: reader.readLongOrNull(offsets[5]),
    notas: reader.readStringOrNull(offsets[6]),
    precio: reader.readDouble(offsets[7]),
    proveedorId: reader.readString(offsets[8]),
    purchaseRequestId: reader.readString(offsets[9]),
    updatedAt: reader.readDateTimeOrNull(offsets[10]),
  );
  return object;
}

P _supplierResponseModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _supplierResponseModelGetId(SupplierResponseModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _supplierResponseModelGetLinks(
    SupplierResponseModel object) {
  return [];
}

void _supplierResponseModelAttach(
    IsarCollection<dynamic> col, Id id, SupplierResponseModel object) {
  object.isarId = id;
}

extension SupplierResponseModelByIndex
    on IsarCollection<SupplierResponseModel> {
  Future<SupplierResponseModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  SupplierResponseModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<SupplierResponseModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<SupplierResponseModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(SupplierResponseModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(SupplierResponseModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<SupplierResponseModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<SupplierResponseModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension SupplierResponseModelQueryWhereSort
    on QueryBuilder<SupplierResponseModel, SupplierResponseModel, QWhere> {
  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SupplierResponseModelQueryWhere on QueryBuilder<SupplierResponseModel,
    SupplierResponseModel, QWhereClause> {
  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterWhereClause>
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterWhereClause>
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterWhereClause>
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterWhereClause>
      purchaseRequestIdEqualTo(String purchaseRequestId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'purchaseRequestId',
        value: [purchaseRequestId],
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterWhereClause>
      purchaseRequestIdNotEqualTo(String purchaseRequestId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'purchaseRequestId',
              lower: [],
              upper: [purchaseRequestId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'purchaseRequestId',
              lower: [purchaseRequestId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'purchaseRequestId',
              lower: [purchaseRequestId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'purchaseRequestId',
              lower: [],
              upper: [purchaseRequestId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterWhereClause>
      proveedorIdEqualTo(String proveedorId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'proveedorId',
        value: [proveedorId],
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterWhereClause>
      proveedorIdNotEqualTo(String proveedorId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'proveedorId',
              lower: [],
              upper: [proveedorId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'proveedorId',
              lower: [proveedorId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'proveedorId',
              lower: [proveedorId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'proveedorId',
              lower: [],
              upper: [proveedorId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SupplierResponseModelQueryFilter on QueryBuilder<
    SupplierResponseModel, SupplierResponseModel, QFilterCondition> {
  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> catalogoUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'catalogoUrl',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> catalogoUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'catalogoUrl',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> catalogoUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> catalogoUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catalogoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> catalogoUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catalogoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> catalogoUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catalogoUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> catalogoUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catalogoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> catalogoUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catalogoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
          QAfterFilterCondition>
      catalogoUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catalogoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
          QAfterFilterCondition>
      catalogoUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catalogoUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> catalogoUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> catalogoUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> currencyCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currencyCode',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> currencyCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currencyCode',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> disponibilidadEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'disponibilidad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> disponibilidadGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'disponibilidad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> disponibilidadLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'disponibilidad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> disponibilidadBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'disponibilidad',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> disponibilidadStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'disponibilidad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> disponibilidadEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'disponibilidad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
          QAfterFilterCondition>
      disponibilidadContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'disponibilidad',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
          QAfterFilterCondition>
      disponibilidadMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'disponibilidad',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> disponibilidadIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'disponibilidad',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> disponibilidadIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'disponibilidad',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> leadTimeDaysIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'leadTimeDays',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> leadTimeDaysIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'leadTimeDays',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> leadTimeDaysEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leadTimeDays',
        value: value,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> leadTimeDaysGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'leadTimeDays',
        value: value,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> leadTimeDaysLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'leadTimeDays',
        value: value,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> leadTimeDaysBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'leadTimeDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> notasIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notas',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> notasIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notas',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> notasEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> notasGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> notasLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> notasBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notas',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> notasStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> notasEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
          QAfterFilterCondition>
      notasContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notas',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
          QAfterFilterCondition>
      notasMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notas',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> notasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notas',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> notasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notas',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> precioEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'precio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> precioGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'precio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> precioLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'precio',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> precioBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'precio',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> proveedorIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proveedorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> proveedorIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proveedorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> proveedorIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proveedorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> proveedorIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proveedorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> proveedorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'proveedorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> proveedorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'proveedorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
          QAfterFilterCondition>
      proveedorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'proveedorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
          QAfterFilterCondition>
      proveedorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'proveedorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> proveedorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proveedorId',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> proveedorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'proveedorId',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> purchaseRequestIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> purchaseRequestIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'purchaseRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> purchaseRequestIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'purchaseRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> purchaseRequestIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'purchaseRequestId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> purchaseRequestIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'purchaseRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> purchaseRequestIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'purchaseRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
          QAfterFilterCondition>
      purchaseRequestIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'purchaseRequestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
          QAfterFilterCondition>
      purchaseRequestIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'purchaseRequestId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> purchaseRequestIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'purchaseRequestId',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> purchaseRequestIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'purchaseRequestId',
        value: '',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

  QueryBuilder<SupplierResponseModel, SupplierResponseModel,
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

extension SupplierResponseModelQueryObject on QueryBuilder<
    SupplierResponseModel, SupplierResponseModel, QFilterCondition> {}

extension SupplierResponseModelQueryLinks on QueryBuilder<SupplierResponseModel,
    SupplierResponseModel, QFilterCondition> {}

extension SupplierResponseModelQuerySortBy
    on QueryBuilder<SupplierResponseModel, SupplierResponseModel, QSortBy> {
  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByCatalogoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogoUrl', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByCatalogoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogoUrl', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByCurrencyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByCurrencyCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByDisponibilidad() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disponibilidad', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByDisponibilidadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disponibilidad', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByLeadTimeDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leadTimeDays', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByLeadTimeDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leadTimeDays', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByNotas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notas', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByNotasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notas', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByPrecio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'precio', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByPrecioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'precio', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByProveedorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proveedorId', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByProveedorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proveedorId', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByPurchaseRequestId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseRequestId', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByPurchaseRequestIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseRequestId', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SupplierResponseModelQuerySortThenBy
    on QueryBuilder<SupplierResponseModel, SupplierResponseModel, QSortThenBy> {
  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByCatalogoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogoUrl', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByCatalogoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogoUrl', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByCurrencyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByCurrencyCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByDisponibilidad() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disponibilidad', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByDisponibilidadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'disponibilidad', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByLeadTimeDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leadTimeDays', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByLeadTimeDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leadTimeDays', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByNotas() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notas', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByNotasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notas', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByPrecio() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'precio', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByPrecioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'precio', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByProveedorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proveedorId', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByProveedorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proveedorId', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByPurchaseRequestId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseRequestId', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByPurchaseRequestIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'purchaseRequestId', Sort.desc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SupplierResponseModelQueryWhereDistinct
    on QueryBuilder<SupplierResponseModel, SupplierResponseModel, QDistinct> {
  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QDistinct>
      distinctByCatalogoUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogoUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QDistinct>
      distinctByCurrencyCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currencyCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QDistinct>
      distinctByDisponibilidad({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'disponibilidad',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QDistinct>
      distinctByLeadTimeDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leadTimeDays');
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QDistinct>
      distinctByNotas({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notas', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QDistinct>
      distinctByPrecio() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'precio');
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QDistinct>
      distinctByProveedorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proveedorId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QDistinct>
      distinctByPurchaseRequestId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'purchaseRequestId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SupplierResponseModel, SupplierResponseModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension SupplierResponseModelQueryProperty on QueryBuilder<
    SupplierResponseModel, SupplierResponseModel, QQueryProperty> {
  QueryBuilder<SupplierResponseModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<SupplierResponseModel, String?, QQueryOperations>
      catalogoUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogoUrl');
    });
  }

  QueryBuilder<SupplierResponseModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SupplierResponseModel, String, QQueryOperations>
      currencyCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currencyCode');
    });
  }

  QueryBuilder<SupplierResponseModel, String, QQueryOperations>
      disponibilidadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'disponibilidad');
    });
  }

  QueryBuilder<SupplierResponseModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SupplierResponseModel, int?, QQueryOperations>
      leadTimeDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leadTimeDays');
    });
  }

  QueryBuilder<SupplierResponseModel, String?, QQueryOperations>
      notasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notas');
    });
  }

  QueryBuilder<SupplierResponseModel, double, QQueryOperations>
      precioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'precio');
    });
  }

  QueryBuilder<SupplierResponseModel, String, QQueryOperations>
      proveedorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proveedorId');
    });
  }

  QueryBuilder<SupplierResponseModel, String, QQueryOperations>
      purchaseRequestIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'purchaseRequestId');
    });
  }

  QueryBuilder<SupplierResponseModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierResponseModel _$SupplierResponseModelFromJson(
        Map<String, dynamic> json) =>
    SupplierResponseModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      purchaseRequestId: json['purchaseRequestId'] as String,
      proveedorId: json['proveedorId'] as String,
      precio: (json['precio'] as num).toDouble(),
      disponibilidad: json['disponibilidad'] as String,
      currencyCode: json['currencyCode'] as String,
      catalogoUrl: json['catalogoUrl'] as String?,
      notas: json['notas'] as String?,
      leadTimeDays: (json['leadTimeDays'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SupplierResponseModelToJson(
        SupplierResponseModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'purchaseRequestId': instance.purchaseRequestId,
      'proveedorId': instance.proveedorId,
      'precio': instance.precio,
      'disponibilidad': instance.disponibilidad,
      'currencyCode': instance.currencyCode,
      'catalogoUrl': instance.catalogoUrl,
      'notas': instance.notas,
      'leadTimeDays': instance.leadTimeDays,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
