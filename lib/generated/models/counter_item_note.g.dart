// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas, always_specify_types, unused_element, unnecessary_non_null_assertion

part of '../../models/counter_item_note.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCounterItemNoteCollection on Isar {
  IsarCollection<CounterItemNote> get counterItemNotes => this.collection();
}

const CounterItemNoteSchema = CollectionSchema(
  name: r'CounterItemNote',
  id: 2264106205980065862,
  properties: {
    r'at': PropertySchema(
      id: 0,
      name: r'at',
      type: IsarType.dateTime,
    ),
    r'content': PropertySchema(
      id: 1,
      name: r'content',
      type: IsarType.string,
    ),
    r'counterGuid': PropertySchema(
      id: 2,
      name: r'counterGuid',
      type: IsarType.string,
    ),
    r'hashCode': PropertySchema(
      id: 3,
      name: r'hashCode',
      type: IsarType.long,
    )
  },
  estimateSize: _counterItemNoteEstimateSize,
  serialize: _counterItemNoteSerialize,
  deserialize: _counterItemNoteDeserialize,
  deserializeProp: _counterItemNoteDeserializeProp,
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
  getId: _counterItemNoteGetId,
  getLinks: _counterItemNoteGetLinks,
  attach: _counterItemNoteAttach,
  version: '3.2.0-dev.2',
);

int _counterItemNoteEstimateSize(
  CounterItemNote object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.content.length * 3;
  bytesCount += 3 + object.counterGuid.length * 3;
  return bytesCount;
}

void _counterItemNoteSerialize(
  CounterItemNote object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.at);
  writer.writeString(offsets[1], object.content);
  writer.writeString(offsets[2], object.counterGuid);
  writer.writeLong(offsets[3], object.hashCode);
}

CounterItemNote _counterItemNoteDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CounterItemNote(
    at: reader.readDateTime(offsets[0]),
    content: reader.readString(offsets[1]),
    counterGuid: reader.readString(offsets[2]),
    id: id,
  );
  return object;
}

P _counterItemNoteDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _counterItemNoteGetId(CounterItemNote object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _counterItemNoteGetLinks(CounterItemNote object) {
  return [];
}

void _counterItemNoteAttach(
    IsarCollection<dynamic> col, Id id, CounterItemNote object) {}

extension CounterItemNoteQueryWhereSort
    on QueryBuilder<CounterItemNote, CounterItemNote, QWhere> {
  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhere> anyAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'at'),
      );
    });
  }
}

extension CounterItemNoteQueryWhere
    on QueryBuilder<CounterItemNote, CounterItemNote, QWhereClause> {
  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause> idBetween(
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause>
      counterGuidEqualToAnyAt(String counterGuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'counterGuid_at',
        value: [counterGuid],
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause>
      counterGuidAtEqualTo(String counterGuid, DateTime at) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'counterGuid_at',
        value: [counterGuid, at],
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause> atEqualTo(
      DateTime at) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'at',
        value: [at],
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause> atLessThan(
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterWhereClause> atBetween(
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

extension CounterItemNoteQueryFilter
    on QueryBuilder<CounterItemNote, CounterItemNote, QFilterCondition> {
  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      atEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'at',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      contentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      contentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      contentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      contentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      counterGuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'counterGuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      counterGuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'counterGuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      counterGuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'counterGuid',
        value: '',
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      counterGuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'counterGuid',
        value: '',
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      hashCodeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterFilterCondition>
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
}

extension CounterItemNoteQueryObject
    on QueryBuilder<CounterItemNote, CounterItemNote, QFilterCondition> {}

extension CounterItemNoteQueryLinks
    on QueryBuilder<CounterItemNote, CounterItemNote, QFilterCondition> {}

extension CounterItemNoteQuerySortBy
    on QueryBuilder<CounterItemNote, CounterItemNote, QSortBy> {
  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy> sortByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.asc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy> sortByAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.desc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy> sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy>
      sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy>
      sortByCounterGuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterGuid', Sort.asc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy>
      sortByCounterGuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterGuid', Sort.desc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy>
      sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy>
      sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }
}

extension CounterItemNoteQuerySortThenBy
    on QueryBuilder<CounterItemNote, CounterItemNote, QSortThenBy> {
  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy> thenByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.asc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy> thenByAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'at', Sort.desc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy> thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy>
      thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy>
      thenByCounterGuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterGuid', Sort.asc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy>
      thenByCounterGuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterGuid', Sort.desc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy>
      thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy>
      thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension CounterItemNoteQueryWhereDistinct
    on QueryBuilder<CounterItemNote, CounterItemNote, QDistinct> {
  QueryBuilder<CounterItemNote, CounterItemNote, QDistinct> distinctByAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'at');
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QDistinct> distinctByContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QDistinct>
      distinctByCounterGuid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'counterGuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CounterItemNote, CounterItemNote, QDistinct>
      distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }
}

extension CounterItemNoteQueryProperty
    on QueryBuilder<CounterItemNote, CounterItemNote, QQueryProperty> {
  QueryBuilder<CounterItemNote, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CounterItemNote, DateTime, QQueryOperations> atProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'at');
    });
  }

  QueryBuilder<CounterItemNote, String, QQueryOperations> contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<CounterItemNote, String, QQueryOperations>
      counterGuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'counterGuid');
    });
  }

  QueryBuilder<CounterItemNote, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterItemNote _$CounterItemNoteFromJson(Map<String, dynamic> json) =>
    CounterItemNote(
      id: (json['id'] as num).toInt(),
      counterGuid: json['counterGuid'] as String,
      at: DateTime.parse(json['at'] as String),
      content: json['content'] as String,
    );

Map<String, dynamic> _$CounterItemNoteToJson(CounterItemNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'counterGuid': instance.counterGuid,
      'at': instance.at.toIso8601String(),
      'content': instance.content,
    };
