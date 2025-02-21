import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glo_trans/model/config_model.dart';

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
  // 翻译耗时
  int translateTakesTime = 0;
  Timer? _timer;

  // 翻译结果
  List<List<String>> translateResult = [];

  int currentPageViewIndex = 0;

  void startTranslating(Map<String, String> keyValueMap) {
    currentkeyValueMap = keyValueMap;
    translating = true;
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
    for (var value in keyValueMap.values) {
      List<String> oneLineRes = [];
      for (var targetLanguageConfig in config.targetLanguageConfigList) {
        if (targetLanguageConfig.willTranslate) {
          String res = await translateOneLanguageTextForDev(
              targetLanguageConfig.language, value, config.deeplKey);
          print(res);
          oneLineRes.add(res);
          currentTranslateProgress += 1;
          notifyListeners();
        }
      }
      translateResult.add(oneLineRes);
      print("翻译完成$value ");
    }
    stopTranslating();
  }
}
