import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final List<String> _settingItems = ["翻译选项", "导出设置", "系统语言", "deepl密钥", "关于"];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    AppDataViewModel appDataViewModel = context.read<AppDataViewModel>();
    _allLanguageConfig = appDataViewModel.config.targetLanguageConfigList;
  }

  List<Widget> _getConfigContentList() {
    AppDataViewModel appDataViewModel = context.read<AppDataViewModel>();
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                "翻译选项",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: double.infinity,
                height: 300,
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
                                color: Colors.white10,
                              ),
                              child: Text(
                                "${_allLanguageConfig[index].country}${_allLanguageConfig[index].language}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                            Checkbox(
                              value: _allLanguageConfig[index].willTranslate,
                              activeColor: Colors.lightGreen,
                              checkColor: Colors.white,
                              tristate: true,
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              // 移除悬停效果
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (data) async{
                                setState(() {
                                  _allLanguageConfig[index].willTranslate =
                                      (data == true);
                                });
                                await ConfigStore.saveConfig(
                                  ConfigModel(deeplKey: appDataViewModel.config.deeplKey, targetLanguageConfigList: _allLanguageConfig)
                                );
                              },
                            ),
                            // const
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _allLanguageConfig[index].usel10n,
                              activeColor: Colors.lightGreen,
                              checkColor: Colors.white,
                              tristate: true,
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              // 移除悬停效果
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (data) {
                                if (data == true) {
                                  if (_allLanguageConfig[index].l10nPath ==
                                      null) {
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
                            Container(
                              width: 150,
                              height: 20,
                              child: TextField(),
                            ),
                            GestureDetector(
                              onTap: () async {
                                String? oneL10nPath = await pickFile("arb");
                                if (oneL10nPath != null) {
                                  _allLanguageConfig[index].usel10n = true;
                                  _allLanguageConfig[index].l10nPath =
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
                            Checkbox(
                              value: _allLanguageConfig[index].useAndroid,
                              activeColor: Colors.lightGreen,
                              checkColor: Colors.white,
                              tristate: true,
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              // 移除悬停效果
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (data) {
                                setState(() {
                                  _allLanguageConfig[index].useAndroid =
                                      (data == true);
                                });
                              },
                            ),
                            const SizedBox(
                              width: 150,
                              height: 30,
                              child: TextField(),
                            ),
                            GestureDetector(
                              onTap: () async {
                                String? androidPath = await pickFile("arb");
                                if (androidPath != null) {
                                  _allLanguageConfig[index].useAndroid = true;
                                  _allLanguageConfig[index].androidPath =
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
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    );
                  }),
                )),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                "导出设置",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("前"),
                        Checkbox(
                          value: appDataViewModel.config.insertBeforeL10nFlag,
                          activeColor: Colors.lightGreen,
                          checkColor: Colors.white,
                          tristate: true,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          // 移除悬停效果
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (data) {
                            setState(() {
                              appDataViewModel.config.insertBeforeL10nFlag =
                                  !appDataViewModel.config.insertBeforeL10nFlag;
                            });
                          },
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            decoration: InputDecoration(hintText: "l10n翻译文件标识"),
                          ),
                        ),
                        const Text("后"),
                        Checkbox(
                          value: !appDataViewModel.config.insertBeforeL10nFlag,
                          activeColor: Colors.lightGreen,
                          checkColor: Colors.white,
                          tristate: true,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          // 移除悬停效果
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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
                      children: [
                        Text("前"),
                        Checkbox(
                          value: _checked,
                          activeColor: Colors.lightGreen,
                          checkColor: Colors.white,
                          tristate: true,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          // 移除悬停效果
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (data) {
                            setState(() {
                              _checked = !_checked;
                            });
                          },
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            decoration: InputDecoration(hintText: "安卓翻译文件标识"),
                          ),
                        ),
                        Text("后"),
                        Checkbox(
                          value: _checked,
                          activeColor: Colors.lightGreen,
                          checkColor: Colors.white,
                          tristate: true,
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          // 移除悬停效果
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: [
            const SizedBox(
              child: Text(
                "系统语言",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: DropdownMenu<String>(
                menuHeight: 400,
                initialSelection:
                    ['简体', '繁体', 'English', 'Franch', '...'].first,
                onSelected: (_) {},
                dropdownMenuEntries: ['简体', '繁体', 'English', 'Franch', '...']
                    .map((e) => DropdownMenuEntry<String>(value: e, label: e))
                    .toList(),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: [
            Text(
              "deepl密钥",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(
              height: 30,
              width: 200,
              child: TextField(
                obscureText: true,
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: [
            Text(
              "关于",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 30,
              width: 200,
              child: TextField(
                obscureText: true,
              ),
            )
          ],
        ),
      ),
    ];
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
