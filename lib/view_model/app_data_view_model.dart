import 'package:flutter/material.dart';
import 'package:glo_trans/model/config_model.dart';

import '../utils.dart';

class AppDataViewModel extends ChangeNotifier {
  String? currentSentence;

  bool translating = false;
  int currentTranslateProgress = 0;

  int currentPageViewIndex = 0;

  void startTranslating() {
    translating = true;
    notifyListeners();
    _parseInputStrAndTranslate();
  }

  void stopTranslating() {
    translating = false;
    notifyListeners();
  }

  void translatedProgress(int progress) {
    currentTranslateProgress = progress;
    notifyListeners();
  }

  void testNotifyListeners(){
    notifyListeners();
  }

  ConfigModel config = ConfigModel(
      deeplKey: "1e6e86dd-797b-4fc7-aaf2-ab6efc120ea9:fx",
      targetLanguageConfigList: []);

  // 解析词条，开始翻译
  Future _parseInputStrAndTranslate() async {
    // appDataViewModel.currentPageViewIndex = 1;
    try {
      Map<String, String> sentences = parseInputStr(currentSentence!);
      List<List<String>> res = [];
      for (var e in config.targetLanguageConfigList) {
        if (e.willTranslate) {
          List<String>? eRes = await translateOneLanguageTexts(
              e.language, sentences.values.toList(), config.deeplKey);
          if (eRes.isNotEmpty) {
            res.add(eRes);
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
