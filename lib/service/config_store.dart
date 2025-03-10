import 'package:glo_trans/model/settings/config_model.dart';
import 'package:hive/hive.dart';

class ConfigStore {
  static const String configBoxName = 'configBox';

  // 打开 Box
  static Future<Box<ConfigModel>> openBox() async {
    return await Hive.openBox<ConfigModel>(configBoxName);
  }

  // 保存配置
  static Future<void> saveConfig(ConfigModel config) async {
    final box = await openBox();
    await box.put('config', config);
  }

  // 获取配置
  static Future<ConfigModel?> getConfig() async {
    final box = await openBox();
    return box.get('config');
  }
}