import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glo_trans/model/config_model.dart';
import 'package:glo_trans/model/target_language_config_model.dart';
import 'package:glo_trans/model/translate_result_model.dart';
import 'package:glo_trans/service/translate_result_list_store.dart';

import '../utils.dart';

class AppDataViewModel extends ChangeNotifier {
  String? currentSentence;

  bool translating = false;
  int currentTranslateProgress = 0;
  Map<String, String> currentkeyValueMap = {};
  int get currentWillTranslateCount =>
      config.targetLanguageConfigList.where((e) => e.willTranslate).length;
  int get willTranslateCount =>
      config.targetLanguageConfigList.where((e) => e.willTranslate).length *
      currentkeyValueMap.length;
  List<TargetLanguageConfigModel> get currentWillTranslateLanguageList =>
      config.targetLanguageConfigList.where((e) => e.willTranslate).toList();
  // 翻译耗时
  int translateTakesTime = 0;
  Timer? _timer;

  // 翻译结果
  List<List<String>> translateResult = [];

  Map<String, String> keyValueMap = {};

  int currentPageViewIndex = 0;

  Locale _locale = const Locale('zh', 'CN');
  Locale get locale => _locale;

  set locale(Locale value) {
    _locale = value;
    notifyListeners();
  }

  void startTranslating(Map<String, String> keyValueMap) {
    currentkeyValueMap = keyValueMap;
    translating = true;
    translateResult = [];
    int index = 0;
    keyValueMap.forEach((key, value) {
      translateResult.add([index.toString(), key]);
      index++;
    });
    notifyListeners();
    _translate(keyValueMap);
    // 开始计时
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      translateTakesTime++;
      notifyListeners();
    });
  }

  void stopTranslating() {
    translating = false;
    notifyListeners();
    currentTranslateProgress = 0;
    _timer?.cancel();
    translateTakesTime = 0;
  }

  void translatedProgress(int progress) {
    currentTranslateProgress = progress;
    notifyListeners();
  }

  void testNotifyListeners() {
    notifyListeners();
  }

  void switchPage(int index) {
    currentPageViewIndex = index;
    notifyListeners();
  }

  ConfigModel config = ConfigModel(
      deeplKey: "1e6e86dd-797b-4fc7-aaf2-ab6efc120ea9:fx",
      targetLanguageConfigList: []);

  // 解析词条，开始翻译
  Future _translate(Map<String, String> keyValueMap) async {
    int index = 0;
    for (var value in keyValueMap.values) {
      List<String> oneLineRes = [];
      for (var targetLanguageConfig in currentWillTranslateLanguageList) {
        String res = await translateOneLanguageTextForDev(
            targetLanguageConfig.language, value, config.deeplKey);
        print(res);
        oneLineRes.add(res);
        currentTranslateProgress += 1;
        notifyListeners();
      }
      translateResult[index] = [
        index.toString(),
        keyValueMap.keys.toList()[index],
        ...oneLineRes
      ];
      print("translateResult: ${translateResult.length}");
      index++;
      print("翻译完成$value ");
      notifyListeners();
    }
    stopTranslating();
    saveTranslateResult();
  }

  // 保存翻译结果
  void saveTranslateResult() async {
    TranslateResultModelList translateResultModelList =
        await getTranslateResultList();
    TranslateResultModel translateResultModel = TranslateResultModel(
        time: DateTime.now().toString(),
        header: ["index", "key", ...keyValueMap.keys],
        rows: translateResult);
    TranslateResultListStore.saveTranslateResultList(
        translateResultModelList.add(translateResultModel));
  }

  // 翻译历史结果
  TranslateResultModelList? translateResultModelList;

  // 获取翻译历史结果
  Future<TranslateResultModelList> getTranslateResultList() async {
    translateResultModelList =
        await TranslateResultListStore.getTranslateResultList();
    if (translateResultModelList != null) {
      print(
          "translateResultModelList: ${translateResultModelList!.translateResultList.length}");
      return translateResultModelList!;
    }
    print("translateResultModelList: null");
    return TranslateResultModelList(translateResultList: []);
  }
}
