// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_cache_status.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMenuCacheStatusCollection on Isar {
  IsarCollection<MenuCacheStatus> get menuCacheStatuses => this.collection();
}

const MenuCacheStatusSchema = CollectionSchema(
  name: r'MenuCacheStatus',
  id: 6003064348504363799,
  properties: {
    r'date': PropertySchema(id: 0, name: r'date', type: IsarType.dateTime),
    r'lastFetchedAt': PropertySchema(
      id: 1,
      name: r'lastFetchedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _menuCacheStatusEstimateSize,
  serialize: _menuCacheStatusSerialize,
  deserialize: _menuCacheStatusDeserialize,
  deserializeProp: _menuCacheStatusDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _menuCacheStatusGetId,
  getLinks: _menuCacheStatusGetLinks,
  attach: _menuCacheStatusAttach,
  version: '3.3.0',
);

int _menuCacheStatusEstimateSize(
  MenuCacheStatus object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _menuCacheStatusSerialize(
  MenuCacheStatus object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeDateTime(offsets[1], object.lastFetchedAt);
}

MenuCacheStatus _menuCacheStatusDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MenuCacheStatus();
  object.date = reader.readDateTime(offsets[0]);
  object.id = id;
  object.lastFetchedAt = reader.readDateTime(offsets[1]);
  return object;
}

P _menuCacheStatusDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _menuCacheStatusGetId(MenuCacheStatus object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _menuCacheStatusGetLinks(MenuCacheStatus object) {
  return [];
}

void _menuCacheStatusAttach(
  IsarCollection<dynamic> col,
  Id id,
  MenuCacheStatus object,
) {
  object.id = id;
}

extension MenuCacheStatusByIndex on IsarCollection<MenuCacheStatus> {
  Future<MenuCacheStatus?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  MenuCacheStatus? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<MenuCacheStatus?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<MenuCacheStatus?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(MenuCacheStatus object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(MenuCacheStatus object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<MenuCacheStatus> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(
    List<MenuCacheStatus> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension MenuCacheStatusQueryWhereSort
    on QueryBuilder<MenuCacheStatus, MenuCacheStatus, QWhere> {
  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension MenuCacheStatusQueryWhere
    on QueryBuilder<MenuCacheStatus, MenuCacheStatus, QWhereClause> {
  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterWhereClause>
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

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterWhereClause> dateEqualTo(
    DateTime date,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'date', value: [date]),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterWhereClause>
  dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterWhereClause>
  dateGreaterThan(DateTime date, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [date],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterWhereClause>
  dateLessThan(DateTime date, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [],
          upper: [date],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [lowerDate],
          includeLower: includeLower,
          upper: [upperDate],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MenuCacheStatusQueryFilter
    on QueryBuilder<MenuCacheStatus, MenuCacheStatus, QFilterCondition> {
  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterFilterCondition>
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterFilterCondition>
  dateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterFilterCondition>
  dateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterFilterCondition>
  dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterFilterCondition>
  lastFetchedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastFetchedAt', value: value),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterFilterCondition>
  lastFetchedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastFetchedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterFilterCondition>
  lastFetchedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastFetchedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterFilterCondition>
  lastFetchedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastFetchedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MenuCacheStatusQueryObject
    on QueryBuilder<MenuCacheStatus, MenuCacheStatus, QFilterCondition> {}

extension MenuCacheStatusQueryLinks
    on QueryBuilder<MenuCacheStatus, MenuCacheStatus, QFilterCondition> {}

extension MenuCacheStatusQuerySortBy
    on QueryBuilder<MenuCacheStatus, MenuCacheStatus, QSortBy> {
  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterSortBy>
  sortByLastFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchedAt', Sort.asc);
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterSortBy>
  sortByLastFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchedAt', Sort.desc);
    });
  }
}

extension MenuCacheStatusQuerySortThenBy
    on QueryBuilder<MenuCacheStatus, MenuCacheStatus, QSortThenBy> {
  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterSortBy>
  thenByLastFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchedAt', Sort.asc);
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QAfterSortBy>
  thenByLastFetchedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastFetchedAt', Sort.desc);
    });
  }
}

extension MenuCacheStatusQueryWhereDistinct
    on QueryBuilder<MenuCacheStatus, MenuCacheStatus, QDistinct> {
  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<MenuCacheStatus, MenuCacheStatus, QDistinct>
  distinctByLastFetchedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastFetchedAt');
    });
  }
}

extension MenuCacheStatusQueryProperty
    on QueryBuilder<MenuCacheStatus, MenuCacheStatus, QQueryProperty> {
  QueryBuilder<MenuCacheStatus, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MenuCacheStatus, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<MenuCacheStatus, DateTime, QQueryOperations>
  lastFetchedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastFetchedAt');
    });
  }
}
