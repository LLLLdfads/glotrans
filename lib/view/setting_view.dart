import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String f = "";
  bool _checked = true;
  List<String> _allLanguage = [
    "简体 ZH-HANS",
    "繁体 ZH-HANT",
    "英语 EN-US",
    "瑞典 SV",
    "日文 JA",
    "葡萄牙 PT-PT",
    "西班牙 ES",
    "土耳其 TR",
    "德文 DE",
    "俄文 RU",
    "法文 FR",
    "意文 IT",
    "波兰 PL",
    "荷兰 NL",
    "捷克 CS",
    "斯洛伐克 SK",
    "韩文 KO",
    "丹麦文 DA",
    "阿拉伯 AR",
    "保加利亚 BG",
    "希腊 EL",
    "爱沙尼亚 ET",
    "芬兰 FI",
    "匈牙利 HU",
    "印尼 ID",
    "立陶宛 LT",
    "拉脱维亚 LV",
    "挪威 NB",
    "罗马尼亚文RO",
    "斯洛文尼亚 SL",
    "乌克兰 UK",
  ];

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
                  style: TextStyle(
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
                // "简体中文": "ZH-HANS",  "繁体中文": "ZH-HANT",   "英语": "EN-US",    "瑞典": "SV",
                // "日语": "JA",          "葡萄牙": "PT-PT",      "西班牙语": "ES",     "土耳其": "TR",
                // "德语": "DE",          "俄语": "RU",           "法语": "FR",       "意大利语": "IT",
                // "波兰": "PL",          "荷兰语": "NL",         "捷克": "CS",       "斯洛伐克": "SK",
                // "韩语": "KO",          "丹麦": "DA"
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
                    children: List.generate(_allLanguage.length, (index) {
                      // 生成10个子元素作为示例
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
                                              "${_allLanguage[index]}文件地址选择"),
                                        ),
                                        content: Container(
                                          width: 400,
                                          height: 200,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: _checked,
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
                                                  FaIcon(
                                                    FontAwesomeIcons.file,
                                                    color: Color(0xff347080),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: _checked,
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
                                  _allLanguage[index],
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
