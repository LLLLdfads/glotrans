import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glo_trans/app_const.dart';
import 'package:glo_trans/utils.dart';
import 'package:glo_trans/view_model/app_data_view_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class ExportView extends StatefulWidget {
  const ExportView({super.key});

  @override
  State<ExportView> createState() => _ExportViewState();
}

class _ExportViewState extends State<ExportView> {
  late AppDataViewModel _appDataViewModel;
  PlutoGridStateManager? _stateManager;
  final List<String> _headerStringList = [];

  final List<PlutoColumn> header = <PlutoColumn>[];

  final List<PlutoRow> rows = [
    // PlutoRow(
    //   cells: {
    //     'index': PlutoCell(value: '0'),
    //     'name': PlutoCell(value: '1'),
    //     'zh': PlutoCell(value: 20),
    //     'tw': PlutoCell(value: '2021-01-01'),
    //     'en': PlutoCell(value: '09:00'),
    //   },
    // ),
    // PlutoRow(
    //   cells: {
    //     'index': PlutoCell(value: '1'),
    //     'name': PlutoCell(value: '2'),
    //     'zh': PlutoCell(value: 20),
    //     'tw': PlutoCell(value: '2021-01-01'),
    //     'en': PlutoCell(value: '09:00'),
    //   },
    // ),
    // PlutoRow(
    //   cells: {
    //     'index': PlutoCell(value: '2'),
    //     'name': PlutoCell(value: '3'),
    //     'zh': PlutoCell(value: 20),
    //     'tw': PlutoCell(value: '2021-01-01'),
    //     'en': PlutoCell(value: '09:00'),
    //   },
    // ),
  ];

  @override
  void initState() {
    super.initState();
    _appDataViewModel = context.read<AppDataViewModel>();
    // _appDataViewModel.addListener(_handleAppDataVM);
    _initTable();
  }

  /// 初始化表格的表头
  void _initTable() {
    // header.add(PlutoColumn(
    //   width: 70,
    //   textAlign: PlutoColumnTextAlign.center,
    //   titleTextAlign: PlutoColumnTextAlign.center,
    //   title: 'index',
    //   field: 'index',
    //   type: PlutoColumnType.text(),
    // ));
    // header.add(PlutoColumn(
    //   width: 150,
    //   textAlign: PlutoColumnTextAlign.center,
    //   titleTextAlign: PlutoColumnTextAlign.center,
    //   title: 'key',
    //   field: 'key',
    //   type: PlutoColumnType.text(),
    // ));
    // for (var e in _appDataViewModel.config.targetLanguageConfigList
    //     .where((e) => e.willTranslate)
    //     .toList()) {
    //   header.add(PlutoColumn(
    //     titleTextAlign: PlutoColumnTextAlign.center,
    //     enableContextMenu: false,
    //     title: "${e.country}-${e.language}",
    //     field: e.language,
    //     type: PlutoColumnType.text(),
    //   ));
    // }
    // header.forEach((e) {
    //   _headerStringList.add(e.field);
    // });
    // 将状态管理中的currentTable应用到表格中
    // _applyTableData(_appDataViewModel.currentTable);
  }

  void _handleAppDataVM() {
    if (!mounted) return; // 不加这行将导致找不到上下文
    // if (_appDataViewModel.translating) {
    //   _addRow(_appDataViewModel.translateResult);
    // } else {
    //   // 将表格的数据应用
    //   _applyTableData(_appDataViewModel.translateResult);
    // }
  }

  // 将table数据应用到表格中
  void _applyTableData(List<List<String>> rows) {
    // 将原先表格的header删除
    _stateManager!.removeColumns(_stateManager!.columns);
    // 将table数据的第一行作为header
    List<PlutoColumn> newHeader = [];
    rows.first.forEach((e) {
      newHeader.add(PlutoColumn(
        titleTextAlign: PlutoColumnTextAlign.center,
        enableContextMenu: false,
        title: e,
        field: e,
        type: PlutoColumnType.text(),
      ));
    });
    // 添加header
    for (int i = 0; i < newHeader.length; i++) {
      _stateManager!.insertColumns(i, [newHeader[i]]);
    }
    _stateManager!.removeAllRows();
    // 将table数据应用到表格中(从第二行开始)
    _stateManager!.appendRows(
      rows
          .sublist(1)
          .map((e) => PlutoRow(
              cells: Map.fromIterables(
                  rows[0], e.map((e2) => PlutoCell(value: e2)))))
          .toList(),
    );
  }

