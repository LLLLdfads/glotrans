import 'package:hive/hive.dart';

class KeyStore {
  static const String configBoxName = 'key_store';

  // 打开 Box
  static Future<Box<String>> openBox() async {
    return await Hive.openBox<String>(configBoxName);
  }

  // 保存配置
  static Future<void> saveKey(String key) async {
    final box = await openBox();
    await box.put('key', key);
  }

  // 获取配置
  static Future<String?> getKey() async {
    final box = await openBox();
    return box.get('key');
  }
}