// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_candidate_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMatchCandidateModelCollection on Isar {
  IsarCollection<MatchCandidateModel> get matchCandidateModels =>
      this.collection();
}

const MatchCandidateModelSchema = CollectionSchema(
  name: r'MatchCandidateModel',
  id: 3535536358090122656,
  properties: {
    r'collisionKindWires': PropertySchema(
      id: 0,
      name: r'collisionKindWires',
      type: IsarType.stringList,
    ),
    r'confirmedAt': PropertySchema(
      id: 1,
      name: r'confirmedAt',
      type: IsarType.dateTime,
    ),
    r'detectedAt': PropertySchema(
      id: 2,
      name: r'detectedAt',
      type: IsarType.dateTime,
    ),
    r'dismissedAt': PropertySchema(
      id: 3,
      name: r'dismissedAt',
      type: IsarType.dateTime,
    ),
    r'exposedAt': PropertySchema(
      id: 4,
      name: r'exposedAt',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 5,
      name: r'id',
      type: IsarType.string,
    ),
    r'isConflictMarked': PropertySchema(
      id: 6,
      name: r'isConflictMarked',
      type: IsarType.bool,
    ),
    r'isCriticalConflict': PropertySchema(
      id: 7,
      name: r'isCriticalConflict',
      type: IsarType.bool,
    ),
    r'localId': PropertySchema(
      id: 8,
      name: r'localId',
      type: IsarType.string,
    ),
    r'localKindWire': PropertySchema(
      id: 9,
      name: r'localKindWire',
      type: IsarType.string,
    ),
    r'matchedKeyTypeWire': PropertySchema(
      id: 10,
      name: r'matchedKeyTypeWire',
      type: IsarType.string,
    ),
    r'matchedKeyValue': PropertySchema(
      id: 11,
      name: r'matchedKeyValue',
      type: IsarType.string,
    ),
    r'platformActorId': PropertySchema(
      id: 12,
      name: r'platformActorId',
      type: IsarType.string,
    ),
    r'resultingRelationshipId': PropertySchema(
      id: 13,
      name: r'resultingRelationshipId',
      type: IsarType.string,
    ),
    r'sourceWorkspaceId': PropertySchema(
      id: 14,
      name: r'sourceWorkspaceId',
      type: IsarType.string,
    ),
    r'stateWire': PropertySchema(
      id: 15,
      name: r'stateWire',
      type: IsarType.string,
    ),
    r'trustLevelWire': PropertySchema(
      id: 16,
      name: r'trustLevelWire',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 17,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _matchCandidateModelEstimateSize,
  serialize: _matchCandidateModelSerialize,
  deserialize: _matchCandidateModelDeserialize,
  deserializeProp: _matchCandidateModelDeserializeProp,
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
    ),
    r'sourceWorkspaceId_isConflictMarked': IndexSchema(
      id: -1069347423731508857,
      name: r'sourceWorkspaceId_isConflictMarked',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sourceWorkspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'isConflictMarked',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'sourceWorkspaceId_localKind_localId': IndexSchema(
      id: 9077198515796657005,
      name: r'sourceWorkspaceId_localKind_localId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sourceWorkspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'localKindWire',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'localId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _matchCandidateModelGetId,
  getLinks: _matchCandidateModelGetLinks,
  attach: _matchCandidateModelAttach,
  version: '3.3.0-dev.1',
);

int _matchCandidateModelEstimateSize(
  MatchCandidateModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.collisionKindWires.length * 3;
  {
    for (var i = 0; i < object.collisionKindWires.length; i++) {
      final value = object.collisionKindWires[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.localId.length * 3;
  bytesCount += 3 + object.localKindWire.length * 3;
  bytesCount += 3 + object.matchedKeyTypeWire.length * 3;
  bytesCount += 3 + object.matchedKeyValue.length * 3;
  bytesCount += 3 + object.platformActorId.length * 3;
  {
    final value = object.resultingRelationshipId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sourceWorkspaceId.length * 3;
  bytesCount += 3 + object.stateWire.length * 3;
  bytesCount += 3 + object.trustLevelWire.length * 3;
  return bytesCount;
}

void _matchCandidateModelSerialize(
  MatchCandidateModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.collisionKindWires);
  writer.writeDateTime(offsets[1], object.confirmedAt);
  writer.writeDateTime(offsets[2], object.detectedAt);
  writer.writeDateTime(offsets[3], object.dismissedAt);
  writer.writeDateTime(offsets[4], object.exposedAt);
  writer.writeString(offsets[5], object.id);
  writer.writeBool(offsets[6], object.isConflictMarked);
  writer.writeBool(offsets[7], object.isCriticalConflict);
  writer.writeString(offsets[8], object.localId);
  writer.writeString(offsets[9], object.localKindWire);
  writer.writeString(offsets[10], object.matchedKeyTypeWire);
  writer.writeString(offsets[11], object.matchedKeyValue);
  writer.writeString(offsets[12], object.platformActorId);
  writer.writeString(offsets[13], object.resultingRelationshipId);
  writer.writeString(offsets[14], object.sourceWorkspaceId);
  writer.writeString(offsets[15], object.stateWire);
  writer.writeString(offsets[16], object.trustLevelWire);
  writer.writeDateTime(offsets[17], object.updatedAt);
}

MatchCandidateModel _matchCandidateModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MatchCandidateModel(
    collisionKindWires: reader.readStringList(offsets[0]) ?? const <String>[],
    confirmedAt: reader.readDateTimeOrNull(offsets[1]),
    detectedAt: reader.readDateTime(offsets[2]),
    dismissedAt: reader.readDateTimeOrNull(offsets[3]),
    exposedAt: reader.readDateTimeOrNull(offsets[4]),
    id: reader.readString(offsets[5]),
    isConflictMarked: reader.readBoolOrNull(offsets[6]) ?? false,
    isCriticalConflict: reader.readBoolOrNull(offsets[7]) ?? false,
    isarId: id,
    localId: reader.readString(offsets[8]),
    localKindWire: reader.readString(offsets[9]),
    matchedKeyTypeWire: reader.readString(offsets[10]),
    matchedKeyValue: reader.readString(offsets[11]),
    platformActorId: reader.readString(offsets[12]),
    resultingRelationshipId: reader.readStringOrNull(offsets[13]),
    sourceWorkspaceId: reader.readString(offsets[14]),
    stateWire: reader.readString(offsets[15]),
    trustLevelWire: reader.readString(offsets[16]),
    updatedAt: reader.readDateTime(offsets[17]),
  );
  return object;
}

P _matchCandidateModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? const <String>[]) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 7:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _matchCandidateModelGetId(MatchCandidateModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _matchCandidateModelGetLinks(
    MatchCandidateModel object) {
  return [];
}

void _matchCandidateModelAttach(
    IsarCollection<dynamic> col, Id id, MatchCandidateModel object) {
  object.isarId = id;
}

extension MatchCandidateModelByIndex on IsarCollection<MatchCandidateModel> {
  Future<MatchCandidateModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  MatchCandidateModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<MatchCandidateModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<MatchCandidateModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(MatchCandidateModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(MatchCandidateModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<MatchCandidateModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<MatchCandidateModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension MatchCandidateModelQueryWhereSort
    on QueryBuilder<MatchCandidateModel, MatchCandidateModel, QWhere> {
  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MatchCandidateModelQueryWhere
    on QueryBuilder<MatchCandidateModel, MatchCandidateModel, QWhereClause> {
  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      sourceWorkspaceIdEqualToAnyStateWire(String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_stateWire',
        value: [sourceWorkspaceId],
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      sourceWorkspaceIdStateWireEqualTo(
          String sourceWorkspaceId, String stateWire) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_stateWire',
        value: [sourceWorkspaceId, stateWire],
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      sourceWorkspaceIdEqualToAnyIsConflictMarked(String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_isConflictMarked',
        value: [sourceWorkspaceId],
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      sourceWorkspaceIdNotEqualToAnyIsConflictMarked(String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_isConflictMarked',
              lower: [],
              upper: [sourceWorkspaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_isConflictMarked',
              lower: [sourceWorkspaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_isConflictMarked',
              lower: [sourceWorkspaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_isConflictMarked',
              lower: [],
              upper: [sourceWorkspaceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      sourceWorkspaceIdIsConflictMarkedEqualTo(
          String sourceWorkspaceId, bool isConflictMarked) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_isConflictMarked',
        value: [sourceWorkspaceId, isConflictMarked],
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      sourceWorkspaceIdEqualToIsConflictMarkedNotEqualTo(
          String sourceWorkspaceId, bool isConflictMarked) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_isConflictMarked',
              lower: [sourceWorkspaceId],
              upper: [sourceWorkspaceId, isConflictMarked],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_isConflictMarked',
              lower: [sourceWorkspaceId, isConflictMarked],
              includeLower: false,
              upper: [sourceWorkspaceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_isConflictMarked',
              lower: [sourceWorkspaceId, isConflictMarked],
              includeLower: false,
              upper: [sourceWorkspaceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_isConflictMarked',
              lower: [sourceWorkspaceId],
              upper: [sourceWorkspaceId, isConflictMarked],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      sourceWorkspaceIdEqualToAnyLocalKindWireLocalId(
          String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_localKind_localId',
        value: [sourceWorkspaceId],
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      sourceWorkspaceIdNotEqualToAnyLocalKindWireLocalId(
          String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_localKind_localId',
              lower: [],
              upper: [sourceWorkspaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_localKind_localId',
              lower: [sourceWorkspaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_localKind_localId',
              lower: [sourceWorkspaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_localKind_localId',
              lower: [],
              upper: [sourceWorkspaceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      sourceWorkspaceIdLocalKindWireEqualToAnyLocalId(
          String sourceWorkspaceId, String localKindWire) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_localKind_localId',
        value: [sourceWorkspaceId, localKindWire],
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      sourceWorkspaceIdEqualToLocalKindWireNotEqualToAnyLocalId(
          String sourceWorkspaceId, String localKindWire) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_localKind_localId',
              lower: [sourceWorkspaceId],
              upper: [sourceWorkspaceId, localKindWire],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_localKind_localId',
              lower: [sourceWorkspaceId, localKindWire],
              includeLower: false,
              upper: [sourceWorkspaceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_localKind_localId',
              lower: [sourceWorkspaceId, localKindWire],
              includeLower: false,
              upper: [sourceWorkspaceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_localKind_localId',
              lower: [sourceWorkspaceId],
              upper: [sourceWorkspaceId, localKindWire],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      sourceWorkspaceIdLocalKindWireLocalIdEqualTo(
          String sourceWorkspaceId, String localKindWire, String localId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_localKind_localId',
        value: [sourceWorkspaceId, localKindWire, localId],
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterWhereClause>
      sourceWorkspaceIdLocalKindWireEqualToLocalIdNotEqualTo(
          String sourceWorkspaceId, String localKindWire, String localId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_localKind_localId',
              lower: [sourceWorkspaceId, localKindWire],
              upper: [sourceWorkspaceId, localKindWire, localId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_localKind_localId',
              lower: [sourceWorkspaceId, localKindWire, localId],
              includeLower: false,
              upper: [sourceWorkspaceId, localKindWire],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_localKind_localId',
              lower: [sourceWorkspaceId, localKindWire, localId],
              includeLower: false,
              upper: [sourceWorkspaceId, localKindWire],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_localKind_localId',
              lower: [sourceWorkspaceId, localKindWire],
              upper: [sourceWorkspaceId, localKindWire, localId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MatchCandidateModelQueryFilter on QueryBuilder<MatchCandidateModel,
    MatchCandidateModel, QFilterCondition> {
  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'collisionKindWires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'collisionKindWires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'collisionKindWires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'collisionKindWires',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'collisionKindWires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'collisionKindWires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'collisionKindWires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'collisionKindWires',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'collisionKindWires',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'collisionKindWires',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collisionKindWires',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collisionKindWires',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collisionKindWires',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collisionKindWires',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collisionKindWires',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      collisionKindWiresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collisionKindWires',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      confirmedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'confirmedAt',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      confirmedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'confirmedAt',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      confirmedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      confirmedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      confirmedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confirmedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      confirmedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confirmedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      detectedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'detectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      detectedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'detectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      detectedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'detectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      detectedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'detectedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      dismissedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dismissedAt',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      dismissedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dismissedAt',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      dismissedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dismissedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      dismissedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dismissedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      dismissedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dismissedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      dismissedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dismissedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      exposedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exposedAt',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      exposedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exposedAt',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      exposedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exposedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      exposedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exposedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      exposedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exposedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      exposedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exposedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      isConflictMarkedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isConflictMarked',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      isCriticalConflictEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCriticalConflict',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'localId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'localId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'localId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'localId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localId',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'localId',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localKindWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localKindWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localKindWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localKindWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localKindWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localKindWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'localKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localKindWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'localKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localKindWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'localKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localKindWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'localKindWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localKindWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localKindWire',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      localKindWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'localKindWire',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyTypeWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matchedKeyTypeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyTypeWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matchedKeyTypeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyTypeWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matchedKeyTypeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyTypeWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matchedKeyTypeWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyTypeWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'matchedKeyTypeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyTypeWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'matchedKeyTypeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyTypeWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'matchedKeyTypeWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyTypeWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'matchedKeyTypeWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyTypeWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matchedKeyTypeWire',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyTypeWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'matchedKeyTypeWire',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyValueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matchedKeyValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyValueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'matchedKeyValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyValueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'matchedKeyValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyValueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'matchedKeyValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyValueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'matchedKeyValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyValueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'matchedKeyValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyValueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'matchedKeyValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyValueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'matchedKeyValue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyValueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'matchedKeyValue',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      matchedKeyValueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'matchedKeyValue',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      platformActorIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'platformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      platformActorIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'platformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      platformActorIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'platformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      platformActorIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'platformActorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      platformActorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'platformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      platformActorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'platformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      platformActorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'platformActorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      platformActorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'platformActorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      platformActorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'platformActorId',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      platformActorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'platformActorId',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      resultingRelationshipIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'resultingRelationshipId',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      resultingRelationshipIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'resultingRelationshipId',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      resultingRelationshipIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resultingRelationshipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      resultingRelationshipIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resultingRelationshipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      resultingRelationshipIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resultingRelationshipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      resultingRelationshipIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resultingRelationshipId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      resultingRelationshipIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'resultingRelationshipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      resultingRelationshipIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'resultingRelationshipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      resultingRelationshipIdContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'resultingRelationshipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      resultingRelationshipIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'resultingRelationshipId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      resultingRelationshipIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resultingRelationshipId',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      resultingRelationshipIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'resultingRelationshipId',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      sourceWorkspaceIdEqualTo(
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      sourceWorkspaceIdGreaterThan(
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      sourceWorkspaceIdLessThan(
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      sourceWorkspaceIdBetween(
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      sourceWorkspaceIdStartsWith(
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      sourceWorkspaceIdEndsWith(
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      sourceWorkspaceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      sourceWorkspaceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceWorkspaceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      sourceWorkspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      sourceWorkspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      stateWireEqualTo(
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      stateWireGreaterThan(
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      stateWireLessThan(
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      stateWireBetween(
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      stateWireStartsWith(
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      stateWireEndsWith(
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      stateWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stateWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      stateWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stateWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      stateWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateWire',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      stateWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stateWire',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      trustLevelWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trustLevelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      trustLevelWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trustLevelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      trustLevelWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trustLevelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      trustLevelWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trustLevelWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      trustLevelWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'trustLevelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      trustLevelWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'trustLevelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      trustLevelWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'trustLevelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      trustLevelWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'trustLevelWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      trustLevelWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trustLevelWire',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      trustLevelWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'trustLevelWire',
        value: '',
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
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

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterFilterCondition>
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
}

extension MatchCandidateModelQueryObject on QueryBuilder<MatchCandidateModel,
    MatchCandidateModel, QFilterCondition> {}

extension MatchCandidateModelQueryLinks on QueryBuilder<MatchCandidateModel,
    MatchCandidateModel, QFilterCondition> {}

extension MatchCandidateModelQuerySortBy
    on QueryBuilder<MatchCandidateModel, MatchCandidateModel, QSortBy> {
  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedAt', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedAt', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByDetectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedAt', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByDetectedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedAt', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByDismissedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedAt', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByDismissedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedAt', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByExposedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exposedAt', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByExposedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exposedAt', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByIsConflictMarked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConflictMarked', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByIsConflictMarkedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConflictMarked', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByIsCriticalConflict() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCriticalConflict', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByIsCriticalConflictDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCriticalConflict', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByLocalKindWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localKindWire', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByLocalKindWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localKindWire', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByMatchedKeyTypeWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchedKeyTypeWire', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByMatchedKeyTypeWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchedKeyTypeWire', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByMatchedKeyValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchedKeyValue', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByMatchedKeyValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchedKeyValue', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByPlatformActorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformActorId', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByPlatformActorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformActorId', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByResultingRelationshipId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultingRelationshipId', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByResultingRelationshipIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultingRelationshipId', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortBySourceWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortBySourceWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByStateWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateWire', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByStateWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateWire', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByTrustLevelWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trustLevelWire', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByTrustLevelWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trustLevelWire', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MatchCandidateModelQuerySortThenBy
    on QueryBuilder<MatchCandidateModel, MatchCandidateModel, QSortThenBy> {
  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedAt', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByConfirmedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confirmedAt', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByDetectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedAt', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByDetectedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedAt', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByDismissedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedAt', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByDismissedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissedAt', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByExposedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exposedAt', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByExposedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exposedAt', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByIsConflictMarked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConflictMarked', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByIsConflictMarkedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isConflictMarked', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByIsCriticalConflict() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCriticalConflict', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByIsCriticalConflictDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCriticalConflict', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByLocalKindWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localKindWire', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByLocalKindWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localKindWire', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByMatchedKeyTypeWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchedKeyTypeWire', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByMatchedKeyTypeWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchedKeyTypeWire', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByMatchedKeyValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchedKeyValue', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByMatchedKeyValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'matchedKeyValue', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByPlatformActorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformActorId', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByPlatformActorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platformActorId', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByResultingRelationshipId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultingRelationshipId', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByResultingRelationshipIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultingRelationshipId', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenBySourceWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenBySourceWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByStateWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateWire', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByStateWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateWire', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByTrustLevelWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trustLevelWire', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByTrustLevelWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trustLevelWire', Sort.desc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MatchCandidateModelQueryWhereDistinct
    on QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct> {
  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByCollisionKindWires() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'collisionKindWires');
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByConfirmedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confirmedAt');
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByDetectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'detectedAt');
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByDismissedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dismissedAt');
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByExposedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exposedAt');
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByIsConflictMarked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isConflictMarked');
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByIsCriticalConflict() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCriticalConflict');
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByLocalId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByLocalKindWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localKindWire',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByMatchedKeyTypeWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matchedKeyTypeWire',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByMatchedKeyValue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'matchedKeyValue',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByPlatformActorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'platformActorId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByResultingRelationshipId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resultingRelationshipId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctBySourceWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceWorkspaceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByStateWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateWire', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByTrustLevelWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trustLevelWire',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MatchCandidateModel, MatchCandidateModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension MatchCandidateModelQueryProperty
    on QueryBuilder<MatchCandidateModel, MatchCandidateModel, QQueryProperty> {
  QueryBuilder<MatchCandidateModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<MatchCandidateModel, List<String>, QQueryOperations>
      collisionKindWiresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'collisionKindWires');
    });
  }

  QueryBuilder<MatchCandidateModel, DateTime?, QQueryOperations>
      confirmedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confirmedAt');
    });
  }

  QueryBuilder<MatchCandidateModel, DateTime, QQueryOperations>
      detectedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'detectedAt');
    });
  }

  QueryBuilder<MatchCandidateModel, DateTime?, QQueryOperations>
      dismissedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dismissedAt');
    });
  }

  QueryBuilder<MatchCandidateModel, DateTime?, QQueryOperations>
      exposedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exposedAt');
    });
  }

  QueryBuilder<MatchCandidateModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MatchCandidateModel, bool, QQueryOperations>
      isConflictMarkedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isConflictMarked');
    });
  }

  QueryBuilder<MatchCandidateModel, bool, QQueryOperations>
      isCriticalConflictProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCriticalConflict');
    });
  }

  QueryBuilder<MatchCandidateModel, String, QQueryOperations>
      localIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localId');
    });
  }

  QueryBuilder<MatchCandidateModel, String, QQueryOperations>
      localKindWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localKindWire');
    });
  }

  QueryBuilder<MatchCandidateModel, String, QQueryOperations>
      matchedKeyTypeWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matchedKeyTypeWire');
    });
  }

  QueryBuilder<MatchCandidateModel, String, QQueryOperations>
      matchedKeyValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'matchedKeyValue');
    });
  }

  QueryBuilder<MatchCandidateModel, String, QQueryOperations>
      platformActorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'platformActorId');
    });
  }

  QueryBuilder<MatchCandidateModel, String?, QQueryOperations>
      resultingRelationshipIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resultingRelationshipId');
    });
  }

  QueryBuilder<MatchCandidateModel, String, QQueryOperations>
      sourceWorkspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceWorkspaceId');
    });
  }

  QueryBuilder<MatchCandidateModel, String, QQueryOperations>
      stateWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateWire');
    });
  }

  QueryBuilder<MatchCandidateModel, String, QQueryOperations>
      trustLevelWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trustLevelWire');
    });
  }

  QueryBuilder<MatchCandidateModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchCandidateModel _$MatchCandidateModelFromJson(Map<String, dynamic> json) =>
    MatchCandidateModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      sourceWorkspaceId: json['sourceWorkspaceId'] as String,
      localKindWire: json['localKindWire'] as String,
      localId: json['localId'] as String,
      platformActorId: json['platformActorId'] as String,
      matchedKeyTypeWire: json['matchedKeyTypeWire'] as String,
      matchedKeyValue: json['matchedKeyValue'] as String,
      trustLevelWire: json['trustLevelWire'] as String,
      stateWire: json['stateWire'] as String,
      detectedAt: DateTime.parse(json['detectedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      exposedAt: json['exposedAt'] == null
          ? null
          : DateTime.parse(json['exposedAt'] as String),
      dismissedAt: json['dismissedAt'] == null
          ? null
          : DateTime.parse(json['dismissedAt'] as String),
      confirmedAt: json['confirmedAt'] == null
          ? null
          : DateTime.parse(json['confirmedAt'] as String),
      resultingRelationshipId: json['resultingRelationshipId'] as String?,
      collisionKindWires: (json['collisionKindWires'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      isConflictMarked: json['isConflictMarked'] as bool? ?? false,
      isCriticalConflict: json['isCriticalConflict'] as bool? ?? false,
    );

Map<String, dynamic> _$MatchCandidateModelToJson(
        MatchCandidateModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'sourceWorkspaceId': instance.sourceWorkspaceId,
      'localKindWire': instance.localKindWire,
      'localId': instance.localId,
      'platformActorId': instance.platformActorId,
      'matchedKeyTypeWire': instance.matchedKeyTypeWire,
      'matchedKeyValue': instance.matchedKeyValue,
      'trustLevelWire': instance.trustLevelWire,
      'stateWire': instance.stateWire,
      'detectedAt': instance.detectedAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'exposedAt': instance.exposedAt?.toIso8601String(),
      'dismissedAt': instance.dismissedAt?.toIso8601String(),
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
      'resultingRelationshipId': instance.resultingRelationshipId,
      'collisionKindWires': instance.collisionKindWires,
      'isConflictMarked': instance.isConflictMarked,
      'isCriticalConflict': instance.isCriticalConflict,
    };
