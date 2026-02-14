// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRestaurantCollection on Isar {
  IsarCollection<Restaurant> get restaurants => this.collection();
}

const RestaurantSchema = CollectionSchema(
  name: r'Restaurant',
  id: -2985775126615523729,
  properties: {
    r'breakfastHours': PropertySchema(
      id: 0,
      name: r'breakfastHours',
      type: IsarType.string,
    ),
    r'dinnerHours': PropertySchema(
      id: 1,
      name: r'dinnerHours',
      type: IsarType.string,
    ),
    r'lunchHours': PropertySchema(
      id: 2,
      name: r'lunchHours',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 3, name: r'name', type: IsarType.string),
  },

  estimateSize: _restaurantEstimateSize,
  serialize: _restaurantSerialize,
  deserialize: _restaurantDeserialize,
  deserializeProp: _restaurantDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {
    r'meals': LinkSchema(
      id: 7908173678700566292,
      name: r'meals',
      target: r'Meal',
      single: false,
      linkName: r'restaurant',
    ),
  },
  embeddedSchemas: {},

  getId: _restaurantGetId,
  getLinks: _restaurantGetLinks,
  attach: _restaurantAttach,
  version: '3.3.0',
);

int _restaurantEstimateSize(
  Restaurant object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.breakfastHours.length * 3;
  bytesCount += 3 + object.dinnerHours.length * 3;
  bytesCount += 3 + object.lunchHours.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _restaurantSerialize(
  Restaurant object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.breakfastHours);
  writer.writeString(offsets[1], object.dinnerHours);
  writer.writeString(offsets[2], object.lunchHours);
  writer.writeString(offsets[3], object.name);
}

Restaurant _restaurantDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Restaurant();
  object.breakfastHours = reader.readString(offsets[0]);
  object.dinnerHours = reader.readString(offsets[1]);
  object.id = id;
  object.lunchHours = reader.readString(offsets[2]);
  object.name = reader.readString(offsets[3]);
  return object;
}

P _restaurantDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _restaurantGetId(Restaurant object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _restaurantGetLinks(Restaurant object) {
  return [object.meals];
}

void _restaurantAttach(IsarCollection<dynamic> col, Id id, Restaurant object) {
  object.id = id;
  object.meals.attach(col, col.isar.collection<Meal>(), r'meals', id);
}

extension RestaurantByIndex on IsarCollection<Restaurant> {
  Future<Restaurant?> getByName(String name) {
    return getByIndex(r'name', [name]);
  }

  Restaurant? getByNameSync(String name) {
    return getByIndexSync(r'name', [name]);
  }

  Future<bool> deleteByName(String name) {
    return deleteByIndex(r'name', [name]);
  }

  bool deleteByNameSync(String name) {
    return deleteByIndexSync(r'name', [name]);
  }

  Future<List<Restaurant?>> getAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndex(r'name', values);
  }

  List<Restaurant?> getAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'name', values);
  }

  Future<int> deleteAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'name', values);
  }

  int deleteAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'name', values);
  }

  Future<Id> putByName(Restaurant object) {
    return putByIndex(r'name', object);
  }

  Id putByNameSync(Restaurant object, {bool saveLinks = true}) {
    return putByIndexSync(r'name', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByName(List<Restaurant> objects) {
    return putAllByIndex(r'name', objects);
  }

  List<Id> putAllByNameSync(List<Restaurant> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'name', objects, saveLinks: saveLinks);
  }
}

