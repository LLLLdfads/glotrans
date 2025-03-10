import 'package:hive/hive.dart';

// 仅存储会翻译的语言
class WillDoLanStore {
  static const String configBoxName = 'will_do_lan_store';

  // 打开 Box
  static Future<Box<List<bool>>> openBox() async {
    return await Hive.openBox<List<bool>>(configBoxName);
  }

  // 保存配置
  static Future<void> saveLanList(List<bool> lanList) async {
    final box = await openBox();
    await box.put('lanList', lanList);
  }

  // 获取配置
  static Future<List<bool>?> getLanList() async {
    final box = await openBox();
    return box.get('lanList');
  }
}