// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operational_request_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOperationalRequestModelCollection on Isar {
  IsarCollection<OperationalRequestModel> get operationalRequestModels =>
      this.collection();
}

const OperationalRequestModelSchema = CollectionSchema(
  name: r'OperationalRequestModel',
  id: -7430730376770901559,
  properties: {
    r'closedAt': PropertySchema(
      id: 0,
      name: r'closedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdBy': PropertySchema(
      id: 2,
      name: r'createdBy',
      type: IsarType.string,
    ),
    r'expiresAt': PropertySchema(
      id: 3,
      name: r'expiresAt',
      type: IsarType.dateTime,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.string,
    ),
    r'notesSource': PropertySchema(
      id: 5,
      name: r'notesSource',
      type: IsarType.string,
    ),
    r'originChannelWire': PropertySchema(
      id: 6,
      name: r'originChannelWire',
      type: IsarType.string,
    ),
    r'payloadJson': PropertySchema(
      id: 7,
      name: r'payloadJson',
      type: IsarType.string,
    ),
    r'relationshipId': PropertySchema(
      id: 8,
      name: r'relationshipId',
      type: IsarType.string,
    ),
    r'requestKindWire': PropertySchema(
      id: 9,
      name: r'requestKindWire',
      type: IsarType.string,
    ),
    r'respondedAt': PropertySchema(
      id: 10,
      name: r'respondedAt',
      type: IsarType.dateTime,
    ),
    r'sentAt': PropertySchema(
      id: 11,
      name: r'sentAt',
      type: IsarType.dateTime,
    ),
    r'sourceWorkspaceId': PropertySchema(
      id: 12,
      name: r'sourceWorkspaceId',
      type: IsarType.string,
    ),
    r'stateUpdatedAt': PropertySchema(
      id: 13,
      name: r'stateUpdatedAt',
      type: IsarType.dateTime,
    ),
    r'stateWire': PropertySchema(
      id: 14,
      name: r'stateWire',
      type: IsarType.string,
    ),
    r'summary': PropertySchema(
      id: 15,
      name: r'summary',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 16,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 17,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _operationalRequestModelEstimateSize,
  serialize: _operationalRequestModelSerialize,
  deserialize: _operationalRequestModelDeserialize,
  deserializeProp: _operationalRequestModelDeserializeProp,
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
  getId: _operationalRequestModelGetId,
  getLinks: _operationalRequestModelGetLinks,
  attach: _operationalRequestModelAttach,
  version: '3.3.0-dev.1',
);

int _operationalRequestModelEstimateSize(
  OperationalRequestModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.createdBy.length * 3;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.notesSource;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.originChannelWire.length * 3;
  {
    final value = object.payloadJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.relationshipId.length * 3;
  bytesCount += 3 + object.requestKindWire.length * 3;
  bytesCount += 3 + object.sourceWorkspaceId.length * 3;
  bytesCount += 3 + object.stateWire.length * 3;
  {
    final value = object.summary;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _operationalRequestModelSerialize(
  OperationalRequestModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.closedAt);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.createdBy);
  writer.writeDateTime(offsets[3], object.expiresAt);
  writer.writeString(offsets[4], object.id);
  writer.writeString(offsets[5], object.notesSource);
  writer.writeString(offsets[6], object.originChannelWire);
  writer.writeString(offsets[7], object.payloadJson);
  writer.writeString(offsets[8], object.relationshipId);
  writer.writeString(offsets[9], object.requestKindWire);
  writer.writeDateTime(offsets[10], object.respondedAt);
  writer.writeDateTime(offsets[11], object.sentAt);
  writer.writeString(offsets[12], object.sourceWorkspaceId);
  writer.writeDateTime(offsets[13], object.stateUpdatedAt);
  writer.writeString(offsets[14], object.stateWire);
  writer.writeString(offsets[15], object.summary);
  writer.writeString(offsets[16], object.title);
  writer.writeDateTime(offsets[17], object.updatedAt);
}

OperationalRequestModel _operationalRequestModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OperationalRequestModel(
    closedAt: reader.readDateTimeOrNull(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    createdBy: reader.readString(offsets[2]),
    expiresAt: reader.readDateTimeOrNull(offsets[3]),
    id: reader.readString(offsets[4]),
    isarId: id,
    notesSource: reader.readStringOrNull(offsets[5]),
    originChannelWire: reader.readString(offsets[6]),
    payloadJson: reader.readStringOrNull(offsets[7]),
    relationshipId: reader.readString(offsets[8]),
    requestKindWire: reader.readString(offsets[9]),
    respondedAt: reader.readDateTimeOrNull(offsets[10]),
    sentAt: reader.readDateTimeOrNull(offsets[11]),
    sourceWorkspaceId: reader.readString(offsets[12]),
    stateUpdatedAt: reader.readDateTime(offsets[13]),
    stateWire: reader.readString(offsets[14]),
    summary: reader.readStringOrNull(offsets[15]),
    title: reader.readString(offsets[16]),
    updatedAt: reader.readDateTime(offsets[17]),
  );
  return object;
}

P _operationalRequestModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _operationalRequestModelGetId(OperationalRequestModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _operationalRequestModelGetLinks(
    OperationalRequestModel object) {
  return [];
}

void _operationalRequestModelAttach(
    IsarCollection<dynamic> col, Id id, OperationalRequestModel object) {
  object.isarId = id;
}

extension OperationalRequestModelByIndex
    on IsarCollection<OperationalRequestModel> {
  Future<OperationalRequestModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  OperationalRequestModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<OperationalRequestModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<OperationalRequestModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(OperationalRequestModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(OperationalRequestModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<OperationalRequestModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<OperationalRequestModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension OperationalRequestModelQueryWhereSort
    on QueryBuilder<OperationalRequestModel, OperationalRequestModel, QWhere> {
  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OperationalRequestModelQueryWhere on QueryBuilder<
    OperationalRequestModel, OperationalRequestModel, QWhereClause> {
  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterWhereClause> idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
          QAfterWhereClause>
      sourceWorkspaceIdEqualToAnyStateWire(String sourceWorkspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceWorkspaceId_stateWire',
        value: [sourceWorkspaceId],
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterWhereClause> relationshipIdEqualTo(String relationshipId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'relationshipId',
        value: [relationshipId],
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterWhereClause> relationshipIdNotEqualTo(String relationshipId) {
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

extension OperationalRequestModelQueryFilter on QueryBuilder<
    OperationalRequestModel, OperationalRequestModel, QFilterCondition> {
  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> closedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'closedAt',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> closedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'closedAt',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> closedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'closedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> createdByEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> createdByGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> createdByLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> createdByBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> createdByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> createdByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
          QAfterFilterCondition>
      createdByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
          QAfterFilterCondition>
      createdByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> createdByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> createdByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> expiresAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiresAt',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> expiresAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiresAt',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> expiresAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> expiresAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> expiresAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiresAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> expiresAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiresAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> notesSourceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notesSource',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> notesSourceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notesSource',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> notesSourceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notesSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> notesSourceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notesSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> notesSourceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notesSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> notesSourceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notesSource',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> notesSourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notesSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> notesSourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notesSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
          QAfterFilterCondition>
      notesSourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notesSource',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
          QAfterFilterCondition>
      notesSourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notesSource',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> notesSourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notesSource',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> notesSourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notesSource',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> originChannelWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originChannelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> originChannelWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originChannelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> originChannelWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originChannelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> originChannelWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originChannelWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> originChannelWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originChannelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> originChannelWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originChannelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
          QAfterFilterCondition>
      originChannelWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originChannelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
          QAfterFilterCondition>
      originChannelWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originChannelWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> originChannelWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originChannelWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> originChannelWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originChannelWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> payloadJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'payloadJson',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> payloadJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'payloadJson',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> payloadJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> payloadJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> payloadJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> payloadJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'payloadJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> payloadJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> payloadJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
          QAfterFilterCondition>
      payloadJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
          QAfterFilterCondition>
      payloadJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'payloadJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> payloadJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> payloadJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'payloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> relationshipIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relationshipId',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> relationshipIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relationshipId',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> requestKindWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'requestKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> requestKindWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'requestKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> requestKindWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'requestKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> requestKindWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'requestKindWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> requestKindWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'requestKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> requestKindWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'requestKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
          QAfterFilterCondition>
      requestKindWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'requestKindWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
          QAfterFilterCondition>
      requestKindWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'requestKindWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> requestKindWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'requestKindWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> requestKindWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'requestKindWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> respondedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'respondedAt',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> respondedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'respondedAt',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> respondedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'respondedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> respondedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'respondedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> respondedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'respondedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> respondedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'respondedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> sentAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sentAt',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> sentAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sentAt',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> sentAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> sentAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> sentAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> sentAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sentAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> sourceWorkspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> sourceWorkspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> stateUpdatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateUpdatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> stateWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stateWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> stateWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stateWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> summaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'summary',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> summaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'summary',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> summaryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> summaryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> summaryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> summaryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'summary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> summaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> summaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
          QAfterFilterCondition>
      summaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
          QAfterFilterCondition>
      summaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'summary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summary',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'summary',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

  QueryBuilder<OperationalRequestModel, OperationalRequestModel,
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

extension OperationalRequestModelQueryObject on QueryBuilder<
    OperationalRequestModel, OperationalRequestModel, QFilterCondition> {}

extension OperationalRequestModelQueryLinks on QueryBuilder<
    OperationalRequestModel, OperationalRequestModel, QFilterCondition> {}

extension OperationalRequestModelQuerySortBy
    on QueryBuilder<OperationalRequestModel, OperationalRequestModel, QSortBy> {
  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByClosedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByNotesSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesSource', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByNotesSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesSource', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByOriginChannelWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originChannelWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByOriginChannelWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originChannelWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByRelationshipId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByRelationshipIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByRequestKindWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestKindWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByRequestKindWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestKindWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByRespondedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'respondedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByRespondedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'respondedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortBySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortBySentAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortBySourceWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortBySourceWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByStateUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByStateUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByStateWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByStateWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension OperationalRequestModelQuerySortThenBy on QueryBuilder<
    OperationalRequestModel, OperationalRequestModel, QSortThenBy> {
  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByClosedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByExpiresAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiresAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByNotesSource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesSource', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByNotesSourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notesSource', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByOriginChannelWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originChannelWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByOriginChannelWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originChannelWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByRelationshipId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByRelationshipIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationshipId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByRequestKindWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestKindWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByRequestKindWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestKindWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByRespondedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'respondedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByRespondedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'respondedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenBySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenBySentAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenBySourceWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenBySourceWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByStateUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByStateUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByStateWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateWire', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByStateWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stateWire', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension OperationalRequestModelQueryWhereDistinct on QueryBuilder<
    OperationalRequestModel, OperationalRequestModel, QDistinct> {
  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByClosedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'closedAt');
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByCreatedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByExpiresAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiresAt');
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByNotesSource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notesSource', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByOriginChannelWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originChannelWire',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByPayloadJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payloadJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByRelationshipId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relationshipId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByRequestKindWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'requestKindWire',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByRespondedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'respondedAt');
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctBySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sentAt');
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctBySourceWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceWorkspaceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByStateUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateUpdatedAt');
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByStateWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stateWire', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctBySummary({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summary', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OperationalRequestModel, OperationalRequestModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension OperationalRequestModelQueryProperty on QueryBuilder<
    OperationalRequestModel, OperationalRequestModel, QQueryProperty> {
  QueryBuilder<OperationalRequestModel, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<OperationalRequestModel, DateTime?, QQueryOperations>
      closedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closedAt');
    });
  }

  QueryBuilder<OperationalRequestModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OperationalRequestModel, String, QQueryOperations>
      createdByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdBy');
    });
  }

  QueryBuilder<OperationalRequestModel, DateTime?, QQueryOperations>
      expiresAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiresAt');
    });
  }

  QueryBuilder<OperationalRequestModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OperationalRequestModel, String?, QQueryOperations>
      notesSourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notesSource');
    });
  }

  QueryBuilder<OperationalRequestModel, String, QQueryOperations>
      originChannelWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originChannelWire');
    });
  }

  QueryBuilder<OperationalRequestModel, String?, QQueryOperations>
      payloadJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadJson');
    });
  }

  QueryBuilder<OperationalRequestModel, String, QQueryOperations>
      relationshipIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relationshipId');
    });
  }

  QueryBuilder<OperationalRequestModel, String, QQueryOperations>
      requestKindWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'requestKindWire');
    });
  }

  QueryBuilder<OperationalRequestModel, DateTime?, QQueryOperations>
      respondedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'respondedAt');
    });
  }

  QueryBuilder<OperationalRequestModel, DateTime?, QQueryOperations>
      sentAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sentAt');
    });
  }

  QueryBuilder<OperationalRequestModel, String, QQueryOperations>
      sourceWorkspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceWorkspaceId');
    });
  }

  QueryBuilder<OperationalRequestModel, DateTime, QQueryOperations>
      stateUpdatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateUpdatedAt');
    });
  }

  QueryBuilder<OperationalRequestModel, String, QQueryOperations>
      stateWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stateWire');
    });
  }

  QueryBuilder<OperationalRequestModel, String?, QQueryOperations>
      summaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summary');
    });
  }

  QueryBuilder<OperationalRequestModel, String, QQueryOperations>
      titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<OperationalRequestModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationalRequestModel _$OperationalRequestModelFromJson(
        Map<String, dynamic> json) =>
    OperationalRequestModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      sourceWorkspaceId: json['sourceWorkspaceId'] as String,
      relationshipId: json['relationshipId'] as String,
      requestKindWire: json['requestKindWire'] as String,
      stateWire: json['stateWire'] as String,
      title: json['title'] as String,
      createdBy: json['createdBy'] as String,
      originChannelWire: json['originChannelWire'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      stateUpdatedAt: DateTime.parse(json['stateUpdatedAt'] as String),
      summary: json['summary'] as String?,
      payloadJson: json['payloadJson'] as String?,
      notesSource: json['notesSource'] as String?,
      sentAt: json['sentAt'] == null
          ? null
          : DateTime.parse(json['sentAt'] as String),
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
      closedAt: json['closedAt'] == null
          ? null
          : DateTime.parse(json['closedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$OperationalRequestModelToJson(
        OperationalRequestModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'sourceWorkspaceId': instance.sourceWorkspaceId,
      'relationshipId': instance.relationshipId,
      'requestKindWire': instance.requestKindWire,
      'stateWire': instance.stateWire,
      'title': instance.title,
      'createdBy': instance.createdBy,
      'originChannelWire': instance.originChannelWire,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'stateUpdatedAt': instance.stateUpdatedAt.toIso8601String(),
      'summary': instance.summary,
      'payloadJson': instance.payloadJson,
      'notesSource': instance.notesSource,
      'sentAt': instance.sentAt?.toIso8601String(),
      'respondedAt': instance.respondedAt?.toIso8601String(),
      'closedAt': instance.closedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
