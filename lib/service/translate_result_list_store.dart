import 'package:glo_trans/model/translate_result_model.dart';
import 'package:hive/hive.dart';

class TranslateResultListStore {
  static const String translateResultListBoxName = 'translateResultListBox';

  // 打开 Box
  static Future<Box<TranslateResultModelList>> openBox() async {
    return await Hive.openBox<TranslateResultModelList>(translateResultListBoxName);
  }
 
  // 保存翻译结果列表
  static Future<void> saveTranslateResultList(TranslateResultModelList translateResultList) async {
    final box = await openBox();
    await box.put('translateResultList', translateResultList);
  }

  // 获取翻译结果列表
  static Future<TranslateResultModelList?> getTranslateResultList() async {
    final box = await openBox();
    return box.get('translateResultList');
  }
}