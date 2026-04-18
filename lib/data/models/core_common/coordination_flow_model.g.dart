// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordination_flow_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCoordinationFlowModelCollection on Isar {
  IsarCollection<CoordinationFlowModel> get coordinationFlowModels =>
      this.collection();
}

const CoordinationFlowModelSchema = CollectionSchema(
  name: r'CoordinationFlowModel',
  id: 6399004663411972065,
  properties: {
    r'cancelledAt': PropertySchema(
      id: 0,
      name: r'cancelledAt',
      type: IsarType.dateTime,
    ),
    r'completedAt': PropertySchema(
      id: 1,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'flowKindWire': PropertySchema(
      id: 3,
      name: r'flowKindWire',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.string,
    ),
    r'relationshipId': PropertySchema(
      id: 5,
      name: r'relationshipId',
      type: IsarType.string,
    ),
    r'sourceWorkspaceId': PropertySchema(
      id: 6,
      name: r'sourceWorkspaceId',
      type: IsarType.string,
    ),
    r'startedAt': PropertySchema(
      id: 7,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'startedBy': PropertySchema(
      id: 8,
      name: r'startedBy',
      type: IsarType.string,
    ),
    r'statusUpdatedAt': PropertySchema(
      id: 9,
      name: r'statusUpdatedAt',
      type: IsarType.dateTime,
    ),
    r'statusWire': PropertySchema(
      id: 10,
      name: r'statusWire',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _coordinationFlowModelEstimateSize,
  serialize: _coordinationFlowModelSerialize,
  deserialize: _coordinationFlowModelDeserialize,
  deserializeProp: _coordinationFlowModelDeserializeProp,
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
    r'sourceWorkspaceId_statusWire': IndexSchema(
      id: -2578700836930620567,
      name: r'sourceWorkspaceId_statusWire',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sourceWorkspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'statusWire',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'relationshipId': IndexSchema(
      id: -8609994343672160716,
      name: r'relationshipId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'relationshipId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _coordinationFlowModelGetId,
  getLinks: _coordinationFlowModelGetLinks,
  attach: _coordinationFlowModelAttach,
  version: '3.3.0-dev.1',
);

int _coordinationFlowModelEstimateSize(
  CoordinationFlowModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.flowKindWire.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.relationshipId.length * 3;
  bytesCount += 3 + object.sourceWorkspaceId.length * 3;
  bytesCount += 3 + object.startedBy.length * 3;
  bytesCount += 3 + object.statusWire.length * 3;
  return bytesCount;
}

void _coordinationFlowModelSerialize(
  CoordinationFlowModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.cancelledAt);
  writer.writeDateTime(offsets[1], object.completedAt);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.flowKindWire);
  writer.writeString(offsets[4], object.id);
  writer.writeString(offsets[5], object.relationshipId);
  writer.writeString(offsets[6], object.sourceWorkspaceId);
  writer.writeDateTime(offsets[7], object.startedAt);
  writer.writeString(offsets[8], object.startedBy);
  writer.writeDateTime(offsets[9], object.statusUpdatedAt);
  writer.writeString(offsets[10], object.statusWire);
  writer.writeDateTime(offsets[11], object.updatedAt);
}

CoordinationFlowModel _coordinationFlowModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CoordinationFlowModel(
    cancelledAt: reader.readDateTimeOrNull(offsets[0]),
    completedAt: reader.readDateTimeOrNull(offsets[1]),
    createdAt: reader.readDateTime(offsets[2]),
    flowKindWire: reader.readStringOrNull(offsets[3]) ?? 'generic',
    id: reader.readString(offsets[4]),
    isarId: id,
    relationshipId: reader.readString(offsets[5]),
    sourceWorkspaceId: reader.readString(offsets[6]),
    startedAt: reader.readDateTimeOrNull(offsets[7]),
    startedBy: reader.readString(offsets[8]),
    statusUpdatedAt: reader.readDateTime(offsets[9]),
    statusWire: reader.readString(offsets[10]),
    updatedAt: reader.readDateTime(offsets[11]),
  );
  return object;
}

P _coordinationFlowModelDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset) ?? 'generic') as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _coordinationFlowModelGetId(CoordinationFlowModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _coordinationFlowModelGetLinks(
    CoordinationFlowModel object) {
  return [];
}

void _coordinationFlowModelAttach(
    IsarCollection<dynamic> col, Id id, CoordinationFlowModel object) {
  object.isarId = id;
}

extension CoordinationFlowModelByIndex
    on IsarCollection<CoordinationFlowModel> {
  Future<CoordinationFlowModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  CoordinationFlowModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<CoordinationFlowModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<CoordinationFlowModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(CoordinationFlowModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(CoordinationFlowModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<CoordinationFlowModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<CoordinationFlowModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension CoordinationFlowModelQueryWhereSort
    on QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QWhere> {
  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CoordinationFlowModelQueryWhere on QueryBuilder<CoordinationFlowModel,
    CoordinationFlowModel, QWhereClause> {
  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhereClause>
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhereClause>
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhereClause>
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhereClause>
      sourceWorkspaceIdEqualToAnyStatusWire(String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_statusWire',
        value: [sourceWorkspaceId],
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhereClause>
      sourceWorkspaceIdNotEqualToAnyStatusWire(String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_statusWire',
              lower: [],
              upper: [sourceWorkspaceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_statusWire',
              lower: [sourceWorkspaceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_statusWire',
              lower: [sourceWorkspaceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_statusWire',
              lower: [],
              upper: [sourceWorkspaceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhereClause>
      sourceWorkspaceIdStatusWireEqualTo(
          String sourceWorkspaceId, String statusWire) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_statusWire',
        value: [sourceWorkspaceId, statusWire],
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhereClause>
      sourceWorkspaceIdEqualToStatusWireNotEqualTo(
          String sourceWorkspaceId, String statusWire) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_statusWire',
              lower: [sourceWorkspaceId],
              upper: [sourceWorkspaceId, statusWire],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_statusWire',
              lower: [sourceWorkspaceId, statusWire],
              includeLower: false,
              upper: [sourceWorkspaceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_statusWire',
              lower: [sourceWorkspaceId, statusWire],
              includeLower: false,
              upper: [sourceWorkspaceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceWorkspaceId_statusWire',
              lower: [sourceWorkspaceId],
              upper: [sourceWorkspaceId, statusWire],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhereClause>
      relationshipIdEqualTo(String relationshipId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'relationshipId',
        value: [relationshipId],
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterWhereClause>
      relationshipIdNotEqualTo(String relationshipId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'relationshipId',
              lower: [],
              upper: [relationshipId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'relationshipId',
              lower: [relationshipId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'relationshipId',
              lower: [relationshipId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'relationshipId',
              lower: [],
              upper: [relationshipId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CoordinationFlowModelQueryFilter on QueryBuilder<
    CoordinationFlowModel, CoordinationFlowModel, QFilterCondition> {
  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> cancelledAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cancelledAt',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> cancelledAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cancelledAt',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> cancelledAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cancelledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> cancelledAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cancelledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> cancelledAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cancelledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> cancelledAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cancelledAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> flowKindWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flowKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> flowKindWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'flowKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> flowKindWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'flowKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> flowKindWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'flowKindWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> flowKindWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'flowKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> flowKindWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'flowKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
          QAfterFilterCondition>
      flowKindWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'flowKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
          QAfterFilterCondition>
      flowKindWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'flowKindWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> flowKindWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flowKindWire',
        value: '',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> flowKindWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'flowKindWire',
        value: '',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> relationshipIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relationshipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> relationshipIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relationshipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> relationshipIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relationshipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> relationshipIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relationshipId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> relationshipIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relationshipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> relationshipIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relationshipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
          QAfterFilterCondition>
      relationshipIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relationshipId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
          QAfterFilterCondition>
      relationshipIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relationshipId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> relationshipIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relationshipId',
        value: '',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> relationshipIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relationshipId',
        value: '',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> sourceWorkspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> sourceWorkspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startedAt',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startedAt',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedByEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startedBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'startedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'startedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
          QAfterFilterCondition>
      startedByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'startedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
          QAfterFilterCondition>
      startedByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'startedBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> startedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'startedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> statusUpdatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> statusUpdatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> statusUpdatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> statusUpdatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusUpdatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> statusWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> statusWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> statusWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> statusWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> statusWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'statusWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> statusWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'statusWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
          QAfterFilterCondition>
      statusWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statusWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
          QAfterFilterCondition>
      statusWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statusWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> statusWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusWire',
        value: '',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> statusWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statusWire',
        value: '',
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel,
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

extension CoordinationFlowModelQueryObject on QueryBuilder<
    CoordinationFlowModel, CoordinationFlowModel, QFilterCondition> {}

extension CoordinationFlowModelQueryLinks on QueryBuilder<CoordinationFlowModel,
    CoordinationFlowModel, QFilterCondition> {}

extension CoordinationFlowModelQuerySortBy
    on QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QSortBy> {
  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByCancelledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByFlowKindWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flowKindWire', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByFlowKindWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flowKindWire', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByRelationshipId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipId', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByRelationshipIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipId', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortBySourceWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortBySourceWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByStartedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedBy', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByStartedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedBy', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByStatusUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByStatusUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByStatusWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusWire', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByStatusWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusWire', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CoordinationFlowModelQuerySortThenBy
    on QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QSortThenBy> {
  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByCancelledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cancelledAt', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByFlowKindWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flowKindWire', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByFlowKindWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flowKindWire', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByRelationshipId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipId', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByRelationshipIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipId', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenBySourceWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenBySourceWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByStartedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedBy', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByStartedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedBy', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByStatusUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByStatusUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByStatusWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusWire', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByStatusWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusWire', Sort.desc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CoordinationFlowModelQueryWhereDistinct
    on QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QDistinct> {
  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QDistinct>
      distinctByCancelledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cancelledAt');
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QDistinct>
      distinctByFlowKindWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'flowKindWire', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QDistinct>
      distinctByRelationshipId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relationshipId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QDistinct>
      distinctBySourceWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceWorkspaceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QDistinct>
      distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QDistinct>
      distinctByStartedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QDistinct>
      distinctByStatusUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusUpdatedAt');
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QDistinct>
      distinctByStatusWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusWire', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CoordinationFlowModel, CoordinationFlowModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension CoordinationFlowModelQueryProperty on QueryBuilder<
    CoordinationFlowModel, CoordinationFlowModel, QQueryProperty> {
  QueryBuilder<CoordinationFlowModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<CoordinationFlowModel, DateTime?, QQueryOperations>
      cancelledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cancelledAt');
    });
  }

  QueryBuilder<CoordinationFlowModel, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<CoordinationFlowModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CoordinationFlowModel, String, QQueryOperations>
      flowKindWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flowKindWire');
    });
  }

  QueryBuilder<CoordinationFlowModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CoordinationFlowModel, String, QQueryOperations>
      relationshipIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relationshipId');
    });
  }

  QueryBuilder<CoordinationFlowModel, String, QQueryOperations>
      sourceWorkspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceWorkspaceId');
    });
  }

  QueryBuilder<CoordinationFlowModel, DateTime?, QQueryOperations>
      startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<CoordinationFlowModel, String, QQueryOperations>
      startedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedBy');
    });
  }

  QueryBuilder<CoordinationFlowModel, DateTime, QQueryOperations>
      statusUpdatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusUpdatedAt');
    });
  }

  QueryBuilder<CoordinationFlowModel, String, QQueryOperations>
      statusWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusWire');
    });
  }

  QueryBuilder<CoordinationFlowModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoordinationFlowModel _$CoordinationFlowModelFromJson(
        Map<String, dynamic> json) =>
    CoordinationFlowModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      sourceWorkspaceId: json['sourceWorkspaceId'] as String,
      relationshipId: json['relationshipId'] as String,
      startedBy: json['startedBy'] as String,
      flowKindWire: json['flowKindWire'] as String? ?? 'generic',
      statusWire: json['statusWire'] as String,
      statusUpdatedAt: DateTime.parse(json['statusUpdatedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      cancelledAt: json['cancelledAt'] == null
          ? null
          : DateTime.parse(json['cancelledAt'] as String),
    );

Map<String, dynamic> _$CoordinationFlowModelToJson(
        CoordinationFlowModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'sourceWorkspaceId': instance.sourceWorkspaceId,
      'relationshipId': instance.relationshipId,
      'startedBy': instance.startedBy,
      'flowKindWire': instance.flowKindWire,
      'statusWire': instance.statusWire,
      'statusUpdatedAt': instance.statusUpdatedAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
    };
