import 'dart:async';
import 'dart:convert';
// import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:glo_trans/app_const.dart';
import 'package:glo_trans/db/export_settings_store.dart';
import 'package:glo_trans/db/key_store.dart';
import 'package:glo_trans/db/system_setting_store.dart';
import 'package:glo_trans/db/will_do_lan_store.dart';
import 'package:glo_trans/model/drift/database_service.dart';
import 'package:glo_trans/model/drift/translate_res_model.dart';
import 'package:glo_trans/model/drift/translate_res_model_db.dart';
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

  // 翻译计时器
  Timer? translateTimer;
  int translateTakesTime = 0;
  void startTranslateTimer() {
    translateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      translateTakesTime++;
      notifyListeners();
    });
  }

  // 翻译结果
  List<List<String>> translateResult = [];

  Map<String, String> keyValueMap = {};

  int currentPageViewIndex = 0;

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

  int translatedCount = 0;
  int totalTranslateCount = 0;
  List<List<String>> currentTable = [];
  bool stopTranslate = false;
  List<List<String>> currentTranslateRes = [];

  // 翻译
  Future translate(Map<String, String> keyValueMap, List<String> willDoLanStr,
      Function(String) onTranslatedAText) async {
    currentTranslateRes = [];
    onTranslatedAText(
        "author: Dewen.Luo\nversion: 3.0\ndescription: 词条转多语言并以excel文件保存在history文件夹中\ne-mail: a3229785914@qq.com");
    onTranslatedAText("翻译语种(${willDoLanStr.length})：${willDoLanStr.join(",")}");
    // 生成表头
    List<String> header = ["index", "key", ...willDoLanStr];
    currentTranslateRes.add(header);
    for (int i = 0; i < keyValueMap.length; i++) {
      List<String> oneLineRes = [i.toString(), keyValueMap.keys.elementAt(i)];
      String name = keyValueMap.keys.elementAt(i);
      String value = keyValueMap.values.elementAt(i);
      onTranslatedAText("开始处理'$name':'$value'");

      for (int j = 0; j < willDoLanStr.length; j++) {
        if (stopTranslate) return;
        String lan = willDoLanStr[j];
        String res =
            // await translateOneLanguageText(lan.split("_")[1], value, key);
            await translateOneLanguageTextForDev(lan.split("_")[1], value, key);
        print(res);
        oneLineRes.add(res);
        translatedCount++;
        notifyListeners();
        onTranslatedAText("${lan.padRight(15, ' ')}:$res");
      }
      currentTranslateRes.add(oneLineRes);
    }
    onTranslatedAText("翻译完成");
    translateTimer?.cancel();
    saveTranslateToHistory(currentTranslateRes);
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

  // history_view的数据
  List<TranslateResModel> translateHistory = [];
  int historyTotalPageCount = 0;
  // 保存翻译结果
  Future<bool> saveTranslateToHistory(List<List<String>> translateRes) async {
    try {
      TranslateResModel translateResModel = TranslateResModel(
          time: DateTime.now().toString(), data: translateRes);

      // 保存到数据库
      DatabaseService databaseService = await DatabaseService.instance;
      final id = await databaseService.saveTranslateResult(
          TranslateResModelDBCompanion(
              time: Value(translateResModel.time),
              data: Value(jsonEncode(translateResModel.data))));

      if (id > 0) {
        // 保存成功，id 就是新记录的主键值
        // translateHistory.insert(0, translateResModel);
        // notifyListeners();
        print('翻译结果保存成功，记录ID: $id');
        return true;
      } else {
        print('翻译结果保存失败，返回ID: $id');
        return false;
      }
    } catch (e) {
      print('保存翻译结果时发生错误：$e');
      return false;
    }
  }

  // 从数据库中拿到指定页面的数据
  Future<void> getTranslateResByPageId(int page) async {
    DatabaseService databaseService = await DatabaseService.instance;
    List<TranslateResModelDBData> translateResModelDBDataList =
        await databaseService.getHistoryByPage(page);
    List<TranslateResModel> translateResModelList =
        translateResModelDBDataList.map((e) {
      print("e.data: ${e.data}");
      TranslateResModel translateResModel = TranslateResModel(
          id: e.id,
          time: e.time,
          data: (jsonDecode(e.data) as List)
              .map((row) =>
                  (row as List).map((item) => item.toString()).toList())
              .toList());
      return translateResModel;
    }).toList();
    if (translateResModelList.isNotEmpty) {
      print("加载到数据: ${translateResModelList.length}");
      translateHistory.addAll(translateResModelList);
      historyTotalPageCount += 1;
      notifyListeners();
    }
  }

  // 从数据库中拿到指定页面的数据并替换当前的翻译历史的数据
  Future<void> getTranslateResFirstPage() async {
    DatabaseService databaseService = await DatabaseService.instance;
    List<TranslateResModelDBData> translateResModelDBDataList =
        await databaseService.getHistoryByPage(0);
    List<TranslateResModel> translateResModelList =
        translateResModelDBDataList.map((e) {
      print("e.data: ${e.data}");
      TranslateResModel translateResModel = TranslateResModel(
          id: e.id,
          time: e.time,
          data: (jsonDecode(e.data) as List)
              .map((row) =>
                  (row as List).map((item) => item.toString()).toList())
              .toList());
      return translateResModel;
    }).toList();
    if (translateResModelList.isNotEmpty) {
      print("加载到数据: ${translateResModelList.length}");
      translateHistory.clear();
      translateHistory.addAll(translateResModelList);
      historyTotalPageCount = 1;
      notifyListeners();
    }
  }

  // 根据id删除某个翻译结果
  Future<int> deleteTranslateRes(int id) async {
    DatabaseService databaseService = await DatabaseService.instance;
    int success = await databaseService.deleteTranslateResult(id);
    notifyListeners();
    return success;
  }
}
