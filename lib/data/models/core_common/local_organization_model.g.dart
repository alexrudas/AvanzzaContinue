// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_organization_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalOrganizationModelCollection on Isar {
  IsarCollection<LocalOrganizationModel> get localOrganizationModels =>
      this.collection();
}

const LocalOrganizationModelSchema = CollectionSchema(
  name: r'LocalOrganizationModel',
  id: -2223438807267267766,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deletedAt': PropertySchema(
      id: 1,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'displayName': PropertySchema(
      id: 2,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    ),
    r'isDeleted': PropertySchema(
      id: 4,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'legalName': PropertySchema(
      id: 5,
      name: r'legalName',
      type: IsarType.string,
    ),
    r'notesPrivate': PropertySchema(
      id: 6,
      name: r'notesPrivate',
      type: IsarType.string,
    ),
    r'primaryEmail': PropertySchema(
      id: 7,
      name: r'primaryEmail',
      type: IsarType.string,
    ),
    r'primaryPhoneE164': PropertySchema(
      id: 8,
      name: r'primaryPhoneE164',
      type: IsarType.string,
    ),
    r'snapshotAdoptedAt': PropertySchema(
      id: 9,
      name: r'snapshotAdoptedAt',
      type: IsarType.dateTime,
    ),
    r'snapshotSourcePlatformActorId': PropertySchema(
      id: 10,
      name: r'snapshotSourcePlatformActorId',
      type: IsarType.string,
    ),
    r'tagsPrivate': PropertySchema(
      id: 11,
      name: r'tagsPrivate',
      type: IsarType.stringList,
    ),
    r'taxId': PropertySchema(
      id: 12,
      name: r'taxId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 13,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'website': PropertySchema(
      id: 14,
      name: r'website',
      type: IsarType.string,
    ),
    r'workspaceId': PropertySchema(
      id: 15,
      name: r'workspaceId',
      type: IsarType.string,
    )
  },
  estimateSize: _localOrganizationModelEstimateSize,
  serialize: _localOrganizationModelSerialize,
  deserialize: _localOrganizationModelDeserialize,
  deserializeProp: _localOrganizationModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'workspaceId_primaryPhoneE164': IndexSchema(
      id: 2898983489437235395,
      name: r'workspaceId_primaryPhoneE164',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'workspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'primaryPhoneE164',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'workspaceId_taxId': IndexSchema(
      id: 6903306244508495492,
      name: r'workspaceId_taxId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'workspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'taxId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'workspaceId_primaryEmail': IndexSchema(
      id: 1311046517598720530,
      name: r'workspaceId_primaryEmail',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'workspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'primaryEmail',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'workspaceId_isDeleted': IndexSchema(
      id: 5467968713867237404,
      name: r'workspaceId_isDeleted',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'workspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'isDeleted',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localOrganizationModelGetId,
  getLinks: _localOrganizationModelGetLinks,
  attach: _localOrganizationModelAttach,
  version: '3.3.0-dev.1',
);

int _localOrganizationModelEstimateSize(
  LocalOrganizationModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.displayName.length * 3;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.legalName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notesPrivate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.primaryEmail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.primaryPhoneE164;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.snapshotSourcePlatformActorId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tagsPrivate.length * 3;
  {
    for (var i = 0; i < object.tagsPrivate.length; i++) {
      final value = object.tagsPrivate[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.taxId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.website;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.workspaceId.length * 3;
  return bytesCount;
}

void _localOrganizationModelSerialize(
  LocalOrganizationModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.deletedAt);
  writer.writeString(offsets[2], object.displayName);
  writer.writeString(offsets[3], object.id);
  writer.writeBool(offsets[4], object.isDeleted);
  writer.writeString(offsets[5], object.legalName);
  writer.writeString(offsets[6], object.notesPrivate);
  writer.writeString(offsets[7], object.primaryEmail);
  writer.writeString(offsets[8], object.primaryPhoneE164);
  writer.writeDateTime(offsets[9], object.snapshotAdoptedAt);
  writer.writeString(offsets[10], object.snapshotSourcePlatformActorId);
  writer.writeStringList(offsets[11], object.tagsPrivate);
  writer.writeString(offsets[12], object.taxId);
  writer.writeDateTime(offsets[13], object.updatedAt);
  writer.writeString(offsets[14], object.website);
  writer.writeString(offsets[15], object.workspaceId);
}

LocalOrganizationModel _localOrganizationModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalOrganizationModel(
    createdAt: reader.readDateTime(offsets[0]),
    deletedAt: reader.readDateTimeOrNull(offsets[1]),
    displayName: reader.readString(offsets[2]),
    id: reader.readString(offsets[3]),
    isDeleted: reader.readBoolOrNull(offsets[4]) ?? false,
    isarId: id,
    legalName: reader.readStringOrNull(offsets[5]),
    notesPrivate: reader.readStringOrNull(offsets[6]),
    primaryEmail: reader.readStringOrNull(offsets[7]),
    primaryPhoneE164: reader.readStringOrNull(offsets[8]),
    snapshotAdoptedAt: reader.readDateTimeOrNull(offsets[9]),
    snapshotSourcePlatformActorId: reader.readStringOrNull(offsets[10]),
    tagsPrivate: reader.readStringList(offsets[11]) ?? const <String>[],
    taxId: reader.readStringOrNull(offsets[12]),
    updatedAt: reader.readDateTime(offsets[13]),
    website: reader.readStringOrNull(offsets[14]),
    workspaceId: reader.readString(offsets[15]),
  );
  return object;
}

P _localOrganizationModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringList(offset) ?? const <String>[]) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localOrganizationModelGetId(LocalOrganizationModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _localOrganizationModelGetLinks(
    LocalOrganizationModel object) {
  return [];
}

void _localOrganizationModelAttach(
    IsarCollection<dynamic> col, Id id, LocalOrganizationModel object) {
  object.isarId = id;
}

extension LocalOrganizationModelByIndex
    on IsarCollection<LocalOrganizationModel> {
  Future<LocalOrganizationModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  LocalOrganizationModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<LocalOrganizationModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<LocalOrganizationModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(LocalOrganizationModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(LocalOrganizationModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<LocalOrganizationModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<LocalOrganizationModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension LocalOrganizationModelQueryWhereSort
    on QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QWhere> {
  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalOrganizationModelQueryWhere on QueryBuilder<
    LocalOrganizationModel, LocalOrganizationModel, QWhereClause> {
  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterWhereClause> idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdEqualToAnyPrimaryPhoneE164(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_primaryPhoneE164',
        value: [workspaceId],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdNotEqualToAnyPrimaryPhoneE164(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryPhoneE164',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryPhoneE164',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryPhoneE164',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryPhoneE164',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdEqualToPrimaryPhoneE164IsNull(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_primaryPhoneE164',
        value: [workspaceId, null],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdEqualToPrimaryPhoneE164IsNotNull(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'workspaceId_primaryPhoneE164',
        lower: [workspaceId, null],
        includeLower: false,
        upper: [
          workspaceId,
        ],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdPrimaryPhoneE164EqualTo(
          String workspaceId, String? primaryPhoneE164) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_primaryPhoneE164',
        value: [workspaceId, primaryPhoneE164],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdEqualToPrimaryPhoneE164NotEqualTo(
          String workspaceId, String? primaryPhoneE164) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryPhoneE164',
              lower: [workspaceId],
              upper: [workspaceId, primaryPhoneE164],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryPhoneE164',
              lower: [workspaceId, primaryPhoneE164],
              includeLower: false,
              upper: [workspaceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryPhoneE164',
              lower: [workspaceId, primaryPhoneE164],
              includeLower: false,
              upper: [workspaceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryPhoneE164',
              lower: [workspaceId],
              upper: [workspaceId, primaryPhoneE164],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterWhereClause> workspaceIdEqualToAnyTaxId(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_taxId',
        value: [workspaceId],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterWhereClause> workspaceIdNotEqualToAnyTaxId(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_taxId',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_taxId',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_taxId',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_taxId',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterWhereClause> workspaceIdEqualToTaxIdIsNull(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_taxId',
        value: [workspaceId, null],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterWhereClause> workspaceIdEqualToTaxIdIsNotNull(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'workspaceId_taxId',
        lower: [workspaceId, null],
        includeLower: false,
        upper: [
          workspaceId,
        ],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdTaxIdEqualTo(String workspaceId, String? taxId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_taxId',
        value: [workspaceId, taxId],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdEqualToTaxIdNotEqualTo(String workspaceId, String? taxId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_taxId',
              lower: [workspaceId],
              upper: [workspaceId, taxId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_taxId',
              lower: [workspaceId, taxId],
              includeLower: false,
              upper: [workspaceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_taxId',
              lower: [workspaceId, taxId],
              includeLower: false,
              upper: [workspaceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_taxId',
              lower: [workspaceId],
              upper: [workspaceId, taxId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterWhereClause> workspaceIdEqualToAnyPrimaryEmail(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_primaryEmail',
        value: [workspaceId],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdNotEqualToAnyPrimaryEmail(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryEmail',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryEmail',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryEmail',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryEmail',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdEqualToPrimaryEmailIsNull(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_primaryEmail',
        value: [workspaceId, null],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdEqualToPrimaryEmailIsNotNull(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'workspaceId_primaryEmail',
        lower: [workspaceId, null],
        includeLower: false,
        upper: [
          workspaceId,
        ],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdPrimaryEmailEqualTo(String workspaceId, String? primaryEmail) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_primaryEmail',
        value: [workspaceId, primaryEmail],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdEqualToPrimaryEmailNotEqualTo(
          String workspaceId, String? primaryEmail) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryEmail',
              lower: [workspaceId],
              upper: [workspaceId, primaryEmail],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryEmail',
              lower: [workspaceId, primaryEmail],
              includeLower: false,
              upper: [workspaceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryEmail',
              lower: [workspaceId, primaryEmail],
              includeLower: false,
              upper: [workspaceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_primaryEmail',
              lower: [workspaceId],
              upper: [workspaceId, primaryEmail],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterWhereClause> workspaceIdEqualToAnyIsDeleted(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_isDeleted',
        value: [workspaceId],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterWhereClause> workspaceIdNotEqualToAnyIsDeleted(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_isDeleted',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_isDeleted',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_isDeleted',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_isDeleted',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdIsDeletedEqualTo(String workspaceId, bool isDeleted) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_isDeleted',
        value: [workspaceId, isDeleted],
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterWhereClause>
      workspaceIdEqualToIsDeletedNotEqualTo(
          String workspaceId, bool isDeleted) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_isDeleted',
              lower: [workspaceId],
              upper: [workspaceId, isDeleted],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_isDeleted',
              lower: [workspaceId, isDeleted],
              includeLower: false,
              upper: [workspaceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_isDeleted',
              lower: [workspaceId, isDeleted],
              includeLower: false,
              upper: [workspaceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_isDeleted',
              lower: [workspaceId],
              upper: [workspaceId, isDeleted],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LocalOrganizationModelQueryFilter on QueryBuilder<
    LocalOrganizationModel, LocalOrganizationModel, QFilterCondition> {
  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> deletedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> deletedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> deletedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deletedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> displayNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> legalNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'legalName',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> legalNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'legalName',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> legalNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> legalNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> legalNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> legalNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'legalName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> legalNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> legalNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      legalNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'legalName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      legalNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'legalName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> legalNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'legalName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> legalNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'legalName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> notesPrivateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notesPrivate',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> notesPrivateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notesPrivate',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> notesPrivateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notesPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> notesPrivateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notesPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> notesPrivateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notesPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> notesPrivateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notesPrivate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> notesPrivateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notesPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> notesPrivateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notesPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      notesPrivateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notesPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      notesPrivateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notesPrivate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> notesPrivateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notesPrivate',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> notesPrivateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notesPrivate',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryEmailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'primaryEmail',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryEmailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'primaryEmail',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryEmailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryEmailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primaryEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryEmailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primaryEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryEmailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primaryEmail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryEmailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'primaryEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryEmailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'primaryEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      primaryEmailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      primaryEmailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryEmail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryPhoneE164IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'primaryPhoneE164',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryPhoneE164IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'primaryPhoneE164',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryPhoneE164EqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryPhoneE164',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryPhoneE164GreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'primaryPhoneE164',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryPhoneE164LessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'primaryPhoneE164',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryPhoneE164Between(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'primaryPhoneE164',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryPhoneE164StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'primaryPhoneE164',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryPhoneE164EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'primaryPhoneE164',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      primaryPhoneE164Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryPhoneE164',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      primaryPhoneE164Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryPhoneE164',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryPhoneE164IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryPhoneE164',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> primaryPhoneE164IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryPhoneE164',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotAdoptedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'snapshotAdoptedAt',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotAdoptedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'snapshotAdoptedAt',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotAdoptedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snapshotAdoptedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotAdoptedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'snapshotAdoptedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotAdoptedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'snapshotAdoptedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotAdoptedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'snapshotAdoptedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotSourcePlatformActorIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'snapshotSourcePlatformActorId',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotSourcePlatformActorIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'snapshotSourcePlatformActorId',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotSourcePlatformActorIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snapshotSourcePlatformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotSourcePlatformActorIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'snapshotSourcePlatformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotSourcePlatformActorIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'snapshotSourcePlatformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotSourcePlatformActorIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'snapshotSourcePlatformActorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotSourcePlatformActorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'snapshotSourcePlatformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotSourcePlatformActorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'snapshotSourcePlatformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      snapshotSourcePlatformActorIdContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'snapshotSourcePlatformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      snapshotSourcePlatformActorIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'snapshotSourcePlatformActorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotSourcePlatformActorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snapshotSourcePlatformActorId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> snapshotSourcePlatformActorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'snapshotSourcePlatformActorId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagsPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tagsPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tagsPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tagsPrivate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tagsPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tagsPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      tagsPrivateElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tagsPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      tagsPrivateElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tagsPrivate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagsPrivate',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tagsPrivate',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagsPrivate',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagsPrivate',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagsPrivate',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagsPrivate',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagsPrivate',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> tagsPrivateLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tagsPrivate',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> taxIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxId',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> taxIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxId',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> taxIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> taxIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> taxIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> taxIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> taxIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> taxIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      taxIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      taxIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taxId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> taxIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> taxIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taxId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
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

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> websiteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'website',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> websiteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'website',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> websiteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'website',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> websiteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'website',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> websiteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'website',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> websiteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'website',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> websiteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'website',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> websiteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'website',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      websiteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'website',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      websiteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'website',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> websiteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'website',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> websiteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'website',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> workspaceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> workspaceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> workspaceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> workspaceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workspaceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> workspaceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> workspaceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      workspaceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
          QAfterFilterCondition>
      workspaceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workspaceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> workspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel,
      QAfterFilterCondition> workspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workspaceId',
        value: '',
      ));
    });
  }
}

extension LocalOrganizationModelQueryObject on QueryBuilder<
    LocalOrganizationModel, LocalOrganizationModel, QFilterCondition> {}

extension LocalOrganizationModelQueryLinks on QueryBuilder<
    LocalOrganizationModel, LocalOrganizationModel, QFilterCondition> {}

extension LocalOrganizationModelQuerySortBy
    on QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QSortBy> {
  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByLegalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legalName', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByLegalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legalName', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByNotesPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesPrivate', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByNotesPrivateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesPrivate', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByPrimaryEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryEmail', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByPrimaryEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryEmail', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByPrimaryPhoneE164() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryPhoneE164', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByPrimaryPhoneE164Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryPhoneE164', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortBySnapshotAdoptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotAdoptedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortBySnapshotAdoptedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotAdoptedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortBySnapshotSourcePlatformActorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotSourcePlatformActorId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortBySnapshotSourcePlatformActorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotSourcePlatformActorId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByTaxId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByTaxIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByWebsite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'website', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByWebsiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'website', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      sortByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension LocalOrganizationModelQuerySortThenBy on QueryBuilder<
    LocalOrganizationModel, LocalOrganizationModel, QSortThenBy> {
  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByLegalName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legalName', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByLegalNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legalName', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByNotesPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesPrivate', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByNotesPrivateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesPrivate', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByPrimaryEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryEmail', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByPrimaryEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryEmail', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByPrimaryPhoneE164() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryPhoneE164', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByPrimaryPhoneE164Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryPhoneE164', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenBySnapshotAdoptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotAdoptedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenBySnapshotAdoptedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotAdoptedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenBySnapshotSourcePlatformActorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotSourcePlatformActorId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenBySnapshotSourcePlatformActorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotSourcePlatformActorId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByTaxId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByTaxIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxId', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByWebsite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'website', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByWebsiteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'website', Sort.desc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QAfterSortBy>
      thenByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension LocalOrganizationModelQueryWhereDistinct
    on QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct> {
  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctByLegalName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'legalName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctByNotesPrivate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notesPrivate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctByPrimaryEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryEmail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctByPrimaryPhoneE164({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryPhoneE164',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctBySnapshotAdoptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snapshotAdoptedAt');
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctBySnapshotSourcePlatformActorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snapshotSourcePlatformActorId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctByTagsPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tagsPrivate');
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctByTaxId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctByWebsite({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'website', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalOrganizationModel, LocalOrganizationModel, QDistinct>
      distinctByWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workspaceId', caseSensitive: caseSensitive);
    });
  }
}

extension LocalOrganizationModelQueryProperty on QueryBuilder<
    LocalOrganizationModel, LocalOrganizationModel, QQueryProperty> {
  QueryBuilder<LocalOrganizationModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalOrganizationModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LocalOrganizationModel, DateTime?, QQueryOperations>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<LocalOrganizationModel, String, QQueryOperations>
      displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<LocalOrganizationModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalOrganizationModel, bool, QQueryOperations>
      isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<LocalOrganizationModel, String?, QQueryOperations>
      legalNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'legalName');
    });
  }

  QueryBuilder<LocalOrganizationModel, String?, QQueryOperations>
      notesPrivateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notesPrivate');
    });
  }

  QueryBuilder<LocalOrganizationModel, String?, QQueryOperations>
      primaryEmailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryEmail');
    });
  }

  QueryBuilder<LocalOrganizationModel, String?, QQueryOperations>
      primaryPhoneE164Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryPhoneE164');
    });
  }

  QueryBuilder<LocalOrganizationModel, DateTime?, QQueryOperations>
      snapshotAdoptedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snapshotAdoptedAt');
    });
  }

  QueryBuilder<LocalOrganizationModel, String?, QQueryOperations>
      snapshotSourcePlatformActorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snapshotSourcePlatformActorId');
    });
  }

  QueryBuilder<LocalOrganizationModel, List<String>, QQueryOperations>
      tagsPrivateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tagsPrivate');
    });
  }

  QueryBuilder<LocalOrganizationModel, String?, QQueryOperations>
      taxIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxId');
    });
  }

  QueryBuilder<LocalOrganizationModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<LocalOrganizationModel, String?, QQueryOperations>
      websiteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'website');
    });
  }

  QueryBuilder<LocalOrganizationModel, String, QQueryOperations>
      workspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workspaceId');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalOrganizationModel _$LocalOrganizationModelFromJson(
        Map<String, dynamic> json) =>
    LocalOrganizationModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      displayName: json['displayName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      legalName: json['legalName'] as String?,
      taxId: json['taxId'] as String?,
      primaryPhoneE164: json['primaryPhoneE164'] as String?,
      primaryEmail: json['primaryEmail'] as String?,
      website: json['website'] as String?,
      notesPrivate: json['notesPrivate'] as String?,
      tagsPrivate: (json['tagsPrivate'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      snapshotSourcePlatformActorId:
          json['snapshotSourcePlatformActorId'] as String?,
      snapshotAdoptedAt: json['snapshotAdoptedAt'] == null
          ? null
          : DateTime.parse(json['snapshotAdoptedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$LocalOrganizationModelToJson(
        LocalOrganizationModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'displayName': instance.displayName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'legalName': instance.legalName,
      'taxId': instance.taxId,
      'primaryPhoneE164': instance.primaryPhoneE164,
      'primaryEmail': instance.primaryEmail,
      'website': instance.website,
      'notesPrivate': instance.notesPrivate,
      'tagsPrivate': instance.tagsPrivate,
      'snapshotSourcePlatformActorId': instance.snapshotSourcePlatformActorId,
      'snapshotAdoptedAt': instance.snapshotAdoptedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
