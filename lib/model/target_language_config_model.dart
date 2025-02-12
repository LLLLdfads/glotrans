class TargetLanguageConfigModel{
  TargetLanguageConfigModel({
    required this.language,
    required this.country,
    this.l10nPath,
    this.usel10n,
    this.androidPath,
    this.useAndroid
  });
  final String language;
  /// 不一定是国家名称，也可能是某种文字，如中文而非“中国”
  final String country;
  String? l10nPath;
  bool? usel10n;
  String? androidPath;
  bool? useAndroid;
}
