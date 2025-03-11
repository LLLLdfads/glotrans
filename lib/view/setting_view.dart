import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glo_trans/app_const.dart';
import 'package:glo_trans/common/common.dart';
import 'package:glo_trans/model/settings/export_setting_model.dart';
import 'package:glo_trans/model/settings/system_setting_model.dart';
import 'package:glo_trans/utils.dart';
import 'package:glo_trans/view_model/app_data_view_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final List<String> _settingItems = ["语言选项", "导出设置", "系统设置", "deepl密钥", "关于"];
  int _scrollIndex = 0;

  final List<TextEditingController> _l10nFilesControllers = [];
  final List<TextEditingController> _androidFilesControllers = [];

  // 导出设置中的变量
  bool _selectedL10nFileSetting = true;
  void _handleChangeSelectedL10nFileSetting() {
    _selectedL10nFileSetting = !_selectedL10nFileSetting;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    AppDataViewModel appDataViewModel = context.read<AppDataViewModel>();

    appDataViewModel.exportingModel.l10nFiles.forEach((element) {
      _l10nFilesControllers.add(TextEditingController()..text = element);
    });

    appDataViewModel.exportingModel.androidFiles.forEach((element) {
      _androidFilesControllers.add(TextEditingController()..text = element);
    });
  }

  List<Widget> _getConfigContentList() {
    AppDataViewModel appDataViewModel = context.read<AppDataViewModel>();
    return [
      _buildSettingItemContent(
        title: "语言选项",
        child: SizedBox(
            width: double.infinity,
            height: 330,
            child: Selector<AppDataViewModel, List<bool>>(
                selector: (context, appDataViewModel) =>
                    appDataViewModel.willDoLan,
                builder: (context, willDoLan, child) {
                  return GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, //横轴三个子widget
                            childAspectRatio: 3.0 //宽高比为1时，子widget
                            ),
                    children:
                        List.generate(AppConst.supportLanMap.length, (index) {
                      return Row(
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
                              "${AppConst.supportLanMap.entries.toList()[index].key}${AppConst.supportLanMap.entries.toList()[index].value}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                          buildCheckbox(
                            value: willDoLan[index],
                            onChanged: (data) async {
                              List<bool> tempWillDoLan =
                                  List.from(appDataViewModel.willDoLan);
                              tempWillDoLan[index] = (data == true);
                              appDataViewModel.willDoLan = tempWillDoLan;
                              appDataViewModel.setWillDoLan();
                            },
                          ),
                          // const
                        ],
                      );
                    }),
                  );
                })),
      ),
      // _buildSettingItemContent(
      //   title:
      //       "语言选项（已选择${_allLanguageConfig.where((element) => element.willTranslate).length}种语言）",
      //   child: SizedBox(
      //       width: double.infinity,
      //       height: 350,
      //       child: ListView(
      //         children: List.generate(_allLanguageConfig.length, (index) {
      //           return Column(
      //             children: [
      //               Row(
      //                 children: [
      //                   Container(
      //                     decoration: BoxDecoration(
      //                       border: Border.all(
      //                         color: Colors.transparent,
      //                         width: 1,
      //                       ),
      //                       borderRadius: BorderRadius.circular(2),
      //                     ),
      //                     child: Text(
      //                       "${_allLanguageConfig[index].country}${_allLanguageConfig[index].language}",
      //                       style: const TextStyle(
      //                           color: Colors.white, fontSize: 12),
      //                     ),
      //                   ),
      //                   buildCheckbox(
      //                     value: _allLanguageConfig[index].willTranslate,
      //                     onChanged: (data) async {
      //                       setState(() {
      //                         _allLanguageConfig[index].willTranslate =
      //                             (data == true);
      //                       });
      //                       await ConfigStore.saveConfig(ConfigModel(
      //                           deeplKey: appDataViewModel.config.deeplKey,
      //                           targetLanguageConfigList: _allLanguageConfig));
      //                     },
      //                   ),
      //                   // const
      //                 ],
      //               ),
      //               Row(
      //                 children: [
      //                   buildCheckbox(
      //                     value: _allLanguageConfig[index].usel10n,
      //                     onChanged: (data) {
      //                       if (data == true) {
      //                         if (_allLanguageConfig[index].l10nPath == null) {
      //                           showDialog(
      //                               context: context,
      //                               builder: (_) {
      //                                 return const AlertDialog(
      //                                   title: Text("请选择l10n文件"),
      //                                 );
      //                               });
      //                           return;
      //                         }
      //                       }
      //                       setState(() {
      //                         _allLanguageConfig[index].usel10n =
      //                             (data == true);
      //                       });
      //                     },
      //                   ),
      //                   SizedBox(
      //                     width: 140,
      //                     height: 20,
      //                     child: buildInputField(
      //                       controller: _translateOptionControllers[index][0],
      //                       hintText: "l10n file path",
      //                       context: context,
      //                       onChanged: (value) {
      //                         _allLanguageConfig[index].l10nPath = value;
      //                         setState(() {});
      //                       },
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     width: 5,
      //                   ),
      //                   GestureDetector(
      //                     onTap: () async {
      //                       String? oneL10nPath = await pickFile("arb");
      //                       if (oneL10nPath != null) {
      //                         _allLanguageConfig[index].usel10n = true;
      //                         _allLanguageConfig[index].l10nPath = oneL10nPath;
      //                         _translateOptionControllers[index][0].text =
      //                             oneL10nPath;
      //                         setState(() {});
      //                       }
      //                     },
      //                     child: const FaIcon(
      //                       size: 20,
      //                       FontAwesomeIcons.file,
      //                       color: Color(0xff347080),
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     width: 5,
      //                   ),
      //                   buildCheckbox(
      //                     value: _allLanguageConfig[index].useAndroid,
      //                     onChanged: (data) {
      //                       setState(() {
      //                         _allLanguageConfig[index].useAndroid =
      //                             (data == true);
      //                       });
      //                     },
      //                   ),
      //                   SizedBox(
      //                     width: 140,
      //                     height: 20,
      //                     child: buildInputField(
      //                       controller: _translateOptionControllers[index][0],
      //                       hintText: "android  file path",
      //                       context: context,
      //                       onChanged: (value) {
      //                         _allLanguageConfig[index].l10nPath = value;
      //                         setState(() {});
      //                       },
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     width: 5,
      //                   ),
      //                   GestureDetector(
      //                     onTap: () async {
      //                       String? androidPath = await pickFile("xml");
      //                       if (androidPath != null) {
      //                         _allLanguageConfig[index].useAndroid = true;
      //                         _allLanguageConfig[index].androidPath =
      //                             androidPath;
      //                         _translateOptionControllers[index][1].text =
      //                             androidPath;
      //                         setState(() {});
      //                       }
      //                     },
      //                     child: const FaIcon(
      //                       size: 20,
      //                       FontAwesomeIcons.file,
      //                       color: Color(0xff347080),
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             ],
      //           );
      //         }),
      //       )),
      // ),
      _buildSettingItemContent(
          title: "导出设置",
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: SizedBox(
              width: double.infinity,
              height: 490,
              child: Selector<AppDataViewModel, ExportSettingModel>(
                selector: (context, appDataViewModel) =>
                    appDataViewModel.exportingModel,
                builder: (context, exportingModel, child) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 50,
                          ),
                          const Text("导入l10n(flutter)项目"),
                          buildCheckbox(
                            value: exportingModel.toL10n,
                            onChanged: (value) {
                              appDataViewModel.exportingModel =
                                  exportingModel.changeAttr(toL10n: value);
                              appDataViewModel.setExportingModel();
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 50,
                          ),
                          const Text("导入安卓项目"),
                          buildCheckbox(
                            value: exportingModel.toAndroid,
                            onChanged: (value) {
                              appDataViewModel.exportingModel =
                                  exportingModel.changeAttr(toAndroid: value);
                              appDataViewModel.setExportingModel();
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: Center(
                          child: Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Color.fromARGB(255, 35, 35, 35)),
                            width: 200,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: _handleChangeSelectedL10nFileSetting,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50)),
                                        color: _selectedL10nFileSetting
                                            ? const Color.fromARGB(
                                                255, 104, 103, 103)
                                            : Colors.transparent,
                                      ),
                                      height: 40,
                                      width: 95,
                                      child: const Center(
                                        child: Text("l10n文件"),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _handleChangeSelectedL10nFileSetting,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50)),
                                        color: !_selectedL10nFileSetting
                                            ? const Color.fromARGB(
                                                255, 104, 103, 103)
                                            : Colors.transparent,
                                      ),
                                      height: 40,
                                      width: 95,
                                      child: const Center(
                                        child: Text("安卓文件"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      _selectedL10nFileSetting
                          ? SizedBox(
                              width: double.infinity,
                              height: 300,
                              child: ListView(
                                  children: List.generate(
                                      exportingModel.l10nFiles.length, (index) {
                                return Column(children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        child: Text(
                                          "${AppConst.supportLanMap.entries.toList()[index].key}${AppConst.supportLanMap.entries.toList()[index].value}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 20,
                                        child: buildInputField(
                                          controller:
                                              _l10nFilesControllers[index],
                                          hintText: "l10n file path",
                                          context: context,
                                          onChanged: (value) {
                                            List<String> l10nFiles =
                                                exportingModel.l10nFiles;
                                            l10nFiles[index] = value;
                                            appDataViewModel.exportingModel =
                                                exportingModel.changeAttr(
                                                    l10nFiles: l10nFiles);
                                            appDataViewModel
                                                .setExportingModel();
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          String? oneL10nPath =
                                              await pickFile("arb");
                                          if (oneL10nPath != null) {
                                            _l10nFilesControllers[index].text =
                                                oneL10nPath;
                                            List<String> l10nFiles =
                                                exportingModel.l10nFiles;
                                            l10nFiles[index] = oneL10nPath;
                                            List<bool> l10nFilesEnable =
                                                exportingModel.l10nFilesEnable;
                                            l10nFilesEnable[index] = true;
                                            appDataViewModel.exportingModel =
                                                exportingModel.changeAttr(
                                                    l10nFiles: l10nFiles,
                                                    l10nFilesEnable:
                                                        l10nFilesEnable);
                                            appDataViewModel
                                                .setExportingModel();
                                          }
                                        },
                                        child: const FaIcon(
                                          size: 20,
                                          FontAwesomeIcons.file,
                                          color: Color(0xff347080),
                                        ),
                                      ),
                                      buildCheckbox(
                                        value: exportingModel
                                            .l10nFilesEnable[index],
                                        onChanged: (data) {
                                          if (data == true) {
                                            if (exportingModel
                                                    .l10nFiles[index] ==
                                                "") {
                                              showToast("请选择l10n文件");
                                              return;
                                            }
                                          }
                                          List<bool> l10nFilesEnable =
                                              exportingModel.l10nFilesEnable;
                                          l10nFilesEnable[index] = data == true;
                                          appDataViewModel.exportingModel =
                                              exportingModel.changeAttr(
                                                  l10nFilesEnable:
                                                      l10nFilesEnable);
                                          appDataViewModel.setExportingModel();
                                        },
                                      ),
                                    ],
                                  ),
                                ]);
                              })))
                          : SizedBox(
                              width: double.infinity,
                              height: 300,
                              child: ListView(
                                  children: List.generate(
                                      exportingModel.androidFiles.length,
                                      (index) {
                                return Column(children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        child: Text(
                                          "${AppConst.supportLanMap.entries.toList()[index].key}${AppConst.supportLanMap.entries.toList()[index].value}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 20,
                                        child: buildInputField(
                                          controller:
                                              _androidFilesControllers[index],
                                          hintText: "android file path",
                                          context: context,
                                          onChanged: (value) {
                                            List<String> androidFiles =
                                                exportingModel.androidFiles;
                                            androidFiles[index] = value;
                                            appDataViewModel.exportingModel =
                                                exportingModel.changeAttr(
                                                    androidFiles: androidFiles);
                                            appDataViewModel
                                                .setExportingModel();
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          String? oneAndroidPath =
                                              await pickFile("xml");
                                          if (oneAndroidPath != null) {
                                            _androidFilesControllers[index]
                                                .text = oneAndroidPath;
                                            List<String> androidFiles =
                                                exportingModel.androidFiles;
                                            androidFiles[index] =
                                                oneAndroidPath;
                                            List<bool> androidFilesEnable =
                                                exportingModel
                                                    .androidFilesEnable;
                                            androidFilesEnable[index] = true;
                                            appDataViewModel.exportingModel =
                                                exportingModel.changeAttr(
                                                    androidFiles: androidFiles,
                                                    androidFilesEnable:
                                                        androidFilesEnable);
                                            appDataViewModel
                                                .setExportingModel();
                                          }
                                        },
                                        child: const FaIcon(
                                          size: 20,
                                          FontAwesomeIcons.file,
                                          color: Color(0xff347080),
                                        ),
                                      ),
                                      buildCheckbox(
                                        value: exportingModel
                                            .androidFilesEnable[index],
                                        onChanged: (data) {
                                          if (data == true) {
                                            if (exportingModel
                                                    .androidFiles[index] ==
                                                "") {
                                              showToast("请选择安卓文件");
                                              return;
                                            }
                                          }
                                          List<bool> androidFilesEnable =
                                              exportingModel.androidFilesEnable;
                                          androidFilesEnable[index] =
                                              data == true;
                                          appDataViewModel.exportingModel =
                                              exportingModel.changeAttr(
                                                  androidFilesEnable:
                                                      androidFilesEnable);
                                          appDataViewModel.setExportingModel();
                                        },
                                      ),
                                    ],
                                  ),
                                ]);
                              }))),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("前插"),
                          buildCheckbox(
                            value: exportingModel.isInsertBeforeL10nFlag,
                            onChanged: (data) {
                              appDataViewModel.exportingModel =
                                  exportingModel.changeAttr(
                                      isInsertBeforeL10nFlag: data == true);
                              appDataViewModel.setExportingModel();
                            },
                          ),
                          SizedBox(
                            width: 200,
                            height: 20,
                            child: buildInputField(
                              controller: TextEditingController()
                                ..text = exportingModel.l10nFlag,
                              hintText: "l10n翻译文件标识",
                              context: context,
                              onChanged: (value) {
                                appDataViewModel.exportingModel =
                                    exportingModel.changeAttr(l10nFlag: value);
                                appDataViewModel.setExportingModel();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("后插"),
                          buildCheckbox(
                            value: !exportingModel.isInsertBeforeL10nFlag,
                            onChanged: (data) {
                              appDataViewModel.exportingModel =
                                  exportingModel.changeAttr(
                                      isInsertBeforeL10nFlag: data == false);
                              appDataViewModel.setExportingModel();
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("前插"),
                          buildCheckbox(
                            value: exportingModel.isInsertBeforeAndroidFlag,
                            onChanged: (data) {
                              appDataViewModel.exportingModel =
                                  exportingModel.changeAttr(
                                      isInsertBeforeAndroidFlag: data == true);
                              appDataViewModel.setExportingModel();
                            },
                          ),
                          SizedBox(
                            width: 200,
                            height: 20,
                            child: buildInputField(
                              controller: TextEditingController()
                                ..text = exportingModel.androidFlag,
                              hintText: "android翻译文件标识",
                              context: context,
                              onChanged: (value) {
                                appDataViewModel.exportingModel = exportingModel
                                    .changeAttr(androidFlag: value);
                                appDataViewModel.setExportingModel();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("后插"),
                          buildCheckbox(
                            value: !exportingModel.isInsertBeforeAndroidFlag,
                            onChanged: (data) {
                              appDataViewModel.exportingModel =
                                  exportingModel.changeAttr(
                                      isInsertBeforeAndroidFlag: data == false);
                              appDataViewModel.setExportingModel();
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          )),
      _buildSettingItemContent(
        title: "系统设置",
        child: Selector<AppDataViewModel, SystemSettingModel>(
          selector: (context, appDataViewModel) =>
              appDataViewModel.systemSettingModel,
          builder: (context, systemSettingModel, child) {
            return Column(
              children: [
                Center(
                  child: DropdownMenu<String>(
                    menuHeight: 350,
                    initialSelection: [
                      '中文',
                      '英文'
                    ][systemSettingModel.systemLan],
                    onSelected: (value) {
                      appDataViewModel.systemSettingModel = systemSettingModel
                          .changeAttr(systemLan: value == "中文" ? 0 : 1);
                      appDataViewModel.setSystemSettingModel();
                      // context.read<AppDataViewModel>().locale =
                      //     Locale(value == "中文" ? "zh" : "en");
                    },
                    dropdownMenuEntries: ['中文', '英文']
                        .map((e) =>
                            DropdownMenuEntry<String>(value: e, label: e))
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: DropdownMenu<String>(
                    menuHeight: 350,
                    initialSelection: [
                      '暗色',
                    ].first,
                    onSelected: (_) {
                      // final themeProvider = Provider.of<ThemeProvider>(context);
                      // themeProvider.toggleTheme(); // 切换主题
                    },
                    dropdownMenuEntries: ['暗色', '亮色']
                        .map((e) =>
                            DropdownMenuEntry<String>(value: e, label: e))
                        .toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      // 密钥输入，这应该是一个密码输入框
      _buildSettingItemContent(
          title: "deepl密钥",
          child: SizedBox(
            height: 20,
            width: 200,
            child: Selector<AppDataViewModel, String>(
              selector: (context, appDataViewModel) => appDataViewModel.key,
              builder: (context, key, child) {
                return buildInputField(
                  controller: TextEditingController()..text = key,
                  hintText: "deepl密钥",
                  context: context,
                  onChanged: (value) {
                    appDataViewModel.setKey(value);
                  },
                  obscureText: true,
                );
              },
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
                                  _scrollIndex = index;
                                  _scrollToItem(_scrollIndex);
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
                                              color: _scrollIndex == index
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
                                              color: _scrollIndex == index
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
