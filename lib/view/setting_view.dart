import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glo_trans/model/target_language_config_model.dart';
import 'package:glo_trans/utils.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    AppDataViewModel appDataViewModel = context.read<AppDataViewModel>();
    _allLanguageConfig = appDataViewModel.config.targetLanguageConfigList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Text(
                  "deepl密钥:$f",
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
          const Divider(
            color: Colors.white38,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "翻译选项:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 110,
                  child: GridView(
                    physics: const NeverScrollableScrollPhysics(), // 禁止滚动
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      childAspectRatio: 5, // 添加这个属性来控制子元素的宽高比
                      crossAxisSpacing: 5, // 可选：添加水平间距
                      mainAxisSpacing: 3, // 可选：添加垂直间距
                    ),
                    children: List.generate(_allLanguageConfig.length, (index) {
                      return Row(
                        children: [
                          MouseRegion(
                            onEnter: (_) {},
                            onExit: (_) {},
                            child: GestureDetector(
                              onTap: () {
                                // Fluttertoast.showToast(msg: "ddds");
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: Center(
                                          child: Text(
                                              "${_allLanguageConfig[index].country} ${_allLanguageConfig[index].language}文件地址选择"),
                                        ),
                                        content: SizedBox(
                                          width: 400,
                                          height: 200,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: _allLanguageConfig[
                                                                index]
                                                            .usel10n ==
                                                        true,
                                                    activeColor:
                                                        Colors.lightGreen,
                                                    checkColor: Colors.white,
                                                    tristate: true,
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                    // 移除悬停效果
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    onChanged: (data) {
                                                      print(data);
                                                      setState(() {
                                                        _checked = !_checked;
                                                      });
                                                    },
                                                  ),
                                                  Container(
                                                    width: 300,
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "l10n文件路径（安卓无需选择）"),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      String? oneL10nPath =
                                                          await pickFile("arb");
                                                      if (oneL10nPath != null) {
                                                        _allLanguageConfig[
                                                                index]
                                                            .usel10n = _checked;
                                                        _allLanguageConfig[
                                                                    index]
                                                                .l10nPath =
                                                            oneL10nPath;
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: const FaIcon(
                                                      FontAwesomeIcons.file,
                                                      color: Color(0xff347080),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: _allLanguageConfig[
                                                                index]
                                                            .useAndroid ==
                                                        true,
                                                    activeColor:
                                                        Colors.lightGreen,
                                                    checkColor: Colors.white,
                                                    tristate: true,
                                                    overlayColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                    // 移除悬停效果
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    onChanged: (data) {
                                                      print(data);
                                                      setState(() {
                                                        _checked = !_checked;
                                                      });
                                                    },
                                                  ),
                                                  Container(
                                                    width: 300,
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "安卓文件路径（flutter无需选择）"),
                                                    ),
                                                  ),
                                                  FaIcon(
                                                    FontAwesomeIcons.file,
                                                    color: Color(0xff347080),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("取消"),
                                          ),
                                          TextButton(
                                              onPressed: () {},
                                              child: const Text("确定")),
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.white10,
                                  // color: _checked
                                  //     ? Colors.green
                                  //     : Colors.transparent,
                                ),
                                child: Text(
                                  "${_allLanguageConfig[index].country}${_allLanguageConfig[index].language}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                          // Checkbox(
                          //   value: _checked
                          //   activeColor: Colors.lightGreen,
                          //   checkColor: Colors.white,
                          //   tristate: true,
                          //   overlayColor:
                          //       MaterialStateProperty.all(Colors.transparent),
                          //   // 移除悬停效果
                          //   materialTapTargetSize:
                          //       MaterialTapTargetSize.shrinkWrap,
                          //   onChanged: (data) {
                          //     print(data);
                          //     setState(() {
                          //       _checked = !_checked;
                          //     });
                          //   },
                          // ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.white38,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "导出设置:（插入词条位置标识，在其前/后插入词条）",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    child: Column(
                      children: [
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
                                print(data);
                                setState(() {
                                  _checked = !_checked;
                                });
                              },
                            ),
                            Container(
                              width: 300,
                              child: TextField(
                                decoration:
                                    InputDecoration(hintText: "l10n翻译文件标识"),
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
                                print(data);
                                setState(() {
                                  _checked = !_checked;
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
                                print(data);
                                setState(() {
                                  _checked = !_checked;
                                });
                              },
                            ),
                            Container(
                              width: 300,
                              child: TextField(
                                decoration:
                                    InputDecoration(hintText: "安卓翻译文件标识"),
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
                                print(data);
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
          const Divider(
            color: Colors.white38,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                const SizedBox(
                  child: Text(
                    "系统语言：",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
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
                    dropdownMenuEntries: [
                      '简体',
                      '繁体',
                      'English',
                      'Franch',
                      '...'
                    ]
                        .map((e) =>
                            DropdownMenuEntry<String>(value: e, label: e))
                        .toList(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
