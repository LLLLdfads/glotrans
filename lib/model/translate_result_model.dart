import 'package:hive/hive.dart';
part 'translate_result_model.g.dart';

@HiveType(typeId: 3)
class TranslateResultModelList {
  @HiveField(0)
  final List<TranslateResultModel> translateResultList;

  TranslateResultModelList({required this.translateResultList});

  TranslateResultModelList add(TranslateResultModel translateResultModel) {
    translateResultList.add(translateResultModel);
    return this;
  }
  List<TranslateResultModel> getTranslateResultList() {
    return translateResultList;
  }
}

@HiveType(typeId: 2)
class TranslateResultModel {
  // 翻译结果的时间戳
  @HiveField(0)
  final String time;
  // 翻译结果的结果，表头为index，key，语言
  @HiveField(1)
  final List<String> header;
  // 翻译的结果，很多行，每行一个key的翻译结果
  @HiveField(2)
  final List<List<String>> rows;

  TranslateResultModel(
      {required this.time,
      required this.header,
      required this.rows});
}
