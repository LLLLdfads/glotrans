class TargetLanguageConfigModel{
  TargetLanguageConfigModel({
    required this.language,
    required this.country,
    this.l10nPath,
    this.androidPath
  });
  final String language;
  final String country;
  String? l10nPath;
  String? androidPath;
}
