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
    r'axles': PropertySchema(
      id: 2,
      name: r'axles',
      type: IsarType.long,
    ),
    r'bodyType': PropertySchema(
      id: 3,
      name: r'bodyType',
      type: IsarType.string,
    ),
    r'chassisNumber': PropertySchema(
      id: 4,
      name: r'chassisNumber',
      type: IsarType.string,
    ),
    r'color': PropertySchema(
      id: 5,
      name: r'color',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 6,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'engineDisplacement': PropertySchema(
      id: 7,
      name: r'engineDisplacement',
      type: IsarType.double,
    ),
    r'engineNumber': PropertySchema(
      id: 8,
      name: r'engineNumber',
      type: IsarType.string,
    ),
    r'fuelType': PropertySchema(
      id: 9,
      name: r'fuelType',
      type: IsarType.string,
    ),
    r'grossWeightKg': PropertySchema(
      id: 10,
      name: r'grossWeightKg',
      type: IsarType.double,
    ),
    r'initialRegistrationDate': PropertySchema(
      id: 11,
      name: r'initialRegistrationDate',
      type: IsarType.string,
    ),
    r'line': PropertySchema(
      id: 12,
      name: r'line',
      type: IsarType.string,
    ),
    r'loadCapacityKg': PropertySchema(
      id: 13,
      name: r'loadCapacityKg',
      type: IsarType.double,
    ),
    r'marca': PropertySchema(
      id: 14,
      name: r'marca',
      type: IsarType.string,
    ),
    r'modelo': PropertySchema(
      id: 15,
      name: r'modelo',
      type: IsarType.string,
    ),
    r'ownerDocument': PropertySchema(
      id: 16,
      name: r'ownerDocument',
      type: IsarType.string,
    ),
    r'ownerDocumentType': PropertySchema(
      id: 17,
      name: r'ownerDocumentType',
      type: IsarType.string,
    ),
    r'ownerName': PropertySchema(
      id: 18,
      name: r'ownerName',
      type: IsarType.string,
    ),
    r'passengerCapacity': PropertySchema(
      id: 19,
      name: r'passengerCapacity',
      type: IsarType.long,
    ),
    r'placa': PropertySchema(
      id: 20,
      name: r'placa',
      type: IsarType.string,
    ),
    r'propertyLiens': PropertySchema(
      id: 21,
      name: r'propertyLiens',
      type: IsarType.string,
    ),
    r'refCode': PropertySchema(
      id: 22,
      name: r'refCode',
      type: IsarType.string,
    ),
    r'runtMetaJson': PropertySchema(
      id: 23,
      name: r'runtMetaJson',
      type: IsarType.string,
    ),
    r'serviceType': PropertySchema(
      id: 24,
      name: r'serviceType',
      type: IsarType.string,
    ),
    r'transitAuthority': PropertySchema(
      id: 25,
      name: r'transitAuthority',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 26,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'vehicleClass': PropertySchema(
      id: 27,
      name: r'vehicleClass',
      type: IsarType.string,
    ),
    r'vin': PropertySchema(
      id: 28,
      name: r'vin',
      type: IsarType.string,
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
      unique: true,
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
  version: '3.3.0-dev.1',
);

int _assetVehiculoModelEstimateSize(
  AssetVehiculoModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assetId.length * 3;
  {
    final value = object.bodyType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.chassisNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.color;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.engineNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fuelType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.initialRegistrationDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.line;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.marca.length * 3;
  bytesCount += 3 + object.modelo.length * 3;
  {
    final value = object.ownerDocument;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ownerDocumentType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ownerName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.placa.length * 3;
  {
    final value = object.propertyLiens;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.refCode.length * 3;
  {
    final value = object.runtMetaJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.serviceType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.transitAuthority;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.vehicleClass;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.vin;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
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
  writer.writeLong(offsets[2], object.axles);
  writer.writeString(offsets[3], object.bodyType);
  writer.writeString(offsets[4], object.chassisNumber);
  writer.writeString(offsets[5], object.color);
  writer.writeDateTime(offsets[6], object.createdAt);
  writer.writeDouble(offsets[7], object.engineDisplacement);
  writer.writeString(offsets[8], object.engineNumber);
  writer.writeString(offsets[9], object.fuelType);
  writer.writeDouble(offsets[10], object.grossWeightKg);
  writer.writeString(offsets[11], object.initialRegistrationDate);
  writer.writeString(offsets[12], object.line);
  writer.writeDouble(offsets[13], object.loadCapacityKg);
  writer.writeString(offsets[14], object.marca);
  writer.writeString(offsets[15], object.modelo);
  writer.writeString(offsets[16], object.ownerDocument);
  writer.writeString(offsets[17], object.ownerDocumentType);
  writer.writeString(offsets[18], object.ownerName);
  writer.writeLong(offsets[19], object.passengerCapacity);
  writer.writeString(offsets[20], object.placa);
  writer.writeString(offsets[21], object.propertyLiens);
  writer.writeString(offsets[22], object.refCode);
  writer.writeString(offsets[23], object.runtMetaJson);
  writer.writeString(offsets[24], object.serviceType);
  writer.writeString(offsets[25], object.transitAuthority);
  writer.writeDateTime(offsets[26], object.updatedAt);
  writer.writeString(offsets[27], object.vehicleClass);
  writer.writeString(offsets[28], object.vin);
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
    axles: reader.readLongOrNull(offsets[2]),
    bodyType: reader.readStringOrNull(offsets[3]),
    chassisNumber: reader.readStringOrNull(offsets[4]),
    color: reader.readStringOrNull(offsets[5]),
    createdAt: reader.readDateTimeOrNull(offsets[6]),
    engineDisplacement: reader.readDoubleOrNull(offsets[7]),
    engineNumber: reader.readStringOrNull(offsets[8]),
    fuelType: reader.readStringOrNull(offsets[9]),
    grossWeightKg: reader.readDoubleOrNull(offsets[10]),
    initialRegistrationDate: reader.readStringOrNull(offsets[11]),
    isarId: id,
    line: reader.readStringOrNull(offsets[12]),
    loadCapacityKg: reader.readDoubleOrNull(offsets[13]),
    marca: reader.readString(offsets[14]),
    modelo: reader.readString(offsets[15]),
    ownerDocument: reader.readStringOrNull(offsets[16]),
    ownerDocumentType: reader.readStringOrNull(offsets[17]),
    ownerName: reader.readStringOrNull(offsets[18]),
    passengerCapacity: reader.readLongOrNull(offsets[19]),
    placa: reader.readString(offsets[20]),
    propertyLiens: reader.readStringOrNull(offsets[21]),
    refCode: reader.readString(offsets[22]),
    runtMetaJson: reader.readStringOrNull(offsets[23]),
    serviceType: reader.readStringOrNull(offsets[24]),
    transitAuthority: reader.readStringOrNull(offsets[25]),
    updatedAt: reader.readDateTimeOrNull(offsets[26]),
    vehicleClass: reader.readStringOrNull(offsets[27]),
    vin: reader.readStringOrNull(offsets[28]),
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
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDoubleOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readDoubleOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readLongOrNull(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    case 28:
      return (reader.readStringOrNull(offset)) as P;
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

  Future<AssetVehiculoModel?> getByPlaca(String placa) {
    return getByIndex(r'placa', [placa]);
  }

  AssetVehiculoModel? getByPlacaSync(String placa) {
    return getByIndexSync(r'placa', [placa]);
  }

  Future<bool> deleteByPlaca(String placa) {
    return deleteByIndex(r'placa', [placa]);
  }

  bool deleteByPlacaSync(String placa) {
    return deleteByIndexSync(r'placa', [placa]);
  }

  Future<List<AssetVehiculoModel?>> getAllByPlaca(List<String> placaValues) {
    final values = placaValues.map((e) => [e]).toList();
    return getAllByIndex(r'placa', values);
  }

  List<AssetVehiculoModel?> getAllByPlacaSync(List<String> placaValues) {
    final values = placaValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'placa', values);
  }

  Future<int> deleteAllByPlaca(List<String> placaValues) {
    final values = placaValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'placa', values);
  }

  int deleteAllByPlacaSync(List<String> placaValues) {
    final values = placaValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'placa', values);
  }

  Future<Id> putByPlaca(AssetVehiculoModel object) {
    return putByIndex(r'placa', object);
  }

  Id putByPlacaSync(AssetVehiculoModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'placa', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPlaca(List<AssetVehiculoModel> objects) {
    return putAllByIndex(r'placa', objects);
  }

  List<Id> putAllByPlacaSync(List<AssetVehiculoModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'placa', objects, saveLinks: saveLinks);
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
      axlesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'axles',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      axlesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'axles',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      axlesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'axles',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      axlesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'axles',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      axlesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'axles',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      axlesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'axles',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      bodyTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bodyType',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      bodyTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bodyType',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      bodyTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bodyType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      bodyTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bodyType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      bodyTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bodyType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      bodyTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bodyType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      bodyTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bodyType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      bodyTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bodyType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      bodyTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bodyType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      bodyTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bodyType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      bodyTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bodyType',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      bodyTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bodyType',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      chassisNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chassisNumber',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      chassisNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chassisNumber',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      chassisNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      chassisNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      chassisNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      chassisNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chassisNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      chassisNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      chassisNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      chassisNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chassisNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      chassisNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chassisNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      chassisNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chassisNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      chassisNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chassisNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      colorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'color',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      colorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'color',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      colorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      colorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      colorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      colorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      colorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      colorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      colorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      colorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'color',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      colorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      colorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'color',
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
      engineDisplacementIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'engineDisplacement',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineDisplacementIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'engineDisplacement',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineDisplacementEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'engineDisplacement',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineDisplacementGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'engineDisplacement',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineDisplacementLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'engineDisplacement',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineDisplacementBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'engineDisplacement',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'engineNumber',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'engineNumber',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'engineNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'engineNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'engineNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'engineNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      engineNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'engineNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      fuelTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fuelType',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      fuelTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fuelType',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      fuelTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fuelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      fuelTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fuelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      fuelTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fuelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      fuelTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fuelType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      fuelTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fuelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      fuelTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fuelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      fuelTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fuelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      fuelTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fuelType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      fuelTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fuelType',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      fuelTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fuelType',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      grossWeightKgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'grossWeightKg',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      grossWeightKgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'grossWeightKg',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      grossWeightKgEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grossWeightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      grossWeightKgGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'grossWeightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      grossWeightKgLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'grossWeightKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      grossWeightKgBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'grossWeightKg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      initialRegistrationDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'initialRegistrationDate',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      initialRegistrationDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'initialRegistrationDate',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      initialRegistrationDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initialRegistrationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      initialRegistrationDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'initialRegistrationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      initialRegistrationDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'initialRegistrationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      initialRegistrationDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'initialRegistrationDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      initialRegistrationDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'initialRegistrationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      initialRegistrationDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'initialRegistrationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      initialRegistrationDateContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'initialRegistrationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      initialRegistrationDateMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'initialRegistrationDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      initialRegistrationDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initialRegistrationDate',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      initialRegistrationDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'initialRegistrationDate',
        value: '',
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
      lineIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'line',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      lineIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'line',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      lineEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'line',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      lineGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'line',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      lineLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'line',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      lineBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'line',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      lineStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'line',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      lineEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'line',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      lineContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'line',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      lineMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'line',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      lineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'line',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      lineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'line',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      loadCapacityKgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'loadCapacityKg',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      loadCapacityKgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'loadCapacityKg',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      loadCapacityKgEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loadCapacityKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      loadCapacityKgGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'loadCapacityKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      loadCapacityKgLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'loadCapacityKg',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      loadCapacityKgBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'loadCapacityKg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
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
      ownerDocumentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ownerDocument',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ownerDocument',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerDocument',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerDocument',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerDocument',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerDocument',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerDocument',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerDocument',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerDocument',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerDocument',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerDocument',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerDocument',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ownerDocumentType',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ownerDocumentType',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerDocumentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerDocumentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerDocumentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerDocumentType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerDocumentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerDocumentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerDocumentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerDocumentType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerDocumentType',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerDocumentTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerDocumentType',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ownerName',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ownerName',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerName',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      ownerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerName',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      passengerCapacityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'passengerCapacity',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      passengerCapacityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'passengerCapacity',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      passengerCapacityEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'passengerCapacity',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      passengerCapacityGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'passengerCapacity',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      passengerCapacityLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'passengerCapacity',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      passengerCapacityBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'passengerCapacity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
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
      propertyLiensIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'propertyLiens',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      propertyLiensIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'propertyLiens',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      propertyLiensEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'propertyLiens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      propertyLiensGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'propertyLiens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      propertyLiensLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'propertyLiens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      propertyLiensBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'propertyLiens',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      propertyLiensStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'propertyLiens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      propertyLiensEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'propertyLiens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      propertyLiensContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'propertyLiens',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      propertyLiensMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'propertyLiens',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      propertyLiensIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'propertyLiens',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      propertyLiensIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'propertyLiens',
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
      runtMetaJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'runtMetaJson',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      runtMetaJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'runtMetaJson',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      runtMetaJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtMetaJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      runtMetaJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'runtMetaJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      runtMetaJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'runtMetaJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      runtMetaJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'runtMetaJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      runtMetaJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'runtMetaJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      runtMetaJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'runtMetaJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      runtMetaJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'runtMetaJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      runtMetaJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'runtMetaJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      runtMetaJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtMetaJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      runtMetaJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'runtMetaJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      serviceTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serviceType',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      serviceTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serviceType',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      serviceTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serviceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      serviceTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serviceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      serviceTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serviceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      serviceTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serviceType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      serviceTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'serviceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      serviceTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'serviceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      serviceTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'serviceType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      serviceTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'serviceType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      serviceTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serviceType',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      serviceTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'serviceType',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      transitAuthorityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'transitAuthority',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      transitAuthorityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'transitAuthority',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      transitAuthorityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transitAuthority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      transitAuthorityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transitAuthority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      transitAuthorityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transitAuthority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      transitAuthorityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transitAuthority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      transitAuthorityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transitAuthority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      transitAuthorityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transitAuthority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      transitAuthorityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transitAuthority',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      transitAuthorityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transitAuthority',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      transitAuthorityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transitAuthority',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      transitAuthorityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transitAuthority',
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vehicleClassIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vehicleClass',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vehicleClassIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vehicleClass',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vehicleClassEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vehicleClassGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vehicleClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vehicleClassLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vehicleClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vehicleClassBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vehicleClass',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vehicleClassStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vehicleClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vehicleClassEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vehicleClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vehicleClassContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vehicleClass',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vehicleClassMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vehicleClass',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vehicleClassIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vehicleClass',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vehicleClassIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vehicleClass',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'vin',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vinIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'vin',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vinEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vinGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vinLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vinBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vinStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vinEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vinContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vinMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vin',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vin',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterFilterCondition>
      vinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vin',
        value: '',
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
      sortByAxles() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'axles', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByAxlesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'axles', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByBodyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyType', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByBodyTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyType', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByChassisNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chassisNumber', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByChassisNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chassisNumber', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
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
      sortByEngineDisplacement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineDisplacement', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByEngineDisplacementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineDisplacement', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByEngineNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineNumber', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByEngineNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineNumber', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByFuelType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuelType', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByFuelTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuelType', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByGrossWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grossWeightKg', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByGrossWeightKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grossWeightKg', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByInitialRegistrationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialRegistrationDate', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByInitialRegistrationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialRegistrationDate', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByLine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'line', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByLineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'line', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByLoadCapacityKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loadCapacityKg', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByLoadCapacityKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loadCapacityKg', Sort.desc);
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
      sortByOwnerDocument() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerDocument', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByOwnerDocumentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerDocument', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByOwnerDocumentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerDocumentType', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByOwnerDocumentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerDocumentType', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByOwnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByOwnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByPassengerCapacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passengerCapacity', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByPassengerCapacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passengerCapacity', Sort.desc);
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
      sortByPropertyLiens() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'propertyLiens', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByPropertyLiensDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'propertyLiens', Sort.desc);
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
      sortByRuntMetaJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtMetaJson', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByRuntMetaJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtMetaJson', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByServiceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceType', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByServiceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceType', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByTransitAuthority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transitAuthority', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByTransitAuthorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transitAuthority', Sort.desc);
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByVehicleClass() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleClass', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByVehicleClassDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleClass', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByVin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vin', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      sortByVinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vin', Sort.desc);
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
      thenByAxles() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'axles', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByAxlesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'axles', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByBodyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyType', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByBodyTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bodyType', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByChassisNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chassisNumber', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByChassisNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chassisNumber', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
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
      thenByEngineDisplacement() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineDisplacement', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByEngineDisplacementDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineDisplacement', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByEngineNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineNumber', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByEngineNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engineNumber', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByFuelType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuelType', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByFuelTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fuelType', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByGrossWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grossWeightKg', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByGrossWeightKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grossWeightKg', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByInitialRegistrationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialRegistrationDate', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByInitialRegistrationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialRegistrationDate', Sort.desc);
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
      thenByLine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'line', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByLineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'line', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByLoadCapacityKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loadCapacityKg', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByLoadCapacityKgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loadCapacityKg', Sort.desc);
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
      thenByOwnerDocument() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerDocument', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByOwnerDocumentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerDocument', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByOwnerDocumentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerDocumentType', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByOwnerDocumentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerDocumentType', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByOwnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByOwnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByPassengerCapacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passengerCapacity', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByPassengerCapacityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passengerCapacity', Sort.desc);
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
      thenByPropertyLiens() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'propertyLiens', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByPropertyLiensDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'propertyLiens', Sort.desc);
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
      thenByRuntMetaJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtMetaJson', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByRuntMetaJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtMetaJson', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByServiceType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceType', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByServiceTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceType', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByTransitAuthority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transitAuthority', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByTransitAuthorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transitAuthority', Sort.desc);
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

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByVehicleClass() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleClass', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByVehicleClassDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vehicleClass', Sort.desc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByVin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vin', Sort.asc);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QAfterSortBy>
      thenByVinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vin', Sort.desc);
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
      distinctByAxles() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'axles');
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByBodyType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bodyType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByChassisNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chassisNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByColor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByEngineDisplacement() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'engineDisplacement');
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByEngineNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'engineNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByFuelType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fuelType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByGrossWeightKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grossWeightKg');
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByInitialRegistrationDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'initialRegistrationDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByLine({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'line', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByLoadCapacityKg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loadCapacityKg');
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
      distinctByOwnerDocument({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerDocument',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByOwnerDocumentType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerDocumentType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByOwnerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByPassengerCapacity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passengerCapacity');
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByPlaca({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'placa', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByPropertyLiens({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'propertyLiens',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByRefCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'refCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByRuntMetaJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtMetaJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByServiceType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serviceType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByTransitAuthority({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transitAuthority',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct>
      distinctByVehicleClass({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vehicleClass', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetVehiculoModel, AssetVehiculoModel, QDistinct> distinctByVin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vin', caseSensitive: caseSensitive);
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

  QueryBuilder<AssetVehiculoModel, int?, QQueryOperations> axlesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'axles');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations>
      bodyTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bodyType');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations>
      chassisNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chassisNumber');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<AssetVehiculoModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AssetVehiculoModel, double?, QQueryOperations>
      engineDisplacementProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'engineDisplacement');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations>
      engineNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'engineNumber');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations>
      fuelTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fuelType');
    });
  }

  QueryBuilder<AssetVehiculoModel, double?, QQueryOperations>
      grossWeightKgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grossWeightKg');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations>
      initialRegistrationDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'initialRegistrationDate');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations> lineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'line');
    });
  }

  QueryBuilder<AssetVehiculoModel, double?, QQueryOperations>
      loadCapacityKgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loadCapacityKg');
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

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations>
      ownerDocumentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerDocument');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations>
      ownerDocumentTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerDocumentType');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations>
      ownerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerName');
    });
  }

  QueryBuilder<AssetVehiculoModel, int?, QQueryOperations>
      passengerCapacityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passengerCapacity');
    });
  }

  QueryBuilder<AssetVehiculoModel, String, QQueryOperations> placaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'placa');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations>
      propertyLiensProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'propertyLiens');
    });
  }

  QueryBuilder<AssetVehiculoModel, String, QQueryOperations> refCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'refCode');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations>
      runtMetaJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtMetaJson');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations>
      serviceTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serviceType');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations>
      transitAuthorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transitAuthority');
    });
  }

  QueryBuilder<AssetVehiculoModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations>
      vehicleClassProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vehicleClass');
    });
  }

  QueryBuilder<AssetVehiculoModel, String?, QQueryOperations> vinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vin');
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
      color: json['color'] as String?,
      engineDisplacement: (json['engineDisplacement'] as num?)?.toDouble(),
      vin: json['vin'] as String?,
      engineNumber: json['engineNumber'] as String?,
      chassisNumber: json['chassisNumber'] as String?,
      line: json['line'] as String?,
      serviceType: json['serviceType'] as String?,
      vehicleClass: json['vehicleClass'] as String?,
      bodyType: json['bodyType'] as String?,
      fuelType: json['fuelType'] as String?,
      passengerCapacity: (json['passengerCapacity'] as num?)?.toInt(),
      loadCapacityKg: (json['loadCapacityKg'] as num?)?.toDouble(),
      grossWeightKg: (json['grossWeightKg'] as num?)?.toDouble(),
      axles: (json['axles'] as num?)?.toInt(),
      transitAuthority: json['transitAuthority'] as String?,
      initialRegistrationDate: json['initialRegistrationDate'] as String?,
      propertyLiens: json['propertyLiens'] as String?,
      ownerDocumentType: json['ownerDocumentType'] as String?,
      ownerName: json['ownerName'] as String?,
      ownerDocument: json['ownerDocument'] as String?,
      runtMetaJson: json['runtMetaJson'] as String?,
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
      'color': instance.color,
      'engineDisplacement': instance.engineDisplacement,
      'vin': instance.vin,
      'engineNumber': instance.engineNumber,
      'chassisNumber': instance.chassisNumber,
      'line': instance.line,
      'serviceType': instance.serviceType,
      'vehicleClass': instance.vehicleClass,
      'bodyType': instance.bodyType,
      'fuelType': instance.fuelType,
      'passengerCapacity': instance.passengerCapacity,
      'loadCapacityKg': instance.loadCapacityKg,
      'grossWeightKg': instance.grossWeightKg,
      'axles': instance.axles,
      'transitAuthority': instance.transitAuthority,
      'initialRegistrationDate': instance.initialRegistrationDate,
      'propertyLiens': instance.propertyLiens,
      'ownerDocumentType': instance.ownerDocumentType,
      'ownerName': instance.ownerName,
      'ownerDocument': instance.ownerDocument,
      'runtMetaJson': instance.runtMetaJson,
      'createdAt':
          const DateTimeTimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const DateTimeTimestampConverter().toJson(instance.updatedAt),
    };
