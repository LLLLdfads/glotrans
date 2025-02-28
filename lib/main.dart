import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:glo_trans/main_page.dart';
import 'package:glo_trans/model/config_model.dart';
import 'package:glo_trans/model/target_language_config_model.dart';
import 'package:glo_trans/model/translate_result_model.dart';
import 'package:glo_trans/view_model/app_data_view_model.dart';
import 'package:hive/hive.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TargetLanguageConfigModelAdapter());
  Hive.registerAdapter(ConfigModelAdapter());
  Hive.registerAdapter(TranslateResultModelAdapter());
  Hive.registerAdapter(TranslateResultModelListAdapter());
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

  runApp(const App());
  // pickAndLoadJsonFile();
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppDataViewModel>(
            create: (_) => AppDataViewModel())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        // 不使用刷新框架的国际化(因为有些语言不支持, 改框架代码也麻烦)
        // RefreshLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: context.watch<AppDataViewModel>().locale,
      title: 'Glo Trans',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
      builder: EasyLoading.init(),
    ));
  }
}
