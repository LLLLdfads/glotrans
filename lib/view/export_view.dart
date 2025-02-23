import 'package:flutter/material.dart';
import 'package:glo_trans/utils.dart';
import 'package:glo_trans/view_model/app_data_view_model.dart';
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
  List<String> _headerStringList = [];

  final List<PlutoColumn> header = <PlutoColumn>[
    // PlutoColumn(
    //   width: 70,
    //   textAlign: PlutoColumnTextAlign.center,
    //   titleTextAlign: PlutoColumnTextAlign.center,
    //   enableContextMenu: false,
    //   title: 'index',
    //   field: 'index',
    //   type: PlutoColumnType.text(),
    // ),
    // PlutoColumn(
    //   titleTextAlign: PlutoColumnTextAlign.center,
    //   enableContextMenu: false,
    //   title: 'Name',
    //   field: 'name',
    //   type: PlutoColumnType.text(),
    // ),
    // PlutoColumn(
    //   titleTextAlign: PlutoColumnTextAlign.center,
    //   enableContextMenu: false,
    //   title: '简体中文',
    //   field: 'zh',
    //   type: PlutoColumnType.text(),
    // ),
    // PlutoColumn(
    //   titleTextAlign: PlutoColumnTextAlign.center,
    //   enableContextMenu: false,
    //   title: '繁体中文',
    //   field: 'tw',
    //   type: PlutoColumnType.text(),
    // ),
    // PlutoColumn(
    //   titleTextAlign: PlutoColumnTextAlign.center,
    //   enableContextMenu: false,
    //   title: '英语',
    //   field: 'en',
    //   type: PlutoColumnType.text(),
    // ),
  ];

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
    _appDataViewModel.addListener(_handleAppDataVM);
    _initTable();
  }

  /// 初始化表格的表头
  void _initTable() {
    header.add(PlutoColumn(
      width: 70,
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
      title: 'index',
      field: 'index',
      type: PlutoColumnType.text(),
    ));
    header.add(PlutoColumn(
      width: 150,
      textAlign: PlutoColumnTextAlign.center,
      titleTextAlign: PlutoColumnTextAlign.center,
      title: 'key',
      field: 'key',
      type: PlutoColumnType.text(),
    ));
    for (var e in _appDataViewModel.config.targetLanguageConfigList
        .where((e) => e.willTranslate)
        .toList()) {
      header.add(PlutoColumn(
        titleTextAlign: PlutoColumnTextAlign.center,
        enableContextMenu: false,
        title: "${e.country}-${e.language}",
        field: e.language,
        type: PlutoColumnType.text(),
      ));
    }
    header.forEach((e) {
      _headerStringList.add(e.field);
    });
  }

  void _handleAppDataVM() {
    if (!mounted) return; // 不加这行将导致找不到上下文
    _addRow(_appDataViewModel.translateResult);
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

  Widget _buildProgressBar() {
    var vm = context.watch<AppDataViewModel>();
    if (!vm.translating) {
      return const SizedBox();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          // 边界半径（`borderRadius`）属性，圆角的边界半径。
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: SizedBox(
            width: 250,
            height: 10,
            child: LinearProgressIndicator(
              value: vm.currentTranslateProgress / vm.willTranslateCount,
              backgroundColor: const Color.fromARGB(255, 7, 8, 8),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 35, 235, 71)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "${vm.currentTranslateProgress}/${vm.willTranslateCount} takes ${vm.translateTakesTime} s",
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        _buildProgressBar(),
        Expanded(
            child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: PlutoGrid(
            columns: header,
            rows: rows,
            onLoaded: (PlutoGridOnLoadedEvent event) {
              _stateManager = event.stateManager;
              // 初始化表格
              final newRows = <PlutoRow>[];

              for (List<String> row in _appDataViewModel.translateResult) {
                if (row.length != _headerStringList.length) {
                  row.addAll(
                      List.filled(_headerStringList.length - row.length, ''));
                }
                newRows.add(PlutoRow(
                    cells: Map.fromIterables(_headerStringList,
                        row.map((e) => PlutoCell(value: e)))));
              }

              // 先清空现有行
              _stateManager!.removeAllRows();
              // 然后添加新行
              _stateManager!.appendRows(newRows);
              _stateManager!.moveScrollByRow(
                  PlutoMoveDirection.down, _stateManager!.rows.length - 2);
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
                gridBorderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                  onPressed: () {
                    // _addRow();
                    // AppDataViewModel appDataViewModel =
                    //     context.read<AppDataViewModel>();
                    // appDataViewModel.testNotifyListeners();
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.white70.withAlpha(90)),
                      elevation: WidgetStateProperty.all<double>(0),
                      overlayColor:
                          WidgetStateProperty.all<Color>(Colors.white24)),
                  child: const Text("导入项目",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await exportToExcel(_stateManager!);
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.white70.withAlpha(90)),
                      elevation: WidgetStateProperty.all<double>(0),
                      overlayColor:
                          WidgetStateProperty.all<Color>(Colors.white24)),
                  child: const Text("导出表格",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
