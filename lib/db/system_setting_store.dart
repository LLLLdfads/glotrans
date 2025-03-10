import 'package:glo_trans/model/settings/system_setting_model.dart';
import 'package:hive/hive.dart';

class SystemSettingStore {
  static const String configBoxName = 'system_setting_store';

  // 打开 Box
  static Future<Box<SystemSettingModel>> openBox() async {
    return await Hive.openBox<SystemSettingModel>(configBoxName);
  }

  // 保存配置
  static Future<void> saveSystemSettingModel(SystemSettingModel config) async {
    final box = await openBox();
    await box.put('systemSettingModel', config);
  }

  // 获取配置
  static Future<SystemSettingModel?> getSystemSettingModel() async {
    final box = await openBox();
    return box.get('systemSettingModel');
  }
}