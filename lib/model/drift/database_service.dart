import 'database_connection.dart';
import 'translate_res_model_db.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static TranslateDatabase? _db;

  DatabaseService._();

  static Future<DatabaseService> get instance async {
    if (_instance == null) {
      final connection = await DatabaseConnection.instance;
      _db = TranslateDatabase(connection.executor);
      _instance = DatabaseService._();
    }
    return _instance!;
  }

  TranslateDatabase get database => _db!;

  Future<int> saveTranslateResult(TranslateResModelDBCompanion entry) {
    return database.saveTranslateResult(entry);
  }

  Future<List<TranslateResModelDBData>> getHistoryByPage(int page,
      {int pageSize = 6}) {
    return database.getResultsByPage(page, pageSize: pageSize);
  }

  Future<int> getTotalPages({int pageSize = 6}) {
    return database.getTotalPages(pageSize: pageSize);
  }

  Future<void> cleanOldRecords(int keepCount) {
    return database.cleanOldRecords(keepCount);
  }
  // 根据id删除某个翻译结果
  Future<int> deleteTranslateResult(int id) {
    return database.deleteTranslateResult(id);
  }
}
