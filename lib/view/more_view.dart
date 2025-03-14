import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MoreView extends StatefulWidget {
  const MoreView({super.key});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _buildItems();
  }

  _handleItemsClick(int index) {
    if (index == 6) {
      // 功能6，生成二维码
      showDialog(
        context: context,
        builder: (_) {
          TextEditingController qrDataController = TextEditingController();

          String qrData = "";
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return Dialog(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2D3E), // 深色背景
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  width: 400,
                  height: 500,
                  child: Column(
                    children: [
                      // 输入区域
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: qrDataController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: '请输入要生成二维码的内容',
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.3)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // 生成按钮
                            ElevatedButton(
                              onPressed: () {
                                setDialogState(() {
                                  qrData = qrDataController.text;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3E4396),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.refresh, size: 18),
                                  SizedBox(width: 8),
                                  Text('生成二维码'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 二维码显示区域
                      if (qrData.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: QrImageView(
                              data: qrData,
                              version: QrVersions.auto,
                              size: 200,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  List<Widget> _buildItems() {
    List<Widget> functionItems = [];

    List<Color> colors = [
      const Color(0xFFFF6B6B), // 活力红
      const Color(0xFF4ECDC4), // 清新绿松石
      const Color(0xFFFFBE76), // 温暖橙色
      const Color(0xFF45B7D1), // 明亮蓝
      const Color(0xFFA17FE0), // 梦幻紫
      const Color(0xFFFF9FF3), // 粉红色
      const Color(0xFF26DE81), // 翡翠绿
    ];
    List<String> titles = [
      "解析xlog",
      "导入表格",
      "导出l10n项目翻译",
      "导出安卓项目翻译", // 会根据导出设置的文件进行处理
      "绘制地图",
      "查询本机ip",
      "绘制二维码",
    ];
    for (var i = 0; i < 7; i++) {
      functionItems.add(Padding(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            _handleItemsClick(i);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return colors[i].withOpacity(0.5);
                }
                if (states.contains(WidgetState.hovered)) {
                  return colors[i].withOpacity(0.8);
                }
                return colors[i];
              },
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            overlayColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.white.withOpacity(0.3); // 点击时的水波纹颜色
                }
                return Colors.transparent;
              },
            ),
            shadowColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return colors[i].withOpacity(0.8);
                }
                return Colors.transparent;
              },
            ),
            elevation: WidgetStateProperty.resolveWith<double>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return 8;
                }
                return 2;
              },
            ),
          ),
          child: Center(
            child: Text(
              titles[i],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ));
    }
    return functionItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 左右箭头
        SizedBox(
          height: 50,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  icon: const Icon(
                    color: Colors.white,
                    Icons.arrow_back,
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  icon: const Icon(
                    color: Colors.grey,
                    Icons.arrow_forward,
                  )),
            ],
          ),
        ),
        currentIndex == 0
            ? Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
                  child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 2.0),
                    children: List.generate(7, (index) => _buildItems()[index]),
                  ),
                ),
              )
            : Container(
                color: Colors.blue,
                height: 300,
              ),
      ],
    );
  }
}
