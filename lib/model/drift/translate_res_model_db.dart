import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'translate_res_model_db.g.dart';

class TranslateResModelDB extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get time => text()();
  TextColumn get data => text()(); // 存储为JSON字符串
}

@DriftDatabase(tables: [TranslateResModelDB])
class TranslateDatabase extends _$TranslateDatabase {
  // 修改构造函数，接受一个 QueryExecutor
  TranslateDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  // 保存翻译结果
  Future<int> saveTranslateResult(TranslateResModelDBCompanion entry) {
    return into(translateResModelDB).insert(entry);
  }

  // 获取所有翻译历史
  Future<List<TranslateResModelDBData>> getAllResults() {
    return (select(translateResModelDB)
          ..orderBy([
            (t) => OrderingTerm(expression: t.time, mode: OrderingMode.desc)
          ]))
        .get();
  }

  // 获取最新的翻译结果
  Future<TranslateResModelDBData?> getLatestResult() {
    return (select(translateResModelDB)
          ..orderBy([
            (t) => OrderingTerm(expression: t.time, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  // 删除旧记录
  Future<void> cleanOldRecords(int keepCount) async {
    final oldRecords = await (select(translateResModelDB)
          ..orderBy([
            (t) => OrderingTerm(expression: t.time, mode: OrderingMode.desc)
          ])
          ..limit(1000000))
        .get();

    // 只保留最新的 keepCount 条记录
    if (oldRecords.length > keepCount) {
      for (final record in oldRecords.sublist(keepCount)) {
        await delete(translateResModelDB).delete(record);
      }
    }
  }

  // 分页获取翻译历史
  Future<List<TranslateResModelDBData>> getResultsByPage(int page,
      {int pageSize = 6}) {
    return (select(translateResModelDB)
          ..orderBy([
            (t) => OrderingTerm(expression: t.time, mode: OrderingMode.desc)
          ])
          ..limit(pageSize, offset: page * pageSize))
        .get();
  }

  // 获取总页数
  Future<int> getTotalPages({int pageSize = 6}) async {
    final totalCount = await (select(translateResModelDB)
          ..orderBy([
            (t) => OrderingTerm(expression: t.time, mode: OrderingMode.desc)
          ]))
        .get();
    return (totalCount.length / pageSize).ceil();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'translate_history.db'));
    return NativeDatabase(file);
  });
}
