// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_state_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWorkspaceStateModelCollection on Isar {
  IsarCollection<WorkspaceStateModel> get workspaceStateModels =>
      this.collection();
}

const WorkspaceStateModelSchema = CollectionSchema(
  name: r'WorkspaceStateModel',
  id: -2838591453273247845,
  properties: {
    r'activeWorkspaceId': PropertySchema(
      id: 0,
      name: r'activeWorkspaceId',
      type: IsarType.string,
    ),
    r'mruQueue': PropertySchema(
      id: 1,
      name: r'mruQueue',
      type: IsarType.stringList,
    ),
    r'updatedAt': PropertySchema(
      id: 2,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _workspaceStateModelEstimateSize,
  serialize: _workspaceStateModelSerialize,
  deserialize: _workspaceStateModelDeserialize,
  deserializeProp: _workspaceStateModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _workspaceStateModelGetId,
  getLinks: _workspaceStateModelGetLinks,
  attach: _workspaceStateModelAttach,
  version: '3.2.0-dev.2',
);

int _workspaceStateModelEstimateSize(
  WorkspaceStateModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.activeWorkspaceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.mruQueue.length * 3;
  {
    for (var i = 0; i < object.mruQueue.length; i++) {
      final value = object.mruQueue[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _workspaceStateModelSerialize(
  WorkspaceStateModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activeWorkspaceId);
  writer.writeStringList(offsets[1], object.mruQueue);
  writer.writeDateTime(offsets[2], object.updatedAt);
}

WorkspaceStateModel _workspaceStateModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WorkspaceStateModel();
  object.activeWorkspaceId = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.mruQueue = reader.readStringList(offsets[1]) ?? [];
  object.updatedAt = reader.readDateTimeOrNull(offsets[2]);
  return object;
}

P _workspaceStateModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _workspaceStateModelGetId(WorkspaceStateModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _workspaceStateModelGetLinks(
    WorkspaceStateModel object) {
  return [];
}

void _workspaceStateModelAttach(
    IsarCollection<dynamic> col, Id id, WorkspaceStateModel object) {
  object.id = id;
}

extension WorkspaceStateModelQueryWhereSort
    on QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QWhere> {
  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WorkspaceStateModelQueryWhere
    on QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QWhereClause> {
  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterWhereClause>
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

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterWhereClause>
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
}

extension WorkspaceStateModelQueryFilter on QueryBuilder<WorkspaceStateModel,
    WorkspaceStateModel, QFilterCondition> {
  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      activeWorkspaceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'activeWorkspaceId',
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      activeWorkspaceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'activeWorkspaceId',
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      activeWorkspaceIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      activeWorkspaceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activeWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      activeWorkspaceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activeWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      activeWorkspaceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activeWorkspaceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      activeWorkspaceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activeWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      activeWorkspaceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activeWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      activeWorkspaceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activeWorkspaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      activeWorkspaceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activeWorkspaceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      activeWorkspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activeWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      activeWorkspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activeWorkspaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mruQueue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mruQueue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mruQueue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mruQueue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mruQueue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mruQueue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mruQueue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mruQueue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mruQueue',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mruQueue',
        value: '',
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mruQueue',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mruQueue',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mruQueue',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mruQueue',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mruQueue',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      mruQueueLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'mruQueue',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime? value, {
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

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime? value, {
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

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterFilterCondition>
      updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
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

extension WorkspaceStateModelQueryObject on QueryBuilder<WorkspaceStateModel,
    WorkspaceStateModel, QFilterCondition> {}

extension WorkspaceStateModelQueryLinks on QueryBuilder<WorkspaceStateModel,
    WorkspaceStateModel, QFilterCondition> {}

extension WorkspaceStateModelQuerySortBy
    on QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QSortBy> {
  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterSortBy>
      sortByActiveWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterSortBy>
      sortByActiveWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension WorkspaceStateModelQuerySortThenBy
    on QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QSortThenBy> {
  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterSortBy>
      thenByActiveWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeWorkspaceId', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterSortBy>
      thenByActiveWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeWorkspaceId', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension WorkspaceStateModelQueryWhereDistinct
    on QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QDistinct> {
  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QDistinct>
      distinctByActiveWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeWorkspaceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QDistinct>
      distinctByMruQueue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mruQueue');
    });
  }

  QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension WorkspaceStateModelQueryProperty
    on QueryBuilder<WorkspaceStateModel, WorkspaceStateModel, QQueryProperty> {
  QueryBuilder<WorkspaceStateModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WorkspaceStateModel, String?, QQueryOperations>
      activeWorkspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeWorkspaceId');
    });
  }

  QueryBuilder<WorkspaceStateModel, List<String>, QQueryOperations>
      mruQueueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mruQueue');
    });
  }

  QueryBuilder<WorkspaceStateModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
