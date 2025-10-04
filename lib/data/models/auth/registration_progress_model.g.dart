// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_progress_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRegistrationProgressModelCollection on Isar {
  IsarCollection<RegistrationProgressModel> get registrationProgressModels =>
      this.collection();
}

const RegistrationProgressModelSchema = CollectionSchema(
  name: r'RegistrationProgressModel',
  id: 7707409393652762021,
  properties: {
    r'assetSegmentIds': PropertySchema(
      id: 0,
      name: r'assetSegmentIds',
      type: IsarType.stringList,
    ),
    r'assetTypeIds': PropertySchema(
      id: 1,
      name: r'assetTypeIds',
      type: IsarType.stringList,
    ),
    r'barcodeRaw': PropertySchema(
      id: 2,
      name: r'barcodeRaw',
      type: IsarType.string,
    ),
    r'businessCategoryId': PropertySchema(
      id: 3,
      name: r'businessCategoryId',
      type: IsarType.string,
    ),
    r'categories': PropertySchema(
      id: 4,
      name: r'categories',
      type: IsarType.stringList,
    ),
    r'cityId': PropertySchema(
      id: 5,
      name: r'cityId',
      type: IsarType.string,
    ),
    r'countryId': PropertySchema(
      id: 6,
      name: r'countryId',
      type: IsarType.string,
    ),
    r'coverageCities': PropertySchema(
      id: 7,
      name: r'coverageCities',
      type: IsarType.stringList,
    ),
    r'docNumber': PropertySchema(
      id: 8,
      name: r'docNumber',
      type: IsarType.string,
    ),
    r'docType': PropertySchema(
      id: 9,
      name: r'docType',
      type: IsarType.string,
    ),
    r'email': PropertySchema(
      id: 10,
      name: r'email',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 11,
      name: r'id',
      type: IsarType.string,
    ),
    r'offeringLineIds': PropertySchema(
      id: 12,
      name: r'offeringLineIds',
      type: IsarType.stringList,
    ),
    r'passwordSet': PropertySchema(
      id: 13,
      name: r'passwordSet',
      type: IsarType.bool,
    ),
    r'phone': PropertySchema(
      id: 14,
      name: r'phone',
      type: IsarType.string,
    ),
    r'providerType': PropertySchema(
      id: 15,
      name: r'providerType',
      type: IsarType.string,
    ),
    r'regionId': PropertySchema(
      id: 16,
      name: r'regionId',
      type: IsarType.string,
    ),
    r'selectedRole': PropertySchema(
      id: 17,
      name: r'selectedRole',
      type: IsarType.string,
    ),
    r'step': PropertySchema(
      id: 18,
      name: r'step',
      type: IsarType.long,
    ),
    r'termsAccepted': PropertySchema(
      id: 19,
      name: r'termsAccepted',
      type: IsarType.bool,
    ),
    r'titularType': PropertySchema(
      id: 20,
      name: r'titularType',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 21,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'username': PropertySchema(
      id: 22,
      name: r'username',
      type: IsarType.string,
    )
  },
  estimateSize: _registrationProgressModelEstimateSize,
  serialize: _registrationProgressModelSerialize,
  deserialize: _registrationProgressModelDeserialize,
  deserializeProp: _registrationProgressModelDeserializeProp,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _registrationProgressModelGetId,
  getLinks: _registrationProgressModelGetLinks,
  attach: _registrationProgressModelAttach,
  version: '3.2.0-dev.2',
);

int _registrationProgressModelEstimateSize(
  RegistrationProgressModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assetSegmentIds.length * 3;
  {
    for (var i = 0; i < object.assetSegmentIds.length; i++) {
      final value = object.assetSegmentIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.assetTypeIds.length * 3;
  {
    for (var i = 0; i < object.assetTypeIds.length; i++) {
      final value = object.assetTypeIds[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.barcodeRaw;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.businessCategoryId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.categories.length * 3;
  {
    for (var i = 0; i < object.categories.length; i++) {
      final value = object.categories[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.cityId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.countryId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.coverageCities.length * 3;
  {
    for (var i = 0; i < object.coverageCities.length; i++) {
      final value = object.coverageCities[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.docNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.docType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.email;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.offeringLineIds.length * 3;
  {
    for (var i = 0; i < object.offeringLineIds.length; i++) {
      final value = object.offeringLineIds[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.phone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.providerType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.regionId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.selectedRole;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.titularType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.username;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _registrationProgressModelSerialize(
  RegistrationProgressModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.assetSegmentIds);
  writer.writeStringList(offsets[1], object.assetTypeIds);
  writer.writeString(offsets[2], object.barcodeRaw);
  writer.writeString(offsets[3], object.businessCategoryId);
  writer.writeStringList(offsets[4], object.categories);
  writer.writeString(offsets[5], object.cityId);
  writer.writeString(offsets[6], object.countryId);
  writer.writeStringList(offsets[7], object.coverageCities);
  writer.writeString(offsets[8], object.docNumber);
  writer.writeString(offsets[9], object.docType);
  writer.writeString(offsets[10], object.email);
  writer.writeString(offsets[11], object.id);
  writer.writeStringList(offsets[12], object.offeringLineIds);
  writer.writeBool(offsets[13], object.passwordSet);
  writer.writeString(offsets[14], object.phone);
  writer.writeString(offsets[15], object.providerType);
  writer.writeString(offsets[16], object.regionId);
  writer.writeString(offsets[17], object.selectedRole);
  writer.writeLong(offsets[18], object.step);
  writer.writeBool(offsets[19], object.termsAccepted);
  writer.writeString(offsets[20], object.titularType);
  writer.writeDateTime(offsets[21], object.updatedAt);
  writer.writeString(offsets[22], object.username);
}

RegistrationProgressModel _registrationProgressModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RegistrationProgressModel();
  object.assetSegmentIds = reader.readStringList(offsets[0]) ?? [];
  object.assetTypeIds = reader.readStringList(offsets[1]) ?? [];
  object.barcodeRaw = reader.readStringOrNull(offsets[2]);
  object.businessCategoryId = reader.readStringOrNull(offsets[3]);
  object.categories = reader.readStringList(offsets[4]) ?? [];
  object.cityId = reader.readStringOrNull(offsets[5]);
  object.countryId = reader.readStringOrNull(offsets[6]);
  object.coverageCities = reader.readStringList(offsets[7]) ?? [];
  object.docNumber = reader.readStringOrNull(offsets[8]);
  object.docType = reader.readStringOrNull(offsets[9]);
  object.email = reader.readStringOrNull(offsets[10]);
  object.id = reader.readString(offsets[11]);
  object.isarId = id;
  object.offeringLineIds = reader.readStringList(offsets[12]) ?? [];
  object.passwordSet = reader.readBool(offsets[13]);
  object.phone = reader.readStringOrNull(offsets[14]);
  object.providerType = reader.readStringOrNull(offsets[15]);
  object.regionId = reader.readStringOrNull(offsets[16]);
  object.selectedRole = reader.readStringOrNull(offsets[17]);
  object.step = reader.readLong(offsets[18]);
  object.termsAccepted = reader.readBool(offsets[19]);
  object.titularType = reader.readStringOrNull(offsets[20]);
  object.updatedAt = reader.readDateTime(offsets[21]);
  object.username = reader.readStringOrNull(offsets[22]);
  return object;
}

P _registrationProgressModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringList(offset) ?? []) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readStringList(offset) ?? []) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    case 19:
      return (reader.readBool(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readDateTime(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _registrationProgressModelGetId(RegistrationProgressModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _registrationProgressModelGetLinks(
    RegistrationProgressModel object) {
  return [];
}

void _registrationProgressModelAttach(
    IsarCollection<dynamic> col, Id id, RegistrationProgressModel object) {
  object.isarId = id;
}

extension RegistrationProgressModelByIndex
    on IsarCollection<RegistrationProgressModel> {
  Future<RegistrationProgressModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  RegistrationProgressModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<RegistrationProgressModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<RegistrationProgressModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(RegistrationProgressModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(RegistrationProgressModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<RegistrationProgressModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<RegistrationProgressModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension RegistrationProgressModelQueryWhereSort on QueryBuilder<
    RegistrationProgressModel, RegistrationProgressModel, QWhere> {
  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RegistrationProgressModelQueryWhere on QueryBuilder<
    RegistrationProgressModel, RegistrationProgressModel, QWhereClause> {
  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterWhereClause> idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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
}

extension RegistrationProgressModelQueryFilter on QueryBuilder<
    RegistrationProgressModel, RegistrationProgressModel, QFilterCondition> {
  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetSegmentIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assetSegmentIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assetSegmentIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assetSegmentIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assetSegmentIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assetSegmentIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      assetSegmentIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assetSegmentIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      assetSegmentIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assetSegmentIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetSegmentIds',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetSegmentIds',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'assetSegmentIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'assetSegmentIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'assetSegmentIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'assetSegmentIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'assetSegmentIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetSegmentIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'assetSegmentIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetTypeIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assetTypeIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assetTypeIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assetTypeIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'assetTypeIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'assetTypeIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      assetTypeIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'assetTypeIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      assetTypeIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'assetTypeIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assetTypeIds',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'assetTypeIds',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'assetTypeIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'assetTypeIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'assetTypeIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'assetTypeIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'assetTypeIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> assetTypeIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'assetTypeIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> barcodeRawIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'barcodeRaw',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> barcodeRawIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'barcodeRaw',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> barcodeRawEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'barcodeRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> barcodeRawGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'barcodeRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> barcodeRawLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'barcodeRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> barcodeRawBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'barcodeRaw',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> barcodeRawStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'barcodeRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> barcodeRawEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'barcodeRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      barcodeRawContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'barcodeRaw',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      barcodeRawMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'barcodeRaw',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> barcodeRawIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'barcodeRaw',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> barcodeRawIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'barcodeRaw',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> businessCategoryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'businessCategoryId',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> businessCategoryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'businessCategoryId',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> businessCategoryIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessCategoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> businessCategoryIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'businessCategoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> businessCategoryIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'businessCategoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> businessCategoryIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'businessCategoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> businessCategoryIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'businessCategoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> businessCategoryIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'businessCategoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      businessCategoryIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'businessCategoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      businessCategoryIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'businessCategoryId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> businessCategoryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessCategoryId',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> businessCategoryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'businessCategoryId',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      categoriesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      categoriesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categories',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categories',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categories',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categories',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categories',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categories',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categories',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categories',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> categoriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'categories',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> cityIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cityId',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> cityIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cityId',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> cityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cityId',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> cityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cityId',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> countryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'countryId',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> countryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'countryId',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> countryIdEqualTo(
    String? value, {
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> countryIdGreaterThan(
    String? value, {
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> countryIdLessThan(
    String? value, {
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> countryIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> countryIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryId',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> countryIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'countryId',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverageCities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coverageCities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coverageCities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coverageCities',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'coverageCities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'coverageCities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      coverageCitiesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'coverageCities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      coverageCitiesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'coverageCities',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverageCities',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'coverageCities',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'coverageCities',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'coverageCities',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'coverageCities',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'coverageCities',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'coverageCities',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> coverageCitiesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'coverageCities',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'docNumber',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'docNumber',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'docNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'docNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'docNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'docNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'docNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'docNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      docNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'docNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      docNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'docNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'docNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'docNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'docType',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'docType',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'docType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'docType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'docType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'docType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'docType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'docType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      docTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'docType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      docTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'docType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'docType',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> docTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'docType',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> emailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> emailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> emailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> emailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offeringLineIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'offeringLineIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'offeringLineIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'offeringLineIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'offeringLineIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'offeringLineIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      offeringLineIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'offeringLineIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      offeringLineIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'offeringLineIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'offeringLineIds',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'offeringLineIds',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'offeringLineIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'offeringLineIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'offeringLineIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'offeringLineIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'offeringLineIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> offeringLineIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'offeringLineIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> passwordSetEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'passwordSet',
        value: value,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> phoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> phoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> phoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> phoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> phoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> phoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      phoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      phoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> providerTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'providerType',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> providerTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'providerType',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> providerTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> providerTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'providerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> providerTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'providerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> providerTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'providerType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> providerTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'providerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> providerTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'providerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      providerTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'providerType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      providerTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'providerType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> providerTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerType',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> providerTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'providerType',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> regionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'regionId',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> regionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'regionId',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> regionIdEqualTo(
    String? value, {
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> regionIdGreaterThan(
    String? value, {
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> regionIdLessThan(
    String? value, {
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> regionIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> regionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regionId',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> regionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'regionId',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> selectedRoleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'selectedRole',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> selectedRoleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'selectedRole',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> selectedRoleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedRole',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> selectedRoleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedRole',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> selectedRoleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedRole',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> selectedRoleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedRole',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> selectedRoleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedRole',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> selectedRoleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedRole',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      selectedRoleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedRole',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      selectedRoleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedRole',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> selectedRoleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedRole',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> selectedRoleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedRole',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> stepEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'step',
        value: value,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> stepGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'step',
        value: value,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> stepLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'step',
        value: value,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> stepBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'step',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> termsAcceptedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'termsAccepted',
        value: value,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> titularTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'titularType',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> titularTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'titularType',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> titularTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titularType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> titularTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'titularType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> titularTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'titularType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> titularTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'titularType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> titularTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'titularType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> titularTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'titularType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      titularTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titularType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      titularTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titularType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> titularTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titularType',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> titularTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titularType',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
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

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> usernameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'username',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> usernameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'username',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> usernameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> usernameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> usernameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> usernameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'username',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> usernameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> usernameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      usernameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
          QAfterFilterCondition>
      usernameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'username',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> usernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: '',
      ));
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterFilterCondition> usernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'username',
        value: '',
      ));
    });
  }
}

extension RegistrationProgressModelQueryObject on QueryBuilder<
    RegistrationProgressModel, RegistrationProgressModel, QFilterCondition> {}

extension RegistrationProgressModelQueryLinks on QueryBuilder<
    RegistrationProgressModel, RegistrationProgressModel, QFilterCondition> {}

extension RegistrationProgressModelQuerySortBy on QueryBuilder<
    RegistrationProgressModel, RegistrationProgressModel, QSortBy> {
  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByBarcodeRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeRaw', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByBarcodeRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeRaw', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByBusinessCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessCategoryId', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByBusinessCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessCategoryId', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByCityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByCityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByCountryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByDocNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docNumber', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByDocNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docNumber', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByDocType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docType', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByDocTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docType', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByPasswordSet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordSet', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByPasswordSetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordSet', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByProviderType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerType', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByProviderTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerType', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByRegionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regionId', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByRegionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regionId', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortBySelectedRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedRole', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortBySelectedRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedRole', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByStep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'step', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByStepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'step', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByTermsAccepted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termsAccepted', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByTermsAcceptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termsAccepted', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByTitularType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titularType', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByTitularTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titularType', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> sortByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension RegistrationProgressModelQuerySortThenBy on QueryBuilder<
    RegistrationProgressModel, RegistrationProgressModel, QSortThenBy> {
  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByBarcodeRaw() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeRaw', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByBarcodeRawDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'barcodeRaw', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByBusinessCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessCategoryId', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByBusinessCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessCategoryId', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByCityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByCityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cityId', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByCountryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByCountryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryId', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByDocNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docNumber', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByDocNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docNumber', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByDocType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docType', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByDocTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docType', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByPasswordSet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordSet', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByPasswordSetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'passwordSet', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByProviderType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerType', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByProviderTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerType', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByRegionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regionId', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByRegionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regionId', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenBySelectedRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedRole', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenBySelectedRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedRole', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByStep() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'step', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByStepDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'step', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByTermsAccepted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termsAccepted', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByTermsAcceptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'termsAccepted', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByTitularType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titularType', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByTitularTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titularType', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel,
      QAfterSortBy> thenByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension RegistrationProgressModelQueryWhereDistinct on QueryBuilder<
    RegistrationProgressModel, RegistrationProgressModel, QDistinct> {
  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByAssetSegmentIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetSegmentIds');
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByAssetTypeIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetTypeIds');
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByBarcodeRaw({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'barcodeRaw', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByBusinessCategoryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessCategoryId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByCategories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categories');
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByCityId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByCountryId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'countryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByCoverageCities() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coverageCities');
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByDocNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'docNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByDocType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'docType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByOfferingLineIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'offeringLineIds');
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByPasswordSet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'passwordSet');
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByProviderType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'providerType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByRegionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regionId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctBySelectedRole({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedRole', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByStep() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'step');
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByTermsAccepted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'termsAccepted');
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByTitularType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titularType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<RegistrationProgressModel, RegistrationProgressModel, QDistinct>
      distinctByUsername({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'username', caseSensitive: caseSensitive);
    });
  }
}

extension RegistrationProgressModelQueryProperty on QueryBuilder<
    RegistrationProgressModel, RegistrationProgressModel, QQueryProperty> {
  QueryBuilder<RegistrationProgressModel, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<RegistrationProgressModel, List<String>, QQueryOperations>
      assetSegmentIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetSegmentIds');
    });
  }

  QueryBuilder<RegistrationProgressModel, List<String>, QQueryOperations>
      assetTypeIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetTypeIds');
    });
  }

  QueryBuilder<RegistrationProgressModel, String?, QQueryOperations>
      barcodeRawProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'barcodeRaw');
    });
  }

  QueryBuilder<RegistrationProgressModel, String?, QQueryOperations>
      businessCategoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessCategoryId');
    });
  }

  QueryBuilder<RegistrationProgressModel, List<String>, QQueryOperations>
      categoriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categories');
    });
  }

  QueryBuilder<RegistrationProgressModel, String?, QQueryOperations>
      cityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cityId');
    });
  }

  QueryBuilder<RegistrationProgressModel, String?, QQueryOperations>
      countryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'countryId');
    });
  }

  QueryBuilder<RegistrationProgressModel, List<String>, QQueryOperations>
      coverageCitiesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverageCities');
    });
  }

  QueryBuilder<RegistrationProgressModel, String?, QQueryOperations>
      docNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'docNumber');
    });
  }

  QueryBuilder<RegistrationProgressModel, String?, QQueryOperations>
      docTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'docType');
    });
  }

  QueryBuilder<RegistrationProgressModel, String?, QQueryOperations>
      emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<RegistrationProgressModel, String, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RegistrationProgressModel, List<String>, QQueryOperations>
      offeringLineIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'offeringLineIds');
    });
  }

  QueryBuilder<RegistrationProgressModel, bool, QQueryOperations>
      passwordSetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'passwordSet');
    });
  }

  QueryBuilder<RegistrationProgressModel, String?, QQueryOperations>
      phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<RegistrationProgressModel, String?, QQueryOperations>
      providerTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'providerType');
    });
  }

  QueryBuilder<RegistrationProgressModel, String?, QQueryOperations>
      regionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regionId');
    });
  }

  QueryBuilder<RegistrationProgressModel, String?, QQueryOperations>
      selectedRoleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedRole');
    });
  }

  QueryBuilder<RegistrationProgressModel, int, QQueryOperations>
      stepProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'step');
    });
  }

  QueryBuilder<RegistrationProgressModel, bool, QQueryOperations>
      termsAcceptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'termsAccepted');
    });
  }

  QueryBuilder<RegistrationProgressModel, String?, QQueryOperations>
      titularTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titularType');
    });
  }

  QueryBuilder<RegistrationProgressModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<RegistrationProgressModel, String?, QQueryOperations>
      usernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'username');
    });
  }
}
