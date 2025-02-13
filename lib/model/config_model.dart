// import 'dart:convert';
//
// Config configFromJson(String str) => Config.fromJson(json.decode(str));
//
// class Config {
//   Jobs jobs;
//   String key;
//   Language language;
//   String l10NInsertFlag;
//   String androidInsertFlag;
//   bool toFlutter;
//   String l10NPath;
//   List<String> l10NTargetFiles;
//   bool toAndroid;
//   String androidPath;
//   List<String> androidTargetFiles;
//
//   Config({
//     required this.jobs,
//     required this.key,
//     required this.language,
//     this.l10NInsertFlag,
//     this.androidInsertFlag,
//     this.toFlutter,
//     this.l10NPath,
//     this.l10NTargetFiles,
//     this.toAndroid,
//     this.androidPath,
//     this.androidTargetFiles,
//   });
//
//   factory Config.fromJson(Map<String, dynamic> json) => Config(
//     jobs: Jobs.fromJson(json["jobs"]),
//     key: json["key"],
//     language: Language.fromJson(json["language"]),
//     l10NInsertFlag: json["l10n_insert_flag"],
//     androidInsertFlag: json["android_insert_flag"],
//     toFlutter: json["to_flutter"],
//     l10NPath: json["l10n_path"],
//     l10NTargetFiles: List<String>.from(json["l10n_target_files"].map((x) => x)),
//     toAndroid: json["to_android"],
//     androidPath: json["android_path"],
//     androidTargetFiles: List<String>.from(json["android_target_files"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "jobs": jobs.toJson(),
//     "key": key,
//     "language": language.toJson(),
//     "l10n_insert_flag": l10NInsertFlag,
//     "android_insert_flag": androidInsertFlag,
//     "to_flutter": toFlutter,
//     "l10n_path": l10NPath,
//     "l10n_target_files": List<dynamic>.from(l10NTargetFiles.map((x) => x)),
//     "to_android": toAndroid,
//     "android_path": androidPath,
//     "android_target_files": List<dynamic>.from(androidTargetFiles.map((x) => x)),
//   };
// }
//
// class Jobs {
//   String taskDialogParamMowingDirection;
//   String taskDialogParamExitMode;
//   String taskDialogParamEdgeTrimming;
//   String taskDialogParamAvoidanceCustomization;
//
//   Jobs({
//     this.taskDialogParamMowingDirection,
//     this.taskDialogParamExitMode,
//     this.taskDialogParamEdgeTrimming,
//     this.taskDialogParamAvoidanceCustomization,
//   });
//
//   factory Jobs.fromJson(Map<String, dynamic> json) => Jobs(
//     taskDialogParamMowingDirection: json["task_dialog_param_mowing_direction"],
//     taskDialogParamExitMode: json["task_dialog_param_exit_mode"],
//     taskDialogParamEdgeTrimming: json["task_dialog_param_edge_trimming"],
//     taskDialogParamAvoidanceCustomization: json["task_dialog_param_avoidance_customization"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "task_dialog_param_mowing_direction": taskDialogParamMowingDirection,
//     "task_dialog_param_exit_mode": taskDialogParamExitMode,
//     "task_dialog_param_edge_trimming": taskDialogParamEdgeTrimming,
//     "task_dialog_param_avoidance_customization": taskDialogParamAvoidanceCustomization,
//   };
// }
//
// class Language {
//   String magenta;
//   String frisky;
//   String mischievous;
//   String cunning;
//   String indecent;
//   String the1;
//   String the2;
//   String purple;
//   String fluffy;
//   String language;
//   String hilarious;
//   String tentacled;
//   String ambitious;
//   String braggadocious;
//   String sticky;
//   String indigo;
//   String the3;
//   String empty;
//
//   Language({
//     this.magenta,
//     this.frisky,
//     this.mischievous,
//     this.cunning,
//     this.indecent,
//     this.the1,
//     this.the2,
//     this.purple,
//     this.fluffy,
//     this.language,
//     this.hilarious,
//     this.tentacled,
//     this.ambitious,
//     this.braggadocious,
//     this.sticky,
//     this.indigo,
//     this.the3,
//     this.empty,
//   });
//
//   factory Language.fromJson(Map<String, dynamic> json) => Language(
//     magenta: json["简体中文"],
//     frisky: json["繁体中文"],
//     mischievous: json["英语"],
//     cunning: json["瑞典"],
//     indecent: json["日语"],
//     the1: json["葡萄牙"],
//     the2: json["西班牙语"],
//     purple: json["土耳其"],
//     fluffy: json["德语"],
//     language: json["俄语"],
//     hilarious: json["法语"],
//     tentacled: json["意大利语"],
//     ambitious: json["波兰"],
//     braggadocious: json["荷兰语"],
//     sticky: json["捷克"],
//     indigo: json["斯洛伐克"],
//     the3: json["韩语"],
//     empty: json["丹麦"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "简体中文": magenta,
//     "繁体中文": frisky,
//     "英语": mischievous,
//     "瑞典": cunning,
//     "日语": indecent,
//     "葡萄牙": the1,
//     "西班牙语": the2,
//     "土耳其": purple,
//     "德语": fluffy,
//     "俄语": language,
//     "法语": hilarious,
//     "意大利语": tentacled,
//     "波兰": ambitious,
//     "荷兰语": braggadocious,
//     "捷克": sticky,
//     "斯洛伐克": indigo,
//     "韩语": the3,
//     "丹麦": empty,
//   };
// }

import 'package:flutter/material.dart';
import 'package:glo_trans/model/target_language_config_model.dart';

class ConfigModel extends ChangeNotifier {
  ConfigModel({
    required this.deeplKey,
    required this.targetLanguageConfigList,
    this.l10nFlag,
    this.insertBeforeL10nFlag = true,
    this.androidFlag,
    this.insertBeforeAndroidFlag = true,
    this.systemLanguage = "china",
  });

  final String deeplKey;

  final List<TargetLanguageConfigModel> targetLanguageConfigList;

  /// 导出设置
  String? l10nFlag;
  bool insertBeforeL10nFlag; // 不是前面就是后面嘛
  String? androidFlag;
  bool insertBeforeAndroidFlag;

  /// 系统语言
  String systemLanguage;
}
