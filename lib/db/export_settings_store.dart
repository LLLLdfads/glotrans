import 'package:glo_trans/model/settings/export_setting_model.dart';
import 'package:hive/hive.dart';

class ExportSettingsStore {
  static const String configBoxName = 'export_settings_store';

  // 打开 Box
  static Future<Box<ExportSettingModel>> openBox() async {
    return await Hive.openBox<ExportSettingModel>(configBoxName);
  }

  // 保存配置
  static Future<void> saveExportSettingModel(ExportSettingModel config) async {
    final box = await openBox();
    await box.put('exportSettingModel', config);
  }

  // 获取配置
  static Future<ExportSettingModel?> getExportSettingModel() async {
    final box = await openBox();
    return box.get('exportSettingModel');
  }
}