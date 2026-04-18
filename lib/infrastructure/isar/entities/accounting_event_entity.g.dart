// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_event_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAccountingEventEntityCollection on Isar {
  IsarCollection<AccountingEventEntity> get accountingEventEntitys =>
      this.collection();
}

const AccountingEventEntitySchema = CollectionSchema(
  name: r'AccountingEventEntity',
  id: 7791510964728284654,
  properties: {
    r'actorId': PropertySchema(
      id: 0,
      name: r'actorId',
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
    r'eventType': PropertySchema(
      id: 4,
      name: r'eventType',
      type: IsarType.string,
    ),
    r'hash': PropertySchema(
      id: 5,
      name: r'hash',
      type: IsarType.string,
    ),
    r'occurredAtIso': PropertySchema(
      id: 6,
      name: r'occurredAtIso',
      type: IsarType.string,
    ),
    r'payloadHash': PropertySchema(
      id: 7,
      name: r'payloadHash',
      type: IsarType.string,
    ),
    r'payloadJson': PropertySchema(
      id: 8,
      name: r'payloadJson',
      type: IsarType.string,
    ),
    r'prevHash': PropertySchema(
      id: 9,
      name: r'prevHash',
      type: IsarType.string,
    ),
    r'recordedAtIso': PropertySchema(
      id: 10,
      name: r'recordedAtIso',
      type: IsarType.string,
    ),
    r'sequenceNumber': PropertySchema(
      id: 11,
      name: r'sequenceNumber',
      type: IsarType.long,
    )
  },
  estimateSize: _accountingEventEntityEstimateSize,
  serialize: _accountingEventEntitySerialize,
  deserialize: _accountingEventEntityDeserialize,
  deserializeProp: _accountingEventEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'eventId': IndexSchema(
      id: -2707901133518603130,
      name: r'eventId',
      unique: true,
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
    r'entityId_entityType_sequenceNumber': IndexSchema(
      id: 326894087129364219,
      name: r'entityId_entityType_sequenceNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entityId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'entityType',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'sequenceNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'occurredAtIso': IndexSchema(
      id: -2655360165798457330,
      name: r'occurredAtIso',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'occurredAtIso',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'payloadHash': IndexSchema(
      id: 3554167572085970943,
      name: r'payloadHash',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'payloadHash',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'sequenceNumber': IndexSchema(
      id: 8335504386525452843,
      name: r'sequenceNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sequenceNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _accountingEventEntityGetId,
  getLinks: _accountingEventEntityGetLinks,
  attach: _accountingEventEntityAttach,
  version: '3.3.0-dev.1',
);

int _accountingEventEntityEstimateSize(
  AccountingEventEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.actorId.length * 3;
  bytesCount += 3 + object.entityId.length * 3;
  bytesCount += 3 + object.entityType.length * 3;
  bytesCount += 3 + object.eventId.length * 3;
  bytesCount += 3 + object.eventType.length * 3;
  bytesCount += 3 + object.hash.length * 3;
  bytesCount += 3 + object.occurredAtIso.length * 3;
  bytesCount += 3 + object.payloadHash.length * 3;
  bytesCount += 3 + object.payloadJson.length * 3;
  {
    final value = object.prevHash;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.recordedAtIso.length * 3;
  return bytesCount;
}

void _accountingEventEntitySerialize(
  AccountingEventEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actorId);
  writer.writeString(offsets[1], object.entityId);
  writer.writeString(offsets[2], object.entityType);
  writer.writeString(offsets[3], object.eventId);
  writer.writeString(offsets[4], object.eventType);
  writer.writeString(offsets[5], object.hash);
  writer.writeString(offsets[6], object.occurredAtIso);
  writer.writeString(offsets[7], object.payloadHash);
  writer.writeString(offsets[8], object.payloadJson);
  writer.writeString(offsets[9], object.prevHash);
  writer.writeString(offsets[10], object.recordedAtIso);
  writer.writeLong(offsets[11], object.sequenceNumber);
}

AccountingEventEntity _accountingEventEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AccountingEventEntity();
  object.actorId = reader.readString(offsets[0]);
  object.entityId = reader.readString(offsets[1]);
  object.entityType = reader.readString(offsets[2]);
  object.eventId = reader.readString(offsets[3]);
  object.eventType = reader.readString(offsets[4]);
  object.hash = reader.readString(offsets[5]);
  object.id = id;
  object.occurredAtIso = reader.readString(offsets[6]);
  object.payloadHash = reader.readString(offsets[7]);
  object.payloadJson = reader.readString(offsets[8]);
  object.prevHash = reader.readStringOrNull(offsets[9]);
  object.recordedAtIso = reader.readString(offsets[10]);
  object.sequenceNumber = reader.readLong(offsets[11]);
  return object;
}

P _accountingEventEntityDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _accountingEventEntityGetId(AccountingEventEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _accountingEventEntityGetLinks(
    AccountingEventEntity object) {
  return [];
}

void _accountingEventEntityAttach(
    IsarCollection<dynamic> col, Id id, AccountingEventEntity object) {
  object.id = id;
}

extension AccountingEventEntityByIndex
    on IsarCollection<AccountingEventEntity> {
  Future<AccountingEventEntity?> getByEventId(String eventId) {
    return getByIndex(r'eventId', [eventId]);
  }

  AccountingEventEntity? getByEventIdSync(String eventId) {
    return getByIndexSync(r'eventId', [eventId]);
  }

  Future<bool> deleteByEventId(String eventId) {
    return deleteByIndex(r'eventId', [eventId]);
  }

  bool deleteByEventIdSync(String eventId) {
    return deleteByIndexSync(r'eventId', [eventId]);
  }

  Future<List<AccountingEventEntity?>> getAllByEventId(
      List<String> eventIdValues) {
    final values = eventIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'eventId', values);
  }

  List<AccountingEventEntity?> getAllByEventIdSync(List<String> eventIdValues) {
    final values = eventIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'eventId', values);
  }

  Future<int> deleteAllByEventId(List<String> eventIdValues) {
    final values = eventIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'eventId', values);
  }

  int deleteAllByEventIdSync(List<String> eventIdValues) {
    final values = eventIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'eventId', values);
  }

  Future<Id> putByEventId(AccountingEventEntity object) {
    return putByIndex(r'eventId', object);
  }

  Id putByEventIdSync(AccountingEventEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'eventId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEventId(List<AccountingEventEntity> objects) {
    return putAllByIndex(r'eventId', objects);
  }

  List<Id> putAllByEventIdSync(List<AccountingEventEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'eventId', objects, saveLinks: saveLinks);
  }
}

extension AccountingEventEntityQueryWhereSort
    on QueryBuilder<AccountingEventEntity, AccountingEventEntity, QWhere> {
  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhere>
      anySequenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'sequenceNumber'),
      );
    });
  }
}

