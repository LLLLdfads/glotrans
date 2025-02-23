
import 'package:glo_trans/model/target_language_config_model.dart';
import 'package:hive/hive.dart';
part 'config_model.g.dart';
//@HiveField(Y) 注解用于定义数据模型类和字段，以便它们能够被 Hive 序列化和反序列化
//这个 typeId 是在整个应用中唯一的标识符，用于区分不同的 Hive 类型
//typeId 必须是全局唯一且为正整数，因为它是 Hive 用来识别不同类型对象的标识符。如果两个不同的类使用了相同的 typeId，可能会导致数据冲突或损坏。
@HiveType(typeId: 0)
class ConfigModel {
  ConfigModel({
    required this.deeplKey,
    required this.targetLanguageConfigList,
    this.l10nFlag,
    this.insertBeforeL10nFlag = true,
    this.androidFlag,
    this.insertBeforeAndroidFlag = true,
    this.systemLanguage = "china",
  });

  @HiveField(0)
  final String deeplKey;

  @HiveField(1)
  final List<TargetLanguageConfigModel> targetLanguageConfigList;

  /// 导出设置
  @HiveField(2)
  String? l10nFlag;
  @HiveField(3)
  bool insertBeforeL10nFlag; // 不是前面就是后面嘛
  @HiveField(4)
  String? androidFlag;
  @HiveField(5)
  bool insertBeforeAndroidFlag;

  /// 系统语言
  @HiveField(6)
  String systemLanguage;
}
