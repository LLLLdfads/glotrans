import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:glo_trans/utils.dart';
import 'package:glo_trans/view_model/app_data_view_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class TranslateView extends StatefulWidget {
  const TranslateView({super.key});

  @override
  State<TranslateView> createState() => _TranslateViewState();
}

class _TranslateViewState extends State<TranslateView> {
  late AppDataViewModel _appDataViewModel;
  late final PlutoGridStateManager stateManager;
  String? _currentSentence;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _appDataViewModel = context.read<AppDataViewModel>();
    _currentSentence = _appDataViewModel.currentSentence;
    _textEditingController.text = _currentSentence ?? "";
    setState(() {});
  }

  // 解析词条，开始翻译
  void _parseInputStrAndTranslate() {
    // 如果输入框为空或者无法解析，则不进行翻译
    if (_textEditingController.text.isEmpty) {
      showToast("请输入");
      return;
    }
    // 如果无法解析输入的文本，也需要有提示
    // 解析的键值对
    Map<String, String> keyValueMap = {};
    try {
      keyValueMap = parseInputStr(_textEditingController.text);
    } catch (e) {
      showToast("格式错误请确认");
      return;
    }
    _appDataViewModel.switchPage(1);
    _appDataViewModel.startTranslating(keyValueMap);
    _appDataViewModel.keyValueMap = keyValueMap;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 100, bottom: 20),
                    child: SizedBox(
                      height: 250.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          SizedBox(
                            height: 150,
                            width: 1000, // your scroll width
                            child: TextFormField(
                              controller: _textEditingController,
                              onChanged: (currentText) {
                                AppDataViewModel appDataViewModel =
                                    context.read<AppDataViewModel>();
                                appDataViewModel.currentSentence = currentText;
                                print("done");
                              },
                              keyboardType: TextInputType.multiline,
                              expands: true,
                              maxLines: null,
                              cursorColor: Colors.blue,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                              decoration: const InputDecoration(
                                hintText:
                                    '输入翻译文本键值对，如：\n"text_hello_world": "你好，世界",\n"text_china": "中国",\n...',
                                hintStyle: TextStyle(
                                    color: Colors.white24, fontSize: 18),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white24), // 未聚焦时下划线的颜色
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue), // 聚焦时下划线的颜色
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _parseInputStrAndTranslate,
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            Colors.white70.withAlpha(90)),
                        elevation: WidgetStateProperty.all<double>(0),
                        overlayColor:
                            WidgetStateProperty.all<Color>(Colors.white24)),
                    child: const Text("开始翻译",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class H extends StatefulWidget {
  const H({super.key});

  @override
  State<H> createState() => _HState();
}

class _HState extends State<H> {
  String? _configJosnFilePath;
  Map<String, dynamic>? _configJsonData;
  double _translatedLanguage = 0;
  final List<String> _texts = ["一杯敬故乡", "一杯敬过往", "唤醒我的善良温柔了寒窗"];
  final List<String> _targetLanguage = [
    "ZH-HANS",
    "ZH-HANT",
    "EN-US",
    "SV",
    "JA",
    "PT-PT",
    "ES",
    "TR",
    "DE",
    "RU",
    "FR",
    "IT",
    "PL",
    "NL",
    "CS",
    "SK",
    "KO",
    "DA"
  ];
  var headers = {
    'Authorization': 'DeepL-Auth-Key 1e6e86dd-797b-4fc7-aaf2-ab6efc120ea9:fx',
    'Content-Type': 'application/json',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: _getConfigJsonFilePath, child: const Text("选择文件")),
        _configJosnFilePath != null ? Text(_configJosnFilePath!) : Container(),
        ElevatedButton(onPressed: _parseJsonFile, child: const Text("解析文件")),
        _configJsonData != null
            ? Text(_configJsonData.toString().substring(0, 100))
            : Container(),
        ElevatedButton(onPressed: _translate, child: const Text("开始翻译")),
        Row(
          children: [
            ClipRRect(
              // 边界半径（`borderRadius`）属性，圆角的边界半径。
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: SizedBox(
                height: 20,
                width: 300,
                child: LinearProgressIndicator(
                  value: _translatedLanguage / _targetLanguage.length,
                  backgroundColor: const Color(0xffFFE3E3),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xffFF4964)),
                ),
              ),
            ),
            Text(
                "${(_translatedLanguage / _targetLanguage.length * 100).toStringAsFixed(1)}%")
          ],
        )
      ],
    );
  }

  Future<void> _getConfigJsonFilePath() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'], // 只允许选择 JSON 文件
      );
      if (result != null) {
        _configJosnFilePath = result.files.single.path!;
        setState(() {});
      } else {}
    } catch (e) {
      print(e);
    }
  }

  Future<void> _translate() async {
    for (var language in _targetLanguage) {
      await _translateOneLanguage(language);
    }
  }

  Future<void> _translateOneLanguage(String language) async {
    var dio = Dio();
    var url = 'https://api-free.deepl.com/v2/translate';

    try {
      var response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization':
                'DeepL-Auth-Key 1e6e86dd-797b-4fc7-aaf2-ab6efc120ea9:fx',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'target_lang': language,
          'text': _texts,
          'show_billed_characters': true,
        },
      );

      if (response.statusCode == 200) {
        print('翻译成功：${response.data}');
        setState(() {
          _translatedLanguage += 1;
        });
      } else {
        print('翻译失败：${response.statusCode}');
      }
    } catch (e) {
      print('发生错误：$e');
    }
  }

  void _parseJsonFile() async {
    File file = File(_configJosnFilePath!);
    String jsonString = await file.readAsString();
    _configJsonData = json.decode(jsonString);
    setState(() {});
  }
}