extension AccountingEventEntityQueryWhere on QueryBuilder<AccountingEventEntity,
    AccountingEventEntity, QWhereClause> {
  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      eventIdEqualTo(String eventId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'eventId',
        value: [eventId],
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      entityTypeEqualTo(String entityType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entityType',
        value: [entityType],
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      entityIdEqualToAnyEntityTypeSequenceNumber(String entityId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entityId_entityType_sequenceNumber',
        value: [entityId],
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      entityIdNotEqualToAnyEntityTypeSequenceNumber(String entityId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId_entityType_sequenceNumber',
              lower: [],
              upper: [entityId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId_entityType_sequenceNumber',
              lower: [entityId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId_entityType_sequenceNumber',
              lower: [entityId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId_entityType_sequenceNumber',
              lower: [],
              upper: [entityId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      entityIdEntityTypeEqualToAnySequenceNumber(
          String entityId, String entityType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entityId_entityType_sequenceNumber',
        value: [entityId, entityType],
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      entityIdEqualToEntityTypeNotEqualToAnySequenceNumber(
          String entityId, String entityType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId_entityType_sequenceNumber',
              lower: [entityId],
              upper: [entityId, entityType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId_entityType_sequenceNumber',
              lower: [entityId, entityType],
              includeLower: false,
              upper: [entityId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId_entityType_sequenceNumber',
              lower: [entityId, entityType],
              includeLower: false,
              upper: [entityId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId_entityType_sequenceNumber',
              lower: [entityId],
              upper: [entityId, entityType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      entityIdEntityTypeSequenceNumberEqualTo(
          String entityId, String entityType, int sequenceNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entityId_entityType_sequenceNumber',
        value: [entityId, entityType, sequenceNumber],
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      entityIdEntityTypeEqualToSequenceNumberNotEqualTo(
          String entityId, String entityType, int sequenceNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId_entityType_sequenceNumber',
              lower: [entityId, entityType],
              upper: [entityId, entityType, sequenceNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId_entityType_sequenceNumber',
              lower: [entityId, entityType, sequenceNumber],
              includeLower: false,
              upper: [entityId, entityType],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId_entityType_sequenceNumber',
              lower: [entityId, entityType, sequenceNumber],
              includeLower: false,
              upper: [entityId, entityType],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId_entityType_sequenceNumber',
              lower: [entityId, entityType],
              upper: [entityId, entityType, sequenceNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      entityIdEntityTypeEqualToSequenceNumberGreaterThan(
    String entityId,
    String entityType,
    int sequenceNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'entityId_entityType_sequenceNumber',
        lower: [entityId, entityType, sequenceNumber],
        includeLower: include,
        upper: [entityId, entityType],
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      entityIdEntityTypeEqualToSequenceNumberLessThan(
    String entityId,
    String entityType,
    int sequenceNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'entityId_entityType_sequenceNumber',
        lower: [entityId, entityType],
        upper: [entityId, entityType, sequenceNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      entityIdEntityTypeEqualToSequenceNumberBetween(
    String entityId,
    String entityType,
    int lowerSequenceNumber,
    int upperSequenceNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'entityId_entityType_sequenceNumber',
        lower: [entityId, entityType, lowerSequenceNumber],
        includeLower: includeLower,
        upper: [entityId, entityType, upperSequenceNumber],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      occurredAtIsoEqualTo(String occurredAtIso) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'occurredAtIso',
        value: [occurredAtIso],
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      occurredAtIsoNotEqualTo(String occurredAtIso) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'occurredAtIso',
              lower: [],
              upper: [occurredAtIso],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'occurredAtIso',
              lower: [occurredAtIso],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'occurredAtIso',
              lower: [occurredAtIso],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'occurredAtIso',
              lower: [],
              upper: [occurredAtIso],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      payloadHashEqualTo(String payloadHash) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'payloadHash',
        value: [payloadHash],
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      payloadHashNotEqualTo(String payloadHash) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'payloadHash',
              lower: [],
              upper: [payloadHash],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'payloadHash',
              lower: [payloadHash],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'payloadHash',
              lower: [payloadHash],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'payloadHash',
              lower: [],
              upper: [payloadHash],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      sequenceNumberEqualTo(int sequenceNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sequenceNumber',
        value: [sequenceNumber],
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      sequenceNumberNotEqualTo(int sequenceNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sequenceNumber',
              lower: [],
              upper: [sequenceNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sequenceNumber',
              lower: [sequenceNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sequenceNumber',
              lower: [sequenceNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sequenceNumber',
              lower: [],
              upper: [sequenceNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      sequenceNumberGreaterThan(
    int sequenceNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sequenceNumber',
        lower: [sequenceNumber],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      sequenceNumberLessThan(
    int sequenceNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sequenceNumber',
        lower: [],
        upper: [sequenceNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterWhereClause>
      sequenceNumberBetween(
    int lowerSequenceNumber,
    int upperSequenceNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sequenceNumber',
        lower: [lowerSequenceNumber],
        includeLower: includeLower,
        upper: [upperSequenceNumber],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AccountingEventEntityQueryFilter on QueryBuilder<
    AccountingEventEntity, AccountingEventEntity, QFilterCondition> {
  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> actorIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> actorIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> actorIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> actorIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> actorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> actorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      actorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      actorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> actorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actorId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> actorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actorId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityIdEqualTo(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityIdGreaterThan(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityIdLessThan(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityIdBetween(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityIdStartsWith(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityIdEndsWith(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      entityIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      entityIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entityId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entityId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityTypeEqualTo(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityTypeGreaterThan(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityTypeLessThan(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityTypeBetween(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityTypeStartsWith(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityTypeEndsWith(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      entityTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      entityTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entityType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityType',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> entityTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entityType',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventIdEqualTo(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventIdGreaterThan(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventIdLessThan(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventIdBetween(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventIdStartsWith(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventIdEndsWith(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      eventIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      eventIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventId',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      eventTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eventType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      eventTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eventType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventType',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> eventTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eventType',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> hashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> hashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> hashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> hashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> hashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> hashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      hashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      hashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> hashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hash',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> hashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hash',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> occurredAtIsoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occurredAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> occurredAtIsoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'occurredAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> occurredAtIsoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'occurredAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> occurredAtIsoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'occurredAtIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> occurredAtIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'occurredAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> occurredAtIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'occurredAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      occurredAtIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'occurredAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      occurredAtIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'occurredAtIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> occurredAtIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occurredAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> occurredAtIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'occurredAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadHashEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payloadHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'payloadHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'payloadHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'payloadHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'payloadHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'payloadHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      payloadHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'payloadHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      payloadHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'payloadHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payloadHash',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'payloadHash',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadJsonEqualTo(
    String value, {
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadJsonGreaterThan(
    String value, {
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadJsonLessThan(
    String value, {
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadJsonBetween(
    String lower,
    String upper, {
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
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

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> payloadJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'payloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> prevHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'prevHash',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> prevHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'prevHash',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> prevHashEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prevHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> prevHashGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prevHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> prevHashLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prevHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> prevHashBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prevHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> prevHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'prevHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> prevHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'prevHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      prevHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'prevHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      prevHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'prevHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> prevHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prevHash',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> prevHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'prevHash',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> recordedAtIsoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> recordedAtIsoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recordedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> recordedAtIsoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recordedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> recordedAtIsoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recordedAtIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> recordedAtIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recordedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> recordedAtIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recordedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      recordedAtIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recordedAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
          QAfterFilterCondition>
      recordedAtIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recordedAtIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> recordedAtIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordedAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> recordedAtIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recordedAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> sequenceNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sequenceNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> sequenceNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sequenceNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> sequenceNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sequenceNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity,
      QAfterFilterCondition> sequenceNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sequenceNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AccountingEventEntityQueryObject on QueryBuilder<
    AccountingEventEntity, AccountingEventEntity, QFilterCondition> {}

extension AccountingEventEntityQueryLinks on QueryBuilder<AccountingEventEntity,
    AccountingEventEntity, QFilterCondition> {}

extension AccountingEventEntityQuerySortBy
    on QueryBuilder<AccountingEventEntity, AccountingEventEntity, QSortBy> {
  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByActorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorId', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByActorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorId', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByEventType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByEventTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByOccurredAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAtIso', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByOccurredAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAtIso', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByPayloadHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadHash', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByPayloadHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadHash', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByPrevHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prevHash', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByPrevHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prevHash', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByRecordedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAtIso', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortByRecordedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAtIso', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortBySequenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceNumber', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      sortBySequenceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceNumber', Sort.desc);
    });
  }
}

extension AccountingEventEntityQuerySortThenBy
    on QueryBuilder<AccountingEventEntity, AccountingEventEntity, QSortThenBy> {
  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByActorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorId', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByActorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actorId', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByEventType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByEventTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hash', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByOccurredAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAtIso', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByOccurredAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAtIso', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByPayloadHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadHash', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByPayloadHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadHash', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByPrevHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prevHash', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByPrevHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prevHash', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByRecordedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAtIso', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenByRecordedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordedAtIso', Sort.desc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenBySequenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceNumber', Sort.asc);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QAfterSortBy>
      thenBySequenceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sequenceNumber', Sort.desc);
    });
  }
}

extension AccountingEventEntityQueryWhereDistinct
    on QueryBuilder<AccountingEventEntity, AccountingEventEntity, QDistinct> {
  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QDistinct>
      distinctByActorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actorId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QDistinct>
      distinctByEntityId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QDistinct>
      distinctByEntityType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QDistinct>
      distinctByEventId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QDistinct>
      distinctByEventType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QDistinct>
      distinctByHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QDistinct>
      distinctByOccurredAtIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'occurredAtIso',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QDistinct>
      distinctByPayloadHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payloadHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QDistinct>
      distinctByPayloadJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payloadJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QDistinct>
      distinctByPrevHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prevHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QDistinct>
      distinctByRecordedAtIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordedAtIso',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AccountingEventEntity, AccountingEventEntity, QDistinct>
      distinctBySequenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sequenceNumber');
    });
  }
}

extension AccountingEventEntityQueryProperty on QueryBuilder<
    AccountingEventEntity, AccountingEventEntity, QQueryProperty> {
  QueryBuilder<AccountingEventEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AccountingEventEntity, String, QQueryOperations>
      actorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actorId');
    });
  }

  QueryBuilder<AccountingEventEntity, String, QQueryOperations>
      entityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityId');
    });
  }

  QueryBuilder<AccountingEventEntity, String, QQueryOperations>
      entityTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityType');
    });
  }

  QueryBuilder<AccountingEventEntity, String, QQueryOperations>
      eventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventId');
    });
  }

  QueryBuilder<AccountingEventEntity, String, QQueryOperations>
      eventTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventType');
    });
  }

  QueryBuilder<AccountingEventEntity, String, QQueryOperations> hashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hash');
    });
  }

  QueryBuilder<AccountingEventEntity, String, QQueryOperations>
      occurredAtIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occurredAtIso');
    });
  }

  QueryBuilder<AccountingEventEntity, String, QQueryOperations>
      payloadHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadHash');
    });
  }

  QueryBuilder<AccountingEventEntity, String, QQueryOperations>
      payloadJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadJson');
    });
  }

  QueryBuilder<AccountingEventEntity, String?, QQueryOperations>
      prevHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prevHash');
    });
  }

  QueryBuilder<AccountingEventEntity, String, QQueryOperations>
      recordedAtIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordedAtIso');
    });
  }

  QueryBuilder<AccountingEventEntity, int, QQueryOperations>
      sequenceNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sequenceNumber');
    });
  }
}
