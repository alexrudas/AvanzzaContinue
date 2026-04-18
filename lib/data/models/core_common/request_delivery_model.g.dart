// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_delivery_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRequestDeliveryModelCollection on Isar {
  IsarCollection<RequestDeliveryModel> get requestDeliveryModels =>
      this.collection();
}

const RequestDeliveryModelSchema = CollectionSchema(
  name: r'RequestDeliveryModel',
  id: -5962156801518869562,
  properties: {
    r'channelWire': PropertySchema(
      id: 0,
      name: r'channelWire',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deliveredAt': PropertySchema(
      id: 2,
      name: r'deliveredAt',
      type: IsarType.dateTime,
    ),
    r'directionWire': PropertySchema(
      id: 3,
      name: r'directionWire',
      type: IsarType.string,
    ),
    r'dispatchedAt': PropertySchema(
      id: 4,
      name: r'dispatchedAt',
      type: IsarType.dateTime,
    ),
    r'externalRef': PropertySchema(
      id: 5,
      name: r'externalRef',
      type: IsarType.string,
    ),
    r'failedReason': PropertySchema(
      id: 6,
      name: r'failedReason',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 7,
      name: r'id',
      type: IsarType.string,
    ),
    r'requestId': PropertySchema(
      id: 8,
      name: r'requestId',
      type: IsarType.string,
    ),
    r'statusWire': PropertySchema(
      id: 9,
      name: r'statusWire',
      type: IsarType.string,
    ),
    r'targetKeyValueUsed': PropertySchema(
      id: 10,
      name: r'targetKeyValueUsed',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _requestDeliveryModelEstimateSize,
  serialize: _requestDeliveryModelSerialize,
  deserialize: _requestDeliveryModelDeserialize,
  deserializeProp: _requestDeliveryModelDeserializeProp,
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
    r'requestId_statusWire': IndexSchema(
      id: 3504417357061572176,
      name: r'requestId_statusWire',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'requestId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'statusWire',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _requestDeliveryModelGetId,
  getLinks: _requestDeliveryModelGetLinks,
  attach: _requestDeliveryModelAttach,
  version: '3.3.0-dev.1',
);

int _requestDeliveryModelEstimateSize(
  RequestDeliveryModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.channelWire.length * 3;
  bytesCount += 3 + object.directionWire.length * 3;
  {
    final value = object.externalRef;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.failedReason;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.requestId.length * 3;
  bytesCount += 3 + object.statusWire.length * 3;
  {
    final value = object.targetKeyValueUsed;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _requestDeliveryModelSerialize(
  RequestDeliveryModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.channelWire);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.deliveredAt);
  writer.writeString(offsets[3], object.directionWire);
  writer.writeDateTime(offsets[4], object.dispatchedAt);
  writer.writeString(offsets[5], object.externalRef);
  writer.writeString(offsets[6], object.failedReason);
  writer.writeString(offsets[7], object.id);
  writer.writeString(offsets[8], object.requestId);
  writer.writeString(offsets[9], object.statusWire);
  writer.writeString(offsets[10], object.targetKeyValueUsed);
  writer.writeDateTime(offsets[11], object.updatedAt);
}

RequestDeliveryModel _requestDeliveryModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RequestDeliveryModel(
    channelWire: reader.readString(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    deliveredAt: reader.readDateTimeOrNull(offsets[2]),
    directionWire: reader.readString(offsets[3]),
    dispatchedAt: reader.readDateTimeOrNull(offsets[4]),
    externalRef: reader.readStringOrNull(offsets[5]),
    failedReason: reader.readStringOrNull(offsets[6]),
    id: reader.readString(offsets[7]),
    isarId: id,
    requestId: reader.readString(offsets[8]),
    statusWire: reader.readString(offsets[9]),
    targetKeyValueUsed: reader.readStringOrNull(offsets[10]),
    updatedAt: reader.readDateTime(offsets[11]),
  );
  return object;
}

P _requestDeliveryModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _requestDeliveryModelGetId(RequestDeliveryModel object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _requestDeliveryModelGetLinks(
    RequestDeliveryModel object) {
  return [];
}

void _requestDeliveryModelAttach(
    IsarCollection<dynamic> col, Id id, RequestDeliveryModel object) {
  object.isarId = id;
}

extension RequestDeliveryModelByIndex on IsarCollection<RequestDeliveryModel> {
  Future<RequestDeliveryModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  RequestDeliveryModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<RequestDeliveryModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<RequestDeliveryModel?> getAllByIdSync(List<String> idValues) {
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

  Future<Id> putById(RequestDeliveryModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(RequestDeliveryModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<RequestDeliveryModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<RequestDeliveryModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension RequestDeliveryModelQueryWhereSort
    on QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QWhere> {
  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RequestDeliveryModelQueryWhere
    on QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QWhereClause> {
  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterWhereClause>
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterWhereClause>
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterWhereClause>
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterWhereClause>
      requestIdEqualToAnyStatusWire(String requestId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'requestId_statusWire',
        value: [requestId],
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterWhereClause>
      requestIdNotEqualToAnyStatusWire(String requestId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'requestId_statusWire',
              lower: [],
              upper: [requestId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'requestId_statusWire',
              lower: [requestId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'requestId_statusWire',
              lower: [requestId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'requestId_statusWire',
              lower: [],
              upper: [requestId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterWhereClause>
      requestIdStatusWireEqualTo(String requestId, String statusWire) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'requestId_statusWire',
        value: [requestId, statusWire],
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterWhereClause>
      requestIdEqualToStatusWireNotEqualTo(
          String requestId, String statusWire) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'requestId_statusWire',
              lower: [requestId],
              upper: [requestId, statusWire],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'requestId_statusWire',
              lower: [requestId, statusWire],
              includeLower: false,
              upper: [requestId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'requestId_statusWire',
              lower: [requestId, statusWire],
              includeLower: false,
              upper: [requestId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'requestId_statusWire',
              lower: [requestId],
              upper: [requestId, statusWire],
              includeUpper: false,
            ));
      }
    });
  }
}

extension RequestDeliveryModelQueryFilter on QueryBuilder<RequestDeliveryModel,
    RequestDeliveryModel, QFilterCondition> {
  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> channelWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> channelWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'channelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> channelWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'channelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> channelWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'channelWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> channelWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'channelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> channelWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'channelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
          QAfterFilterCondition>
      channelWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'channelWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
          QAfterFilterCondition>
      channelWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'channelWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> channelWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelWire',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> channelWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'channelWire',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> deliveredAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deliveredAt',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> deliveredAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deliveredAt',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> deliveredAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deliveredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> deliveredAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deliveredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> deliveredAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deliveredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> deliveredAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deliveredAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> directionWireEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'directionWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> directionWireGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'directionWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> directionWireLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'directionWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> directionWireBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'directionWire',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> directionWireStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'directionWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> directionWireEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'directionWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
          QAfterFilterCondition>
      directionWireContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'directionWire',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
          QAfterFilterCondition>
      directionWireMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'directionWire',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> directionWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'directionWire',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> directionWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'directionWire',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> dispatchedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dispatchedAt',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> dispatchedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dispatchedAt',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> dispatchedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dispatchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> dispatchedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dispatchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> dispatchedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dispatchedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> dispatchedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dispatchedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> externalRefIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'externalRef',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> externalRefIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'externalRef',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> externalRefEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> externalRefGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'externalRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> externalRefLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'externalRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> externalRefBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'externalRef',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> externalRefStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'externalRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> externalRefEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'externalRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
          QAfterFilterCondition>
      externalRefContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'externalRef',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
          QAfterFilterCondition>
      externalRefMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'externalRef',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> externalRefIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'externalRef',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> externalRefIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'externalRef',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> failedReasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'failedReason',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> failedReasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'failedReason',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> failedReasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'failedReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> failedReasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'failedReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> failedReasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'failedReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> failedReasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'failedReason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> failedReasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'failedReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> failedReasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'failedReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
          QAfterFilterCondition>
      failedReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'failedReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
          QAfterFilterCondition>
      failedReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'failedReason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> failedReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'failedReason',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> failedReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'failedReason',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> requestIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'requestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> requestIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'requestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> requestIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'requestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> requestIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'requestId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> requestIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'requestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> requestIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'requestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
          QAfterFilterCondition>
      requestIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'requestId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
          QAfterFilterCondition>
      requestIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'requestId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> requestIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'requestId',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> requestIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'requestId',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> statusWireIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusWire',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> statusWireIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statusWire',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> targetKeyValueUsedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetKeyValueUsed',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> targetKeyValueUsedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetKeyValueUsed',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> targetKeyValueUsedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetKeyValueUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> targetKeyValueUsedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetKeyValueUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> targetKeyValueUsedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetKeyValueUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> targetKeyValueUsedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetKeyValueUsed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> targetKeyValueUsedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetKeyValueUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> targetKeyValueUsedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetKeyValueUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
          QAfterFilterCondition>
      targetKeyValueUsedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetKeyValueUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
          QAfterFilterCondition>
      targetKeyValueUsedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetKeyValueUsed',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> targetKeyValueUsedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetKeyValueUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> targetKeyValueUsedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetKeyValueUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel,
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

extension RequestDeliveryModelQueryObject on QueryBuilder<RequestDeliveryModel,
    RequestDeliveryModel, QFilterCondition> {}

extension RequestDeliveryModelQueryLinks on QueryBuilder<RequestDeliveryModel,
    RequestDeliveryModel, QFilterCondition> {}

extension RequestDeliveryModelQuerySortBy
    on QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QSortBy> {
  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByChannelWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelWire', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByChannelWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelWire', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByDeliveredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveredAt', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByDeliveredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveredAt', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByDirectionWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'directionWire', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByDirectionWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'directionWire', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByDispatchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dispatchedAt', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByDispatchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dispatchedAt', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByExternalRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalRef', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByExternalRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalRef', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByFailedReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedReason', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByFailedReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedReason', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByRequestId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestId', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByRequestIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestId', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByStatusWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusWire', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByStatusWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusWire', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByTargetKeyValueUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetKeyValueUsed', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByTargetKeyValueUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetKeyValueUsed', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension RequestDeliveryModelQuerySortThenBy
    on QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QSortThenBy> {
  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByChannelWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelWire', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByChannelWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelWire', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByDeliveredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveredAt', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByDeliveredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deliveredAt', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByDirectionWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'directionWire', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByDirectionWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'directionWire', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByDispatchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dispatchedAt', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByDispatchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dispatchedAt', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByExternalRef() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalRef', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByExternalRefDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'externalRef', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByFailedReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedReason', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByFailedReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedReason', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByRequestId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestId', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByRequestIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requestId', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByStatusWire() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusWire', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByStatusWireDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusWire', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByTargetKeyValueUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetKeyValueUsed', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByTargetKeyValueUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetKeyValueUsed', Sort.desc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension RequestDeliveryModelQueryWhereDistinct
    on QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QDistinct> {
  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QDistinct>
      distinctByChannelWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'channelWire', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QDistinct>
      distinctByDeliveredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deliveredAt');
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QDistinct>
      distinctByDirectionWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'directionWire',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QDistinct>
      distinctByDispatchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dispatchedAt');
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QDistinct>
      distinctByExternalRef({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'externalRef', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QDistinct>
      distinctByFailedReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'failedReason', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QDistinct>
      distinctByRequestId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'requestId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QDistinct>
      distinctByStatusWire({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusWire', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QDistinct>
      distinctByTargetKeyValueUsed({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetKeyValueUsed',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RequestDeliveryModel, RequestDeliveryModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension RequestDeliveryModelQueryProperty on QueryBuilder<
    RequestDeliveryModel, RequestDeliveryModel, QQueryProperty> {
  QueryBuilder<RequestDeliveryModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<RequestDeliveryModel, String, QQueryOperations>
      channelWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'channelWire');
    });
  }

  QueryBuilder<RequestDeliveryModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<RequestDeliveryModel, DateTime?, QQueryOperations>
      deliveredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deliveredAt');
    });
  }

  QueryBuilder<RequestDeliveryModel, String, QQueryOperations>
      directionWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'directionWire');
    });
  }

  QueryBuilder<RequestDeliveryModel, DateTime?, QQueryOperations>
      dispatchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dispatchedAt');
    });
  }

  QueryBuilder<RequestDeliveryModel, String?, QQueryOperations>
      externalRefProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'externalRef');
    });
  }

  QueryBuilder<RequestDeliveryModel, String?, QQueryOperations>
      failedReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'failedReason');
    });
  }

  QueryBuilder<RequestDeliveryModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RequestDeliveryModel, String, QQueryOperations>
      requestIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'requestId');
    });
  }

  QueryBuilder<RequestDeliveryModel, String, QQueryOperations>
      statusWireProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusWire');
    });
  }

  QueryBuilder<RequestDeliveryModel, String?, QQueryOperations>
      targetKeyValueUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetKeyValueUsed');
    });
  }

  QueryBuilder<RequestDeliveryModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestDeliveryModel _$RequestDeliveryModelFromJson(
        Map<String, dynamic> json) =>
    RequestDeliveryModel(
      isarId: (json['isarId'] as num?)?.toInt(),
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      channelWire: json['channelWire'] as String,
      directionWire: json['directionWire'] as String,
      statusWire: json['statusWire'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      externalRef: json['externalRef'] as String?,
      targetKeyValueUsed: json['targetKeyValueUsed'] as String?,
      dispatchedAt: json['dispatchedAt'] == null
          ? null
          : DateTime.parse(json['dispatchedAt'] as String),
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
      failedReason: json['failedReason'] as String?,
    );

Map<String, dynamic> _$RequestDeliveryModelToJson(
        RequestDeliveryModel instance) =>
    <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.id,
      'requestId': instance.requestId,
      'channelWire': instance.channelWire,
      'directionWire': instance.directionWire,
      'statusWire': instance.statusWire,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'externalRef': instance.externalRef,
      'targetKeyValueUsed': instance.targetKeyValueUsed,
      'dispatchedAt': instance.dispatchedAt?.toIso8601String(),
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
      'failedReason': instance.failedReason,
    };
