import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:isolate';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: H(),
  ));
  // pickAndLoadJsonFile();
}

class H extends StatefulWidget {
  const H({super.key});

  @override
  State<H> createState() => _HState();
}

class _HState extends State<H> {
  String? _configJosnFilePath;
  Map<String, dynamic>? _configJsonData;
  double _currentProgress = 0.0;
  ReceivePort? _receivePort;
  Isolate? _isolate;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GloTrans"),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: _getConfigJsonFilePath, child: const Text("选择文件")),
          _configJosnFilePath != null
              ? Text(_configJosnFilePath!)
              : Container(),
          ElevatedButton(onPressed: _parseJsonFile, child: const Text("解析文件")),
          _configJsonData != null
              ? Text(_configJsonData.toString())
              : Container(),
          ElevatedButton(onPressed: _startTranslate, child: const Text("开始翻译")),
          Row(
            children: [
              ClipRRect(
                // 边界半径（`borderRadius`）属性，圆角的边界半径。
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: SizedBox(
                  height: 20,
                  width: 300,
                  child: LinearProgressIndicator(
                    value: _currentProgress,
                    backgroundColor: const Color(0xffFFE3E3),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xffFF4964)),
                  ),
                ),
              ),
              Text("${(_currentProgress * 100).toStringAsFixed(1)}%")
            ],
          )
        ],
      ),
    );
  }

  Future<void> _getConfigJsonFilePath() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'], // 只允许选择 JSON 文件
      );
      if (result != null) {
        _configJosnFilePath = result.files.single.path!;
        setState(() {});
      } else {
        print("用户取消选择文件");
      }
    } catch (e) {
      print("读取 JSON 文件时出错: $e");
    }
  }

  void _parseJsonFile() async {
    File file = File(_configJosnFilePath!);
    String jsonString = await file.readAsString();
    _configJsonData = json.decode(jsonString);
    print("读取的 JSON 数据: $_configJsonData");
    setState(() {});
  }

  Future<void> _startTranslate() async {
    if (_isolate != null) {
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
    _receivePort?.close();
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(_translate, _receivePort!.sendPort);
    _receivePort!.listen((message) {
      setState(() {
        _currentProgress = message;
      });
    });
  }
}

void _translate(SendPort sendPort) {
  double currentProgress = 0.0;
  Timer.periodic(const Duration(milliseconds: 100), (timer) {
    if (currentProgress <= 1) {
      currentProgress += 0.001;
    } else {
      currentProgress = 0.0;
    }
    sendPort.send(currentProgress);
  });
}
