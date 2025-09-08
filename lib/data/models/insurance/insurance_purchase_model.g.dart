// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_purchase_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInsurancePurchaseModelCollection on Isar {
  IsarCollection<InsurancePurchaseModel> get insurancePurchaseModels =>
      this.collection();
}

const InsurancePurchaseModelSchema = CollectionSchema(
  name: r'InsurancePurchaseModel',
  id: -1536477810194045828,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.object,
      target: r'AddressModel',
    ),
    r'assetId': PropertySchema(
      id: 1,
      name: r'assetId',
      type: IsarType.string,
    ),
    r'compradorId': PropertySchema(
      id: 2,
      name: r'compradorId',
      type: IsarType.string,
    ),
    r'contactEmail': PropertySchema(
      id: 3,
      name: r'contactEmail',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currencyCode': PropertySchema(
      id: 5,
      name: r'currencyCode',
      type: IsarType.string,
    ),
    r'estadoCompra': PropertySchema(
      id: 6,
      name: r'estadoCompra',
      type: IsarType.string,
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
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _insurancePurchaseModelEstimateSize,
  serialize: _insurancePurchaseModelSerialize,
  deserialize: _insurancePurchaseModelDeserialize,
  deserializeProp: _insurancePurchaseModelDeserializeProp,
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
    r'estadoCompra': IndexSchema(
      id: 7680675193573989364,
      name: r'estadoCompra',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'estadoCompra',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'AddressModel': AddressModelSchema},
  getId: _insurancePurchaseModelGetId,
  getLinks: _insurancePurchaseModelGetLinks,
  attach: _insurancePurchaseModelAttach,
  version: '3.2.0-dev.2',
);

int _insurancePurchaseModelEstimateSize(
  InsurancePurchaseModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      AddressModelSchema.estimateSize(
          object.address, allOffsets[AddressModel]!, allOffsets);
  bytesCount += 3 + object.assetId.length * 3;
  bytesCount += 3 + object.compradorId.length * 3;
  bytesCount += 3 + object.contactEmail.length * 3;
  bytesCount += 3 + object.currencyCode.length * 3;
  bytesCount += 3 + object.estadoCompra.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.orgId.length * 3;
  return bytesCount;
}

void _insurancePurchaseModelSerialize(
  InsurancePurchaseModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<AddressModel>(
    offsets[0],
    allOffsets,
    AddressModelSchema.serialize,
    object.address,
  );
  writer.writeString(offsets[1], object.assetId);
  writer.writeString(offsets[2], object.compradorId);
  writer.writeString(offsets[3], object.contactEmail);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.currencyCode);
  writer.writeString(offsets[6], object.estadoCompra);
  writer.writeString(offsets[7], object.id);
  writer.writeString(offsets[8], object.orgId);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

InsurancePurchaseModel _insurancePurchaseModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InsurancePurchaseModel(
    address: reader.readObjectOrNull<AddressModel>(
          offsets[0],
          AddressModelSchema.deserialize,
          allOffsets,
        ) ??
        AddressModel(),
    assetId: reader.readString(offsets[1]),
    compradorId: reader.readString(offsets[2]),
    contactEmail: reader.readString(offsets[3]),
    createdAt: reader.readDateTimeOrNull(offsets[4]),
    currencyCode: reader.readString(offsets[5]),
    estadoCompra: reader.readString(offsets[6]),
    id: reader.readString(offsets[7]),
    isarId: id,
    orgId: reader.readString(offsets[8]),
    updatedAt: reader.readDateTimeOrNull(offsets[9]),
  );
  return object;
}

P _insurancePurchaseModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<AddressModel>(
            offset,
            AddressModelSchema.deserialize,
            allOffsets,
          ) ??
          AddressModel()) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
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

