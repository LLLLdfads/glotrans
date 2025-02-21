import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:glo_trans/app_const.dart';

/// 将输入的json文本解析成map键值对
Map<String, String> parseInputStr(String inputStr) {
  Map<String, String> map = {};
  var tempMap = jsonDecode("{$inputStr}");
  tempMap.forEach((key, value) => map[key] = value.toString());
  return map;
}

/// 打开文件选择器
Future<String?> pickFile(String fileCate) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [fileCate], // 只允许选择 JSON 文件
    );
    if (result != null) {
      String filePath = result.files.single.path!;
      return filePath;
    } else {}
  } catch (e) {
    print(e);
  }
}

// 翻译一种语言（多个文本），暂时不用了，展示不好看
Future<List<String>> translateOneLanguageTexts(
    String language, List<String> texts, String key) async {
  var dio = Dio();
  var url = AppConst.deeplurl;
  List<String> res = [];
  try {
    var response = await dio.post(
      url,
      options: Options(
        headers: {
          'Authorization': 'DeepL-Auth-Key $key',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'target_lang': language,
        'text': texts,
        'show_billed_characters': true,
      },
    );

    if (response.statusCode == 200) {
      print('翻译成功：${response.data}');
      response.data['translations'].forEach((e) {
        res.add(e.toString());
      });
    } else {
      print('翻译失败：${response.statusCode}');
    }
  } catch (e) {
    print('发生错误：$e');
  }
  return res;
}

// 翻译一种语言（单个文本）
Future<String> translateOneLanguageText(
    String language, String text, String key) async {
  var dio = Dio();
  var url = AppConst.deeplurl;
  String res = "";
  try {
    var response = await dio.post(
      url,
      options: Options(
        headers: {
          'Authorization': 'DeepL-Auth-Key $key',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'target_lang': language,
        'text': [text],
        'show_billed_characters': true,
      },
    );

    if (response.statusCode == 200) {
      print('翻译成功：${response.data}');
      // response.data['translations'].forEach((e) {
      //   res.add(e.toString());
      // });
      res = response.data['translations'][0].toString();
    } else {
      print('翻译失败：${response.statusCode}');
    }
    return res;
  } catch (e) {
    print('发生错误：$e');
    return "error";
  }
}

// 翻译一种语言（单个文本）,不调用接口，直接返回
Future<String> translateOneLanguageTextForDev(
    String language, String text, String key) async {
  await Future.delayed(const Duration(milliseconds: 100));
  return "$language -$text";
}
