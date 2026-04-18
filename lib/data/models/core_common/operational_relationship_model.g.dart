// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operational_relationship_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOperationalRelationshipModelCollection on Isar {
  IsarCollection<OperationalRelationshipModel>
      get operationalRelationshipModels => this.collection();
}

const OperationalRelationshipModelSchema = CollectionSchema(
  name: r'OperationalRelationshipModel',
  id: 2469036291408243505,
  properties: {
    r'activatedUnilaterallyAt': PropertySchema(
      id: 0,
      name: r'activatedUnilaterallyAt',
      type: IsarType.dateTime,
    ),
    r'closedAt': PropertySchema(
      id: 1,
      name: r'closedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    ),
    r'lastInvitationId': PropertySchema(
      id: 4,
      name: r'lastInvitationId',
      type: IsarType.string,
    ),
    r'linkedAt': PropertySchema(
      id: 5,
      name: r'linkedAt',
      type: IsarType.dateTime,
    ),
    r'matchTrustLevelWire': PropertySchema(
      id: 6,
      name: r'matchTrustLevelWire',
      type: IsarType.string,
    ),
    r'relationshipKindWire': PropertySchema(
      id: 7,
      name: r'relationshipKindWire',
      type: IsarType.string,
    ),
    r'sourceWorkspaceId': PropertySchema(
      id: 8,
      name: r'sourceWorkspaceId',
      type: IsarType.string,
    ),
    r'stateUpdatedAt': PropertySchema(
      id: 9,
      name: r'stateUpdatedAt',
      type: IsarType.dateTime,
    ),
    r'stateWire': PropertySchema(
      id: 10,
      name: r'stateWire',
      type: IsarType.string,
    ),
    r'suspendedAt': PropertySchema(
      id: 11,
      name: r'suspendedAt',
      type: IsarType.dateTime,
    ),
    r'suspensionReasonWire': PropertySchema(
      id: 12,
      name: r'suspensionReasonWire',
      type: IsarType.string,
    ),
    r'targetLocalId': PropertySchema(
      id: 13,
      name: r'targetLocalId',
      type: IsarType.string,
    ),
    r'targetLocalKindWire': PropertySchema(
      id: 14,
      name: r'targetLocalKindWire',
      type: IsarType.string,
    ),
    r'targetPlatformActorId': PropertySchema(
      id: 15,
      name: r'targetPlatformActorId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 16,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _operationalRelationshipModelEstimateSize,
  serialize: _operationalRelationshipModelSerialize,
  deserialize: _operationalRelationshipModelDeserialize,
  deserializeProp: _operationalRelationshipModelDeserializeProp,
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
    r'sourceWorkspaceId_targetLocalKindWire_targetLocalId': IndexSchema(
      id: -6586682580569528064,
      name: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sourceWorkspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'targetLocalKindWire',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'targetLocalId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'sourceWorkspaceId_targetPlatformActorId': IndexSchema(
      id: 8910785949348362563,
      name: r'sourceWorkspaceId_targetPlatformActorId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sourceWorkspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'targetPlatformActorId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'sourceWorkspaceId_stateWire': IndexSchema(
      id: 6731002396722145745,
      name: r'sourceWorkspaceId_stateWire',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sourceWorkspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'stateWire',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _operationalRelationshipModelGetId,
  getLinks: _operationalRelationshipModelGetLinks,
  attach: _operationalRelationshipModelAttach,
  version: '3.3.0-dev.1',
);

int _operationalRelationshipModelEstimateSize(
  OperationalRelationshipModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.lastInvitationId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.matchTrustLevelWire;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.relationshipKindWire.length * 3;
  bytesCount += 3 + object.sourceWorkspaceId.length * 3;
  bytesCount += 3 + object.stateWire.length * 3;
  {
    final value = object.suspensionReasonWire;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.targetLocalId.length * 3;
  bytesCount += 3 + object.targetLocalKindWire.length * 3;
  {
    final value = object.targetPlatformActorId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _operationalRelationshipModelSerialize(
  OperationalRelationshipModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.activatedUnilaterallyAt);
  writer.writeDateTime(offsets[1], object.closedAt);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.id);
  writer.writeString(offsets[4], object.lastInvitationId);
  writer.writeDateTime(offsets[5], object.linkedAt);
  writer.writeString(offsets[6], object.matchTrustLevelWire);
  writer.writeString(offsets[7], object.relationshipKindWire);
  writer.writeString(offsets[8], object.sourceWorkspaceId);
  writer.writeDateTime(offsets[9], object.stateUpdatedAt);
  writer.writeString(offsets[10], object.stateWire);
  writer.writeDateTime(offsets[11], object.suspendedAt);
  writer.writeString(offsets[12], object.suspensionReasonWire);
  writer.writeString(offsets[13], object.targetLocalId);
  writer.writeString(offsets[14], object.targetLocalKindWire);
  writer.writeString(offsets[15], object.targetPlatformActorId);
  writer.writeDateTime(offsets[16], object.updatedAt);
}

OperationalRelationshipModel _operationalRelationshipModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OperationalRelationshipModel(
    activatedUnilaterallyAt: reader.readDateTimeOrNull(offsets[0]),
    closedAt: reader.readDateTimeOrNull(offsets[1]),
    createdAt: reader.readDateTime(offsets[2]),
    id: reader.readString(offsets[3]),
    isarId: id,
    lastInvitationId: reader.readStringOrNull(offsets[4]),
    linkedAt: reader.readDateTimeOrNull(offsets[5]),
    matchTrustLevelWire: reader.readStringOrNull(offsets[6]),
    relationshipKindWire: reader.readStringOrNull(offsets[7]) ?? 'generic',
    sourceWorkspaceId: reader.readString(offsets[8]),
    stateUpdatedAt: reader.readDateTime(offsets[9]),
    stateWire: reader.readString(offsets[10]),
    suspendedAt: reader.readDateTimeOrNull(offsets[11]),
    suspensionReasonWire: reader.readStringOrNull(offsets[12]),
    targetLocalId: reader.readString(offsets[13]),
    targetLocalKindWire: reader.readString(offsets[14]),
    targetPlatformActorId: reader.readStringOrNull(offsets[15]),
    updatedAt: reader.readDateTime(offsets[16]),
  );
  return object;
}

P _operationalRelationshipModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? 'generic') as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _operationalRelationshipModelGetId(OperationalRelationshipModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _operationalRelationshipModelGetLinks(
    OperationalRelationshipModel object) {
  return [];
}

void _operationalRelationshipModelAttach(
    IsarCollection<dynamic> col, Id id, OperationalRelationshipModel object) {
  object.isarId = id;
}

extension OperationalRelationshipModelByIndex
    on IsarCollection<OperationalRelationshipModel> {
  Future<OperationalRelationshipModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  OperationalRelationshipModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<OperationalRelationshipModel?>> getAllById(
      List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<OperationalRelationshipModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(OperationalRelationshipModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(OperationalRelationshipModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<OperationalRelationshipModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<OperationalRelationshipModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension OperationalRelationshipModelQueryWhereSort on QueryBuilder<
    OperationalRelationshipModel, OperationalRelationshipModel, QWhere> {
  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OperationalRelationshipModelQueryWhere on QueryBuilder<
    OperationalRelationshipModel, OperationalRelationshipModel, QWhereClause> {
  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterWhereClause> idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdEqualToAnyTargetLocalKindWireTargetLocalId(
          String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
        value: [sourceWorkspaceId],
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdNotEqualToAnyTargetLocalKindWireTargetLocalId(
          String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
              lower: [],
              upper: [sourceWorkspaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
              lower: [sourceWorkspaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
              lower: [sourceWorkspaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
              lower: [],
              upper: [sourceWorkspaceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdTargetLocalKindWireEqualToAnyTargetLocalId(
          String sourceWorkspaceId, String targetLocalKindWire) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
        value: [sourceWorkspaceId, targetLocalKindWire],
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdEqualToTargetLocalKindWireNotEqualToAnyTargetLocalId(
          String sourceWorkspaceId, String targetLocalKindWire) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
              lower: [sourceWorkspaceId],
              upper: [sourceWorkspaceId, targetLocalKindWire],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
              lower: [sourceWorkspaceId, targetLocalKindWire],
              includeLower: false,
              upper: [sourceWorkspaceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
              lower: [sourceWorkspaceId, targetLocalKindWire],
              includeLower: false,
              upper: [sourceWorkspaceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
              lower: [sourceWorkspaceId],
              upper: [sourceWorkspaceId, targetLocalKindWire],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdTargetLocalKindWireTargetLocalIdEqualTo(
          String sourceWorkspaceId,
          String targetLocalKindWire,
          String targetLocalId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
        value: [sourceWorkspaceId, targetLocalKindWire, targetLocalId],
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdTargetLocalKindWireEqualToTargetLocalIdNotEqualTo(
          String sourceWorkspaceId,
          String targetLocalKindWire,
          String targetLocalId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
              lower: [sourceWorkspaceId, targetLocalKindWire],
              upper: [sourceWorkspaceId, targetLocalKindWire, targetLocalId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
              lower: [sourceWorkspaceId, targetLocalKindWire, targetLocalId],
              includeLower: false,
              upper: [sourceWorkspaceId, targetLocalKindWire],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
              lower: [sourceWorkspaceId, targetLocalKindWire, targetLocalId],
              includeLower: false,
              upper: [sourceWorkspaceId, targetLocalKindWire],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetLocalKindWire_targetLocalId',
              lower: [sourceWorkspaceId, targetLocalKindWire],
              upper: [sourceWorkspaceId, targetLocalKindWire, targetLocalId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdEqualToAnyTargetPlatformActorId(
          String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_targetPlatformActorId',
        value: [sourceWorkspaceId],
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdNotEqualToAnyTargetPlatformActorId(
          String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetPlatformActorId',
              lower: [],
              upper: [sourceWorkspaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetPlatformActorId',
              lower: [sourceWorkspaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetPlatformActorId',
              lower: [sourceWorkspaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetPlatformActorId',
              lower: [],
              upper: [sourceWorkspaceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdEqualToTargetPlatformActorIdIsNull(
          String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_targetPlatformActorId',
        value: [sourceWorkspaceId, null],
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdEqualToTargetPlatformActorIdIsNotNull(
          String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceWorkspaceId_targetPlatformActorId',
        lower: [sourceWorkspaceId, null],
        includeLower: false,
        upper: [
          sourceWorkspaceId,
        ],
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdTargetPlatformActorIdEqualTo(
          String sourceWorkspaceId, String? targetPlatformActorId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_targetPlatformActorId',
        value: [sourceWorkspaceId, targetPlatformActorId],
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdEqualToTargetPlatformActorIdNotEqualTo(
          String sourceWorkspaceId, String? targetPlatformActorId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetPlatformActorId',
              lower: [sourceWorkspaceId],
              upper: [sourceWorkspaceId, targetPlatformActorId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetPlatformActorId',
              lower: [sourceWorkspaceId, targetPlatformActorId],
              includeLower: false,
              upper: [sourceWorkspaceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetPlatformActorId',
              lower: [sourceWorkspaceId, targetPlatformActorId],
              includeLower: false,
              upper: [sourceWorkspaceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_targetPlatformActorId',
              lower: [sourceWorkspaceId],
              upper: [sourceWorkspaceId, targetPlatformActorId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdEqualToAnyStateWire(String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_stateWire',
        value: [sourceWorkspaceId],
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdNotEqualToAnyStateWire(String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_stateWire',
              lower: [],
              upper: [sourceWorkspaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_stateWire',
              lower: [sourceWorkspaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_stateWire',
              lower: [sourceWorkspaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_stateWire',
              lower: [],
              upper: [sourceWorkspaceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdStateWireEqualTo(
          String sourceWorkspaceId, String stateWire) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_stateWire',
        value: [sourceWorkspaceId, stateWire],
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterWhereClause>
      sourceWorkspaceIdEqualToStateWireNotEqualTo(
          String sourceWorkspaceId, String stateWire) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_stateWire',
              lower: [sourceWorkspaceId],
              upper: [sourceWorkspaceId, stateWire],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_stateWire',
              lower: [sourceWorkspaceId, stateWire],
              includeLower: false,
              upper: [sourceWorkspaceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_stateWire',
              lower: [sourceWorkspaceId, stateWire],
              includeLower: false,
              upper: [sourceWorkspaceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_stateWire',
              lower: [sourceWorkspaceId],
              upper: [sourceWorkspaceId, stateWire],
              includeUpper: false,
            ));
      }
    });
  }
}

extension OperationalRelationshipModelQueryFilter on QueryBuilder<
    OperationalRelationshipModel,
    OperationalRelationshipModel,
    QFilterCondition> {
  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> activatedUnilaterallyAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activatedUnilaterallyAt',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> activatedUnilaterallyAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activatedUnilaterallyAt',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> activatedUnilaterallyAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activatedUnilaterallyAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> activatedUnilaterallyAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activatedUnilaterallyAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> activatedUnilaterallyAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activatedUnilaterallyAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> activatedUnilaterallyAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activatedUnilaterallyAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> closedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'closedAt',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> closedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'closedAt',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> closedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'closedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> closedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'closedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> closedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'closedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> closedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'closedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> lastInvitationIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastInvitationId',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> lastInvitationIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastInvitationId',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> lastInvitationIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastInvitationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> lastInvitationIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastInvitationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> lastInvitationIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastInvitationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> lastInvitationIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastInvitationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> lastInvitationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastInvitationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> lastInvitationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastInvitationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      lastInvitationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastInvitationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      lastInvitationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastInvitationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> lastInvitationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastInvitationId',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> lastInvitationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastInvitationId',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> linkedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'linkedAt',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> linkedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'linkedAt',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> linkedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> linkedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'linkedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> linkedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'linkedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> linkedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'linkedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> matchTrustLevelWireIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'matchTrustLevelWire',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> matchTrustLevelWireIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'matchTrustLevelWire',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> matchTrustLevelWireEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matchTrustLevelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> matchTrustLevelWireGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matchTrustLevelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> matchTrustLevelWireLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matchTrustLevelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> matchTrustLevelWireBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matchTrustLevelWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> matchTrustLevelWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'matchTrustLevelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> matchTrustLevelWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'matchTrustLevelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      matchTrustLevelWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'matchTrustLevelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      matchTrustLevelWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'matchTrustLevelWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> matchTrustLevelWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matchTrustLevelWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> matchTrustLevelWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'matchTrustLevelWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> relationshipKindWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relationshipKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> relationshipKindWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relationshipKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> relationshipKindWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relationshipKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> relationshipKindWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relationshipKindWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> relationshipKindWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relationshipKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> relationshipKindWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relationshipKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      relationshipKindWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relationshipKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      relationshipKindWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relationshipKindWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> relationshipKindWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relationshipKindWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> relationshipKindWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relationshipKindWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> sourceWorkspaceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> sourceWorkspaceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> sourceWorkspaceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> sourceWorkspaceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceWorkspaceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> sourceWorkspaceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> sourceWorkspaceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      sourceWorkspaceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      sourceWorkspaceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceWorkspaceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> sourceWorkspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> sourceWorkspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> stateUpdatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> stateUpdatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stateUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> stateUpdatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stateUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> stateUpdatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stateUpdatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> stateWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> stateWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stateWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> stateWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stateWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> stateWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stateWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> stateWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stateWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> stateWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stateWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      stateWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stateWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      stateWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stateWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> stateWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> stateWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stateWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspendedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'suspendedAt',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspendedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'suspendedAt',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspendedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'suspendedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspendedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'suspendedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspendedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'suspendedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspendedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'suspendedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspensionReasonWireIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'suspensionReasonWire',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspensionReasonWireIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'suspensionReasonWire',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspensionReasonWireEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'suspensionReasonWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspensionReasonWireGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'suspensionReasonWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspensionReasonWireLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'suspensionReasonWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspensionReasonWireBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'suspensionReasonWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspensionReasonWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'suspensionReasonWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspensionReasonWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'suspensionReasonWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      suspensionReasonWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'suspensionReasonWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      suspensionReasonWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'suspensionReasonWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspensionReasonWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'suspensionReasonWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> suspensionReasonWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'suspensionReasonWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetLocalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetLocalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetLocalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetLocalId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetLocalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetLocalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      targetLocalIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetLocalId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      targetLocalIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetLocalId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetLocalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetLocalId',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalKindWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetLocalKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalKindWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetLocalKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalKindWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetLocalKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalKindWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetLocalKindWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalKindWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetLocalKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalKindWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetLocalKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      targetLocalKindWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetLocalKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      targetLocalKindWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetLocalKindWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalKindWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetLocalKindWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetLocalKindWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetLocalKindWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetPlatformActorIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetPlatformActorId',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetPlatformActorIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetPlatformActorId',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetPlatformActorIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetPlatformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetPlatformActorIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetPlatformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetPlatformActorIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetPlatformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetPlatformActorIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetPlatformActorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetPlatformActorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetPlatformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetPlatformActorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetPlatformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      targetPlatformActorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetPlatformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
          QAfterFilterCondition>
      targetPlatformActorIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetPlatformActorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetPlatformActorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetPlatformActorId',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> targetPlatformActorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetPlatformActorId',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
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

extension OperationalRelationshipModelQueryObject on QueryBuilder<
    OperationalRelationshipModel,
    OperationalRelationshipModel,
    QFilterCondition> {}

extension OperationalRelationshipModelQueryLinks on QueryBuilder<
    OperationalRelationshipModel,
    OperationalRelationshipModel,
    QFilterCondition> {}

extension OperationalRelationshipModelQuerySortBy on QueryBuilder<
    OperationalRelationshipModel, OperationalRelationshipModel, QSortBy> {
  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByActivatedUnilaterallyAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activatedUnilaterallyAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByActivatedUnilaterallyAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activatedUnilaterallyAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByClosedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByLastInvitationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInvitationId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByLastInvitationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInvitationId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByLinkedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByLinkedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByMatchTrustLevelWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchTrustLevelWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByMatchTrustLevelWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchTrustLevelWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByRelationshipKindWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipKindWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByRelationshipKindWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipKindWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortBySourceWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortBySourceWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByStateUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByStateUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByStateWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByStateWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortBySuspendedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suspendedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortBySuspendedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suspendedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortBySuspensionReasonWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suspensionReasonWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortBySuspensionReasonWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suspensionReasonWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByTargetLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetLocalId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByTargetLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetLocalId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByTargetLocalKindWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetLocalKindWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByTargetLocalKindWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetLocalKindWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByTargetPlatformActorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetPlatformActorId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByTargetPlatformActorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetPlatformActorId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension OperationalRelationshipModelQuerySortThenBy on QueryBuilder<
    OperationalRelationshipModel, OperationalRelationshipModel, QSortThenBy> {
  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByActivatedUnilaterallyAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activatedUnilaterallyAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByActivatedUnilaterallyAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activatedUnilaterallyAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByClosedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByLastInvitationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInvitationId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByLastInvitationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastInvitationId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByLinkedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByLinkedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByMatchTrustLevelWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchTrustLevelWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByMatchTrustLevelWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchTrustLevelWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByRelationshipKindWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipKindWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByRelationshipKindWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipKindWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenBySourceWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenBySourceWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByStateUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByStateUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByStateWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByStateWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenBySuspendedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suspendedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenBySuspendedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suspendedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenBySuspensionReasonWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suspensionReasonWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenBySuspensionReasonWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suspensionReasonWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByTargetLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetLocalId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByTargetLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetLocalId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByTargetLocalKindWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetLocalKindWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByTargetLocalKindWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetLocalKindWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByTargetPlatformActorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetPlatformActorId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByTargetPlatformActorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetPlatformActorId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension OperationalRelationshipModelQueryWhereDistinct on QueryBuilder<
    OperationalRelationshipModel, OperationalRelationshipModel, QDistinct> {
  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctByActivatedUnilaterallyAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activatedUnilaterallyAt');
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'closedAt');
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctByLastInvitationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastInvitationId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctByLinkedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linkedAt');
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctByMatchTrustLevelWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matchTrustLevelWire',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctByRelationshipKindWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relationshipKindWire',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctBySourceWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceWorkspaceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctByStateUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateUpdatedAt');
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctByStateWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateWire', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctBySuspendedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'suspendedAt');
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctBySuspensionReasonWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'suspensionReasonWire',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctByTargetLocalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetLocalId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctByTargetLocalKindWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetLocalKindWire',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctByTargetPlatformActorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetPlatformActorId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRelationshipModel, OperationalRelationshipModel,
      QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension OperationalRelationshipModelQueryProperty on QueryBuilder<
    OperationalRelationshipModel,
    OperationalRelationshipModel,
    QQueryProperty> {
  QueryBuilder<OperationalRelationshipModel, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<OperationalRelationshipModel, DateTime?, QQueryOperations>
      activatedUnilaterallyAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activatedUnilaterallyAt');
    });
  }

  QueryBuilder<OperationalRelationshipModel, DateTime?, QQueryOperations>
      closedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closedAt');
    });
  }

  QueryBuilder<OperationalRelationshipModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OperationalRelationshipModel, String, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OperationalRelationshipModel, String?, QQueryOperations>
      lastInvitationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastInvitationId');
    });
  }

  QueryBuilder<OperationalRelationshipModel, DateTime?, QQueryOperations>
      linkedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkedAt');
    });
  }

  QueryBuilder<OperationalRelationshipModel, String?, QQueryOperations>
      matchTrustLevelWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matchTrustLevelWire');
    });
  }

  QueryBuilder<OperationalRelationshipModel, String, QQueryOperations>
      relationshipKindWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relationshipKindWire');
    });
  }

  QueryBuilder<OperationalRelationshipModel, String, QQueryOperations>
      sourceWorkspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceWorkspaceId');
    });
  }

  QueryBuilder<OperationalRelationshipModel, DateTime, QQueryOperations>
      stateUpdatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateUpdatedAt');
    });
  }

  QueryBuilder<OperationalRelationshipModel, String, QQueryOperations>
      stateWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateWire');
    });
  }

  QueryBuilder<OperationalRelationshipModel, DateTime?, QQueryOperations>
      suspendedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'suspendedAt');
    });
  }

  QueryBuilder<OperationalRelationshipModel, String?, QQueryOperations>
      suspensionReasonWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'suspensionReasonWire');
    });
  }

  QueryBuilder<OperationalRelationshipModel, String, QQueryOperations>
      targetLocalIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetLocalId');
    });
  }

  QueryBuilder<OperationalRelationshipModel, String, QQueryOperations>
      targetLocalKindWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetLocalKindWire');
    });
  }

  QueryBuilder<OperationalRelationshipModel, String?, QQueryOperations>
      targetPlatformActorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetPlatformActorId');
    });
  }

  QueryBuilder<OperationalRelationshipModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationalRelationshipModel _$OperationalRelationshipModelFromJson(
        Map<String, dynamic> json) =>
    OperationalRelationshipModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      sourceWorkspaceId: json['sourceWorkspaceId'] as String,
      targetLocalKindWire: json['targetLocalKindWire'] as String,
      targetLocalId: json['targetLocalId'] as String,
      stateWire: json['stateWire'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      stateUpdatedAt: DateTime.parse(json['stateUpdatedAt'] as String),
      relationshipKindWire:
          json['relationshipKindWire'] as String? ?? 'generic',
      targetPlatformActorId: json['targetPlatformActorId'] as String?,
      matchTrustLevelWire: json['matchTrustLevelWire'] as String?,
      suspensionReasonWire: json['suspensionReasonWire'] as String?,
      activatedUnilaterallyAt: json['activatedUnilaterallyAt'] == null
          ? null
          : DateTime.parse(json['activatedUnilaterallyAt'] as String),
      linkedAt: json['linkedAt'] == null
          ? null
          : DateTime.parse(json['linkedAt'] as String),
      suspendedAt: json['suspendedAt'] == null
          ? null
          : DateTime.parse(json['suspendedAt'] as String),
      closedAt: json['closedAt'] == null
          ? null
          : DateTime.parse(json['closedAt'] as String),
      lastInvitationId: json['lastInvitationId'] as String?,
    );

Map<String, dynamic> _$OperationalRelationshipModelToJson(
        OperationalRelationshipModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'sourceWorkspaceId': instance.sourceWorkspaceId,
      'targetLocalKindWire': instance.targetLocalKindWire,
      'targetLocalId': instance.targetLocalId,
      'stateWire': instance.stateWire,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'stateUpdatedAt': instance.stateUpdatedAt.toIso8601String(),
      'relationshipKindWire': instance.relationshipKindWire,
      'targetPlatformActorId': instance.targetPlatformActorId,
      'matchTrustLevelWire': instance.matchTrustLevelWire,
      'suspensionReasonWire': instance.suspensionReasonWire,
      'activatedUnilaterallyAt':
          instance.activatedUnilaterallyAt?.toIso8601String(),
      'linkedAt': instance.linkedAt?.toIso8601String(),
      'suspendedAt': instance.suspendedAt?.toIso8601String(),
      'closedAt': instance.closedAt?.toIso8601String(),
      'lastInvitationId': instance.lastInvitationId,
    };
