// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_registration_draft_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAssetRegistrationDraftModelCollection on Isar {
  IsarCollection<AssetRegistrationDraftModel>
      get assetRegistrationDraftModels => this.collection();
}

const AssetRegistrationDraftModelSchema = CollectionSchema(
  name: r'AssetRegistrationDraftModel',
  id: 5427237489746356562,
  properties: {
    r'assetType': PropertySchema(
      id: 0,
      name: r'assetType',
      type: IsarType.string,
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
    r'documentNumber': PropertySchema(
      id: 3,
      name: r'documentNumber',
      type: IsarType.string,
    ),
    r'documentType': PropertySchema(
      id: 4,
      name: r'documentType',
      type: IsarType.string,
    ),
    r'draftId': PropertySchema(
      id: 5,
      name: r'draftId',
      type: IsarType.string,
    ),
    r'hasDocumentData': PropertySchema(
      id: 6,
      name: r'hasDocumentData',
      type: IsarType.bool,
    ),
    r'hasPlate': PropertySchema(
      id: 7,
      name: r'hasPlate',
      type: IsarType.bool,
    ),
    r'hasRuntFinalData': PropertySchema(
      id: 8,
      name: r'hasRuntFinalData',
      type: IsarType.bool,
    ),
    r'hasRuntJob': PropertySchema(
      id: 9,
      name: r'hasRuntJob',
      type: IsarType.bool,
    ),
    r'hasRuntPartialData': PropertySchema(
      id: 10,
      name: r'hasRuntPartialData',
      type: IsarType.bool,
    ),
    r'hasRuntProgress': PropertySchema(
      id: 11,
      name: r'hasRuntProgress',
      type: IsarType.bool,
    ),
    r'hasStep1CoreData': PropertySchema(
      id: 12,
      name: r'hasStep1CoreData',
      type: IsarType.bool,
    ),
    r'hasValidCoreEnums': PropertySchema(
      id: 13,
      name: r'hasValidCoreEnums',
      type: IsarType.bool,
    ),
    r'isRuntCompleted': PropertySchema(
      id: 14,
      name: r'isRuntCompleted',
      type: IsarType.bool,
    ),
    r'isRuntFailed': PropertySchema(
      id: 15,
      name: r'isRuntFailed',
      type: IsarType.bool,
    ),
    r'isRuntIdle': PropertySchema(
      id: 16,
      name: r'isRuntIdle',
      type: IsarType.bool,
    ),
    r'isRuntPending': PropertySchema(
      id: 17,
      name: r'isRuntPending',
      type: IsarType.bool,
    ),
    r'isRuntRunning': PropertySchema(
      id: 18,
      name: r'isRuntRunning',
      type: IsarType.bool,
    ),
    r'orgId': PropertySchema(
      id: 19,
      name: r'orgId',
      type: IsarType.string,
    ),
    r'plate': PropertySchema(
      id: 20,
      name: r'plate',
      type: IsarType.string,
    ),
    r'portfolioName': PropertySchema(
      id: 21,
      name: r'portfolioName',
      type: IsarType.string,
    ),
    r'regionId': PropertySchema(
      id: 22,
      name: r'regionId',
      type: IsarType.string,
    ),
    r'runtCompletedAt': PropertySchema(
      id: 23,
      name: r'runtCompletedAt',
      type: IsarType.dateTime,
    ),
    r'runtErrorMessage': PropertySchema(
      id: 24,
      name: r'runtErrorMessage',
      type: IsarType.string,
    ),
    r'runtJobId': PropertySchema(
      id: 25,
      name: r'runtJobId',
      type: IsarType.string,
    ),
    r'runtPartialDataJson': PropertySchema(
      id: 26,
      name: r'runtPartialDataJson',
      type: IsarType.string,
    ),
    r'runtProgressJson': PropertySchema(
      id: 27,
      name: r'runtProgressJson',
      type: IsarType.string,
    ),
    r'runtProgressPercent': PropertySchema(
      id: 28,
      name: r'runtProgressPercent',
      type: IsarType.long,
    ),
    r'runtStatus': PropertySchema(
      id: 29,
      name: r'runtStatus',
      type: IsarType.string,
    ),
    r'runtUpdatedAt': PropertySchema(
      id: 30,
      name: r'runtUpdatedAt',
      type: IsarType.dateTime,
    ),
    r'runtVehicleDataJson': PropertySchema(
      id: 31,
      name: r'runtVehicleDataJson',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 32,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _assetRegistrationDraftModelEstimateSize,
  serialize: _assetRegistrationDraftModelSerialize,
  deserialize: _assetRegistrationDraftModelDeserialize,
  deserializeProp: _assetRegistrationDraftModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'draftId': IndexSchema(
      id: 5577587084572475806,
      name: r'draftId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'draftId',
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _assetRegistrationDraftModelGetId,
  getLinks: _assetRegistrationDraftModelGetLinks,
  attach: _assetRegistrationDraftModelAttach,
  version: '3.2.0-dev.2',
);

int _assetRegistrationDraftModelEstimateSize(
  AssetRegistrationDraftModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assetType.length * 3;
  bytesCount += 3 + object.cityId.length * 3;
  bytesCount += 3 + object.countryId.length * 3;
  {
    final value = object.documentNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.documentType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.draftId.length * 3;
  bytesCount += 3 + object.orgId.length * 3;
  {
    final value = object.plate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.portfolioName.length * 3;
  bytesCount += 3 + object.regionId.length * 3;
  {
    final value = object.runtErrorMessage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.runtJobId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.runtPartialDataJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.runtProgressJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.runtStatus.length * 3;
  {
    final value = object.runtVehicleDataJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _assetRegistrationDraftModelSerialize(
  AssetRegistrationDraftModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.assetType);
  writer.writeString(offsets[1], object.cityId);
  writer.writeString(offsets[2], object.countryId);
  writer.writeString(offsets[3], object.documentNumber);
  writer.writeString(offsets[4], object.documentType);
  writer.writeString(offsets[5], object.draftId);
  writer.writeBool(offsets[6], object.hasDocumentData);
  writer.writeBool(offsets[7], object.hasPlate);
  writer.writeBool(offsets[8], object.hasRuntFinalData);
  writer.writeBool(offsets[9], object.hasRuntJob);
  writer.writeBool(offsets[10], object.hasRuntPartialData);
  writer.writeBool(offsets[11], object.hasRuntProgress);
  writer.writeBool(offsets[12], object.hasStep1CoreData);
  writer.writeBool(offsets[13], object.hasValidCoreEnums);
  writer.writeBool(offsets[14], object.isRuntCompleted);
  writer.writeBool(offsets[15], object.isRuntFailed);
  writer.writeBool(offsets[16], object.isRuntIdle);
  writer.writeBool(offsets[17], object.isRuntPending);
  writer.writeBool(offsets[18], object.isRuntRunning);
  writer.writeString(offsets[19], object.orgId);
  writer.writeString(offsets[20], object.plate);
  writer.writeString(offsets[21], object.portfolioName);
  writer.writeString(offsets[22], object.regionId);
  writer.writeDateTime(offsets[23], object.runtCompletedAt);
  writer.writeString(offsets[24], object.runtErrorMessage);
  writer.writeString(offsets[25], object.runtJobId);
  writer.writeString(offsets[26], object.runtPartialDataJson);
  writer.writeString(offsets[27], object.runtProgressJson);
  writer.writeLong(offsets[28], object.runtProgressPercent);
  writer.writeString(offsets[29], object.runtStatus);
  writer.writeDateTime(offsets[30], object.runtUpdatedAt);
  writer.writeString(offsets[31], object.runtVehicleDataJson);
  writer.writeDateTime(offsets[32], object.updatedAt);
}

AssetRegistrationDraftModel _assetRegistrationDraftModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AssetRegistrationDraftModel();
  object.assetType = reader.readString(offsets[0]);
  object.cityId = reader.readString(offsets[1]);
  object.countryId = reader.readString(offsets[2]);
  object.documentNumber = reader.readStringOrNull(offsets[3]);
  object.documentType = reader.readStringOrNull(offsets[4]);
  object.draftId = reader.readString(offsets[5]);
  object.isarId = id;
  object.orgId = reader.readString(offsets[19]);
  object.plate = reader.readStringOrNull(offsets[20]);
  object.portfolioName = reader.readString(offsets[21]);
  object.regionId = reader.readString(offsets[22]);
  object.runtCompletedAt = reader.readDateTimeOrNull(offsets[23]);
  object.runtErrorMessage = reader.readStringOrNull(offsets[24]);
  object.runtJobId = reader.readStringOrNull(offsets[25]);
  object.runtPartialDataJson = reader.readStringOrNull(offsets[26]);
  object.runtProgressJson = reader.readStringOrNull(offsets[27]);
  object.runtProgressPercent = reader.readLongOrNull(offsets[28]);
  object.runtStatus = reader.readString(offsets[29]);
  object.runtUpdatedAt = reader.readDateTimeOrNull(offsets[30]);
  object.runtVehicleDataJson = reader.readStringOrNull(offsets[31]);
  object.updatedAt = reader.readDateTime(offsets[32]);
  return object;
}

P _assetRegistrationDraftModelDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (reader.readBool(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    case 23:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    case 28:
      return (reader.readLongOrNull(offset)) as P;
    case 29:
      return (reader.readString(offset)) as P;
    case 30:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 31:
      return (reader.readStringOrNull(offset)) as P;
    case 32:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _assetRegistrationDraftModelGetId(AssetRegistrationDraftModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _assetRegistrationDraftModelGetLinks(
    AssetRegistrationDraftModel object) {
  return [];
}

void _assetRegistrationDraftModelAttach(
    IsarCollection<dynamic> col, Id id, AssetRegistrationDraftModel object) {
  object.isarId = id;
}

extension AssetRegistrationDraftModelByIndex
    on IsarCollection<AssetRegistrationDraftModel> {
  Future<AssetRegistrationDraftModel?> getByDraftId(String draftId) {
    return getByIndex(r'draftId', [draftId]);
  }

  AssetRegistrationDraftModel? getByDraftIdSync(String draftId) {
    return getByIndexSync(r'draftId', [draftId]);
  }

  Future<bool> deleteByDraftId(String draftId) {
    return deleteByIndex(r'draftId', [draftId]);
  }

  bool deleteByDraftIdSync(String draftId) {
    return deleteByIndexSync(r'draftId', [draftId]);
  }

  Future<List<AssetRegistrationDraftModel?>> getAllByDraftId(
      List<String> draftIdValues) {
    final values = draftIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'draftId', values);
  }

  List<AssetRegistrationDraftModel?> getAllByDraftIdSync(
      List<String> draftIdValues) {
    final values = draftIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'draftId', values);
  }

  Future<int> deleteAllByDraftId(List<String> draftIdValues) {
    final values = draftIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'draftId', values);
  }

  int deleteAllByDraftIdSync(List<String> draftIdValues) {
    final values = draftIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'draftId', values);
  }

  Future<Id> putByDraftId(AssetRegistrationDraftModel object) {
    return putByIndex(r'draftId', object);
  }

  Id putByDraftIdSync(AssetRegistrationDraftModel object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'draftId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDraftId(List<AssetRegistrationDraftModel> objects) {
    return putAllByIndex(r'draftId', objects);
  }

  List<Id> putAllByDraftIdSync(List<AssetRegistrationDraftModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'draftId', objects, saveLinks: saveLinks);
  }
}

extension AssetRegistrationDraftModelQueryWhereSort on QueryBuilder<
    AssetRegistrationDraftModel, AssetRegistrationDraftModel, QWhere> {
  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AssetRegistrationDraftModelQueryWhere on QueryBuilder<
    AssetRegistrationDraftModel, AssetRegistrationDraftModel, QWhereClause> {
  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterWhereClause> draftIdEqualTo(String draftId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'draftId',
        value: [draftId],
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterWhereClause> draftIdNotEqualTo(String draftId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'draftId',
              lower: [],
              upper: [draftId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'draftId',
              lower: [draftId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'draftId',
              lower: [draftId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'draftId',
              lower: [],
              upper: [draftId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterWhereClause> orgIdEqualTo(String orgId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orgId',
        value: [orgId],
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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
}

extension AssetRegistrationDraftModelQueryFilter on QueryBuilder<
    AssetRegistrationDraftModel,
    AssetRegistrationDraftModel,
    QFilterCondition> {
  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> assetTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> assetTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assetType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> assetTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assetType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> assetTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assetType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> assetTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assetType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> assetTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assetType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      assetTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assetType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      assetTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assetType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> assetTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetType',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> assetTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetType',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> cityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> cityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cityId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> countryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> countryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'countryId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'documentNumber',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'documentNumber',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'documentNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'documentNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'documentNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'documentNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'documentNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      documentNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'documentNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      documentNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'documentNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'documentNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'documentType',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'documentType',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'documentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'documentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'documentType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'documentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'documentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      documentTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'documentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      documentTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'documentType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentType',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> documentTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'documentType',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> draftIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'draftId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> draftIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'draftId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> draftIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'draftId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> draftIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'draftId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> draftIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'draftId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> draftIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'draftId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      draftIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'draftId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      draftIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'draftId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> draftIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'draftId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> draftIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'draftId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> hasDocumentDataEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasDocumentData',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> hasPlateEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasPlate',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> hasRuntFinalDataEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasRuntFinalData',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> hasRuntJobEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasRuntJob',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> hasRuntPartialDataEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasRuntPartialData',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> hasRuntProgressEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasRuntProgress',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> hasStep1CoreDataEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasStep1CoreData',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> hasValidCoreEnumsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasValidCoreEnums',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> isRuntCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRuntCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> isRuntFailedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRuntFailed',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> isRuntIdleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRuntIdle',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> isRuntPendingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRuntPending',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> isRuntRunningEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRuntRunning',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> isarIdLessThan(
    Id value, {
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> orgIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orgId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> orgIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orgId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> plateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'plate',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> plateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'plate',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> plateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> plateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> plateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> plateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> plateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'plate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> plateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'plate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      plateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'plate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      plateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'plate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> plateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plate',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> plateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'plate',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> portfolioNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'portfolioName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> portfolioNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'portfolioName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> portfolioNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'portfolioName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> portfolioNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'portfolioName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> portfolioNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'portfolioName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> portfolioNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'portfolioName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      portfolioNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'portfolioName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      portfolioNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'portfolioName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> portfolioNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'portfolioName',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> portfolioNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'portfolioName',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> regionIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> regionIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'regionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> regionIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'regionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> regionIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'regionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> regionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'regionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> regionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'regionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      regionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'regionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      regionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'regionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> regionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regionId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> regionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'regionId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtCompletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'runtCompletedAt',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtCompletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'runtCompletedAt',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtCompletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtCompletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtCompletedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'runtCompletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtCompletedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'runtCompletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtCompletedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'runtCompletedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtErrorMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'runtErrorMessage',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtErrorMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'runtErrorMessage',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtErrorMessageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtErrorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtErrorMessageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'runtErrorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtErrorMessageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'runtErrorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtErrorMessageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'runtErrorMessage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtErrorMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'runtErrorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtErrorMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'runtErrorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      runtErrorMessageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'runtErrorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      runtErrorMessageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'runtErrorMessage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtErrorMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtErrorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtErrorMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'runtErrorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtJobIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'runtJobId',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtJobIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'runtJobId',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtJobIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtJobId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtJobIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'runtJobId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtJobIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'runtJobId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtJobIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'runtJobId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtJobIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'runtJobId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtJobIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'runtJobId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      runtJobIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'runtJobId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      runtJobIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'runtJobId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtJobIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtJobId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtJobIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'runtJobId',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtPartialDataJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'runtPartialDataJson',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtPartialDataJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'runtPartialDataJson',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtPartialDataJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtPartialDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtPartialDataJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'runtPartialDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtPartialDataJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'runtPartialDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtPartialDataJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'runtPartialDataJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtPartialDataJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'runtPartialDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtPartialDataJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'runtPartialDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      runtPartialDataJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'runtPartialDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      runtPartialDataJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'runtPartialDataJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtPartialDataJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtPartialDataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtPartialDataJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'runtPartialDataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'runtProgressJson',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'runtProgressJson',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtProgressJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'runtProgressJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'runtProgressJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'runtProgressJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'runtProgressJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'runtProgressJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      runtProgressJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'runtProgressJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      runtProgressJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'runtProgressJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtProgressJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'runtProgressJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressPercentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'runtProgressPercent',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressPercentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'runtProgressPercent',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressPercentEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtProgressPercent',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressPercentGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'runtProgressPercent',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressPercentLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'runtProgressPercent',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtProgressPercentBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'runtProgressPercent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtStatusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtStatusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'runtStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtStatusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'runtStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtStatusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'runtStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtStatusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'runtStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtStatusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'runtStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      runtStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'runtStatus',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      runtStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'runtStatus',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'runtStatus',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtUpdatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'runtUpdatedAt',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtUpdatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'runtUpdatedAt',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtUpdatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtUpdatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'runtUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtUpdatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'runtUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtUpdatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'runtUpdatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtVehicleDataJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'runtVehicleDataJson',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtVehicleDataJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'runtVehicleDataJson',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtVehicleDataJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtVehicleDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtVehicleDataJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'runtVehicleDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtVehicleDataJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'runtVehicleDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtVehicleDataJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'runtVehicleDataJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtVehicleDataJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'runtVehicleDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtVehicleDataJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'runtVehicleDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      runtVehicleDataJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'runtVehicleDataJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
          QAfterFilterCondition>
      runtVehicleDataJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'runtVehicleDataJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtVehicleDataJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'runtVehicleDataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> runtVehicleDataJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'runtVehicleDataJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
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

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
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

extension AssetRegistrationDraftModelQueryObject on QueryBuilder<
    AssetRegistrationDraftModel,
    AssetRegistrationDraftModel,
    QFilterCondition> {}

extension AssetRegistrationDraftModelQueryLinks on QueryBuilder<
    AssetRegistrationDraftModel,
    AssetRegistrationDraftModel,
    QFilterCondition> {}

extension AssetRegistrationDraftModelQuerySortBy on QueryBuilder<
    AssetRegistrationDraftModel, AssetRegistrationDraftModel, QSortBy> {
  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByAssetType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetType', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByAssetTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetType', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByCityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByCityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByCountryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByDocumentNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentNumber', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByDocumentNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentNumber', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByDocumentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentType', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByDocumentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentType', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByDraftId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'draftId', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByDraftIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'draftId', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasDocumentData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasDocumentData', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasDocumentDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasDocumentData', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasPlate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPlate', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasPlateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPlate', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasRuntFinalData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntFinalData', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasRuntFinalDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntFinalData', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasRuntJob() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntJob', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasRuntJobDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntJob', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasRuntPartialData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntPartialData', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasRuntPartialDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntPartialData', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasRuntProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntProgress', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasRuntProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntProgress', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasStep1CoreData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasStep1CoreData', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasStep1CoreDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasStep1CoreData', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasValidCoreEnums() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasValidCoreEnums', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByHasValidCoreEnumsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasValidCoreEnums', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByIsRuntCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntCompleted', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByIsRuntCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntCompleted', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByIsRuntFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntFailed', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByIsRuntFailedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntFailed', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByIsRuntIdle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntIdle', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByIsRuntIdleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntIdle', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByIsRuntPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntPending', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByIsRuntPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntPending', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByIsRuntRunning() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntRunning', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByIsRuntRunningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntRunning', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByOrgId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByOrgIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByPlate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plate', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByPlateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plate', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByPortfolioName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portfolioName', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByPortfolioNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portfolioName', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRegionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regionId', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRegionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regionId', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtCompletedAt', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtCompletedAt', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtErrorMessage', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtErrorMessage', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntJobId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtJobId', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntJobIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtJobId', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntPartialDataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtPartialDataJson', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntPartialDataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtPartialDataJson', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntProgressJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtProgressJson', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntProgressJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtProgressJson', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntProgressPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtProgressPercent', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntProgressPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtProgressPercent', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtStatus', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtStatus', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntVehicleDataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtVehicleDataJson', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByRuntVehicleDataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtVehicleDataJson', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AssetRegistrationDraftModelQuerySortThenBy on QueryBuilder<
    AssetRegistrationDraftModel, AssetRegistrationDraftModel, QSortThenBy> {
  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByAssetType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetType', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByAssetTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetType', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByCityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByCityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByCountryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByDocumentNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentNumber', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByDocumentNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentNumber', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByDocumentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentType', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByDocumentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentType', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByDraftId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'draftId', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByDraftIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'draftId', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasDocumentData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasDocumentData', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasDocumentDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasDocumentData', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasPlate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPlate', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasPlateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasPlate', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasRuntFinalData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntFinalData', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasRuntFinalDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntFinalData', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasRuntJob() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntJob', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasRuntJobDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntJob', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasRuntPartialData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntPartialData', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasRuntPartialDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntPartialData', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasRuntProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntProgress', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasRuntProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasRuntProgress', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasStep1CoreData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasStep1CoreData', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasStep1CoreDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasStep1CoreData', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasValidCoreEnums() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasValidCoreEnums', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByHasValidCoreEnumsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasValidCoreEnums', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByIsRuntCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntCompleted', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByIsRuntCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntCompleted', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByIsRuntFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntFailed', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByIsRuntFailedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntFailed', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByIsRuntIdle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntIdle', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByIsRuntIdleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntIdle', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByIsRuntPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntPending', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByIsRuntPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntPending', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByIsRuntRunning() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntRunning', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByIsRuntRunningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRuntRunning', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByOrgId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByOrgIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgId', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByPlate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plate', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByPlateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plate', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByPortfolioName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portfolioName', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByPortfolioNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portfolioName', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRegionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regionId', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRegionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regionId', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtCompletedAt', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtCompletedAt', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtErrorMessage', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtErrorMessage', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntJobId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtJobId', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntJobIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtJobId', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntPartialDataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtPartialDataJson', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntPartialDataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtPartialDataJson', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntProgressJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtProgressJson', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntProgressJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtProgressJson', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntProgressPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtProgressPercent', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntProgressPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtProgressPercent', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtStatus', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtStatus', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntVehicleDataJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtVehicleDataJson', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByRuntVehicleDataJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'runtVehicleDataJson', Sort.desc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AssetRegistrationDraftModelQueryWhereDistinct on QueryBuilder<
    AssetRegistrationDraftModel, AssetRegistrationDraftModel, QDistinct> {
  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByAssetType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByCityId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByCountryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'countryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByDocumentNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'documentNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByDocumentType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'documentType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByDraftId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'draftId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByHasDocumentData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasDocumentData');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByHasPlate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasPlate');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByHasRuntFinalData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasRuntFinalData');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByHasRuntJob() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasRuntJob');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByHasRuntPartialData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasRuntPartialData');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByHasRuntProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasRuntProgress');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByHasStep1CoreData() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasStep1CoreData');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByHasValidCoreEnums() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasValidCoreEnums');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByIsRuntCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRuntCompleted');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByIsRuntFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRuntFailed');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByIsRuntIdle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRuntIdle');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByIsRuntPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRuntPending');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByIsRuntRunning() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRuntRunning');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByOrgId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orgId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByPlate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByPortfolioName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'portfolioName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByRegionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByRuntCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtCompletedAt');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByRuntErrorMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtErrorMessage',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByRuntJobId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtJobId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByRuntPartialDataJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtPartialDataJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByRuntProgressJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtProgressJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByRuntProgressPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtProgressPercent');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByRuntStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtStatus', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByRuntUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtUpdatedAt');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByRuntVehicleDataJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'runtVehicleDataJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, AssetRegistrationDraftModel,
      QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension AssetRegistrationDraftModelQueryProperty on QueryBuilder<
    AssetRegistrationDraftModel, AssetRegistrationDraftModel, QQueryProperty> {
  QueryBuilder<AssetRegistrationDraftModel, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String, QQueryOperations>
      assetTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetType');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String, QQueryOperations>
      cityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cityId');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String, QQueryOperations>
      countryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'countryId');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String?, QQueryOperations>
      documentNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'documentNumber');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String?, QQueryOperations>
      documentTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'documentType');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String, QQueryOperations>
      draftIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'draftId');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, bool, QQueryOperations>
      hasDocumentDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasDocumentData');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, bool, QQueryOperations>
      hasPlateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasPlate');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, bool, QQueryOperations>
      hasRuntFinalDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasRuntFinalData');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, bool, QQueryOperations>
      hasRuntJobProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasRuntJob');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, bool, QQueryOperations>
      hasRuntPartialDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasRuntPartialData');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, bool, QQueryOperations>
      hasRuntProgressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasRuntProgress');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, bool, QQueryOperations>
      hasStep1CoreDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasStep1CoreData');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, bool, QQueryOperations>
      hasValidCoreEnumsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasValidCoreEnums');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, bool, QQueryOperations>
      isRuntCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRuntCompleted');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, bool, QQueryOperations>
      isRuntFailedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRuntFailed');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, bool, QQueryOperations>
      isRuntIdleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRuntIdle');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, bool, QQueryOperations>
      isRuntPendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRuntPending');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, bool, QQueryOperations>
      isRuntRunningProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRuntRunning');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String, QQueryOperations>
      orgIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orgId');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String?, QQueryOperations>
      plateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plate');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String, QQueryOperations>
      portfolioNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'portfolioName');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String, QQueryOperations>
      regionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regionId');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, DateTime?, QQueryOperations>
      runtCompletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtCompletedAt');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String?, QQueryOperations>
      runtErrorMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtErrorMessage');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String?, QQueryOperations>
      runtJobIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtJobId');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String?, QQueryOperations>
      runtPartialDataJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtPartialDataJson');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String?, QQueryOperations>
      runtProgressJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtProgressJson');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, int?, QQueryOperations>
      runtProgressPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtProgressPercent');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String, QQueryOperations>
      runtStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtStatus');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, DateTime?, QQueryOperations>
      runtUpdatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtUpdatedAt');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, String?, QQueryOperations>
      runtVehicleDataJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'runtVehicleDataJson');
    });
  }

  QueryBuilder<AssetRegistrationDraftModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
