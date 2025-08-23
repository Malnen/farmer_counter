// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas, always_specify_types, unused_element, unnecessary_non_null_assertion

part of '../../models/counter_change_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCounterChangeItemCollection on Isar {
  IsarCollection<CounterChangeItem> get counterChangeItems => this.collection();
}

const CounterChangeItemSchema = CollectionSchema(
  name: r'CounterChangeItem',
  id: 7662396288480724886,
  properties: {
    r'at': PropertySchema(
      id: 0,
      name: r'at',
      type: IsarType.dateTime,
    ),
    r'counterGuid': PropertySchema(
      id: 1,
      name: r'counterGuid',
      type: IsarType.string,
    ),
    r'delta': PropertySchema(
      id: 2,
      name: r'delta',
      type: IsarType.long,
    ),
    r'hashCode': PropertySchema(
      id: 3,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'newValue': PropertySchema(
      id: 4,
      name: r'newValue',
      type: IsarType.long,
    )
  },
  estimateSize: _counterChangeItemEstimateSize,
  serialize: _counterChangeItemSerialize,
  deserialize: _counterChangeItemDeserialize,
  deserializeProp: _counterChangeItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'counterGuid_at': IndexSchema(
      id: -6768483186234645421,
      name: r'counterGuid_at',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'counterGuid',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'at',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'at': IndexSchema(
      id: 1454144528255648370,
      name: r'at',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'at',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _counterChangeItemGetId,
  getLinks: _counterChangeItemGetLinks,
  attach: _counterChangeItemAttach,
  version: '3.2.0-dev.2',
);

int _counterChangeItemEstimateSize(
  CounterChangeItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.counterGuid.length * 3;
  return bytesCount;
}

void _counterChangeItemSerialize(
  CounterChangeItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.at);
  writer.writeString(offsets[1], object.counterGuid);
  writer.writeLong(offsets[2], object.delta);
  writer.writeLong(offsets[3], object.hashCode);
  writer.writeLong(offsets[4], object.newValue);
}

CounterChangeItem _counterChangeItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CounterChangeItem(
    at: reader.readDateTime(offsets[0]),
    counterGuid: reader.readString(offsets[1]),
    delta: reader.readLong(offsets[2]),
    id: id,
    newValue: reader.readLong(offsets[4]),
  );
  return object;
}

P _counterChangeItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _counterChangeItemGetId(CounterChangeItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _counterChangeItemGetLinks(
    CounterChangeItem object) {
  return [];
}

void _counterChangeItemAttach(
    IsarCollection<dynamic> col, Id id, CounterChangeItem object) {}

extension CounterChangeItemQueryWhereSort
    on QueryBuilder<CounterChangeItem, CounterChangeItem, QWhere> {
  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhere> anyAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'at'),
      );
    });
  }
}

