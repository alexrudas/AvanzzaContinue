// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbox_event_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOutboxEventEntityCollection on Isar {
  IsarCollection<OutboxEventEntity> get outboxEventEntitys => this.collection();
}

const OutboxEventEntitySchema = CollectionSchema(
  name: r'OutboxEventEntity',
  id: -3933489546108402088,
  properties: {
    r'createdAtIso': PropertySchema(
      id: 0,
      name: r'createdAtIso',
      type: IsarType.string,
    ),
    r'entityId': PropertySchema(
      id: 1,
      name: r'entityId',
      type: IsarType.string,
    ),
    r'entityType': PropertySchema(
      id: 2,
      name: r'entityType',
      type: IsarType.string,
    ),
    r'eventId': PropertySchema(
      id: 3,
      name: r'eventId',
      type: IsarType.string,
    ),
    r'idempotencyKey': PropertySchema(
      id: 4,
      name: r'idempotencyKey',
      type: IsarType.string,
    ),
    r'lastAttemptAtIso': PropertySchema(
      id: 5,
      name: r'lastAttemptAtIso',
      type: IsarType.string,
    ),
    r'lastError': PropertySchema(
      id: 6,
      name: r'lastError',
      type: IsarType.string,
    ),
    r'lockedUntilIso': PropertySchema(
      id: 7,
      name: r'lockedUntilIso',
      type: IsarType.string,
    ),
    r'outboxId': PropertySchema(
      id: 8,
      name: r'outboxId',
      type: IsarType.string,
    ),
    r'retryCount': PropertySchema(
      id: 9,
      name: r'retryCount',
      type: IsarType.long,
    ),
    r'statusWire': PropertySchema(
      id: 10,
      name: r'statusWire',
      type: IsarType.string,
    ),
    r'updatedAtIso': PropertySchema(
      id: 11,
      name: r'updatedAtIso',
      type: IsarType.string,
    ),
    r'workerLockedBy': PropertySchema(
      id: 12,
      name: r'workerLockedBy',
      type: IsarType.string,
    )
  },
  estimateSize: _outboxEventEntityEstimateSize,
  serialize: _outboxEventEntitySerialize,
  deserialize: _outboxEventEntityDeserialize,
  deserializeProp: _outboxEventEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'outboxId': IndexSchema(
      id: 2208980373728687676,
      name: r'outboxId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'outboxId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'eventId': IndexSchema(
      id: -2707901133518603130,
      name: r'eventId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'eventId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'entityType': IndexSchema(
      id: -5109706325448941117,
      name: r'entityType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entityType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'entityId': IndexSchema(
      id: 745355021660786263,
      name: r'entityId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entityId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'statusWire_lockedUntilIso': IndexSchema(
      id: -4224970814160735244,
      name: r'statusWire_lockedUntilIso',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'statusWire',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'lockedUntilIso',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'createdAtIso': IndexSchema(
      id: 8898886970231457701,
      name: r'createdAtIso',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAtIso',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'idempotencyKey': IndexSchema(
      id: 6522471565226449816,
      name: r'idempotencyKey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'idempotencyKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'lockedUntilIso': IndexSchema(
      id: -4158774010416252207,
      name: r'lockedUntilIso',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lockedUntilIso',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _outboxEventEntityGetId,
  getLinks: _outboxEventEntityGetLinks,
  attach: _outboxEventEntityAttach,
  version: '3.2.0-dev.2',
);

int _outboxEventEntityEstimateSize(
  OutboxEventEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.createdAtIso.length * 3;
  bytesCount += 3 + object.entityId.length * 3;
  bytesCount += 3 + object.entityType.length * 3;
  bytesCount += 3 + object.eventId.length * 3;
  {
    final value = object.idempotencyKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastAttemptAtIso;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastError;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lockedUntilIso;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.outboxId.length * 3;
  bytesCount += 3 + object.statusWire.length * 3;
  bytesCount += 3 + object.updatedAtIso.length * 3;
  {
    final value = object.workerLockedBy;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _outboxEventEntitySerialize(
  OutboxEventEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.createdAtIso);
  writer.writeString(offsets[1], object.entityId);
  writer.writeString(offsets[2], object.entityType);
  writer.writeString(offsets[3], object.eventId);
  writer.writeString(offsets[4], object.idempotencyKey);
  writer.writeString(offsets[5], object.lastAttemptAtIso);
  writer.writeString(offsets[6], object.lastError);
  writer.writeString(offsets[7], object.lockedUntilIso);
  writer.writeString(offsets[8], object.outboxId);
  writer.writeLong(offsets[9], object.retryCount);
  writer.writeString(offsets[10], object.statusWire);
  writer.writeString(offsets[11], object.updatedAtIso);
  writer.writeString(offsets[12], object.workerLockedBy);
}

OutboxEventEntity _outboxEventEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OutboxEventEntity();
  object.createdAtIso = reader.readString(offsets[0]);
  object.entityId = reader.readString(offsets[1]);
  object.entityType = reader.readString(offsets[2]);
  object.eventId = reader.readString(offsets[3]);
  object.id = id;
  object.idempotencyKey = reader.readStringOrNull(offsets[4]);
  object.lastAttemptAtIso = reader.readStringOrNull(offsets[5]);
  object.lastError = reader.readStringOrNull(offsets[6]);
  object.lockedUntilIso = reader.readStringOrNull(offsets[7]);
  object.outboxId = reader.readString(offsets[8]);
  object.retryCount = reader.readLong(offsets[9]);
  object.statusWire = reader.readString(offsets[10]);
  object.updatedAtIso = reader.readString(offsets[11]);
  object.workerLockedBy = reader.readStringOrNull(offsets[12]);
  return object;
}

P _outboxEventEntityDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _outboxEventEntityGetId(OutboxEventEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _outboxEventEntityGetLinks(
    OutboxEventEntity object) {
  return [];
}

void _outboxEventEntityAttach(
    IsarCollection<dynamic> col, Id id, OutboxEventEntity object) {
  object.id = id;
}

extension OutboxEventEntityByIndex on IsarCollection<OutboxEventEntity> {
  Future<OutboxEventEntity?> getByOutboxId(String outboxId) {
    return getByIndex(r'outboxId', [outboxId]);
  }

  OutboxEventEntity? getByOutboxIdSync(String outboxId) {
    return getByIndexSync(r'outboxId', [outboxId]);
  }

  Future<bool> deleteByOutboxId(String outboxId) {
    return deleteByIndex(r'outboxId', [outboxId]);
  }

  bool deleteByOutboxIdSync(String outboxId) {
    return deleteByIndexSync(r'outboxId', [outboxId]);
  }

  Future<List<OutboxEventEntity?>> getAllByOutboxId(
      List<String> outboxIdValues) {
    final values = outboxIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'outboxId', values);
  }

  List<OutboxEventEntity?> getAllByOutboxIdSync(List<String> outboxIdValues) {
    final values = outboxIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'outboxId', values);
  }

  Future<int> deleteAllByOutboxId(List<String> outboxIdValues) {
    final values = outboxIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'outboxId', values);
  }

  int deleteAllByOutboxIdSync(List<String> outboxIdValues) {
    final values = outboxIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'outboxId', values);
  }

  Future<Id> putByOutboxId(OutboxEventEntity object) {
    return putByIndex(r'outboxId', object);
  }

  Id putByOutboxIdSync(OutboxEventEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'outboxId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByOutboxId(List<OutboxEventEntity> objects) {
    return putAllByIndex(r'outboxId', objects);
  }

  List<Id> putAllByOutboxIdSync(List<OutboxEventEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'outboxId', objects, saveLinks: saveLinks);
  }
}

extension OutboxEventEntityQueryWhereSort
    on QueryBuilder<OutboxEventEntity, OutboxEventEntity, QWhere> {
  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OutboxEventEntityQueryWhere
    on QueryBuilder<OutboxEventEntity, OutboxEventEntity, QWhereClause> {
  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      outboxIdEqualTo(String outboxId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'outboxId',
        value: [outboxId],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      outboxIdNotEqualTo(String outboxId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'outboxId',
              lower: [],
              upper: [outboxId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'outboxId',
              lower: [outboxId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'outboxId',
              lower: [outboxId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'outboxId',
              lower: [],
              upper: [outboxId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      eventIdEqualTo(String eventId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'eventId',
        value: [eventId],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      eventIdNotEqualTo(String eventId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [],
              upper: [eventId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [eventId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [eventId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'eventId',
              lower: [],
              upper: [eventId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      entityTypeEqualTo(String entityType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entityType',
        value: [entityType],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      entityTypeNotEqualTo(String entityType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityType',
              lower: [],
              upper: [entityType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityType',
              lower: [entityType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityType',
              lower: [entityType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityType',
              lower: [],
              upper: [entityType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      entityIdEqualTo(String entityId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entityId',
        value: [entityId],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      entityIdNotEqualTo(String entityId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [],
              upper: [entityId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [entityId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [entityId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [],
              upper: [entityId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      statusWireEqualToAnyLockedUntilIso(String statusWire) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'statusWire_lockedUntilIso',
        value: [statusWire],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      statusWireNotEqualToAnyLockedUntilIso(String statusWire) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusWire_lockedUntilIso',
              lower: [],
              upper: [statusWire],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusWire_lockedUntilIso',
              lower: [statusWire],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusWire_lockedUntilIso',
              lower: [statusWire],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusWire_lockedUntilIso',
              lower: [],
              upper: [statusWire],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      statusWireEqualToLockedUntilIsoIsNull(String statusWire) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'statusWire_lockedUntilIso',
        value: [statusWire, null],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      statusWireEqualToLockedUntilIsoIsNotNull(String statusWire) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'statusWire_lockedUntilIso',
        lower: [statusWire, null],
        includeLower: false,
        upper: [
          statusWire,
        ],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      statusWireLockedUntilIsoEqualTo(
          String statusWire, String? lockedUntilIso) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'statusWire_lockedUntilIso',
        value: [statusWire, lockedUntilIso],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      statusWireEqualToLockedUntilIsoNotEqualTo(
          String statusWire, String? lockedUntilIso) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusWire_lockedUntilIso',
              lower: [statusWire],
              upper: [statusWire, lockedUntilIso],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusWire_lockedUntilIso',
              lower: [statusWire, lockedUntilIso],
              includeLower: false,
              upper: [statusWire],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusWire_lockedUntilIso',
              lower: [statusWire, lockedUntilIso],
              includeLower: false,
              upper: [statusWire],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'statusWire_lockedUntilIso',
              lower: [statusWire],
              upper: [statusWire, lockedUntilIso],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      createdAtIsoEqualTo(String createdAtIso) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAtIso',
        value: [createdAtIso],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      createdAtIsoNotEqualTo(String createdAtIso) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAtIso',
              lower: [],
              upper: [createdAtIso],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAtIso',
              lower: [createdAtIso],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAtIso',
              lower: [createdAtIso],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAtIso',
              lower: [],
              upper: [createdAtIso],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      idempotencyKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idempotencyKey',
        value: [null],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      idempotencyKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'idempotencyKey',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      idempotencyKeyEqualTo(String? idempotencyKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'idempotencyKey',
        value: [idempotencyKey],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      idempotencyKeyNotEqualTo(String? idempotencyKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idempotencyKey',
              lower: [],
              upper: [idempotencyKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idempotencyKey',
              lower: [idempotencyKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idempotencyKey',
              lower: [idempotencyKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'idempotencyKey',
              lower: [],
              upper: [idempotencyKey],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      lockedUntilIsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lockedUntilIso',
        value: [null],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      lockedUntilIsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lockedUntilIso',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      lockedUntilIsoEqualTo(String? lockedUntilIso) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lockedUntilIso',
        value: [lockedUntilIso],
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterWhereClause>
      lockedUntilIsoNotEqualTo(String? lockedUntilIso) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lockedUntilIso',
              lower: [],
              upper: [lockedUntilIso],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lockedUntilIso',
              lower: [lockedUntilIso],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lockedUntilIso',
              lower: [lockedUntilIso],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lockedUntilIso',
              lower: [],
              upper: [lockedUntilIso],
              includeUpper: false,
            ));
      }
    });
  }
}

extension OutboxEventEntityQueryFilter
    on QueryBuilder<OutboxEventEntity, OutboxEventEntity, QFilterCondition> {
  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      createdAtIsoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      createdAtIsoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      createdAtIsoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      createdAtIsoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAtIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      createdAtIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      createdAtIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      createdAtIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      createdAtIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdAtIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      createdAtIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      createdAtIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entityId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityId',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entityId',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entityType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entityType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityType',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      entityTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entityType',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      eventIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      eventIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      eventIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      eventIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      eventIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      eventIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      eventIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      eventIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      eventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      eventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idempotencyKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'idempotencyKey',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idempotencyKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'idempotencyKey',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idempotencyKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idempotencyKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idempotencyKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idempotencyKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idempotencyKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idempotencyKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idempotencyKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idempotencyKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idempotencyKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idempotencyKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idempotencyKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idempotencyKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idempotencyKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idempotencyKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idempotencyKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idempotencyKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idempotencyKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idempotencyKey',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      idempotencyKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idempotencyKey',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastAttemptAtIsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastAttemptAtIso',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastAttemptAtIsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastAttemptAtIso',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastAttemptAtIsoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAttemptAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastAttemptAtIsoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAttemptAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastAttemptAtIsoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAttemptAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastAttemptAtIsoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAttemptAtIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastAttemptAtIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastAttemptAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastAttemptAtIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastAttemptAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastAttemptAtIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastAttemptAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastAttemptAtIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastAttemptAtIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastAttemptAtIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAttemptAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastAttemptAtIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastAttemptAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastErrorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastError',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastErrorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastError',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastErrorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastErrorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastErrorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastErrorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastError',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastErrorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastErrorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastErrorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastErrorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastError',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastErrorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastError',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lastErrorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastError',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lockedUntilIsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lockedUntilIso',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lockedUntilIsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lockedUntilIso',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lockedUntilIsoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lockedUntilIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lockedUntilIsoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lockedUntilIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lockedUntilIsoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lockedUntilIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lockedUntilIsoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lockedUntilIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lockedUntilIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lockedUntilIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lockedUntilIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lockedUntilIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lockedUntilIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lockedUntilIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lockedUntilIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lockedUntilIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lockedUntilIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lockedUntilIso',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      lockedUntilIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lockedUntilIso',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      outboxIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outboxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      outboxIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'outboxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      outboxIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'outboxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      outboxIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'outboxId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      outboxIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'outboxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      outboxIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'outboxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      outboxIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'outboxId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      outboxIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'outboxId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      outboxIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outboxId',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      outboxIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'outboxId',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      retryCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      retryCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      retryCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'retryCount',
        value: value,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      retryCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retryCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      statusWireEqualTo(
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

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      statusWireGreaterThan(
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

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      statusWireLessThan(
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

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      statusWireBetween(
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

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      statusWireStartsWith(
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

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      statusWireEndsWith(
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

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      statusWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statusWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      statusWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statusWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      statusWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      statusWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statusWire',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      updatedAtIsoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      updatedAtIsoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      updatedAtIsoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      updatedAtIsoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAtIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      updatedAtIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'updatedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      updatedAtIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'updatedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      updatedAtIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'updatedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      updatedAtIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'updatedAtIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      updatedAtIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      updatedAtIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'updatedAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      workerLockedByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'workerLockedBy',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      workerLockedByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'workerLockedBy',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      workerLockedByEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workerLockedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      workerLockedByGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workerLockedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      workerLockedByLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workerLockedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      workerLockedByBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workerLockedBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      workerLockedByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'workerLockedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      workerLockedByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'workerLockedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      workerLockedByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'workerLockedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      workerLockedByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'workerLockedBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      workerLockedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workerLockedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterFilterCondition>
      workerLockedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'workerLockedBy',
        value: '',
      ));
    });
  }
}

extension OutboxEventEntityQueryObject
    on QueryBuilder<OutboxEventEntity, OutboxEventEntity, QFilterCondition> {}

extension OutboxEventEntityQueryLinks
    on QueryBuilder<OutboxEventEntity, OutboxEventEntity, QFilterCondition> {}

extension OutboxEventEntityQuerySortBy
    on QueryBuilder<OutboxEventEntity, OutboxEventEntity, QSortBy> {
  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByCreatedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtIso', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByCreatedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtIso', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByIdempotencyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByIdempotencyKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByLastAttemptAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAtIso', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByLastAttemptAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAtIso', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByLockedUntilIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockedUntilIso', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByLockedUntilIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockedUntilIso', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByOutboxId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outboxId', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByOutboxIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outboxId', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByStatusWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusWire', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByStatusWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusWire', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByUpdatedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtIso', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByUpdatedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtIso', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByWorkerLockedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workerLockedBy', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      sortByWorkerLockedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workerLockedBy', Sort.desc);
    });
  }
}

extension OutboxEventEntityQuerySortThenBy
    on QueryBuilder<OutboxEventEntity, OutboxEventEntity, QSortThenBy> {
  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByCreatedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtIso', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByCreatedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtIso', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByIdempotencyKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByIdempotencyKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idempotencyKey', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByLastAttemptAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAtIso', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByLastAttemptAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAtIso', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByLockedUntilIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockedUntilIso', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByLockedUntilIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockedUntilIso', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByOutboxId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outboxId', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByOutboxIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outboxId', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByStatusWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusWire', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByStatusWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusWire', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByUpdatedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtIso', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByUpdatedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAtIso', Sort.desc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByWorkerLockedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workerLockedBy', Sort.asc);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QAfterSortBy>
      thenByWorkerLockedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workerLockedBy', Sort.desc);
    });
  }
}

extension OutboxEventEntityQueryWhereDistinct
    on QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct> {
  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct>
      distinctByCreatedAtIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAtIso', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct>
      distinctByEntityId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct>
      distinctByEntityType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct>
      distinctByEventId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct>
      distinctByIdempotencyKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idempotencyKey',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct>
      distinctByLastAttemptAtIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAttemptAtIso',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct>
      distinctByLastError({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastError', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct>
      distinctByLockedUntilIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lockedUntilIso',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct>
      distinctByOutboxId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outboxId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct>
      distinctByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retryCount');
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct>
      distinctByStatusWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusWire', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct>
      distinctByUpdatedAtIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAtIso', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OutboxEventEntity, OutboxEventEntity, QDistinct>
      distinctByWorkerLockedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workerLockedBy',
          caseSensitive: caseSensitive);
    });
  }
}

extension OutboxEventEntityQueryProperty
    on QueryBuilder<OutboxEventEntity, OutboxEventEntity, QQueryProperty> {
  QueryBuilder<OutboxEventEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OutboxEventEntity, String, QQueryOperations>
      createdAtIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAtIso');
    });
  }

  QueryBuilder<OutboxEventEntity, String, QQueryOperations> entityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityId');
    });
  }

  QueryBuilder<OutboxEventEntity, String, QQueryOperations>
      entityTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityType');
    });
  }

  QueryBuilder<OutboxEventEntity, String, QQueryOperations> eventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventId');
    });
  }

  QueryBuilder<OutboxEventEntity, String?, QQueryOperations>
      idempotencyKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idempotencyKey');
    });
  }

  QueryBuilder<OutboxEventEntity, String?, QQueryOperations>
      lastAttemptAtIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAttemptAtIso');
    });
  }

  QueryBuilder<OutboxEventEntity, String?, QQueryOperations>
      lastErrorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastError');
    });
  }

  QueryBuilder<OutboxEventEntity, String?, QQueryOperations>
      lockedUntilIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lockedUntilIso');
    });
  }

  QueryBuilder<OutboxEventEntity, String, QQueryOperations> outboxIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outboxId');
    });
  }

  QueryBuilder<OutboxEventEntity, int, QQueryOperations> retryCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retryCount');
    });
  }

  QueryBuilder<OutboxEventEntity, String, QQueryOperations>
      statusWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusWire');
    });
  }

  QueryBuilder<OutboxEventEntity, String, QQueryOperations>
      updatedAtIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAtIso');
    });
  }

  QueryBuilder<OutboxEventEntity, String?, QQueryOperations>
      workerLockedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workerLockedBy');
    });
  }
}
