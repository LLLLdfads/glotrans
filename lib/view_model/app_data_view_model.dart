import 'dart:async';
// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glo_trans/app_const.dart';
import 'package:glo_trans/db/export_settings_store.dart';
import 'package:glo_trans/db/key_store.dart';
import 'package:glo_trans/db/system_setting_store.dart';
import 'package:glo_trans/db/will_do_lan_store.dart';
import 'package:glo_trans/model/settings/config_model.dart';
import 'package:glo_trans/model/settings/export_setting_model.dart';
import 'package:glo_trans/model/settings/system_setting_model.dart';
import 'package:glo_trans/model/translate_result_model.dart';
import 'package:glo_trans/service/translate_result_list_store.dart';

import '../utils.dart';

class AppDataViewModel extends ChangeNotifier {
  // 设置·语言选项（将会翻译的项）
  List<bool> willDoLan = [];
  void setWillDoLan() {
    WillDoLanStore.saveLanList(willDoLan);
    notifyListeners();
  }

  // 设置·导出设置（导入文件，导入位置，插入flag）
  ExportSettingModel exportingModel = ExportSettingModel(
    toL10n: false,
    toAndroid: false,
    l10nFiles: [],
    l10nFilesEnable: [],
    androidFiles: [],
    androidFilesEnable: [],
    l10nFlag: "",
    androidFlag: "",
    isInsertBeforeL10nFlag: true,
    isInsertBeforeAndroidFlag: true,
  );
  void setExportingModel() {
    ExportSettingsStore.saveExportSettingModel(exportingModel);
    notifyListeners();
  }

  // 设置·系统设置（系统语言，主题）
  SystemSettingModel systemSettingModel = SystemSettingModel(
    systemLan: 0,
    themeKind: 0,
  );
  void setSystemSettingModel() {
    SystemSettingStore.saveSystemSettingModel(systemSettingModel);
    notifyListeners();
  }

  // 设置·密钥
  String key = "";
  void setKey(String key) {
    this.key = key;
    KeyStore.saveKey(key);
    notifyListeners();
  }

  // 设置·初始化配置项
  Future<void> initSettingConfig() async {
    // 设置·语言选项（将会翻译的项）
    List<bool>? willDoLanRes = await WillDoLanStore.getLanList();
    print("willDoLanRes: $willDoLanRes");
    if (willDoLanRes == null) {
      willDoLan = List.generate(AppConst.supportLanMap.length, (_) => false);
    } else {
      willDoLan = willDoLanRes;
    }
    // 设置·导出设置（导入文件，导入位置，插入flag）
    ExportSettingModel? exportingModelRes =
        await ExportSettingsStore.getExportSettingModel();
    print("exportingModelRes: ${exportingModelRes?.toJson()}");
    if (exportingModelRes == null) {
      exportingModel = ExportSettingModel(
        toL10n: false,
        toAndroid: false,
        l10nFiles: List.generate(AppConst.supportLanMap.length, (_) => ""),
        l10nFilesEnable:
            List.generate(AppConst.supportLanMap.length, (_) => false),
        androidFiles: List.generate(AppConst.supportLanMap.length, (_) => ""),
        androidFilesEnable:
            List.generate(AppConst.supportLanMap.length, (_) => false),
        l10nFlag: "",
        androidFlag: "",
        isInsertBeforeL10nFlag: true,
        isInsertBeforeAndroidFlag: true,
      );
    } else {
      exportingModel = exportingModelRes;
    }
    // 设置·系统设置（系统语言，主题）
    SystemSettingModel? systemSettingModelRes =
        await SystemSettingStore.getSystemSettingModel();
    print("systemSettingModelRes: ${systemSettingModelRes?.toJson()}");
    if (systemSettingModelRes == null) {
      systemSettingModel = SystemSettingModel(
        systemLan: 0,
        themeKind: 0,
      );
    } else {
      systemSettingModel = systemSettingModelRes;
    }
    // 设置·密钥
    String? keyRes = await KeyStore.getKey();
    print("keyRes: $keyRes");
    if (keyRes == null) {
      key = "1e6e86dd-797b-4fc7-aaf2-ab6efc120ea9:fx";
    } else {
      key = keyRes;
    }
    notifyListeners();
  }

  // 翻译·当前输入
  String? currentSentence;

  bool translating = false;
  int currentTranslateProgress = 0;
  Map<String, String> currentkeyValueMap = {};
  // int get currentWillTranslateCount =>
  //     config.targetLanguageConfigList.where((e) => e.willTranslate).length;
  // int get willTranslateCount =>
  //     config.targetLanguageConfigList.where((e) => e.willTranslate).length *
  //     currentkeyValueMap.length;
  int get willTranslateCount => 0;

  // 翻译耗时
  int translateTakesTime = 0;
  Timer? _timer;

  // 翻译结果
  List<List<String>> translateResult = [];

  Map<String, String> keyValueMap = {};

  int currentPageViewIndex = 0;

  // Locale _locale = const Locale('zh', 'CN');
  // Locale get locale => _locale;

  // set locale(Locale value) {
  //   _locale = value;
  //   setSystemSettingModel();
  //   notifyListeners();
  // }

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
      // for (var targetLanguageConfig in currentWillTranslateLanguageList) {
      //   String res = await translateOneLanguageTextForDev(
      //       targetLanguageConfig.language, value, config.deeplKey);
      //   print(res);
      //   // oneLineRes.add(jsonDecode(res)["translations"][0]["text"]);
      //   oneLineRes.add(res);
      //   currentTranslateProgress += 1;
      //   notifyListeners();
      // }
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

  // 导入excel，替换当前的表格数据值
  void importExcelReplace(List<List<String>> excelData) {
    translateResult = excelData;
    notifyListeners();
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
