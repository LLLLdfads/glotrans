import 'dart:io';
import 'dart:isolate';

import 'package:excel/excel.dart' as e;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glo_trans/utils.dart';
import 'package:glo_trans/view_model/app_data_view_model.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:desktop_drop/desktop_drop.dart';

class MoreView extends StatefulWidget {
  const MoreView({super.key});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  int currentIndex = 0;

  late AppDataViewModel _appDataViewModel;

  @override
  void initState() {
    super.initState();
    initData();
    _buildItems();
  }

  void initData() {
    _appDataViewModel = context.read<AppDataViewModel>();
    _appDataViewModel.initXLogPrivateKey();
  }

  /// 导入excel,替换状态管理中的表格
  void _handleImportExcel() async {
    print("导入excel");
    String? excelPath = await pickFile("xlsx");
    if (excelPath == null) {
      return;
    }
    var excel = e.Excel.decodeBytes(File(excelPath).readAsBytesSync());
    print('选择文件：$excelPath');
    List<List<e.Data?>> rows = excel.sheets["Sheet1"]!.rows;
    List<List<String>> listStringRows = [];
    print("内容：");
    for (var row in rows) {
      print(row.map((e) => e?.value).toList());
      listStringRows.add(row.map((e) => e?.value.toString() ?? '').toList());
    }
    _appDataViewModel.importExcelReplace(listStringRows);
    _appDataViewModel.switchPage(1);
  }

  // 获取ipv4
  Future<void> _getIpv4() async {
    String ipv4 = "";
    // 内网ip
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.address.split(".").length == 4) {
          ipv4 = addr.address;
        }
      }
    }

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF2A2D3E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '本机IP地址',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SelectableText(
                ipv4,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: ipv4));
                      showToast("已复制到剪贴板");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E4396),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('复制'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleXLogFile(String filePath, String privateKey) async {
    // 显示解析中对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF2A2D3E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF3E4396),
                ),
              ),
              SizedBox(width: 16),
              Text(
                '正在解析文件...',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
    try {
      ReceivePort? receivePort = ReceivePort();

      Isolate.spawn(
          decodeMarsLog, [privateKey, filePath, receivePort.sendPort]);

      receivePort.listen((message) {
        if (!mounted) return;
        Navigator.of(context).pop(); // 关闭解析中对话框
        dismissAllToast(showAnim: true);

        // 显示解析完成对话框
        showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: const Color(0xFF2A2D3E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF3E4396),
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '解析完成',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // '文件 $fileName 已成功解析',
                    '已成功解析',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        receivePort.close();
      });
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // 关闭解析中对话框
      dismissAllToast(showAnim: true);

      // 显示错误对话框
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: const Color(0xFF2A2D3E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  '解析失败',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('关闭'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  _handleItemsClick(int index) {
    if (index == 0) {
      // 功能1，解析xlog
      showDialog(
        context: context,
        builder: (_) {
          TextEditingController privateKeyController = TextEditingController();
          privateKeyController.text = _appDataViewModel.xlogPrivateKey;
          String? selectedFilePath;
          String fileName = '';
          bool hasFile = false;
          bool isDragging = false;
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return Dialog(
                backgroundColor: const Color(0xFF2A2D3E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题
                      const Text(
                        '解析 XLog 文件',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 私钥输入区域
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48, // 设置固定高度
                              child: TextField(
                                controller: privateKeyController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: '输入解密私钥',
                                  hintStyle:
                                      const TextStyle(color: Colors.white38),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.05),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 48, // 设置固定高度
                            child: ElevatedButton(
                              onPressed: () {
                                final privateKey = privateKeyController.text;
                                if (privateKey.isEmpty) {
                                  showToast("请输入私钥");
                                  return;
                                }
                                // 检查文件selectedFilePath
                                if (selectedFilePath == null) {
                                  showToast("请选择文件");
                                  return;
                                }
                                // 检查文件后缀
                                if (!selectedFilePath!.endsWith('.xlog')) {
                                  showToast("仅限xlog文件");
                                  return;
                                }
                                _appDataViewModel.setXLogPrivateKey(privateKey);
                                // 移除所有toast后再关闭对话框
                                Navigator.of(context).pop(); // 关闭当前对话框
                                _handleXLogFile(
                                    selectedFilePath!, privateKey); // 开始解析
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3E4396),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('开始解析'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // 拖拽区域
                      DropTarget(
                        onDragDone: (detail) async {
                          selectedFilePath = detail.files.first.path;
                          // 拖拽的文件后缀必须是xlog
                          if (selectedFilePath == null ||
                              !selectedFilePath!.endsWith('.xlog')) {
                            showToast("仅限xlog文件");
                            return;
                          }
                          setDialogState(() {
                            isDragging = false;
                            hasFile = true;
                            fileName = detail.files.first.name;
                          });
                        },
                        onDragEntered: (detail) {
                          setDialogState(() => isDragging = true);
                        },
                        onDragExited: (detail) {
                          setDialogState(() => isDragging = false);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: (isDragging
                                    ? const Color(0xFF3E4396)
                                    : Colors.black)
                                .withOpacity(isDragging ? 0.1 : 0.2),
                            border: Border.all(
                              color: isDragging
                                  ? const Color(0xFF3E4396)
                                  : Colors.white24,
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                hasFile
                                    ? Icons.check_circle
                                    : Icons.upload_file,
                                size: 40,
                                color: hasFile
                                    ? const Color(0xFF3E4396)
                                    : (isDragging
                                        ? const Color(0xFF3E4396)
                                        : Colors.white38),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                hasFile ? fileName : '拖拽文件到这里',
                                style: TextStyle(
                                  color: hasFile
                                      ? const Color(0xFF3E4396)
                                      : (isDragging
                                          ? const Color(0xFF3E4396)
                                          : Colors.white38),
                                  fontSize: 16,
                                ),
                              ),
                              if (!hasFile) ...[
                                const SizedBox(height: 8),
                                Text(
                                  '仅支持 .xlog 文件',
                                  style: TextStyle(
                                    color: Colors.white38.withOpacity(0.5),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
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
    } else if (index == 1) {
      // 功能2，导入excel
      _handleImportExcel();
    } else if (index == 5) {
      // 功能5，查询本机ip
      _getIpv4();
    } else if (index == 6) {
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