extension RestaurantQueryWhereSort
    on QueryBuilder<Restaurant, Restaurant, QWhere> {
  QueryBuilder<Restaurant, Restaurant, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RestaurantQueryWhere
    on QueryBuilder<Restaurant, Restaurant, QWhereClause> {
  QueryBuilder<Restaurant, Restaurant, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Restaurant, Restaurant, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterWhereClause> idBetween(
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

  QueryBuilder<Restaurant, Restaurant, QAfterWhereClause> nameEqualTo(
    String name,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'name', value: [name]),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterWhereClause> nameNotEqualTo(
    String name,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [name],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'name',
                lower: [],
                upper: [name],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension RestaurantQueryFilter
    on QueryBuilder<Restaurant, Restaurant, QFilterCondition> {
  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  breakfastHoursEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'breakfastHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  breakfastHoursGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'breakfastHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  breakfastHoursLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'breakfastHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  breakfastHoursBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'breakfastHours',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  breakfastHoursStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'breakfastHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  breakfastHoursEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'breakfastHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  breakfastHoursContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'breakfastHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  breakfastHoursMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'breakfastHours',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  breakfastHoursIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'breakfastHours', value: ''),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  breakfastHoursIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'breakfastHours', value: ''),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  dinnerHoursEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dinnerHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  dinnerHoursGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dinnerHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  dinnerHoursLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dinnerHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  dinnerHoursBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dinnerHours',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  dinnerHoursStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dinnerHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  dinnerHoursEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dinnerHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  dinnerHoursContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dinnerHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  dinnerHoursMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dinnerHours',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  dinnerHoursIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dinnerHours', value: ''),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  dinnerHoursIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dinnerHours', value: ''),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> lunchHoursEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lunchHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  lunchHoursGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lunchHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  lunchHoursLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lunchHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> lunchHoursBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lunchHours',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  lunchHoursStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'lunchHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  lunchHoursEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'lunchHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  lunchHoursContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'lunchHours',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> lunchHoursMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'lunchHours',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  lunchHoursIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lunchHours', value: ''),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  lunchHoursIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'lunchHours', value: ''),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }
}

extension RestaurantQueryObject
    on QueryBuilder<Restaurant, Restaurant, QFilterCondition> {}

extension RestaurantQueryLinks
    on QueryBuilder<Restaurant, Restaurant, QFilterCondition> {
  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> meals(
    FilterQuery<Meal> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'meals');
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  mealsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'meals', length, true, length, true);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition> mealsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'meals', 0, true, 0, true);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  mealsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'meals', 0, false, 999999, true);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  mealsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'meals', 0, true, length, include);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  mealsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'meals', length, include, 999999, true);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterFilterCondition>
  mealsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'meals',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension RestaurantQuerySortBy
    on QueryBuilder<Restaurant, Restaurant, QSortBy> {
  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> sortByBreakfastHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakfastHours', Sort.asc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy>
  sortByBreakfastHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakfastHours', Sort.desc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> sortByDinnerHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dinnerHours', Sort.asc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> sortByDinnerHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dinnerHours', Sort.desc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> sortByLunchHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lunchHours', Sort.asc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> sortByLunchHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lunchHours', Sort.desc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension RestaurantQuerySortThenBy
    on QueryBuilder<Restaurant, Restaurant, QSortThenBy> {
  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> thenByBreakfastHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakfastHours', Sort.asc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy>
  thenByBreakfastHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breakfastHours', Sort.desc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> thenByDinnerHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dinnerHours', Sort.asc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> thenByDinnerHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dinnerHours', Sort.desc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> thenByLunchHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lunchHours', Sort.asc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> thenByLunchHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lunchHours', Sort.desc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension RestaurantQueryWhereDistinct
    on QueryBuilder<Restaurant, Restaurant, QDistinct> {
  QueryBuilder<Restaurant, Restaurant, QDistinct> distinctByBreakfastHours({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'breakfastHours',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Restaurant, Restaurant, QDistinct> distinctByDinnerHours({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dinnerHours', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QDistinct> distinctByLunchHours({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lunchHours', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Restaurant, Restaurant, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension RestaurantQueryProperty
    on QueryBuilder<Restaurant, Restaurant, QQueryProperty> {
  QueryBuilder<Restaurant, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Restaurant, String, QQueryOperations> breakfastHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breakfastHours');
    });
  }

  QueryBuilder<Restaurant, String, QQueryOperations> dinnerHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dinnerHours');
    });
  }

  QueryBuilder<Restaurant, String, QQueryOperations> lunchHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lunchHours');
    });
  }

  QueryBuilder<Restaurant, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