Id _insurancePurchaseModelGetId(InsurancePurchaseModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _insurancePurchaseModelGetLinks(
    InsurancePurchaseModel object) {
  return [];
}

void _insurancePurchaseModelAttach(
    IsarCollection<dynamic> col, Id id, InsurancePurchaseModel object) {
  object.isarId = id;
}

extension InsurancePurchaseModelByIndex
    on IsarCollection<InsurancePurchaseModel> {
  Future<InsurancePurchaseModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  InsurancePurchaseModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<InsurancePurchaseModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<InsurancePurchaseModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(InsurancePurchaseModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(InsurancePurchaseModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<InsurancePurchaseModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<InsurancePurchaseModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension InsurancePurchaseModelQueryWhereSort
    on QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QWhere> {
  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension InsurancePurchaseModelQueryWhere on QueryBuilder<
    InsurancePurchaseModel, InsurancePurchaseModel, QWhereClause> {
  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterWhereClause> idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterWhereClause> assetIdEqualTo(String assetId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'assetId',
        value: [assetId],
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterWhereClause> orgIdEqualTo(String orgId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orgId',
        value: [orgId],
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterWhereClause> estadoCompraEqualTo(String estadoCompra) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'estadoCompra',
        value: [estadoCompra],
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterWhereClause> estadoCompraNotEqualTo(String estadoCompra) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'estadoCompra',
              lower: [],
              upper: [estadoCompra],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'estadoCompra',
              lower: [estadoCompra],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'estadoCompra',
              lower: [estadoCompra],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'estadoCompra',
              lower: [],
              upper: [estadoCompra],
              includeUpper: false,
            ));
      }
    });
  }
}

extension InsurancePurchaseModelQueryFilter on QueryBuilder<
    InsurancePurchaseModel, InsurancePurchaseModel, QFilterCondition> {
  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> assetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetId',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> assetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetId',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> compradorIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'compradorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> compradorIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'compradorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> compradorIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'compradorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> compradorIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'compradorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> compradorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'compradorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> compradorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'compradorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
          QAfterFilterCondition>
      compradorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'compradorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
          QAfterFilterCondition>
      compradorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'compradorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> compradorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'compradorId',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> compradorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'compradorId',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> contactEmailEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> contactEmailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contactEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> contactEmailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contactEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> contactEmailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contactEmail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> contactEmailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contactEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> contactEmailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contactEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
          QAfterFilterCondition>
      contactEmailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contactEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
          QAfterFilterCondition>
      contactEmailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contactEmail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> contactEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contactEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> contactEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contactEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> currencyCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currencyCode',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> currencyCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currencyCode',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> estadoCompraEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estadoCompra',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> estadoCompraGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'estadoCompra',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> estadoCompraLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'estadoCompra',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> estadoCompraBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'estadoCompra',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> estadoCompraStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'estadoCompra',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> estadoCompraEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'estadoCompra',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
          QAfterFilterCondition>
      estadoCompraContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'estadoCompra',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
          QAfterFilterCondition>
      estadoCompraMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'estadoCompra',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> estadoCompraIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'estadoCompra',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> estadoCompraIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'estadoCompra',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> orgIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orgId',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> orgIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orgId',
        value: '',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
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

extension InsurancePurchaseModelQueryObject on QueryBuilder<
    InsurancePurchaseModel, InsurancePurchaseModel, QFilterCondition> {
  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel,
      QAfterFilterCondition> address(FilterQuery<AddressModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'address');
    });
  }
}

extension InsurancePurchaseModelQueryLinks on QueryBuilder<
    InsurancePurchaseModel, InsurancePurchaseModel, QFilterCondition> {}

extension InsurancePurchaseModelQuerySortBy
    on QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QSortBy> {
  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByCompradorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compradorId', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByCompradorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compradorId', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByContactEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactEmail', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByContactEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactEmail', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByCurrencyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByCurrencyCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByEstadoCompra() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estadoCompra', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByEstadoCompraDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estadoCompra', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByOrgId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByOrgIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension InsurancePurchaseModelQuerySortThenBy on QueryBuilder<
    InsurancePurchaseModel, InsurancePurchaseModel, QSortThenBy> {
  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByAssetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByAssetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetId', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByCompradorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compradorId', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByCompradorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'compradorId', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByContactEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactEmail', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByContactEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contactEmail', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByCurrencyCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByCurrencyCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currencyCode', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByEstadoCompra() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estadoCompra', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByEstadoCompraDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estadoCompra', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByOrgId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByOrgIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.desc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension InsurancePurchaseModelQueryWhereDistinct
    on QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QDistinct> {
  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QDistinct>
      distinctByAssetId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QDistinct>
      distinctByCompradorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'compradorId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QDistinct>
      distinctByContactEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contactEmail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QDistinct>
      distinctByCurrencyCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currencyCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QDistinct>
      distinctByEstadoCompra({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estadoCompra', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QDistinct>
      distinctByOrgId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orgId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InsurancePurchaseModel, InsurancePurchaseModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension InsurancePurchaseModelQueryProperty on QueryBuilder<
    InsurancePurchaseModel, InsurancePurchaseModel, QQueryProperty> {
  QueryBuilder<InsurancePurchaseModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<InsurancePurchaseModel, AddressModel, QQueryOperations>
      addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<InsurancePurchaseModel, String, QQueryOperations>
      assetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetId');
    });
  }

  QueryBuilder<InsurancePurchaseModel, String, QQueryOperations>
      compradorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'compradorId');
    });
  }

  QueryBuilder<InsurancePurchaseModel, String, QQueryOperations>
      contactEmailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contactEmail');
    });
  }

  QueryBuilder<InsurancePurchaseModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<InsurancePurchaseModel, String, QQueryOperations>
      currencyCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currencyCode');
    });
  }

  QueryBuilder<InsurancePurchaseModel, String, QQueryOperations>
      estadoCompraProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estadoCompra');
    });
  }

  QueryBuilder<InsurancePurchaseModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<InsurancePurchaseModel, String, QQueryOperations>
      orgIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orgId');
    });
  }

  QueryBuilder<InsurancePurchaseModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsurancePurchaseModel _$InsurancePurchaseModelFromJson(
        Map<String, dynamic> json) =>
    InsurancePurchaseModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      assetId: json['assetId'] as String,
      compradorId: json['compradorId'] as String,
      orgId: json['orgId'] as String,
      contactEmail: json['contactEmail'] as String,
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      currencyCode: json['currencyCode'] as String,
      estadoCompra: json['estadoCompra'] as String,
      createdAt: const DateTimeTimestampConverter().fromJson(json['createdAt']),
      updatedAt: const DateTimeTimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$InsurancePurchaseModelToJson(
        InsurancePurchaseModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'assetId': instance.assetId,
      'orgId': instance.orgId,
      'compradorId': instance.compradorId,
      'contactEmail': instance.contactEmail,
      'address': instance.address.toJson(),
      'currencyCode': instance.currencyCode,
      'estadoCompra': instance.estadoCompra,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const DateTimeTimestampConverter().toJson(instance.updatedAt),
    };
