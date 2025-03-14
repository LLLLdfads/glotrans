import 'package:hive/hive.dart';

class XLogPrivateKeyStore {
  static const String configBoxName = 'xlog_private_key_store';

  // 打开 Box
  static Future<Box<String>> openBox() async {
    return await Hive.openBox<String>(configBoxName);
  }

  // 保存配置
  static Future<void> saveXLogPrivateKey(String key) async {
    final box = await openBox();
    await box.put('xlog_private_key', key);
  }

  // 获取配置
  static Future<String?> getXLogPrivateKey() async {
    final box = await openBox();
    return box.get('xlog_private_key');
  }
}