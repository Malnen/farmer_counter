// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas, always_specify_types, unused_element, unnecessary_non_null_assertion

part of '../../models/counter_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCounterItemCollection on Isar {
  IsarCollection<CounterItem> get counterItems => this.collection();
}

const CounterItemSchema = CollectionSchema(
  name: r'CounterItem',
  id: 9077968144829314720,
  properties: {
    r'count': PropertySchema(
      id: 0,
      name: r'count',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'guid': PropertySchema(
      id: 2,
      name: r'guid',
      type: IsarType.string,
    ),
    r'hashCode': PropertySchema(
      id: 3,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'lastSelectedChartType': PropertySchema(
      id: 4,
      name: r'lastSelectedChartType',
      type: IsarType.byte,
      enumMap: _CounterItemlastSelectedChartTypeEnumValueMap,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _counterItemEstimateSize,
  serialize: _counterItemSerialize,
  deserialize: _counterItemDeserialize,
  deserializeProp: _counterItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'guid': IndexSchema(
      id: 4245463075130215835,
      name: r'guid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'guid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _counterItemGetId,
  getLinks: _counterItemGetLinks,
  attach: _counterItemAttach,
  version: '3.2.0-dev.2',
);

int _counterItemEstimateSize(
  CounterItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.guid.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _counterItemSerialize(
  CounterItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.count);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.guid);
  writer.writeLong(offsets[3], object.hashCode);
  writer.writeByte(offsets[4], object.lastSelectedChartType.index);
  writer.writeString(offsets[5], object.name);
}

CounterItem _counterItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CounterItem(
    count: reader.readLong(offsets[0]),
    createdAt: reader.readDateTime(offsets[1]),
    guid: reader.readString(offsets[2]),
    id: id,
    lastSelectedChartType: _CounterItemlastSelectedChartTypeValueEnumMap[
            reader.readByteOrNull(offsets[4])] ??
        CounterChartType.bar,
    name: reader.readString(offsets[5]),
  );
  return object;
}

P _counterItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (_CounterItemlastSelectedChartTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          CounterChartType.bar) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CounterItemlastSelectedChartTypeEnumValueMap = {
  'bar': 0,
  'line': 1,
};
const _CounterItemlastSelectedChartTypeValueEnumMap = {
  0: CounterChartType.bar,
  1: CounterChartType.line,
};

Id _counterItemGetId(CounterItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _counterItemGetLinks(CounterItem object) {
  return [];
}

void _counterItemAttach(
    IsarCollection<dynamic> col, Id id, CounterItem object) {}

extension CounterItemByIndex on IsarCollection<CounterItem> {
  Future<CounterItem?> getByGuid(String guid) {
    return getByIndex(r'guid', [guid]);
  }

  CounterItem? getByGuidSync(String guid) {
    return getByIndexSync(r'guid', [guid]);
  }

  Future<bool> deleteByGuid(String guid) {
    return deleteByIndex(r'guid', [guid]);
  }

  bool deleteByGuidSync(String guid) {
    return deleteByIndexSync(r'guid', [guid]);
  }

  Future<List<CounterItem?>> getAllByGuid(List<String> guidValues) {
    final values = guidValues.map((e) => [e]).toList();
    return getAllByIndex(r'guid', values);
  }

  List<CounterItem?> getAllByGuidSync(List<String> guidValues) {
    final values = guidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'guid', values);
  }

  Future<int> deleteAllByGuid(List<String> guidValues) {
    final values = guidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'guid', values);
  }

  int deleteAllByGuidSync(List<String> guidValues) {
    final values = guidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'guid', values);
  }

  Future<Id> putByGuid(CounterItem object) {
    return putByIndex(r'guid', object);
  }

  Id putByGuidSync(CounterItem object, {bool saveLinks = true}) {
    return putByIndexSync(r'guid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByGuid(List<CounterItem> objects) {
    return putAllByIndex(r'guid', objects);
  }

  List<Id> putAllByGuidSync(List<CounterItem> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'guid', objects, saveLinks: saveLinks);
  }
}

extension CounterItemQueryWhereSort
    on QueryBuilder<CounterItem, CounterItem, QWhere> {
  QueryBuilder<CounterItem, CounterItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CounterItemQueryWhere
    on QueryBuilder<CounterItem, CounterItem, QWhereClause> {
  QueryBuilder<CounterItem, CounterItem, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<CounterItem, CounterItem, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterWhereClause> idBetween(
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

  QueryBuilder<CounterItem, CounterItem, QAfterWhereClause> guidEqualTo(
      String guid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'guid',
        value: [guid],
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterWhereClause> guidNotEqualTo(
      String guid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'guid',
              lower: [],
              upper: [guid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'guid',
              lower: [guid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'guid',
              lower: [guid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'guid',
              lower: [],
              upper: [guid],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CounterItemQueryFilter
    on QueryBuilder<CounterItem, CounterItem, QFilterCondition> {
  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> countEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition>
      countGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> countLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> countBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'count',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> guidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'guid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> guidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'guid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> guidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'guid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> guidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'guid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> guidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'guid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> guidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'guid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> guidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'guid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> guidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'guid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> guidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'guid',
        value: '',
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition>
      guidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'guid',
        value: '',
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition>
      lastSelectedChartTypeEqualTo(CounterChartType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSelectedChartType',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition>
      lastSelectedChartTypeGreaterThan(
    CounterChartType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSelectedChartType',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition>
      lastSelectedChartTypeLessThan(
    CounterChartType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSelectedChartType',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition>
      lastSelectedChartTypeBetween(
    CounterChartType lower,
    CounterChartType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSelectedChartType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension CounterItemQueryObject
    on QueryBuilder<CounterItem, CounterItem, QFilterCondition> {}

extension CounterItemQueryLinks
    on QueryBuilder<CounterItem, CounterItem, QFilterCondition> {}

extension CounterItemQuerySortBy
    on QueryBuilder<CounterItem, CounterItem, QSortBy> {
  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> sortByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> sortByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> sortByGuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guid', Sort.asc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> sortByGuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guid', Sort.desc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy>
      sortByLastSelectedChartType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSelectedChartType', Sort.asc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy>
      sortByLastSelectedChartTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSelectedChartType', Sort.desc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CounterItemQuerySortThenBy
    on QueryBuilder<CounterItem, CounterItem, QSortThenBy> {
  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> thenByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> thenByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> thenByGuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guid', Sort.asc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> thenByGuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'guid', Sort.desc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy>
      thenByLastSelectedChartType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSelectedChartType', Sort.asc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy>
      thenByLastSelectedChartTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSelectedChartType', Sort.desc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CounterItemQueryWhereDistinct
    on QueryBuilder<CounterItem, CounterItem, QDistinct> {
  QueryBuilder<CounterItem, CounterItem, QDistinct> distinctByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'count');
    });
  }

  QueryBuilder<CounterItem, CounterItem, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CounterItem, CounterItem, QDistinct> distinctByGuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'guid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CounterItem, CounterItem, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<CounterItem, CounterItem, QDistinct>
      distinctByLastSelectedChartType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSelectedChartType');
    });
  }

  QueryBuilder<CounterItem, CounterItem, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension CounterItemQueryProperty
    on QueryBuilder<CounterItem, CounterItem, QQueryProperty> {
  QueryBuilder<CounterItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CounterItem, int, QQueryOperations> countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'count');
    });
  }

  QueryBuilder<CounterItem, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CounterItem, String, QQueryOperations> guidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'guid');
    });
  }

  QueryBuilder<CounterItem, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<CounterItem, CounterChartType, QQueryOperations>
      lastSelectedChartTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSelectedChartType');
    });
  }

  QueryBuilder<CounterItem, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterItem _$CounterItemFromJson(Map<String, dynamic> json) => CounterItem(
      guid: json['guid'] as String,
      name: json['name'] as String,
      count: (json['count'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      id: (json['id'] as num).toInt(),
      lastSelectedChartType: $enumDecodeNullable(
              _$CounterChartTypeEnumMap, json['lastSelectedChartType']) ??
          CounterChartType.bar,
    );

Map<String, dynamic> _$CounterItemToJson(CounterItem instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'name': instance.name,
      'count': instance.count,
      'createdAt': instance.createdAt.toIso8601String(),
      'id': instance.id,
      'lastSelectedChartType':
          _$CounterChartTypeEnumMap[instance.lastSelectedChartType]!,
    };

const _$CounterChartTypeEnumMap = {
  CounterChartType.bar: 'bar',
  CounterChartType.line: 'line',
};
