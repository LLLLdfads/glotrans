
import 'package:flutter/material.dart';
import 'package:glo_trans/model/config_model.dart';

class AppDataViewModel extends ChangeNotifier {
  String? currentSentence;
  ConfigModel config=ConfigModel(deeplKey: "1e6e86dd-797b-4fc7-aaf2-ab6efc120ea9:fx", targetLanguageConfigList: []);
}