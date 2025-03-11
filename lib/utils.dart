import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:glo_trans/app_const.dart';
import 'package:pluto_grid/pluto_grid.dart';

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
  return null;
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
  key = "1e6e86dd-797b-4fc7-aaf2-ab6efc120ea9:fx";

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
      res = response.data['translations'][0]['text'].toString();
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
  key = "1e6e86dd-797b-4fc7-aaf2-ab6efc120ea9:fx";
  await Future.delayed(const Duration(milliseconds: 50));
  return "$language -$text";
}

Future<void> exportToExcelForPGSM(PlutoGridStateManager stateManager) async {
  // 创建一个新的 Excel 文件
  var excel = Excel.createExcel();

  // 获取当前表格的 Sheet
  var sheet = excel['Sheet1'];

  // 添加表头
  for (var i = 0; i < stateManager.columns.length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value =
        stateManager.columns[i].title;
  }

  // 添加数据行
  for (var rowIndex = 0; rowIndex < stateManager.rows.length; rowIndex++) {
    var row = stateManager.rows[rowIndex];
    for (var colIndex = 0; colIndex < stateManager.columns.length; colIndex++) {
      var cell = row.cells[stateManager.columns[colIndex].field];
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: colIndex, rowIndex: rowIndex + 1))
          .value = cell?.value.toString();
    }
  }

  // 保存文件
  var fileBytes = excel.save();
  if (fileBytes != null) {
    // 使用 file_picker 选择保存路径
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: '保存 Excel 文件',
      fileName: 'exported_data.xlsx',
    );

    if (outputFile != null) {
      // 写入文件
      await File(outputFile).writeAsBytes(fileBytes);
    }
  }
}

// list格式导出excel
Future<void> exportToExcel(List<List<String>> data) async {
  // 创建一个新的 Excel 文件
  var excel = Excel.createExcel();

  // 获取当前表格的 Sheet
  var sheet = excel['Sheet1'];

  // 添加数据行
  for (var rowIndex = 0; rowIndex < data.length; rowIndex++) {
    var row = data[rowIndex];
    for (var colIndex = 0; colIndex < row.length; colIndex++) {
      var cell = row[colIndex];
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: colIndex, rowIndex: rowIndex))
          .value = cell;
    }
  }

  // 保存文件
  var fileBytes = excel.save();
  if (fileBytes != null) {
    // 保存的文件名称以为当前时间为准，如2025年3月11日10点10分，就命名成25_0311_1010
    String now = DateTime.now().toString();
    String fileName =
        '${now.substring(0, 4)}_${now.substring(5, 7)}_${now.substring(11, 13)}_${now.substring(14, 16)}';
    // 使用 file_picker 选择保存路径
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: '保存 Excel 文件',
      fileName: '$fileName.xlsx',
    );

    if (outputFile != null) {
      // 写入文件
      await File(outputFile).writeAsBytes(fileBytes);
    }
  }
}
