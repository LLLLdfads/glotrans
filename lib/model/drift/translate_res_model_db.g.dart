// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate_res_model_db.dart';

// ignore_for_file: type=lint
class $TranslateResModelDBTable extends TranslateResModelDB
    with TableInfo<$TranslateResModelDBTable, TranslateResModelDBData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslateResModelDBTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
      'time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, time, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translate_res_model_d_b';
  @override
  VerificationContext validateIntegrity(
      Insertable<TranslateResModelDBData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TranslateResModelDBData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TranslateResModelDBData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
    );
  }

  @override
  $TranslateResModelDBTable createAlias(String alias) {
    return $TranslateResModelDBTable(attachedDatabase, alias);
  }
}

class TranslateResModelDBData extends DataClass
    implements Insertable<TranslateResModelDBData> {
  final int id;
  final String time;
  final String data;
  const TranslateResModelDBData(
      {required this.id, required this.time, required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['time'] = Variable<String>(time);
    map['data'] = Variable<String>(data);
    return map;
  }

  TranslateResModelDBCompanion toCompanion(bool nullToAbsent) {
    return TranslateResModelDBCompanion(
      id: Value(id),
      time: Value(time),
      data: Value(data),
    );
  }

  factory TranslateResModelDBData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TranslateResModelDBData(
      id: serializer.fromJson<int>(json['id']),
      time: serializer.fromJson<String>(json['time']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'time': serializer.toJson<String>(time),
      'data': serializer.toJson<String>(data),
    };
  }

  TranslateResModelDBData copyWith({int? id, String? time, String? data}) =>
      TranslateResModelDBData(
        id: id ?? this.id,
        time: time ?? this.time,
        data: data ?? this.data,
      );
  TranslateResModelDBData copyWithCompanion(TranslateResModelDBCompanion data) {
    return TranslateResModelDBData(
      id: data.id.present ? data.id.value : this.id,
      time: data.time.present ? data.time.value : this.time,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TranslateResModelDBData(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, time, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TranslateResModelDBData &&
          other.id == this.id &&
          other.time == this.time &&
          other.data == this.data);
}

class TranslateResModelDBCompanion
    extends UpdateCompanion<TranslateResModelDBData> {
  final Value<int> id;
  final Value<String> time;
  final Value<String> data;
  const TranslateResModelDBCompanion({
    this.id = const Value.absent(),
    this.time = const Value.absent(),
    this.data = const Value.absent(),
  });
  TranslateResModelDBCompanion.insert({
    this.id = const Value.absent(),
    required String time,
    required String data,
  })  : time = Value(time),
        data = Value(data);
  static Insertable<TranslateResModelDBData> custom({
    Expression<int>? id,
    Expression<String>? time,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (time != null) 'time': time,
      if (data != null) 'data': data,
    });
  }

  TranslateResModelDBCompanion copyWith(
      {Value<int>? id, Value<String>? time, Value<String>? data}) {
    return TranslateResModelDBCompanion(
      id: id ?? this.id,
      time: time ?? this.time,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslateResModelDBCompanion(')
          ..write('id: $id, ')
          ..write('time: $time, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

abstract class _$TranslateDatabase extends GeneratedDatabase {
  _$TranslateDatabase(QueryExecutor e) : super(e);
  $TranslateDatabaseManager get managers => $TranslateDatabaseManager(this);
  late final $TranslateResModelDBTable translateResModelDB =
      $TranslateResModelDBTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [translateResModelDB];
}

typedef $$TranslateResModelDBTableCreateCompanionBuilder
    = TranslateResModelDBCompanion Function({
  Value<int> id,
  required String time,
  required String data,
});
typedef $$TranslateResModelDBTableUpdateCompanionBuilder
    = TranslateResModelDBCompanion Function({
  Value<int> id,
  Value<String> time,
  Value<String> data,
});

class $$TranslateResModelDBTableFilterComposer
    extends Composer<_$TranslateDatabase, $TranslateResModelDBTable> {
  $$TranslateResModelDBTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));
}

class $$TranslateResModelDBTableOrderingComposer
    extends Composer<_$TranslateDatabase, $TranslateResModelDBTable> {
  $$TranslateResModelDBTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));
}

class $$TranslateResModelDBTableAnnotationComposer
    extends Composer<_$TranslateDatabase, $TranslateResModelDBTable> {
  $$TranslateResModelDBTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$TranslateResModelDBTableTableManager extends RootTableManager<
    _$TranslateDatabase,
    $TranslateResModelDBTable,
    TranslateResModelDBData,
    $$TranslateResModelDBTableFilterComposer,
    $$TranslateResModelDBTableOrderingComposer,
    $$TranslateResModelDBTableAnnotationComposer,
    $$TranslateResModelDBTableCreateCompanionBuilder,
    $$TranslateResModelDBTableUpdateCompanionBuilder,
    (
      TranslateResModelDBData,
      BaseReferences<_$TranslateDatabase, $TranslateResModelDBTable,
          TranslateResModelDBData>
    ),
    TranslateResModelDBData,
    PrefetchHooks Function()> {
  $$TranslateResModelDBTableTableManager(
      _$TranslateDatabase db, $TranslateResModelDBTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranslateResModelDBTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranslateResModelDBTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranslateResModelDBTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> time = const Value.absent(),
            Value<String> data = const Value.absent(),
          }) =>
              TranslateResModelDBCompanion(
            id: id,
            time: time,
            data: data,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String time,
            required String data,
          }) =>
              TranslateResModelDBCompanion.insert(
            id: id,
            time: time,
            data: data,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TranslateResModelDBTableProcessedTableManager = ProcessedTableManager<
    _$TranslateDatabase,
    $TranslateResModelDBTable,
    TranslateResModelDBData,
    $$TranslateResModelDBTableFilterComposer,
    $$TranslateResModelDBTableOrderingComposer,
    $$TranslateResModelDBTableAnnotationComposer,
    $$TranslateResModelDBTableCreateCompanionBuilder,
    $$TranslateResModelDBTableUpdateCompanionBuilder,
    (
      TranslateResModelDBData,
      BaseReferences<_$TranslateDatabase, $TranslateResModelDBTable,
          TranslateResModelDBData>
    ),
    TranslateResModelDBData,
    PrefetchHooks Function()>;

class $TranslateDatabaseManager {
  final _$TranslateDatabase _db;
  $TranslateDatabaseManager(this._db);
  $$TranslateResModelDBTableTableManager get translateResModelDB =>
      $$TranslateResModelDBTableTableManager(_db, _db.translateResModelDB);
}
