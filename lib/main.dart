import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glo_trans/app_const.dart';
import 'package:glo_trans/model/config_model.dart';
import 'package:glo_trans/model/target_language_config_model.dart';
import 'package:glo_trans/service/config_store.dart';
import 'package:glo_trans/view/export_view.dart';
import 'package:glo_trans/view/history_view.dart';
import 'package:glo_trans/view/setting_view.dart';
import 'package:glo_trans/view/translate_view.dart';
import 'package:glo_trans/view_model/app_data_view_model.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TargetLanguageConfigModelAdapter());
  Hive.registerAdapter(ConfigModelAdapter());

  await windowManager.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    center: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
  // pickAndLoadJsonFile();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppDataViewModel>(
            create: (_) => AppDataViewModel())
      ],
      child: MaterialApp(
        title: 'Flutter EasyLoading',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const App(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _translateBtnHovered = false;
  bool _translateBtnClicked = true;
  bool _exportBtnHovered = false;
  bool _exportBtnClicked = false;
  bool _settingsBtnHovered = false;
  bool _settingsBtnClicked = false;
  bool _historyBtnHovered = false;
  bool _historyBtnClicked = false;

  @override
  void initState() {
    super.initState();
    _initConfig();
    _initData();
  }

  void _initConfig() {
    AppDataViewModel appDataViewModel = context.read<AppDataViewModel>();
    for (var countryLanguage in AppConst.allCountryLanguage) {
      appDataViewModel.config.targetLanguageConfigList.add(
          TargetLanguageConfigModel(
              country: countryLanguage.split(" ")[0],
              language: countryLanguage.split(" ")[1]));
    }
  }

  Future _initData() async{
    ConfigModel? savedConfig = await ConfigStore.getConfig();
    AppDataViewModel appDataViewModel = context.read<AppDataViewModel>();
    if(savedConfig != null){
      appDataViewModel.config= savedConfig;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 200,
            height: double.infinity,
            color: const Color(0xff347080),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Glo Trans",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(1.0, 1.0),
                          ),
                        ],
                        decoration: TextDecoration.none,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationColor: const Color(0xFF3498DB),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  // color: Colors.red,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white10, // 背景颜色
                      color: _translateBtnClicked
                          ? Colors.white38
                          : (_translateBtnHovered
                              ? Colors.white10
                              : Colors.transparent), // 背景颜色
                      borderRadius: BorderRadius.circular(5), // 圆角半径，数值越大越圆滑
                    ),
                    height: 50,
                    width: double.infinity,
                    child: MouseRegion(
                      onEnter: (_) {
                        _translateBtnHovered = true;
                        setState(() {});
                      },
                      onExit: (_) {
                        _translateBtnHovered = false;
                        setState(() {});
                      },
                      child: GestureDetector(
                        onTap: () {
                          _translateBtnClicked = true;
                          _exportBtnClicked = false;
                          _settingsBtnClicked = false;
                          _historyBtnClicked = false;
                          setState(() {});
                        },
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            FaIcon(
                              FontAwesomeIcons.language,
                              color: Color(0xeeDFDFDF),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "词条翻译",
                              style: TextStyle(
                                  fontSize: 20, color: Color(0xeeDFDFDF)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white10, // 背景颜色
                      color: _exportBtnClicked
                          ? Colors.white38
                          : (_exportBtnHovered
                              ? Colors.white10
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(5), // 圆角半径，数值越大越圆滑
                    ),
                    height: 50,
                    width: double.infinity,
                    child: MouseRegion(
                      onEnter: (_) {
                        _exportBtnHovered = true;
                        setState(() {});
                      },
                      onExit: (_) {
                        _exportBtnHovered = false;
                        setState(() {});
                      },
                      child: GestureDetector(
                        onTap: () {
                          _translateBtnClicked = false;
                          _exportBtnClicked = true;
                          _settingsBtnClicked = false;
                          _historyBtnClicked = false;
                          setState(() {});
                        },
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            FaIcon(
                              FontAwesomeIcons.fileExport,
                              color: Color(0xeeDFDFDF),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "导入项目",
                              style: TextStyle(
                                  fontSize: 20, color: Color(0xeeDFDFDF)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white10, // 背景颜色
                      color: _settingsBtnClicked
                          ? Colors.white38
                          : (_settingsBtnHovered
                              ? Colors.white10
                              : Colors.transparent), // 背景颜色
                      borderRadius: BorderRadius.circular(5), // 圆角半径，数值越大越圆滑
                    ),
                    height: 50,
                    width: double.infinity,
                    child: MouseRegion(
                      onEnter: (_) {
                        _settingsBtnHovered = true;
                        setState(() {});
                      },
                      onExit: (_) {
                        _settingsBtnHovered = false;
                        setState(() {});
                      },
                      child: GestureDetector(
                        onTap: () {
                          _translateBtnClicked = false;
                          _exportBtnClicked = false;
                          _settingsBtnClicked = true;
                          _historyBtnClicked = false;
                          setState(() {});
                        },
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            FaIcon(
                              FontAwesomeIcons.gear,
                              color: Color(0xeeDFDFDF),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "翻译设置",
                              style: TextStyle(
                                  fontSize: 20, color: Color(0xeeDFDFDF)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.white10, // 背景颜色
                      color: _historyBtnClicked
                          ? Colors.white38
                          : (_historyBtnHovered
                              ? Colors.white10
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(5), // 圆角半径，数值越大越圆滑
                    ),
                    height: 50,
                    width: double.infinity,
                    child: MouseRegion(
                      onEnter: (_) {
                        _historyBtnHovered = true;
                        setState(() {});
                      },
                      onExit: (_) {
                        _historyBtnHovered = false;
                        setState(() {});
                      },
                      child: GestureDetector(
                        onTap: () {
                          _translateBtnClicked = false;
                          _exportBtnClicked = false;
                          _settingsBtnClicked = false;
                          _historyBtnClicked = true;
                          setState(() {});
                        },
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            FaIcon(
                              FontAwesomeIcons.history,
                              color: Color(0xeeDFDFDF),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "翻译历史",
                              style: TextStyle(
                                  fontSize: 20, color: Color(0xeeDFDFDF)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 600,
            height: double.infinity,
            color: const Color(0xff448899),
            child: getViewByClickedBtn(),
          ),
        ],
      ),
    );
  }

  Widget getViewByClickedBtn() {
    if (_settingsBtnClicked) {
      return const SettingsView();
    } else if (_translateBtnClicked) {
      return const TranslateView();
    } else if (_historyBtnClicked) {
      return const HistoryView();
    } else {
      return const ExportView();
    }
  }
}
