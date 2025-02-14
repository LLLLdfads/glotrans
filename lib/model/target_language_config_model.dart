import 'package:hive/hive.dart';
part 'target_language_config_model.g.dart';
@HiveType(typeId: 1)
class TargetLanguageConfigModel {
  TargetLanguageConfigModel({
    required this.language,
    required this.country,
    this.l10nPath,
    this.usel10n = false,
    this.androidPath,
    this.useAndroid = false,
    this.willTranslate = false,
  });

  @HiveField(0)
  final String language;

  /// 不一定是国家名称，也可能是某种文字，如中文而非“中国”
  @HiveField(1)
  final String country;
  @HiveField(2)
  bool willTranslate;
  @HiveField(3)
  String? l10nPath;
  @HiveField(4)
  bool usel10n;
  @HiveField(5)
  String? androidPath;
  @HiveField(6)
  bool useAndroid;
}
