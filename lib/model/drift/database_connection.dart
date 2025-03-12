// lib/database/database_connection.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class DatabaseConnection {
  static DatabaseConnection? _instance;
  static QueryExecutor? _executor;

  static Future<DatabaseConnection> get instance async {
    if (_instance == null) {
      _instance = DatabaseConnection();
      _executor = await _createExecutor();
    }
    return _instance!;
  }

  QueryExecutor get executor => _executor!;

  static Future<QueryExecutor> _createExecutor() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'translate_history.db'));
    return NativeDatabase(file);
  }
}