  void _addRow(List<List<String>> translateResult) {
    // 创建一个新的临时列表
    final newRows = <PlutoRow>[];

    for (List<String> row in translateResult) {
      if (row.length != _headerStringList.length) {
        row.addAll(List.filled(_headerStringList.length - row.length, ''));
      }
      newRows.add(PlutoRow(
          cells: Map.fromIterables(
              _headerStringList, row.map((e) => PlutoCell(value: e)))));
    }

    // 先清空现有行
    _stateManager!.removeAllRows();
    // 然后添加新行
    _stateManager!.appendRows(newRows);
    _stateManager!.moveScrollByRow(
        PlutoMoveDirection.down, _stateManager!.rows.length - 2);
  }

  int findInsertLineIndex(List<String> lines, String flag, bool insertBefore) {
    if (flag.isEmpty) {
      return lines.length; // 如果没有标记，则在文件末尾插入
    }

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains(flag)) {
        return insertBefore ? i : i + 1; // 根据insertBefore决定是在标记行前还是标记行后插入
      }
    }

    return lines.length; // 如果没找到标记，则在文件末尾插入
  }

  Future<void> importProject() async {
    if (_appDataViewModel.currentTable.isEmpty) {
      showToast("无数据，请导入excel、翻译或从历史输入中选择一个数据进行导出");
      return;
    }

    // 如果压根没有设置tol10n或者toAndroid,则不导出
    if (!(_appDataViewModel.exportingModel.toL10n ||
        _appDataViewModel.exportingModel.toAndroid)) {
      showToast("请在导出设置中设置导入l10n或android");
      return;
    }

    // 如果flag为空，则不进行翻译
    if (_appDataViewModel.exportingModel.toL10n) {
      if (_appDataViewModel.exportingModel.l10nFlag.isEmpty) {
        showToast("未定义插入标识，请在导出设置中设置l10n flag");
        return;
      }
    }
    if (_appDataViewModel.exportingModel.toAndroid) {
      if (_appDataViewModel.exportingModel.androidFlag.isEmpty) {
        showToast("未定义插入标识，请在导出设置中设置android flag");
        return;
      }
    }

    // 获取所有行的数据（跳过表头）
    List<String> names = [];
    for (var row in _appDataViewModel.currentTable.skip(1)) {
      names.add(row[1]); // 第二列是key（第一列是index）
    }

    // 处理Flutter l10n文件
    if (_appDataViewModel.exportingModel.toL10n) {
      // 如果l10nFilesEnable中元素都为false，则不处理
      if (_appDataViewModel.exportingModel.l10nFilesEnable.every((e) => !e)) {
        showToast("请选择导出文件");
        return;
      }
      for (int fileIndex = 0;
          fileIndex < _appDataViewModel.exportingModel.l10nFiles.length;
          fileIndex++) {
        String filePath = _appDataViewModel.exportingModel.l10nFiles[fileIndex];
        if (filePath.isEmpty ||
            !_appDataViewModel.exportingModel.l10nFilesEnable[fileIndex]) {
          continue;
        }

        File l10nFile = File(filePath);
        if (!await l10nFile.exists()) {
          print('合入flutter ${filePath.split('/').last}失败!文件不存在 ❌');
          continue;
        }

        // 如果语言文件存在，但是currentTable中没有对应的语言，如选择了英文文件，但是currentTable中没有英文的翻译结果，则不处理
        List<String> currentTableLanList = _appDataViewModel.currentTable[0]
            .map((e) => e.split('_').last)
            .toList();
        print(
            "当前导出文件：${filePath.split('/').last}，对应语言：${AppConst.supportLanMap.entries.toList()[fileIndex].key}");
        print("currentTable中的语言：${_appDataViewModel.currentTable.sublist(1)}");

        if (!currentTableLanList
            .contains(AppConst.supportLanMap.entries.toList()[fileIndex].key)) {
          print('合入flutter ${filePath.split('/').last}失败!文件不存在 ❌');
          continue;
        }

        List<String> valueToNameList = [];
        for (int i = 0; i < names.length; i++) {
          String value = _appDataViewModel.currentTable[i + 1]
              [fileIndex + 2]; // +2是因为前两列是index和key
          valueToNameList.add('  "${names[i]}": "$value",');
        }

        // 读取原文件内容
        List<String> l10nLines = await l10nFile.readAsLines();

        // 找到插入位置
        int insertIndex = findInsertLineIndex(
            l10nLines,
            _appDataViewModel.exportingModel.l10nFlag,
            _appDataViewModel.exportingModel.isInsertBeforeL10nFlag);

        // 插入新内容
        l10nLines.insertAll(insertIndex, valueToNameList);

        // 保存文件
        await l10nFile.writeAsString(l10nLines.join('\n'));
        print('合入flutter ${filePath.split('/').last}完成! ✔️');
      }
    }

    // 处理Android文件
    if (_appDataViewModel.exportingModel.toAndroid) {
      // 如果androidFilesEnable中元素都为false，则不处理
      if (_appDataViewModel.exportingModel.androidFilesEnable
          .every((e) => !e)) {
        showToast("请选择导出文件");
        return;
      }
      for (int fileIndex = 0;
          fileIndex < _appDataViewModel.exportingModel.androidFiles.length;
          fileIndex++) {
        String filePath =
            _appDataViewModel.exportingModel.androidFiles[fileIndex];
        if (filePath.isEmpty ||
            !_appDataViewModel.exportingModel.androidFilesEnable[fileIndex]) {
          continue;
        }

        File androidFile = File(filePath);
        if (!await androidFile.exists()) {
          print('合入android ${filePath.split('/').last}失败!文件不存在 ❌');
          continue;
        }

        // 如果语言文件存在，但是currentTable中没有对应的语言，如选择了英文文件，但是currentTable中没有英文的翻译结果，则不处理
        List<String> currentTableLanList = _appDataViewModel.currentTable[0]
            .map((e) => e.split('_').last)
            .toList();
        print(
            "当前导出文件：${filePath.split('/').last}，对应语言：${AppConst.supportLanMap.entries.toList()[fileIndex].key}");
        print("currentTable中的语言：${_appDataViewModel.currentTable.sublist(1)}");

        if (!currentTableLanList
            .contains(AppConst.supportLanMap.entries.toList()[fileIndex].key)) {
          print('合入android ${filePath.split('/').last}失败!文件不存在 ❌');
          continue;
        }

        List<String> valueToNameList = [];
        for (int i = 0; i < names.length; i++) {
          String value = _appDataViewModel.currentTable[i + 1][fileIndex + 2];
          value = value.replaceAll("'", "\\'").replaceAll("\n", "\\n");
          valueToNameList
              // ignore: unnecessary_brace_in_string_interps
              .add('    <string name="${names[i]}">${value}</string>');
        }

        // 读取原文件内容
        List<String> androidLines = await androidFile.readAsLines();

        // 找到插入位置
        int insertIndex = findInsertLineIndex(
            androidLines,
            _appDataViewModel.exportingModel.androidFlag,
            _appDataViewModel.exportingModel.isInsertBeforeAndroidFlag);

        // 插入新内容
        androidLines.insertAll(insertIndex, valueToNameList);

        // 保存文件
        await androidFile.writeAsString(androidLines.join('\n'));
        print('合入android ${filePath.split('/').last}完成! ✔️');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AppDataViewModel, List<List<String>>>(
        selector: (_, vm) => vm.currentTable,
        builder: (context, currentTable, child) {
          if (currentTable.isEmpty) {
            return const Center(
              child: Text(
                "空空如也～，快去翻译吧",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            );
          }
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                child: PlutoGrid(
                  columns: header,
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
                    _applyTableData(_appDataViewModel.currentTable);
                  },
                  onChanged: (PlutoGridOnChangedEvent event) {
                    print(event);
                  },
                  configuration: PlutoGridConfiguration(
                    style: PlutoGridStyleConfig(
                      activatedColor: const Color.fromARGB(255, 42, 41, 41),
                      activatedBorderColor:
                          const Color.fromARGB(255, 31, 157, 216),
                      inactivatedBorderColor:
                          const Color.fromARGB(255, 23, 112, 153),
                      cellColorInEditState: Colors.black.withAlpha(20),
                      columnTextStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      cellTextStyle: const TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                      iconColor: Colors.transparent,
                      // gridBackgroundColor: Color.fromARGB(97, 255, 255, 255),
                      gridBackgroundColor: Colors.white.withAlpha(10),

                      oddRowColor: Colors.white.withAlpha(30),
                      evenRowColor: Colors.white.withAlpha(20),
                      // borderColor: Color.fromARGB(255, 255, 255, 255),
                      borderColor: Colors.white.withAlpha(20),
                      gridBorderColor: Colors.transparent,
                      gridBorderRadius:
                          const BorderRadius.all(Radius.circular(5.0)),
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
                        onPressed: importProject,
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.white70.withAlpha(90)),
                            elevation: WidgetStateProperty.all<double>(0),
                            overlayColor:
                                WidgetStateProperty.all<Color>(Colors.white24)),
                        child: const Text("导入项目",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await exportToExcelForPGSM(_stateManager!);
                        },
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                Colors.white70.withAlpha(90)),
                            elevation: WidgetStateProperty.all<double>(0),
                            overlayColor:
                                WidgetStateProperty.all<Color>(Colors.white24)),
                        child: const Text("导出表格",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
