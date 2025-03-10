
import 'package:hive/hive.dart';
part 'export_setting_model.g.dart';
//@HiveField(Y) 注解用于定义数据模型类和字段，以便它们能够被 Hive 序列化和反序列化
//这个 typeId 是在整个应用中唯一的标识符，用于区分不同的 Hive 类型
//typeId 必须是全局唯一且为正整数，因为它是 Hive 用来识别不同类型对象的标识符。如果两个不同的类使用了相同的 typeId，可能会导致数据冲突或损坏。
@HiveType(typeId: 4)
class ExportSettingModel {
  ExportSettingModel({
    required this.toL10n,
    required this.toAndroid,
    required this.l10nFiles,
    required this.l10nFilesEnable,
    required this.androidFiles,
    required this.androidFilesEnable,
    required this.l10nFlag,
    required this.androidFlag,
    required this.isInsertBeforeL10nFlag,
    required this.isInsertBeforeAndroidFlag,
  });

  @HiveField(0)
  final bool toL10n;

  @HiveField(1)
  final bool toAndroid;

  /// 是一个长度为语言数量的列表，初始都是""
  @HiveField(2)
  final List<String> l10nFiles;

  /// 是一个长度为语言数量的列表，初始都是false
  @HiveField(3)
  final List<bool> l10nFilesEnable;

  /// 是一个长度为语言数量的列表，初始都是""
  @HiveField(4)
  final List<String> androidFiles;

  /// 是一个长度为语言数量的列表，初始都是false
  @HiveField(5)
  final List<bool> androidFilesEnable;

  /// 初始都是""
  @HiveField(6)
  final String l10nFlag;

  /// 初始是""
  @HiveField(7)
  final String androidFlag;

  /// 初始是true
  @HiveField(8)
  final bool isInsertBeforeL10nFlag;

  /// 初始是true
  @HiveField(9)
  final bool isInsertBeforeAndroidFlag;

  Map<String, Object> toJson(){
    return {
      "toL10n": toL10n,
      "toAndroid": toAndroid,
      "l10nFiles": l10nFiles,
      "l10nFilesEnable": l10nFilesEnable,
      "androidFiles": androidFiles,
      "androidFilesEnable": androidFilesEnable,
      "l10nFlag": l10nFlag,
      "androidFlag": androidFlag,
      "isInsertBeforeL10nFlag": isInsertBeforeL10nFlag,
      "isInsertBeforeAndroidFlag": isInsertBeforeAndroidFlag,
    };
  }
  ExportSettingModel changeAttr({
    bool? toL10n,
    bool? toAndroid,
    List<String>? l10nFiles,
    List<bool>? l10nFilesEnable,
    List<String>? androidFiles,
    List<bool>? androidFilesEnable,
    String? l10nFlag,
    String? androidFlag,
    bool? isInsertBeforeL10nFlag,
    bool? isInsertBeforeAndroidFlag,
  }){
    return ExportSettingModel(
      toL10n: toL10n ?? this.toL10n,
      toAndroid: toAndroid ?? this.toAndroid,
      l10nFiles: l10nFiles ?? this.l10nFiles,
      l10nFilesEnable: l10nFilesEnable ?? this.l10nFilesEnable,
      androidFiles: androidFiles ?? this.androidFiles,
      androidFilesEnable: androidFilesEnable ?? this.androidFilesEnable,
      l10nFlag: l10nFlag ?? this.l10nFlag,
      androidFlag: androidFlag ?? this.androidFlag,
      isInsertBeforeL10nFlag: isInsertBeforeL10nFlag ?? this.isInsertBeforeL10nFlag,
      isInsertBeforeAndroidFlag: isInsertBeforeAndroidFlag ?? this.isInsertBeforeAndroidFlag,
    );
  }

}