extension CounterChangeItemQueryWhere
    on QueryBuilder<CounterChangeItem, CounterChangeItem, QWhereClause> {
  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
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

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
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

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      counterGuidEqualToAnyAt(String counterGuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'counterGuid_at',
        value: [counterGuid],
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      counterGuidNotEqualToAnyAt(String counterGuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'counterGuid_at',
              lower: [],
              upper: [counterGuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'counterGuid_at',
              lower: [counterGuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'counterGuid_at',
              lower: [counterGuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'counterGuid_at',
              lower: [],
              upper: [counterGuid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      counterGuidAtEqualTo(String counterGuid, DateTime at) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'counterGuid_at',
        value: [counterGuid, at],
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      counterGuidEqualToAtNotEqualTo(String counterGuid, DateTime at) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'counterGuid_at',
              lower: [counterGuid],
              upper: [counterGuid, at],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'counterGuid_at',
              lower: [counterGuid, at],
              includeLower: false,
              upper: [counterGuid],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'counterGuid_at',
              lower: [counterGuid, at],
              includeLower: false,
              upper: [counterGuid],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'counterGuid_at',
              lower: [counterGuid],
              upper: [counterGuid, at],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      counterGuidEqualToAtGreaterThan(
    String counterGuid,
    DateTime at, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'counterGuid_at',
        lower: [counterGuid, at],
        includeLower: include,
        upper: [counterGuid],
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      counterGuidEqualToAtLessThan(
    String counterGuid,
    DateTime at, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'counterGuid_at',
        lower: [counterGuid],
        upper: [counterGuid, at],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      counterGuidEqualToAtBetween(
    String counterGuid,
    DateTime lowerAt,
    DateTime upperAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'counterGuid_at',
        lower: [counterGuid, lowerAt],
        includeLower: includeLower,
        upper: [counterGuid, upperAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      atEqualTo(DateTime at) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'at',
        value: [at],
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      atNotEqualTo(DateTime at) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'at',
              lower: [],
              upper: [at],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'at',
              lower: [at],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'at',
              lower: [at],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'at',
              lower: [],
              upper: [at],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      atGreaterThan(
    DateTime at, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'at',
        lower: [at],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      atLessThan(
    DateTime at, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'at',
        lower: [],
        upper: [at],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterWhereClause>
      atBetween(
    DateTime lowerAt,
    DateTime upperAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'at',
        lower: [lowerAt],
        includeLower: includeLower,
        upper: [upperAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CounterChangeItemQueryFilter
    on QueryBuilder<CounterChangeItem, CounterChangeItem, QFilterCondition> {
  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      atEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'at',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      atGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'at',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      atLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'at',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      atBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'at',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      counterGuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'counterGuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      counterGuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'counterGuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      counterGuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'counterGuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      counterGuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'counterGuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      counterGuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'counterGuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      counterGuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'counterGuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      counterGuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'counterGuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      counterGuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'counterGuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      counterGuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'counterGuid',
        value: '',
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      counterGuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'counterGuid',
        value: '',
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      deltaEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'delta',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      deltaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'delta',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      deltaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'delta',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      deltaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'delta',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
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

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
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

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      hashCodeBetween(
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

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
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

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
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

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
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

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      newValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'newValue',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      newValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'newValue',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      newValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'newValue',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterFilterCondition>
      newValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'newValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CounterChangeItemQueryObject
    on QueryBuilder<CounterChangeItem, CounterChangeItem, QFilterCondition> {}

extension CounterChangeItemQueryLinks
    on QueryBuilder<CounterChangeItem, CounterChangeItem, QFilterCondition> {}

extension CounterChangeItemQuerySortBy
    on QueryBuilder<CounterChangeItem, CounterChangeItem, QSortBy> {
  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy> sortByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.asc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      sortByAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.desc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      sortByCounterGuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterGuid', Sort.asc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      sortByCounterGuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterGuid', Sort.desc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      sortByDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delta', Sort.asc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      sortByDeltaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delta', Sort.desc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      sortByNewValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newValue', Sort.asc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      sortByNewValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newValue', Sort.desc);
    });
  }
}

extension CounterChangeItemQuerySortThenBy
    on QueryBuilder<CounterChangeItem, CounterChangeItem, QSortThenBy> {
  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy> thenByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.asc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      thenByAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.desc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      thenByCounterGuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterGuid', Sort.asc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      thenByCounterGuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterGuid', Sort.desc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      thenByDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delta', Sort.asc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      thenByDeltaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delta', Sort.desc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      thenByNewValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newValue', Sort.asc);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QAfterSortBy>
      thenByNewValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newValue', Sort.desc);
    });
  }
}

extension CounterChangeItemQueryWhereDistinct
    on QueryBuilder<CounterChangeItem, CounterChangeItem, QDistinct> {
  QueryBuilder<CounterChangeItem, CounterChangeItem, QDistinct> distinctByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'at');
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QDistinct>
      distinctByCounterGuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'counterGuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QDistinct>
      distinctByDelta() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'delta');
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QDistinct>
      distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<CounterChangeItem, CounterChangeItem, QDistinct>
      distinctByNewValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'newValue');
    });
  }
}

extension CounterChangeItemQueryProperty
    on QueryBuilder<CounterChangeItem, CounterChangeItem, QQueryProperty> {
  QueryBuilder<CounterChangeItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CounterChangeItem, DateTime, QQueryOperations> atProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'at');
    });
  }

  QueryBuilder<CounterChangeItem, String, QQueryOperations>
      counterGuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'counterGuid');
    });
  }

  QueryBuilder<CounterChangeItem, int, QQueryOperations> deltaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'delta');
    });
  }

  QueryBuilder<CounterChangeItem, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<CounterChangeItem, int, QQueryOperations> newValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'newValue');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterChangeItem _$CounterChangeItemFromJson(Map<String, dynamic> json) =>
    CounterChangeItem(
      id: (json['id'] as num).toInt(),
      counterGuid: json['counterGuid'] as String,
      at: DateTime.parse(json['at'] as String),
      delta: (json['delta'] as num).toInt(),
      newValue: (json['newValue'] as num).toInt(),
    );

Map<String, dynamic> _$CounterChangeItemToJson(CounterChangeItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'counterGuid': instance.counterGuid,
      'at': instance.at.toIso8601String(),
      'delta': instance.delta,
      'newValue': instance.newValue,
    };
