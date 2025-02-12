import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TranslateView extends StatefulWidget {
  const TranslateView({super.key});

  @override
  State<TranslateView> createState() => _TranslateViewState();
}

class _TranslateViewState extends State<TranslateView> {
  bool _hasResult = false;
  bool _inResultView = false;

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      titleTextAlign: PlutoColumnTextAlign.center,
      enableContextMenu: false,
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      titleTextAlign: PlutoColumnTextAlign.center,
      enableContextMenu: false,
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      titleTextAlign: PlutoColumnTextAlign.center,
      enableContextMenu: false,
      title: 'Age',
      field: 'age',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      titleTextAlign: PlutoColumnTextAlign.center,
      enableContextMenu: false,
      title: 'Joined',
      field: 'joined',
      type: PlutoColumnType.date(),
    ),
    PlutoColumn(
      titleTextAlign: PlutoColumnTextAlign.center,
      enableContextMenu: false,
      title: 'Working time',
      field: 'working_time',
      type: PlutoColumnType.time(),
    ),
  ];

  final List<PlutoRow> rows = [
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 'user1'),
        'name': PlutoCell(value: 'Mike'),
        'age': PlutoCell(value: 20),
        'joined': PlutoCell(value: '2021-01-01'),
        'working_time': PlutoCell(value: '09:00'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 'user2'),
        'name': PlutoCell(value: 'Jack'),
        'age': PlutoCell(value: 25),
        'joined': PlutoCell(value: '2021-02-01'),
        'working_time': PlutoCell(value: '10:00'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 'user3'),
        'name': PlutoCell(value: 'Suzi'),
        'age': PlutoCell(value: 40),
        'joined': PlutoCell(value: '2021-03-01'),
        'working_time': PlutoCell(value: '11:00'),
      },
    ),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Icon(Icons.arrow_back_ios,
                  color: _inResultView ? Colors.white54 : Colors.white10),
              const SizedBox(
                width: 20,
              ),
              Icon(Icons.arrow_forward_ios,
                  color: _hasResult ? Colors.white54 : Colors.white10),
            ],
          ),
        ),
        Expanded(
          child: PageView(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ClipRRect(
                        // 边界半径（`borderRadius`）属性，圆角的边界半径。
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: SizedBox(
                          height: 15,
                          width: 300,
                          child: LinearProgressIndicator(
                            value: 1 / 20,
                            backgroundColor: Color(0xff436E7E),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.lightGreen),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${(1 / 2 * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "takes 10s",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      )
                    ],
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    child: PlutoGrid(
                      columns: columns,
                      rows: rows,
                      onLoaded: (PlutoGridOnLoadedEvent event) {
                        // stateManager = event.stateManager;
                      },
                      onChanged: (PlutoGridOnChangedEvent event) {
                        print(event);
                      },
                      configuration: const PlutoGridConfiguration(
                        style: PlutoGridStyleConfig(
                          iconColor: Colors.transparent,
                          gridBackgroundColor: Colors.white38,
                          oddRowColor: Colors.white60,
                          borderColor: Colors.white70,
                          gridBorderColor: Colors.transparent,
                          gridBorderRadius:
                              BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                    ),
                  )),
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.white70.withAlpha(90)),
                                elevation: MaterialStateProperty.all<double>(0),
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.white24)),
                            child: const Text("导入项目",
                                style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                          const SizedBox(width: 20,),
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.white70.withAlpha(90)),
                                elevation: MaterialStateProperty.all<double>(0),
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.white24)),
                            child: const Text("导出表格",
                                style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
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
                              keyboardType: TextInputType.multiline,
                              expands: true,
                              maxLines: null,
                              cursorColor: Colors.white24,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                              decoration: const InputDecoration(
                                hintText:
                                    '输入翻译文本键值对，如：\n\"text_hello_world\": \"你好，世界\",\n\"text_china\": \"中国\",\n...',
                                hintStyle: TextStyle(
                                    color: Colors.white24, fontSize: 18),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xff347080)), // 未聚焦时下划线的颜色
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white24), // 聚焦时下划线的颜色
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.white70.withAlpha(90)),
                        elevation: MaterialStateProperty.all<double>(0),
                        overlayColor:
                            MaterialStateProperty.all<Color>(Colors.white24)),
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
  List<String> _texts = ["一杯敬故乡", "一杯敬过往", "唤醒我的善良温柔了寒窗"];
  List<String> _targetLanguage = [
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
                  backgroundColor: Color(0xffFFE3E3),
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
