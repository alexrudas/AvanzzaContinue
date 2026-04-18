// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_contact_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalContactModelCollection on Isar {
  IsarCollection<LocalContactModel> get localContactModels => this.collection();
}

const LocalContactModelSchema = CollectionSchema(
  name: r'LocalContactModel',
  id: -1867106818189807675,
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
    r'docId': PropertySchema(
      id: 3,
      name: r'docId',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.string,
    ),
    r'isDeleted': PropertySchema(
      id: 5,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'notesPrivate': PropertySchema(
      id: 6,
      name: r'notesPrivate',
      type: IsarType.string,
    ),
    r'organizationId': PropertySchema(
      id: 7,
      name: r'organizationId',
      type: IsarType.string,
    ),
    r'primaryEmail': PropertySchema(
      id: 8,
      name: r'primaryEmail',
      type: IsarType.string,
    ),
    r'primaryPhoneE164': PropertySchema(
      id: 9,
      name: r'primaryPhoneE164',
      type: IsarType.string,
    ),
    r'roleLabel': PropertySchema(
      id: 10,
      name: r'roleLabel',
      type: IsarType.string,
    ),
    r'snapshotAdoptedAt': PropertySchema(
      id: 11,
      name: r'snapshotAdoptedAt',
      type: IsarType.dateTime,
    ),
    r'snapshotSourcePlatformActorId': PropertySchema(
      id: 12,
      name: r'snapshotSourcePlatformActorId',
      type: IsarType.string,
    ),
    r'tagsPrivate': PropertySchema(
      id: 13,
      name: r'tagsPrivate',
      type: IsarType.stringList,
    ),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'workspaceId': PropertySchema(
      id: 15,
      name: r'workspaceId',
      type: IsarType.string,
    )
  },
  estimateSize: _localContactModelEstimateSize,
  serialize: _localContactModelSerialize,
  deserialize: _localContactModelDeserialize,
  deserializeProp: _localContactModelDeserializeProp,
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
    r'workspaceId_docId': IndexSchema(
      id: 5685840189180795002,
      name: r'workspaceId_docId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'workspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'docId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'workspaceId_organizationId': IndexSchema(
      id: -3543738048786310893,
      name: r'workspaceId_organizationId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'workspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'organizationId',
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
  getId: _localContactModelGetId,
  getLinks: _localContactModelGetLinks,
  attach: _localContactModelAttach,
  version: '3.3.0-dev.1',
);

int _localContactModelEstimateSize(
  LocalContactModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.displayName.length * 3;
  {
    final value = object.docId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.notesPrivate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.organizationId;
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
    final value = object.roleLabel;
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
  bytesCount += 3 + object.workspaceId.length * 3;
  return bytesCount;
}

void _localContactModelSerialize(
  LocalContactModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDateTime(offsets[1], object.deletedAt);
  writer.writeString(offsets[2], object.displayName);
  writer.writeString(offsets[3], object.docId);
  writer.writeString(offsets[4], object.id);
  writer.writeBool(offsets[5], object.isDeleted);
  writer.writeString(offsets[6], object.notesPrivate);
  writer.writeString(offsets[7], object.organizationId);
  writer.writeString(offsets[8], object.primaryEmail);
  writer.writeString(offsets[9], object.primaryPhoneE164);
  writer.writeString(offsets[10], object.roleLabel);
  writer.writeDateTime(offsets[11], object.snapshotAdoptedAt);
  writer.writeString(offsets[12], object.snapshotSourcePlatformActorId);
  writer.writeStringList(offsets[13], object.tagsPrivate);
  writer.writeDateTime(offsets[14], object.updatedAt);
  writer.writeString(offsets[15], object.workspaceId);
}

LocalContactModel _localContactModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalContactModel(
    createdAt: reader.readDateTime(offsets[0]),
    deletedAt: reader.readDateTimeOrNull(offsets[1]),
    displayName: reader.readString(offsets[2]),
    docId: reader.readStringOrNull(offsets[3]),
    id: reader.readString(offsets[4]),
    isDeleted: reader.readBoolOrNull(offsets[5]) ?? false,
    isarId: id,
    notesPrivate: reader.readStringOrNull(offsets[6]),
    organizationId: reader.readStringOrNull(offsets[7]),
    primaryEmail: reader.readStringOrNull(offsets[8]),
    primaryPhoneE164: reader.readStringOrNull(offsets[9]),
    roleLabel: reader.readStringOrNull(offsets[10]),
    snapshotAdoptedAt: reader.readDateTimeOrNull(offsets[11]),
    snapshotSourcePlatformActorId: reader.readStringOrNull(offsets[12]),
    tagsPrivate: reader.readStringList(offsets[13]) ?? const <String>[],
    updatedAt: reader.readDateTime(offsets[14]),
    workspaceId: reader.readString(offsets[15]),
  );
  return object;
}

P _localContactModelDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringList(offset) ?? const <String>[]) as P;
    case 14:
      return (reader.readDateTime(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localContactModelGetId(LocalContactModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _localContactModelGetLinks(
    LocalContactModel object) {
  return [];
}

void _localContactModelAttach(
    IsarCollection<dynamic> col, Id id, LocalContactModel object) {
  object.isarId = id;
}

extension LocalContactModelByIndex on IsarCollection<LocalContactModel> {
  Future<LocalContactModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  LocalContactModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<LocalContactModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<LocalContactModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(LocalContactModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(LocalContactModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<LocalContactModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<LocalContactModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension LocalContactModelQueryWhereSort
    on QueryBuilder<LocalContactModel, LocalContactModel, QWhere> {
  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalContactModelQueryWhere
    on QueryBuilder<LocalContactModel, LocalContactModel, QWhereClause> {
  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdEqualToAnyPrimaryPhoneE164(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_primaryPhoneE164',
        value: [workspaceId],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdEqualToPrimaryPhoneE164IsNull(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_primaryPhoneE164',
        value: [workspaceId, null],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdPrimaryPhoneE164EqualTo(
          String workspaceId, String? primaryPhoneE164) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_primaryPhoneE164',
        value: [workspaceId, primaryPhoneE164],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdEqualToAnyPrimaryEmail(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_primaryEmail',
        value: [workspaceId],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdEqualToPrimaryEmailIsNull(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_primaryEmail',
        value: [workspaceId, null],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdPrimaryEmailEqualTo(String workspaceId, String? primaryEmail) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_primaryEmail',
        value: [workspaceId, primaryEmail],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdEqualToAnyDocId(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_docId',
        value: [workspaceId],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdNotEqualToAnyDocId(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_docId',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_docId',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_docId',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_docId',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdEqualToDocIdIsNull(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_docId',
        value: [workspaceId, null],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdEqualToDocIdIsNotNull(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'workspaceId_docId',
        lower: [workspaceId, null],
        includeLower: false,
        upper: [
          workspaceId,
        ],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdDocIdEqualTo(String workspaceId, String? docId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_docId',
        value: [workspaceId, docId],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdEqualToDocIdNotEqualTo(String workspaceId, String? docId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_docId',
              lower: [workspaceId],
              upper: [workspaceId, docId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_docId',
              lower: [workspaceId, docId],
              includeLower: false,
              upper: [workspaceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_docId',
              lower: [workspaceId, docId],
              includeLower: false,
              upper: [workspaceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_docId',
              lower: [workspaceId],
              upper: [workspaceId, docId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdEqualToAnyOrganizationId(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_organizationId',
        value: [workspaceId],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdNotEqualToAnyOrganizationId(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_organizationId',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_organizationId',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_organizationId',
              lower: [workspaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_organizationId',
              lower: [],
              upper: [workspaceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdEqualToOrganizationIdIsNull(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_organizationId',
        value: [workspaceId, null],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdEqualToOrganizationIdIsNotNull(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'workspaceId_organizationId',
        lower: [workspaceId, null],
        includeLower: false,
        upper: [
          workspaceId,
        ],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdOrganizationIdEqualTo(
          String workspaceId, String? organizationId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_organizationId',
        value: [workspaceId, organizationId],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdEqualToOrganizationIdNotEqualTo(
          String workspaceId, String? organizationId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_organizationId',
              lower: [workspaceId],
              upper: [workspaceId, organizationId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_organizationId',
              lower: [workspaceId, organizationId],
              includeLower: false,
              upper: [workspaceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_organizationId',
              lower: [workspaceId, organizationId],
              includeLower: false,
              upper: [workspaceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'workspaceId_organizationId',
              lower: [workspaceId],
              upper: [workspaceId, organizationId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdEqualToAnyIsDeleted(String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_isDeleted',
        value: [workspaceId],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdNotEqualToAnyIsDeleted(String workspaceId) {
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
      workspaceIdIsDeletedEqualTo(String workspaceId, bool isDeleted) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'workspaceId_isDeleted',
        value: [workspaceId, isDeleted],
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterWhereClause>
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

extension LocalContactModelQueryFilter
    on QueryBuilder<LocalContactModel, LocalContactModel, QFilterCondition> {
  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      deletedAtGreaterThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      deletedAtLessThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      deletedAtBetween(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      displayNameEqualTo(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      displayNameGreaterThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      displayNameLessThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      displayNameBetween(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      displayNameStartsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      displayNameEndsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      docIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'docId',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      docIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'docId',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      docIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'docId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      docIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'docId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      docIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'docId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      docIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'docId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      docIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'docId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      docIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'docId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      docIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'docId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      docIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'docId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      docIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'docId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      docIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'docId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      idEqualTo(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      idStartsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      idEndsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      notesPrivateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notesPrivate',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      notesPrivateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notesPrivate',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      notesPrivateEqualTo(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      notesPrivateGreaterThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      notesPrivateLessThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      notesPrivateBetween(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      notesPrivateStartsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      notesPrivateEndsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      notesPrivateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notesPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      notesPrivateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notesPrivate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      notesPrivateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notesPrivate',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      notesPrivateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notesPrivate',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      organizationIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'organizationId',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      organizationIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'organizationId',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      organizationIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'organizationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      organizationIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'organizationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      organizationIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'organizationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      organizationIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'organizationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      organizationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'organizationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      organizationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'organizationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      organizationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'organizationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      organizationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'organizationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      organizationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'organizationId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      organizationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'organizationId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryEmailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'primaryEmail',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryEmailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'primaryEmail',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryEmailEqualTo(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryEmailGreaterThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryEmailLessThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryEmailBetween(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryEmailStartsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryEmailEndsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryEmailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryEmailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryEmail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryPhoneE164IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'primaryPhoneE164',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryPhoneE164IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'primaryPhoneE164',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryPhoneE164EqualTo(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryPhoneE164GreaterThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryPhoneE164LessThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryPhoneE164Between(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryPhoneE164StartsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryPhoneE164EndsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryPhoneE164Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'primaryPhoneE164',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryPhoneE164Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'primaryPhoneE164',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryPhoneE164IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'primaryPhoneE164',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      primaryPhoneE164IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'primaryPhoneE164',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      roleLabelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'roleLabel',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      roleLabelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'roleLabel',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      roleLabelEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roleLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      roleLabelGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'roleLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      roleLabelLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'roleLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      roleLabelBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'roleLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      roleLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'roleLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      roleLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'roleLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      roleLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'roleLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      roleLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'roleLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      roleLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roleLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      roleLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'roleLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotAdoptedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'snapshotAdoptedAt',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotAdoptedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'snapshotAdoptedAt',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotAdoptedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snapshotAdoptedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotAdoptedAtGreaterThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotAdoptedAtLessThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotAdoptedAtBetween(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotSourcePlatformActorIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'snapshotSourcePlatformActorId',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotSourcePlatformActorIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'snapshotSourcePlatformActorId',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotSourcePlatformActorIdEqualTo(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotSourcePlatformActorIdGreaterThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotSourcePlatformActorIdLessThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotSourcePlatformActorIdBetween(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotSourcePlatformActorIdStartsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotSourcePlatformActorIdEndsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotSourcePlatformActorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snapshotSourcePlatformActorId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      snapshotSourcePlatformActorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'snapshotSourcePlatformActorId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateElementEqualTo(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateElementGreaterThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateElementLessThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateElementBetween(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateElementStartsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateElementEndsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tagsPrivate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tagsPrivate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagsPrivate',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tagsPrivate',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateLengthEqualTo(int length) {
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateIsEmpty() {
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateIsNotEmpty() {
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateLengthLessThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateLengthGreaterThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      tagsPrivateLengthBetween(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      updatedAtGreaterThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      updatedAtBetween(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      workspaceIdEqualTo(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      workspaceIdGreaterThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      workspaceIdLessThan(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      workspaceIdBetween(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      workspaceIdStartsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      workspaceIdEndsWith(
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

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      workspaceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      workspaceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workspaceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      workspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterFilterCondition>
      workspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workspaceId',
        value: '',
      ));
    });
  }
}

extension LocalContactModelQueryObject
    on QueryBuilder<LocalContactModel, LocalContactModel, QFilterCondition> {}

extension LocalContactModelQueryLinks
    on QueryBuilder<LocalContactModel, LocalContactModel, QFilterCondition> {}

extension LocalContactModelQuerySortBy
    on QueryBuilder<LocalContactModel, LocalContactModel, QSortBy> {
  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByDocId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docId', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByDocIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docId', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByNotesPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesPrivate', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByNotesPrivateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesPrivate', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByOrganizationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organizationId', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByOrganizationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organizationId', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByPrimaryEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryEmail', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByPrimaryEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryEmail', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByPrimaryPhoneE164() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryPhoneE164', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByPrimaryPhoneE164Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryPhoneE164', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByRoleLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleLabel', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByRoleLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleLabel', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortBySnapshotAdoptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotAdoptedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortBySnapshotAdoptedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotAdoptedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortBySnapshotSourcePlatformActorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotSourcePlatformActorId', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortBySnapshotSourcePlatformActorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotSourcePlatformActorId', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      sortByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension LocalContactModelQuerySortThenBy
    on QueryBuilder<LocalContactModel, LocalContactModel, QSortThenBy> {
  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByDocId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docId', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByDocIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'docId', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByNotesPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesPrivate', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByNotesPrivateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesPrivate', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByOrganizationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organizationId', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByOrganizationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'organizationId', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByPrimaryEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryEmail', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByPrimaryEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryEmail', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByPrimaryPhoneE164() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryPhoneE164', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByPrimaryPhoneE164Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'primaryPhoneE164', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByRoleLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleLabel', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByRoleLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleLabel', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenBySnapshotAdoptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotAdoptedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenBySnapshotAdoptedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotAdoptedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenBySnapshotSourcePlatformActorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotSourcePlatformActorId', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenBySnapshotSourcePlatformActorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snapshotSourcePlatformActorId', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QAfterSortBy>
      thenByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension LocalContactModelQueryWhereDistinct
    on QueryBuilder<LocalContactModel, LocalContactModel, QDistinct> {
  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct> distinctByDocId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'docId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctByNotesPrivate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notesPrivate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctByOrganizationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'organizationId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctByPrimaryEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryEmail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctByPrimaryPhoneE164({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'primaryPhoneE164',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctByRoleLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'roleLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctBySnapshotAdoptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snapshotAdoptedAt');
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctBySnapshotSourcePlatformActorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snapshotSourcePlatformActorId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctByTagsPrivate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tagsPrivate');
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<LocalContactModel, LocalContactModel, QDistinct>
      distinctByWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workspaceId', caseSensitive: caseSensitive);
    });
  }
}

extension LocalContactModelQueryProperty
    on QueryBuilder<LocalContactModel, LocalContactModel, QQueryProperty> {
  QueryBuilder<LocalContactModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<LocalContactModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LocalContactModel, DateTime?, QQueryOperations>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<LocalContactModel, String, QQueryOperations>
      displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<LocalContactModel, String?, QQueryOperations> docIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'docId');
    });
  }

  QueryBuilder<LocalContactModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalContactModel, bool, QQueryOperations> isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<LocalContactModel, String?, QQueryOperations>
      notesPrivateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notesPrivate');
    });
  }

  QueryBuilder<LocalContactModel, String?, QQueryOperations>
      organizationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'organizationId');
    });
  }

  QueryBuilder<LocalContactModel, String?, QQueryOperations>
      primaryEmailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryEmail');
    });
  }

  QueryBuilder<LocalContactModel, String?, QQueryOperations>
      primaryPhoneE164Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'primaryPhoneE164');
    });
  }

  QueryBuilder<LocalContactModel, String?, QQueryOperations>
      roleLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'roleLabel');
    });
  }

  QueryBuilder<LocalContactModel, DateTime?, QQueryOperations>
      snapshotAdoptedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snapshotAdoptedAt');
    });
  }

  QueryBuilder<LocalContactModel, String?, QQueryOperations>
      snapshotSourcePlatformActorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snapshotSourcePlatformActorId');
    });
  }

  QueryBuilder<LocalContactModel, List<String>, QQueryOperations>
      tagsPrivateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tagsPrivate');
    });
  }

  QueryBuilder<LocalContactModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<LocalContactModel, String, QQueryOperations>
      workspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workspaceId');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalContactModel _$LocalContactModelFromJson(Map<String, dynamic> json) =>
    LocalContactModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      displayName: json['displayName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      organizationId: json['organizationId'] as String?,
      roleLabel: json['roleLabel'] as String?,
      primaryPhoneE164: json['primaryPhoneE164'] as String?,
      primaryEmail: json['primaryEmail'] as String?,
      docId: json['docId'] as String?,
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

Map<String, dynamic> _$LocalContactModelToJson(LocalContactModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'displayName': instance.displayName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'organizationId': instance.organizationId,
      'roleLabel': instance.roleLabel,
      'primaryPhoneE164': instance.primaryPhoneE164,
      'primaryEmail': instance.primaryEmail,
      'docId': instance.docId,
      'notesPrivate': instance.notesPrivate,
      'tagsPrivate': instance.tagsPrivate,
      'snapshotSourcePlatformActorId': instance.snapshotSourcePlatformActorId,
      'snapshotAdoptedAt': instance.snapshotAdoptedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
