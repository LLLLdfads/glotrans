import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:glo_trans/app_const.dart';
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

  // 在类的开始处添加一个 controller
  final ScrollController _logScrollController = ScrollController();
  final TextEditingController _logTextController = TextEditingController();

  PlutoGridStateManager? _stateManager;

  // 在需要添加日志的地方使用这个方法
  void _appendLog(String text) {
    _logTextController.text += '$text\n';
    // 确保滚动到最底部
    Future.delayed(const Duration(milliseconds: 50), () {
      _logScrollController.animateTo(
        _logScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _logScrollController.dispose();
    _logTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _appDataViewModel = context.read<AppDataViewModel>();
    // 预制翻译文本，方便调试
    // _appDataViewModel.currentSentence =
    // '"text_window":"窗户","text_table":"桌子","text_milk":"牛奶","text_bread":"面包","text_key":"钥匙","text_apple":"苹果","text_orange":"橘子","text_banana":"香蕉","text_onion":"洋葱","text_watermelon":"西瓜"';
    // '"text_window":"窗户","text_table":"桌子","text_milk":"牛奶","text_bread":"面包"';
    // '"text_window":"窗户","text_table":"桌子"';
    _currentSentence = _appDataViewModel.currentSentence;
    _textEditingController.text = _currentSentence ?? "";
    setState(() {});
  }

  // 解析词条，开始翻译
  void _parseInputStrAndTranslate() {
    // 如果输入框为空或者无法解析，则不进行翻译
    if (_textEditingController.text.isEmpty) {
      showToast("未检测到输入");
      return;
    }

    // 如果无法解析输入的文本，也需要有提示
    Map<String, String> keyValueMap = {};
    try {
      keyValueMap = parseInputStr(_textEditingController.text);
    } catch (e) {
      showToast("格式错误请确认");
      return;
    }
    // _appDataViewModel.switchPage(1);
    // _appDataViewModel.startTranslating(keyValueMap);
    // _appDataViewModel.keyValueMap = keyValueMap;
    _logTextController.clear();
    _appDataViewModel.totalTranslateCount = keyValueMap.length;
    _appDataViewModel.translateTakesTime = 0;
    _showProgressDialog();
    List<String> willDoLanStr = [];
    for (var i = 0; i < _appDataViewModel.willDoLan.length; i++) {
      if (_appDataViewModel.willDoLan[i]) {
        willDoLanStr.add(
            "${AppConst.supportLanMap.values.toList()[i]}_${AppConst.supportLanMap.keys.toList()[i]}");
      }
    }
    _appDataViewModel.translatedCount = 0;
    _appDataViewModel.stopTranslate = false;
    _appDataViewModel.totalTranslateCount =
        keyValueMap.length * willDoLanStr.length;
    _appDataViewModel.startTranslateTimer();
    _appDataViewModel.translate(keyValueMap, willDoLanStr, (String res) {
      _appendLog(res);
    });
  }

  // 防止dialog中切换页面，发生对已unmouted后的还更新状态的错误
  void _switchToExportView() async {
    Future.delayed(const Duration(milliseconds: 200), () {
      _appDataViewModel.switchPage(1);
    });
  }

  void _showProgressDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // 防止点击外部关闭
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
              height: 257,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: SizedBox(
                        width: 400,
                        height: 10,
                        child: Selector<AppDataViewModel, int>(
                          selector: (_, vm) => vm.translatedCount,
                          builder: (context, translatedCount, child) {
                            return LinearProgressIndicator(
                              value: translatedCount /
                                  _appDataViewModel.totalTranslateCount,
                              backgroundColor: const Color(0xFFE8F5E9),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4CAF50)),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Selector<AppDataViewModel, int>(
                        selector: (_, vm) => vm.translatedCount,
                        builder: (context, translatedCount, child) {
                          return Text(
                            '进度: $translatedCount/${_appDataViewModel.totalTranslateCount}',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                      const SizedBox(width: 20),
                      Selector<AppDataViewModel, int>(
                        selector: (_, vm) => vm.translateTakesTime,
                        builder: (context, time, child) {
                          return Text(
                            '耗时: $time 秒',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 150, // 可以调整高度
                    width: 400,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2D3E), // 深色背景
                      borderRadius: BorderRadius.circular(8),
                      // border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: TextField(
                      controller: _logTextController,
                      scrollController: _logScrollController,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      maxLines: null,
                      readOnly: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(8, 8, 18, 8),
                        border: InputBorder.none,
                        hintText: '翻译进度输出...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          _appDataViewModel.translateTimer?.cancel();
                          _appDataViewModel.stopTranslate = true;
                          exportToExcel(_appDataViewModel.currentTranslateRes);
                        },
                        child: const Text(
                          '导出表格',
                          style: TextStyle(color: Color(0xff347080)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _appDataViewModel.translateTimer?.cancel();
                          _appDataViewModel.stopTranslate = true;
                          _appDataViewModel.currentTable =
                              _appDataViewModel.currentTranslateRes;
                          Navigator.of(context).pop();
                          _switchToExportView();
                        },
                        child: const Text(
                          '表格查看',
                          style: TextStyle(color: Color(0xff347080)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _appDataViewModel.translateTimer?.cancel();
                          _appDataViewModel.stopTranslate = true;
                        },
                        child: const Text(
                          '取消翻译',
                          style: TextStyle(color: Color(0xff347080)),
                        ),
                      )
                    ],
                  )
                ],
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppDataViewModel vm = context.watch<AppDataViewModel>();
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 100,
          child: Center(
            child: Selector<AppDataViewModel, int>(
              selector: (_, vm) => vm.inputMode,
              builder: (context, inputMode, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              vm.inputMode == 0
                                  ? Colors.white70.withAlpha(90)
                                  : Colors.transparent),
                        ),
                        onPressed: () {
                          if (_appDataViewModel.currentSentence == null ||
                              _appDataViewModel.currentSentence == "") {
                            vm.setInputMode(0);
                            return;
                          }

                          // 如果无法解析输入的文本，也需要有提示
                          Map<String, String> keyValueMap = {};
                          try {
                            keyValueMap = parseInputStr(
                                _appDataViewModel.currentSentence!);
                          } catch (e) {
                            showToast("解析失败");
                            return;
                          }
                          vm.setInputMode(0);
                        },
                        child: const Text(
                          "表格输入",
                          style: TextStyle(color: Colors.white),
                        )),
                    TextButton(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0))),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              vm.inputMode == 1
                                  ? Colors.white70.withAlpha(90)
                                  : Colors.transparent),
                        ),
                        onPressed: () {
                          vm.setInputMode(1);
                          _textEditingController.text =
                              _appDataViewModel.currentSentence ?? "";
                        },
                        child: const Text(
                          "文本输入",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                );
              },
            ),
          ),
        ),
        Expanded(
          child: PageView(
            children: [
              Column(
                children: [
                  Selector<AppDataViewModel, int>(
                    selector: (_, vm) => vm.inputMode,
                    builder: (context, inputMode, child) {
                      if (inputMode == 0) {
                        List<PlutoRow> rows = [];
                        if (_appDataViewModel.currentSentence != null &&
                            _appDataViewModel.currentSentence != "") {
                          Map<String, String> keyValueMap =
                              parseInputStr(_appDataViewModel.currentSentence!);

                          for (var key in keyValueMap.keys) {
                            rows.add(PlutoRow(cells: {
                              'key': PlutoCell(value: key),
                              'value': PlutoCell(value: keyValueMap[key]!),
                            }));
                          }
                        }

                        rows.add(PlutoRow(cells: {
                          'key': PlutoCell(value: ''),
                          'value': PlutoCell(value: ''),
                        }));

                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 20),
                          child: SizedBox(
                            height: 350,
                            child: PlutoGrid(
                              columns: <PlutoColumn>[
                                PlutoColumn(
                                  width: 289,
                                  backgroundColor: Colors.white.withAlpha(20),
                                  textAlign: PlutoColumnTextAlign.center,
                                  titleTextAlign: PlutoColumnTextAlign.center,
                                  enableContextMenu: false,
                                  title: '键',
                                  field: 'key',
                                  type: PlutoColumnType.text(),
                                ),
                                PlutoColumn(
                                  width: 289,
                                  backgroundColor: Colors.white.withAlpha(20),
                                  textAlign: PlutoColumnTextAlign.center,
                                  titleTextAlign: PlutoColumnTextAlign.center,
                                  enableContextMenu: false,
                                  title: '值',
                                  field: 'value',
                                  type: PlutoColumnType.text(),
                                ),
                              ],
                              rows: rows,
                              onLoaded: (PlutoGridOnLoadedEvent event) {
                                _stateManager = event.stateManager;
                                // // 初始化表格
                                // final newRows = <PlutoRow>[];

                                // for (List<String> row in _appDataViewModel.currentTable) {
                                //   if (row.length != _headerStringList.length) {
                                //     row.addAll(
                                //         List.filled(_headerStringList.length - row.length, ''));
                                //   }
                                //   newRows.add(PlutoRow(
                                //       cells: Map.fromIterables(_headerStringList,
                                //           row.map((e) => PlutoCell(value: e)))));
                                // }

                                // // 先清空现有行
                                // _stateManager!.removeAllRows();
                                // // 然后添加新行
                                // _stateManager!.appendRows(newRows);
                                // _stateManager!.moveScrollByRow(
                                //     PlutoMoveDirection.down, _stateManager!.rows.length - 2);
                                // _applyTableData(_appDataViewModel.currentTable);
                              },
                              onChanged: (PlutoGridOnChangedEvent event) {
                                print(event);
                                // 当前行数量
                                int currentRowCount =
                                    _stateManager!.rows.length;
                                // 如果在之后一行有新的值，那么再添加一行
                                if (event.row.cells['value']!.value != '' ||
                                    event.row.cells['key']!.value != '') {
                                  // 如果最后一行键值对都是"","",那么不添加行
                                  if (_stateManager!.rows[currentRowCount - 1]
                                              .cells['key']!.value !=
                                          '' &&
                                      _stateManager!.rows[currentRowCount - 1]
                                              .cells['value']!.value !=
                                          '') {
                                    _stateManager!.appendRows([
                                      PlutoRow(cells: {
                                        'key': PlutoCell(value: ''),
                                        'value': PlutoCell(value: ''),
                                      })
                                    ]);
                                  }
                                }
                                // 状态管理中的数据也要变一下
                                // step1 先把rows中key和value都为空或“”的行去除
                                Map<String, String> keyValueMap = {};
                                _stateManager!.rows.forEach((row) {
                                  if (row.cells['key']!.value == '' &&
                                      row.cells['value']!.value == '') {
                                  } else {
                                    keyValueMap[row.cells['key']!.value] =
                                        row.cells['value']!.value;
                                  }
                                });
                                _appDataViewModel.currentSentence = keyValueMap
                                    .entries
                                    .map((e) => "\"${e.key}\":\"${e.value}\"")
                                    .join(',');
                              },
                              configuration: PlutoGridConfiguration(
                                style: PlutoGridStyleConfig(
                                  activatedColor:
                                      const Color.fromARGB(255, 42, 41, 41),
                                  activatedBorderColor:
                                      const Color.fromARGB(255, 31, 157, 216),
                                  inactivatedBorderColor:
                                      const Color.fromARGB(255, 23, 112, 153),
                                  cellColorInEditState:
                                      Colors.black.withAlpha(20),
                                  columnTextStyle: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  cellTextStyle: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 14,
                                  ),
                                  iconColor: Colors.transparent,
                                  gridBackgroundColor:
                                      Colors.white.withAlpha(5),
                                  // gridBackgroundColor: Colors.transparent,
                                  oddRowColor: Colors.transparent,
                                  evenRowColor: Colors.transparent,
                                  // borderColor: Color.fromARGB(255, 255, 255, 255),
                                  borderColor: Colors.white.withAlpha(20),
                                  gridBorderColor: Colors.transparent,
                                  gridBorderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 100, bottom: 20),
                        child: SizedBox(
                          height: 250,
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
                                    appDataViewModel.currentSentence =
                                        _textEditingController.text;
                                    print("onchange done");
                                  },
                                  onEditingComplete: () {
                                    AppDataViewModel appDataViewModel =
                                        context.read<AppDataViewModel>();
                                    appDataViewModel.currentSentence =
                                        _textEditingController.text;
                                    print("onEditingComplete done");
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
                      );
                    },
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
