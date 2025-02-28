import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glo_trans/common/common.dart';
import 'package:glo_trans/model/config_model.dart';
import 'package:glo_trans/model/target_language_config_model.dart';
import 'package:glo_trans/service/config_store.dart';
import 'package:glo_trans/utils.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../view_model/app_data_view_model.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String f = "";
  bool _checked = true;
  List<TargetLanguageConfigModel> _allLanguageConfig = [];
  final ItemScrollController itemScrollController = ItemScrollController();
  final List<String> _settingItems = ["翻译选项", "导出设置", "系统设置", "deepl密钥", "关于"];
  int _currentIndex = 0;
  // 翻译选项的controller
  final List<List<TextEditingController>> _translateOptionControllers = [];

  @override
  void initState() {
    super.initState();
    AppDataViewModel appDataViewModel = context.read<AppDataViewModel>();
    _allLanguageConfig = appDataViewModel.config.targetLanguageConfigList;
    appDataViewModel.config.targetLanguageConfigList.forEach((element) {
      _translateOptionControllers
          .add([TextEditingController(), TextEditingController()]);
    });
    for (var i = 0; i < _allLanguageConfig.length; i++) {
      if (_allLanguageConfig[i].l10nPath != null) {
        _translateOptionControllers[i][0].text =
            _allLanguageConfig[i].l10nPath!;
      }
      if (_allLanguageConfig[i].androidPath != null) {
        _translateOptionControllers[i][1].text =
            _allLanguageConfig[i].androidPath!;
      }
    }
  }

  List<Widget> _getConfigContentList() {
    AppDataViewModel appDataViewModel = context.read<AppDataViewModel>();
    return [
      _buildSettingItemContent(
        title:
            "翻译选项（已选择${_allLanguageConfig.where((element) => element.willTranslate).length}种语言）",
        child: SizedBox(
            width: double.infinity,
            height: 350,
            child: ListView(
              children: List.generate(_allLanguageConfig.length, (index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            "${_allLanguageConfig[index].country}${_allLanguageConfig[index].language}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                        buildCheckbox(
                          value: _allLanguageConfig[index].willTranslate,
                          onChanged: (data) async {
                            setState(() {
                              _allLanguageConfig[index].willTranslate =
                                  (data == true);
                            });
                            await ConfigStore.saveConfig(ConfigModel(
                                deeplKey: appDataViewModel.config.deeplKey,
                                targetLanguageConfigList: _allLanguageConfig));
                          },
                        ),
                        // const
                      ],
                    ),
                    Row(
                      children: [
                        buildCheckbox(
                          value: _allLanguageConfig[index].usel10n,
                          onChanged: (data) {
                            if (data == true) {
                              if (_allLanguageConfig[index].l10nPath == null) {
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return const AlertDialog(
                                        title: Text("请选择l10n文件"),
                                      );
                                    });
                                return;
                              }
                            }
                            setState(() {
                              _allLanguageConfig[index].usel10n =
                                  (data == true);
                            });
                          },
                        ),
                        SizedBox(
                          width: 140,
                          height: 20,
                          child: buildInputField(
                            controller: _translateOptionControllers[index][0],
                            hintText: "l10n file path",
                            context: context,
                            onChanged: (value) {
                              _allLanguageConfig[index].l10nPath = value;
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () async {
                            String? oneL10nPath = await pickFile("arb");
                            if (oneL10nPath != null) {
                              _allLanguageConfig[index].usel10n = true;
                              _allLanguageConfig[index].l10nPath = oneL10nPath;
                              _translateOptionControllers[index][0].text =
                                  oneL10nPath;
                              setState(() {});
                            }
                          },
                          child: const FaIcon(
                            size: 20,
                            FontAwesomeIcons.file,
                            color: Color(0xff347080),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        buildCheckbox(
                          value: _allLanguageConfig[index].useAndroid,
                          onChanged: (data) {
                            setState(() {
                              _allLanguageConfig[index].useAndroid =
                                  (data == true);
                            });
                          },
                        ),
                        SizedBox(
                          width: 140,
                          height: 20,
                          child: buildInputField(
                            controller: _translateOptionControllers[index][0],
                            hintText: "android  file path",
                            context: context,
                            onChanged: (value) {
                              _allLanguageConfig[index].l10nPath = value;
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () async {
                            String? androidPath = await pickFile("xml");
                            if (androidPath != null) {
                              _allLanguageConfig[index].useAndroid = true;
                              _allLanguageConfig[index].androidPath =
                                  androidPath;
                              _translateOptionControllers[index][1].text =
                                  androidPath;
                              setState(() {});
                            }
                          },
                          child: const FaIcon(
                            size: 20,
                            FontAwesomeIcons.file,
                            color: Color(0xff347080),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              }),
            )),
      ),
      _buildSettingItemContent(
          title: "导出设置",
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: SizedBox(
              width: double.infinity,
              height: 100,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("前"),
                      buildCheckbox(
                        value: appDataViewModel.config.insertBeforeL10nFlag,
                        onChanged: (data) {
                          setState(() {
                            appDataViewModel.config.insertBeforeL10nFlag =
                                !appDataViewModel.config.insertBeforeL10nFlag;
                          });
                        },
                      ),
                      SizedBox(
                        width: 100,
                        height: 20,
                        child: buildInputField(
                          controller: _translateOptionControllers[0][0],
                          hintText: "l10n翻译文件标识",
                          context: context,
                          onChanged: (value) {},
                        ),
                      ),
                      const Text("后"),
                      Checkbox(
                        value: !appDataViewModel.config.insertBeforeL10nFlag,
                        activeColor: Colors.lightGreen,
                        checkColor: Colors.white,
                        tristate: true,
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                        // 移除悬停效果
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (data) {
                          setState(() {
                            appDataViewModel.config.insertBeforeL10nFlag =
                                !appDataViewModel.config.insertBeforeL10nFlag;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("前"),
                      Checkbox(
                        value: _checked,
                        activeColor: Colors.lightGreen,
                        checkColor: Colors.white,
                        tristate: true,
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                        // 移除悬停效果
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (data) {
                          setState(() {
                            _checked = !_checked;
                          });
                        },
                      ),
                      SizedBox(
                        width: 100,
                        height: 20,
                        child: buildInputField(
                          controller: _translateOptionControllers[0][0],
                          hintText: "l10n翻译文件标识",
                          context: context,
                          onChanged: (value) {},
                        ),
                      ),
                      const Text("后"),
                      Checkbox(
                        value: _checked,
                        activeColor: Colors.lightGreen,
                        checkColor: Colors.white,
                        tristate: true,
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                        // 移除悬停效果
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (data) {
                          setState(() {
                            _checked = !_checked;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
      _buildSettingItemContent(
        title: "系统设置",
        child: Column(
          children: [
            Center(
              child: DropdownMenu<String>(
                menuHeight: 400,
                initialSelection: ['中文'].first,
                onSelected: (value) {
                  context.read<AppDataViewModel>().locale =
                      Locale(value == "中文" ? "zh" : "en");
                },
                dropdownMenuEntries: ['中文', '英文']
                    .map((e) => DropdownMenuEntry<String>(value: e, label: e))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: DropdownMenu<String>(
                menuHeight: 400,
                initialSelection: [
                  '暗色',
                ].first,
                onSelected: (_) {
                  // final themeProvider = Provider.of<ThemeProvider>(context);
                  // themeProvider.toggleTheme(); // 切换主题
                },
                dropdownMenuEntries: ['暗色', '亮色']
                    .map((e) => DropdownMenuEntry<String>(value: e, label: e))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      _buildSettingItemContent(
          title: "deepl密钥",
          child: SizedBox(
            height: 20,
            width: 200,
            child: buildInputField(
              controller: _translateOptionControllers[0][0],
              hintText: "deepl密钥",
              context: context,
              onChanged: (value) {},
            ),
          )),
      _buildSettingItemContent(title: "关于", child: _buildAboutItemContent()),
    ];
  }

  _buildAboutItemContent() {
    return const Column(
      children: [
        Text(
          "版本号：1.0.0",
          style: TextStyle(color: Colors.white),
        ),
        Text(
          "作者：glo_trans",
          style: TextStyle(color: Colors.white),
        ),
        Text(
          "邮箱：glo_trans@163.com",
          style: TextStyle(color: Colors.white),
        ),
        Text(
          "github：https://github.com/glo_trans",
          style: TextStyle(color: Colors.white),
        ),
        Text(
          "QQ：1234567890",
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  _buildSettingItemContent({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: child,
          ),
        ],
      ),
    );
  }

  void _scrollToItem(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          height: double.infinity,
          child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                  children: List.generate(
                      _settingItems.length,
                      (index) => GestureDetector(
                            onTap: () {
                              _scrollToItem(index);
                            },
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentIndex = index;
                                  _scrollToItem(index);
                                });
                              },
                              child: SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                          height: 4,
                                          width: 4,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              color: _currentIndex == index
                                                  ? Colors.white
                                                  : Colors.white38)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          _settingItems[index],
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: _currentIndex == index
                                                  ? Colors.white
                                                  : Colors.white38),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          )))),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SizedBox(
              width: 400,
              height: 500, // 设置你想要的高度
              child: ScrollablePositionedList.separated(
                  physics: const ClampingScrollPhysics(),
                  // 禁止触底反弹
                  itemScrollController: itemScrollController,
                  itemCount: 5,
                  itemBuilder: (context, index) =>
                      _getConfigContentList()[index],
                  separatorBuilder: (context, index) => const Divider())),
        )
      ],
    );
  }
}
