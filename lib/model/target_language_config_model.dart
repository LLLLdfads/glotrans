class TargetLanguageConfigModel{
  TargetLanguageConfigModel({
    required this.language,
    required this.country,
    this.l10nPath,
    this.usel10n = false,
    this.androidPath,
    this.useAndroid = false,
    this.willTranslate = false,
  });
  final String language;
  /// 不一定是国家名称，也可能是某种文字，如中文而非“中国”
  final String country;
  bool willTranslate;
  String? l10nPath;
  bool usel10n;
  String? androidPath;
  bool useAndroid;
}
