
import 'package:hive/hive.dart';
part 'system_setting_model.g.dart';
//@HiveField(Y) 注解用于定义数据模型类和字段，以便它们能够被 Hive 序列化和反序列化
//这个 typeId 是在整个应用中唯一的标识符，用于区分不同的 Hive 类型
//typeId 必须是全局唯一且为正整数，因为它是 Hive 用来识别不同类型对象的标识符。如果两个不同的类使用了相同的 typeId，可能会导致数据冲突或损坏。
@HiveType(typeId: 5)
class SystemSettingModel {
  SystemSettingModel({
    this.systemLan = 0,
    this.themeKind = 0,
  });

  @HiveField(0)
  final int systemLan;

  @HiveField(1)
  final int themeKind;

  Map<String, Object> toJson() {
    return {
      "systemLan": systemLan,
      "themeKind": themeKind,
    };
  }

  SystemSettingModel changeAttr({int? systemLan, int? themeKind}) {
    return SystemSettingModel(
      systemLan: systemLan ?? this.systemLan,
      themeKind: themeKind ?? this.themeKind,
    );
  }
}
