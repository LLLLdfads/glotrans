import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glo_trans/app_const.dart';
import 'package:glo_trans/generated/l10n.dart';
import 'package:glo_trans/model/config_model.dart';
import 'package:glo_trans/model/target_language_config_model.dart';
import 'package:glo_trans/service/config_store.dart';
import 'package:glo_trans/view/export_view.dart';
import 'package:glo_trans/view/history_view.dart';
import 'package:glo_trans/view/setting_view.dart';
import 'package:glo_trans/view/translate_view.dart';
import 'package:glo_trans/view_model/app_data_view_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentOptionIndex = 0;
  late AppDataViewModel _appDataViewModel;

  @override
  void initState() {
    super.initState();
    _appDataViewModel = context.read<AppDataViewModel>();
    _initConfig();
    _initData();
    _initTranslateResultList();
    print("支持的语种:${S.delegate.supportedLocales}");
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

  void _initTranslateResultList() {
    _appDataViewModel.getTranslateResultList();
  }

  Future _initData() async {
    ConfigModel? savedConfig = await ConfigStore.getConfig();
    AppDataViewModel appDataViewModel = context.read<AppDataViewModel>();
    if (savedConfig != null) {
      appDataViewModel.config = savedConfig;
    }
    appDataViewModel.addListener(_handleNotifier);
  }

  void _handleNotifier() {
    _currentOptionIndex = _appDataViewModel.currentPageViewIndex;
    setState(() {});
  }

  void _handleOptionItemTap(int index) {
    setState(() {
      _currentOptionIndex = index;
    });
    _appDataViewModel.currentPageViewIndex = index;
  }

  Widget _buildHeader() {
    return SizedBox(
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
                color: Colors.black.withAlpha(30),
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
    );
  }

  Widget _buildContent() {
    return Container(
      width: 600,
      height: double.infinity,
      color: const Color.fromARGB(255, 39, 39, 41),
      // child: getViewByClickedBtn(),
      child: Selector<AppDataViewModel, int>(
          selector: (_, vm) => vm.currentPageViewIndex,
          builder: (context, currentPageViewIndex, child) {
            return [
              const TranslateView(),
              const ExportView(),
              const SettingsView(),
              const HistoryView(),
            ][currentPageViewIndex];
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 200,
            height: double.infinity,
            color: const Color.fromARGB(255, 30, 30, 32),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                _buildHeader(),
                OptionItem(
                  title: S.current.textTranslate,
                  selected: _currentOptionIndex == 0,
                  icon: FontAwesomeIcons.language,
                  onTap: _handleOptionItemTap,
                  index: 0,
                ),
                OptionItem(
                  title: S.current.exportToProject,
                  selected: _currentOptionIndex == 1,
                  icon: FontAwesomeIcons.fileImport,
                  onTap: _handleOptionItemTap,
                  index: 1,
                ),
                OptionItem(
                  title: S.current.translateSetting,
                  selected: _currentOptionIndex == 2,
                  icon: FontAwesomeIcons.gear,
                  onTap: _handleOptionItemTap,
                  index: 2,
                ),
                OptionItem(
                  title: S.current.translateHistory,
                  selected: _currentOptionIndex == 3,
                  icon: FontAwesomeIcons.clockRotateLeft,
                  onTap: _handleOptionItemTap,
                  index: 3,
                ),
              ],
            ),
          ),
          _buildContent(),
        ],
      ),
    );
  }
}

class OptionItem extends StatefulWidget {
  const OptionItem({
    super.key,
    required this.title,
    required this.selected,
    required this.icon,
    required this.onTap,
    required this.index,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final Function(int) onTap;
  final int index;

  @override
  State<OptionItem> createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem> {
  bool _areaIn = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.index);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            // color: Colors.white10, // 背景颜色
            color: widget.selected
                ? Colors.white38
                : (_areaIn ? Colors.white10 : Colors.transparent),
            borderRadius: BorderRadius.circular(5), // 圆角半径，数值越大越圆滑
          ),
          height: 50,
          width: double.infinity,
          child: MouseRegion(
            onEnter: (_) {
              _areaIn = true;
              setState(() {});
            },
            onExit: (_) {
              _areaIn = false;
              setState(() {});
            },
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 25,
                  child: FaIcon(
                    widget.icon,
                    color: const Color(0xeeDFDFDF),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.title,
                  style:
                      const TextStyle(fontSize: 20, color: Color(0xeeDFDFDF)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
