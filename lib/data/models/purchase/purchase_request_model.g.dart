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
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deliveryAddress': PropertySchema(
      id: 3,
      name: r'deliveryAddress',
      type: IsarType.string,
    ),
    r'deliveryCity': PropertySchema(
      id: 4,
      name: r'deliveryCity',
      type: IsarType.string,
    ),
    r'deliveryDepartment': PropertySchema(
      id: 5,
      name: r'deliveryDepartment',
      type: IsarType.string,
    ),
    r'deliveryInfo': PropertySchema(
      id: 6,
      name: r'deliveryInfo',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 7,
      name: r'id',
      type: IsarType.string,
    ),
    r'itemsCount': PropertySchema(
      id: 8,
      name: r'itemsCount',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 9,
      name: r'notes',
      type: IsarType.string,
    ),
    r'orgId': PropertySchema(
      id: 10,
      name: r'orgId',
      type: IsarType.string,
    ),
    r'originTypeWire': PropertySchema(
      id: 11,
      name: r'originTypeWire',
      type: IsarType.string,
    ),
    r'respuestasCount': PropertySchema(
      id: 12,
      name: r'respuestasCount',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 13,
      name: r'status',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 14,
      name: r'title',
      type: IsarType.string,
    ),
    r'typeWire': PropertySchema(
      id: 15,
      name: r'typeWire',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 16,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'vehicleSpecEngineCc': PropertySchema(
      id: 17,
      name: r'vehicleSpecEngineCc',
      type: IsarType.long,
    ),
    r'vehicleSpecId': PropertySchema(
      id: 18,
      name: r'vehicleSpecId',
      type: IsarType.string,
    ),
    r'vehicleSpecLabel': PropertySchema(
      id: 19,
      name: r'vehicleSpecLabel',
      type: IsarType.string,
    ),
    r'vehicleSpecLinkedAssetsCount': PropertySchema(
      id: 20,
      name: r'vehicleSpecLinkedAssetsCount',
      type: IsarType.long,
    ),
    r'vehicleSpecMake': PropertySchema(
      id: 21,
      name: r'vehicleSpecMake',
      type: IsarType.string,
    ),
    r'vehicleSpecModel': PropertySchema(
      id: 22,
      name: r'vehicleSpecModel',
      type: IsarType.string,
    ),
    r'vehicleSpecMotorization': PropertySchema(
      id: 23,
      name: r'vehicleSpecMotorization',
      type: IsarType.string,
    ),
    r'vehicleSpecTransmission': PropertySchema(
      id: 24,
      name: r'vehicleSpecTransmission',
      type: IsarType.string,
    ),
    r'vehicleSpecVersion': PropertySchema(
      id: 25,
      name: r'vehicleSpecVersion',
      type: IsarType.string,
    ),
    r'vehicleSpecYear': PropertySchema(
      id: 26,
      name: r'vehicleSpecYear',
      type: IsarType.long,
    )
  },
  estimateSize: _purchaseRequestModelEstimateSize,
  serialize: _purchaseRequestModelSerialize,
  deserialize: _purchaseRequestModelDeserialize,
  deserializeProp: _purchaseRequestModelDeserializeProp,
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
    r'vehicleSpecId': IndexSchema(
      id: 5120545643371834555,
      name: r'vehicleSpecId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'vehicleSpecId',
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
  version: '3.3.0-dev.1',
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
  {
    final value = object.category;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.deliveryAddress;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.deliveryCity;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.deliveryDepartment;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.deliveryInfo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.orgId.length * 3;
  bytesCount += 3 + object.originTypeWire.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.typeWire.length * 3;
  {
    final value = object.vehicleSpecId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.vehicleSpecLabel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.vehicleSpecMake;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.vehicleSpecModel;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.vehicleSpecMotorization;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.vehicleSpecTransmission;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.vehicleSpecVersion;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _purchaseRequestModelSerialize(
  PurchaseRequestModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assetId);
  writer.writeString(offsets[1], object.category);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.deliveryAddress);
  writer.writeString(offsets[4], object.deliveryCity);
  writer.writeString(offsets[5], object.deliveryDepartment);
  writer.writeString(offsets[6], object.deliveryInfo);
  writer.writeString(offsets[7], object.id);
  writer.writeLong(offsets[8], object.itemsCount);
  writer.writeString(offsets[9], object.notes);
  writer.writeString(offsets[10], object.orgId);
  writer.writeString(offsets[11], object.originTypeWire);
  writer.writeLong(offsets[12], object.respuestasCount);
  writer.writeString(offsets[13], object.status);
  writer.writeString(offsets[14], object.title);
  writer.writeString(offsets[15], object.typeWire);
  writer.writeDateTime(offsets[16], object.updatedAt);
  writer.writeLong(offsets[17], object.vehicleSpecEngineCc);
  writer.writeString(offsets[18], object.vehicleSpecId);
  writer.writeString(offsets[19], object.vehicleSpecLabel);
  writer.writeLong(offsets[20], object.vehicleSpecLinkedAssetsCount);
  writer.writeString(offsets[21], object.vehicleSpecMake);
  writer.writeString(offsets[22], object.vehicleSpecModel);
  writer.writeString(offsets[23], object.vehicleSpecMotorization);
  writer.writeString(offsets[24], object.vehicleSpecTransmission);
  writer.writeString(offsets[25], object.vehicleSpecVersion);
  writer.writeLong(offsets[26], object.vehicleSpecYear);
}

PurchaseRequestModel _purchaseRequestModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PurchaseRequestModel(
    assetId: reader.readStringOrNull(offsets[0]),
    category: reader.readStringOrNull(offsets[1]),
    createdAt: reader.readDateTimeOrNull(offsets[2]),
    deliveryAddress: reader.readStringOrNull(offsets[3]),
    deliveryCity: reader.readStringOrNull(offsets[4]),
    deliveryDepartment: reader.readStringOrNull(offsets[5]),
    deliveryInfo: reader.readStringOrNull(offsets[6]),
    id: reader.readString(offsets[7]),
    isarId: id,
    itemsCount: reader.readLongOrNull(offsets[8]) ?? 0,
    notes: reader.readStringOrNull(offsets[9]),
    orgId: reader.readString(offsets[10]),
    originTypeWire: reader.readString(offsets[11]),
    respuestasCount: reader.readLongOrNull(offsets[12]) ?? 0,
    status: reader.readString(offsets[13]),
    title: reader.readString(offsets[14]),
    typeWire: reader.readString(offsets[15]),
    updatedAt: reader.readDateTimeOrNull(offsets[16]),
    vehicleSpecEngineCc: reader.readLongOrNull(offsets[17]),
    vehicleSpecId: reader.readStringOrNull(offsets[18]),
    vehicleSpecLabel: reader.readStringOrNull(offsets[19]),
    vehicleSpecLinkedAssetsCount: reader.readLongOrNull(offsets[20]),
    vehicleSpecMake: reader.readStringOrNull(offsets[21]),
    vehicleSpecModel: reader.readStringOrNull(offsets[22]),
    vehicleSpecMotorization: reader.readStringOrNull(offsets[23]),
    vehicleSpecTransmission: reader.readStringOrNull(offsets[24]),
    vehicleSpecVersion: reader.readStringOrNull(offsets[25]),
    vehicleSpecYear: reader.readLongOrNull(offsets[26]),
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
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 17:
      return (reader.readLongOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readLongOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readLongOrNull(offset)) as P;
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
      statusEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      vehicleSpecIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'vehicleSpecId',
        value: [null],
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      vehicleSpecIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'vehicleSpecId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      vehicleSpecIdEqualTo(String? vehicleSpecId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'vehicleSpecId',
        value: [vehicleSpecId],
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterWhereClause>
      vehicleSpecIdNotEqualTo(String? vehicleSpecId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vehicleSpecId',
              lower: [],
              upper: [vehicleSpecId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vehicleSpecId',
              lower: [vehicleSpecId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vehicleSpecId',
              lower: [vehicleSpecId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'vehicleSpecId',
              lower: [],
              upper: [vehicleSpecId],
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
      QAfterFilterCondition> categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> categoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> categoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> categoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> categoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> categoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
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
      QAfterFilterCondition> deliveryAddressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deliveryAddress',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryAddressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deliveryAddress',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryAddressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveryAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryAddressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deliveryAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryAddressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deliveryAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryAddressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deliveryAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deliveryAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deliveryAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      deliveryAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deliveryAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      deliveryAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deliveryAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveryAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deliveryAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryCityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deliveryCity',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryCityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deliveryCity',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryCityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveryCity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryCityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deliveryCity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryCityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deliveryCity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryCityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deliveryCity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryCityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deliveryCity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryCityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deliveryCity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      deliveryCityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deliveryCity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      deliveryCityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deliveryCity',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryCityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveryCity',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryCityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deliveryCity',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryDepartmentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deliveryDepartment',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryDepartmentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deliveryDepartment',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryDepartmentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveryDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryDepartmentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deliveryDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryDepartmentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deliveryDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryDepartmentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deliveryDepartment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryDepartmentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deliveryDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryDepartmentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deliveryDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      deliveryDepartmentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deliveryDepartment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      deliveryDepartmentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deliveryDepartment',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryDepartmentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveryDepartment',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryDepartmentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deliveryDepartment',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryInfoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deliveryInfo',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryInfoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deliveryInfo',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryInfoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveryInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryInfoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deliveryInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryInfoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deliveryInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryInfoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deliveryInfo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryInfoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deliveryInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryInfoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deliveryInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      deliveryInfoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deliveryInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      deliveryInfoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deliveryInfo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryInfoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveryInfo',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> deliveryInfoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deliveryInfo',
        value: '',
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
      QAfterFilterCondition> itemsCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> itemsCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> itemsCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> itemsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemsCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
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
      QAfterFilterCondition> originTypeWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originTypeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> originTypeWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originTypeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> originTypeWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originTypeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> originTypeWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originTypeWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> originTypeWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originTypeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> originTypeWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originTypeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      originTypeWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originTypeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      originTypeWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originTypeWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> originTypeWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originTypeWire',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> originTypeWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originTypeWire',
        value: '',
      ));
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
      QAfterFilterCondition> statusEqualTo(
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> statusGreaterThan(
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> statusLessThan(
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> statusBetween(
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> statusStartsWith(
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> statusEndsWith(
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> typeWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> typeWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> typeWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> typeWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> typeWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> typeWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      typeWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      typeWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typeWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> typeWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeWire',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> typeWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typeWire',
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecEngineCcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleSpecEngineCc',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecEngineCcIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleSpecEngineCc',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecEngineCcEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecEngineCc',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecEngineCcGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleSpecEngineCc',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecEngineCcLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleSpecEngineCc',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecEngineCcBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleSpecEngineCc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleSpecId',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleSpecId',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleSpecId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleSpecId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleSpecId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleSpecId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleSpecId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleSpecId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleSpecId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecId',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleSpecId',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleSpecLabel',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleSpecLabel',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLabelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLabelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleSpecLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLabelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleSpecLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLabelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleSpecLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleSpecLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleSpecLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleSpecLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleSpecLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleSpecLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLinkedAssetsCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleSpecLinkedAssetsCount',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLinkedAssetsCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleSpecLinkedAssetsCount',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLinkedAssetsCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecLinkedAssetsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLinkedAssetsCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleSpecLinkedAssetsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLinkedAssetsCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleSpecLinkedAssetsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecLinkedAssetsCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleSpecLinkedAssetsCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMakeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleSpecMake',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMakeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleSpecMake',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMakeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecMake',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMakeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleSpecMake',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMakeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleSpecMake',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMakeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleSpecMake',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMakeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleSpecMake',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMakeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleSpecMake',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecMakeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleSpecMake',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecMakeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleSpecMake',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMakeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecMake',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMakeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleSpecMake',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecModelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleSpecModel',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecModelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleSpecModel',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecModelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecModelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleSpecModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecModelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleSpecModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecModelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleSpecModel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecModelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleSpecModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecModelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleSpecModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecModelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleSpecModel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecModelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleSpecModel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecModelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecModel',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecModelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleSpecModel',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMotorizationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleSpecMotorization',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMotorizationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleSpecMotorization',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMotorizationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecMotorization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMotorizationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleSpecMotorization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMotorizationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleSpecMotorization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMotorizationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleSpecMotorization',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMotorizationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleSpecMotorization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMotorizationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleSpecMotorization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecMotorizationContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleSpecMotorization',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecMotorizationMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleSpecMotorization',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMotorizationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecMotorization',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecMotorizationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleSpecMotorization',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecTransmissionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleSpecTransmission',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecTransmissionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleSpecTransmission',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecTransmissionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecTransmission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecTransmissionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleSpecTransmission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecTransmissionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleSpecTransmission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecTransmissionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleSpecTransmission',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecTransmissionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleSpecTransmission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecTransmissionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleSpecTransmission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecTransmissionContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleSpecTransmission',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecTransmissionMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleSpecTransmission',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecTransmissionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecTransmission',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecTransmissionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleSpecTransmission',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecVersionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleSpecVersion',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecVersionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleSpecVersion',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecVersionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecVersionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleSpecVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecVersionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleSpecVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecVersionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleSpecVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecVersionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleSpecVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecVersionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleSpecVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecVersionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleSpecVersion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
          QAfterFilterCondition>
      vehicleSpecVersionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleSpecVersion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecVersionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecVersionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleSpecVersion',
        value: '',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecYearIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleSpecYear',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecYearIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleSpecYear',
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecYearEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleSpecYear',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecYearGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleSpecYear',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecYearLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleSpecYear',
        value: value,
      ));
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel,
      QAfterFilterCondition> vehicleSpecYearBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleSpecYear',
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
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
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
      sortByDeliveryAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryAddress', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByDeliveryAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryAddress', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByDeliveryCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryCity', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByDeliveryCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryCity', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByDeliveryDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryDepartment', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByDeliveryDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryDepartment', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByDeliveryInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryInfo', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByDeliveryInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryInfo', Sort.desc);
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
      sortByItemsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsCount', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByItemsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsCount', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
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
      sortByOriginTypeWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originTypeWire', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByOriginTypeWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originTypeWire', Sort.desc);
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
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByTypeWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeWire', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByTypeWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeWire', Sort.desc);
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecEngineCc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecEngineCc', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecEngineCcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecEngineCc', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecId', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecId', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecLabel', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecLabel', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecLinkedAssetsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecLinkedAssetsCount', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecLinkedAssetsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecLinkedAssetsCount', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecMake() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecMake', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecMakeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecMake', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecModel', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecModel', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecMotorization() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecMotorization', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecMotorizationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecMotorization', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecTransmission() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecTransmission', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecTransmissionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecTransmission', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecVersion', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecVersion', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecYear', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      sortByVehicleSpecYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecYear', Sort.desc);
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
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
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
      thenByDeliveryAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryAddress', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByDeliveryAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryAddress', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByDeliveryCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryCity', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByDeliveryCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryCity', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByDeliveryDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryDepartment', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByDeliveryDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryDepartment', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByDeliveryInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryInfo', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByDeliveryInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveryInfo', Sort.desc);
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
      thenByItemsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsCount', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByItemsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemsCount', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
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
      thenByOriginTypeWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originTypeWire', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByOriginTypeWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originTypeWire', Sort.desc);
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
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByTypeWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeWire', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByTypeWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeWire', Sort.desc);
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

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecEngineCc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecEngineCc', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecEngineCcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecEngineCc', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecId', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecId', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecLabel', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecLabel', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecLinkedAssetsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecLinkedAssetsCount', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecLinkedAssetsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecLinkedAssetsCount', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecMake() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecMake', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecMakeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecMake', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecModel', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecModel', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecMotorization() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecMotorization', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecMotorizationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecMotorization', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecTransmission() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecTransmission', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecTransmissionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecTransmission', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecVersion', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecVersion', Sort.desc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecYear', Sort.asc);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QAfterSortBy>
      thenByVehicleSpecYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleSpecYear', Sort.desc);
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
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByDeliveryAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deliveryAddress',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByDeliveryCity({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deliveryCity', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByDeliveryDepartment({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deliveryDepartment',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByDeliveryInfo({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deliveryInfo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByItemsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemsCount');
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByOrgId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orgId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByOriginTypeWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originTypeWire',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByRespuestasCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'respuestasCount');
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByTypeWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeWire', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByVehicleSpecEngineCc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleSpecEngineCc');
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByVehicleSpecId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleSpecId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByVehicleSpecLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleSpecLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByVehicleSpecLinkedAssetsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleSpecLinkedAssetsCount');
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByVehicleSpecMake({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleSpecMake',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByVehicleSpecModel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleSpecModel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByVehicleSpecMotorization({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleSpecMotorization',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByVehicleSpecTransmission({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleSpecTransmission',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByVehicleSpecVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleSpecVersion',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PurchaseRequestModel, PurchaseRequestModel, QDistinct>
      distinctByVehicleSpecYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleSpecYear');
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

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<PurchaseRequestModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      deliveryAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deliveryAddress');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      deliveryCityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deliveryCity');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      deliveryDepartmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deliveryDepartment');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      deliveryInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deliveryInfo');
    });
  }

  QueryBuilder<PurchaseRequestModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PurchaseRequestModel, int, QQueryOperations>
      itemsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemsCount');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<PurchaseRequestModel, String, QQueryOperations> orgIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orgId');
    });
  }

  QueryBuilder<PurchaseRequestModel, String, QQueryOperations>
      originTypeWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originTypeWire');
    });
  }

  QueryBuilder<PurchaseRequestModel, int, QQueryOperations>
      respuestasCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'respuestasCount');
    });
  }

  QueryBuilder<PurchaseRequestModel, String, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<PurchaseRequestModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<PurchaseRequestModel, String, QQueryOperations>
      typeWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeWire');
    });
  }

  QueryBuilder<PurchaseRequestModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<PurchaseRequestModel, int?, QQueryOperations>
      vehicleSpecEngineCcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleSpecEngineCc');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      vehicleSpecIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleSpecId');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      vehicleSpecLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleSpecLabel');
    });
  }

  QueryBuilder<PurchaseRequestModel, int?, QQueryOperations>
      vehicleSpecLinkedAssetsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleSpecLinkedAssetsCount');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      vehicleSpecMakeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleSpecMake');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      vehicleSpecModelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleSpecModel');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      vehicleSpecMotorizationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleSpecMotorization');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      vehicleSpecTransmissionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleSpecTransmission');
    });
  }

  QueryBuilder<PurchaseRequestModel, String?, QQueryOperations>
      vehicleSpecVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleSpecVersion');
    });
  }

  QueryBuilder<PurchaseRequestModel, int?, QQueryOperations>
      vehicleSpecYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleSpecYear');
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
      title: json['title'] as String,
      typeWire: json['typeWire'] as String,
      category: json['category'] as String?,
      originTypeWire: json['originTypeWire'] as String,
      assetId: json['assetId'] as String?,
      notes: json['notes'] as String?,
      deliveryCity: json['deliveryCity'] as String?,
      deliveryDepartment: json['deliveryDepartment'] as String?,
      deliveryAddress: json['deliveryAddress'] as String?,
      deliveryInfo: json['deliveryInfo'] as String?,
      itemsCount: (json['itemsCount'] as num?)?.toInt() ?? 0,
      status: json['status'] as String,
      respuestasCount: (json['respuestasCount'] as num?)?.toInt() ?? 0,
      createdAt: const DateTimeTimestampConverter().fromJson(json['createdAt']),
      updatedAt: const DateTimeTimestampConverter().fromJson(json['updatedAt']),
      vehicleSpecId: json['vehicleSpecId'] as String?,
      vehicleSpecLabel: json['vehicleSpecLabel'] as String?,
      vehicleSpecMake: json['vehicleSpecMake'] as String?,
      vehicleSpecModel: json['vehicleSpecModel'] as String?,
      vehicleSpecYear: (json['vehicleSpecYear'] as num?)?.toInt(),
      vehicleSpecVersion: json['vehicleSpecVersion'] as String?,
      vehicleSpecMotorization: json['vehicleSpecMotorization'] as String?,
      vehicleSpecEngineCc: (json['vehicleSpecEngineCc'] as num?)?.toInt(),
      vehicleSpecTransmission: json['vehicleSpecTransmission'] as String?,
      vehicleSpecLinkedAssetsCount:
          (json['vehicleSpecLinkedAssetsCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PurchaseRequestModelToJson(
        PurchaseRequestModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'orgId': instance.orgId,
      'title': instance.title,
      'typeWire': instance.typeWire,
      'category': instance.category,
      'originTypeWire': instance.originTypeWire,
      'assetId': instance.assetId,
      'notes': instance.notes,
      'deliveryCity': instance.deliveryCity,
      'deliveryDepartment': instance.deliveryDepartment,
      'deliveryAddress': instance.deliveryAddress,
      'deliveryInfo': instance.deliveryInfo,
      'itemsCount': instance.itemsCount,
      'status': instance.status,
      'respuestasCount': instance.respuestasCount,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const DateTimeTimestampConverter().toJson(instance.updatedAt),
      'vehicleSpecId': instance.vehicleSpecId,
      'vehicleSpecLabel': instance.vehicleSpecLabel,
      'vehicleSpecMake': instance.vehicleSpecMake,
      'vehicleSpecModel': instance.vehicleSpecModel,
      'vehicleSpecYear': instance.vehicleSpecYear,
      'vehicleSpecVersion': instance.vehicleSpecVersion,
      'vehicleSpecMotorization': instance.vehicleSpecMotorization,
      'vehicleSpecEngineCc': instance.vehicleSpecEngineCc,
      'vehicleSpecTransmission': instance.vehicleSpecTransmission,
      'vehicleSpecLinkedAssetsCount': instance.vehicleSpecLinkedAssetsCount,
    };
