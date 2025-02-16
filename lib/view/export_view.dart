import 'package:flutter/material.dart';
import 'package:glo_trans/view_model/app_data_view_model.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class ExportView extends StatefulWidget {
  const ExportView({super.key});

  @override
  State<ExportView> createState() => _ExportViewState();
}

class _ExportViewState extends State<ExportView> {
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

  bool _translating = false;
  int _currentWillTranslateLanguageLength = 0;

  @override
  void initState() {
    super.initState();
    AppDataViewModel appDataViewModel = context.read<AppDataViewModel>();
    appDataViewModel.addListener(_handleAppDataVM);
  }

  void _handleAppDataVM() {
    AppDataViewModel appDataViewModel = context.read<AppDataViewModel>();
    _translating = appDataViewModel.translating;
    _currentWillTranslateLanguageLength =
        appDataViewModel.config.targetLanguageConfigList.length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              // 边界半径（`borderRadius`）属性，圆角的边界半径。
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: SizedBox(
                  height: 15,
                  width: 300,
                  child: _translating
                      ? Selector<AppDataViewModel, int>(
                          selector: (_, vm) => vm.currentTranslateProgress,
                          builder: (context, currentTranslateProgress, child) {
                            return LinearProgressIndicator(
                              value: currentTranslateProgress /
                                  _currentWillTranslateLanguageLength,
                              backgroundColor: const Color(0xff436E7E),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.lightGreen),
                            );
                          })
                      : Container()
                  // child: LinearProgressIndicator(
                  //   value: 1 / 20,
                  //   backgroundColor: Color(0xff436E7E),
                  //   valueColor: AlwaysStoppedAnimation<Color>(
                  //       Colors.lightGreen),
                  // ),
                  ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "${(1 / 2 * 100).toStringAsFixed(1)}%",
              style: const TextStyle(color: Colors.white70, fontSize: 16),
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
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
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
                    AppDataViewModel appDataViewModel =
                        context.read<AppDataViewModel>();
                    appDataViewModel.testNotifyListeners();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.white70.withAlpha(90)),
                      elevation: MaterialStateProperty.all<double>(0),
                      overlayColor:
                          MaterialStateProperty.all<Color>(Colors.white24)),
                  child: const Text("导入项目",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.white70.withAlpha(90)),
                      elevation: MaterialStateProperty.all<double>(0),
                      overlayColor:
                          MaterialStateProperty.all<Color>(Colors.white24)),
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
