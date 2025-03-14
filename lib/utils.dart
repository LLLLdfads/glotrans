import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:pointycastle/export.dart';
import 'package:convert/convert.dart';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:glo_trans/app_const.dart';
import 'package:pluto_grid/pluto_grid.dart';

/// 将输入的json文本解析成map键值对
Map<String, String> parseInputStr(String inputStr) {
  Map<String, String> map = {};
  var tempMap = jsonDecode("{$inputStr}");
  tempMap.forEach((key, value) => map[key] = value.toString());
  return map;
}

/// 打开文件选择器
Future<String?> pickFile(String fileCate) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [fileCate], // 只允许选择 JSON 文件
    );
    if (result != null) {
      String filePath = result.files.single.path!;
      return filePath;
    } else {}
  } catch (e) {
    print(e);
  }
  return null;
}

// 翻译一种语言（多个文本），暂时不用了，展示不好看
Future<List<String>> translateOneLanguageTexts(
    String language, List<String> texts, String key) async {
  var dio = Dio();
  var url = AppConst.deeplurl;
  List<String> res = [];
  try {
    var response = await dio.post(
      url,
      options: Options(
        headers: {
          'Authorization': 'DeepL-Auth-Key $key',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'target_lang': language,
        'text': texts,
        'show_billed_characters': true,
      },
    );

    if (response.statusCode == 200) {
      print('翻译成功：${response.data}');
      response.data['translations'].forEach((e) {
        res.add(e.toString());
      });
    } else {
      print('翻译失败：${response.statusCode}');
    }
  } catch (e) {
    print('发生错误：$e');
  }
  return res;
}

// 翻译一种语言（单个文本）
Future<String> translateOneLanguageText(
    String language, String text, String key) async {
  key = "1e6e86dd-797b-4fc7-aaf2-ab6efc120ea9:fx";

  var dio = Dio();
  var url = AppConst.deeplurl;
  String res = "";
  try {
    var response = await dio.post(
      url,
      options: Options(
        headers: {
          'Authorization': 'DeepL-Auth-Key $key',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'target_lang': language,
        'text': [text],
        'show_billed_characters': true,
      },
    );

    if (response.statusCode == 200) {
      print('翻译成功：${response.data}');
      // response.data['translations'].forEach((e) {
      //   res.add(e.toString());
      // });
      res = response.data['translations'][0]['text'].toString();
    } else {
      print('翻译失败：${response.statusCode}');
    }
    return res;
  } catch (e) {
    print('发生错误：$e');
    return "error";
  }
}

// 翻译一种语言（单个文本）,不调用接口，直接返回
Future<String> translateOneLanguageTextForDev(
    String language, String text, String key) async {
  key = "1e6e86dd-797b-4fc7-aaf2-ab6efc120ea9:fx";
  await Future.delayed(const Duration(milliseconds: 50));
  return "$language -$text";
}

Future<void> exportToExcelForPGSM(PlutoGridStateManager stateManager) async {
  // 创建一个新的 Excel 文件
  var excel = Excel.createExcel();

  // 获取当前表格的 Sheet
  var sheet = excel['Sheet1'];

  // 添加表头
  for (var i = 0; i < stateManager.columns.length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value =
        stateManager.columns[i].title;
  }

  // 添加数据行
  for (var rowIndex = 0; rowIndex < stateManager.rows.length; rowIndex++) {
    var row = stateManager.rows[rowIndex];
    for (var colIndex = 0; colIndex < stateManager.columns.length; colIndex++) {
      var cell = row.cells[stateManager.columns[colIndex].field];
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: colIndex, rowIndex: rowIndex + 1))
          .value = cell?.value.toString();
    }
  }

  // 保存文件
  var fileBytes = excel.save();
  if (fileBytes != null) {
    // 使用 file_picker 选择保存路径
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: '保存 Excel 文件',
      fileName: 'exported_data.xlsx',
    );

    if (outputFile != null) {
      // 写入文件
      await File(outputFile).writeAsBytes(fileBytes);
    }
  }
}

// list格式导出excel
Future<void> exportToExcel(List<List<String>> data) async {
  // 创建一个新的 Excel 文件
  var excel = Excel.createExcel();

  // 获取当前表格的 Sheet
  var sheet = excel['Sheet1'];

  // 添加数据行
  for (var rowIndex = 0; rowIndex < data.length; rowIndex++) {
    var row = data[rowIndex];
    for (var colIndex = 0; colIndex < row.length; colIndex++) {
      var cell = row[colIndex];
      sheet
          .cell(CellIndex.indexByColumnRow(
              columnIndex: colIndex, rowIndex: rowIndex))
          .value = cell;
    }
  }

  // 保存文件
  var fileBytes = excel.save();
  if (fileBytes != null) {
    // 保存的文件名称以为当前时间为准，如2025年3月11日10点10分，就命名成25_0311_1010
    String now = DateTime.now().toString();
    String fileName =
        '${now.substring(0, 4)}_${now.substring(5, 7)}_${now.substring(11, 13)}_${now.substring(14, 16)}';
    // 使用 file_picker 选择保存路径
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: '保存 Excel 文件',
      fileName: '$fileName.xlsx',
    );

    if (outputFile != null) {
      // 写入文件
      await File(outputFile).writeAsBytes(fileBytes);
    }
  }
}

// 解析xlog
Future decodeMarsLog(List<dynamic> args) async {
  // 85472b071be23389aa87037b3e2fabc2ab6bcb67c7bee3bf5bf7d0decf7987ff
  String privateKey = args[0];
  String filePath = args[1];
  SendPort sendPort = args[2];
  var decoder = MarsLogDecoder(privateKey);
  await decoder.decodeFile(filePath, '$filePath.log');
  sendPort.send("done!");
}

// Future<void> decodeMarsLog(String privateKey, String filePath) async {
//   // 85472b071be23389aa87037b3e2fabc2ab6bcb67c7bee3bf5bf7d0decf7987ff
//   var decoder = MarsLogDecoder(privateKey);
//   await decoder.decodeFile(filePath, '$filePath.log');
//   await decoder.decodeFile(filePath, '$filePath.log');
//   await decoder.decodeFile(filePath, '$filePath.log');
// }

class MarsLogDecoder {
  // 魔数常量定义
  static const int magicNoCompressStart = 0x03;
  static const int magicNoCompressStart1 = 0x06;
  static const int magicNoCompressNoCryptStart = 0x08;
  static const int magicCompressStart = 0x04;
  static const int magicCompressStart1 = 0x05;
  static const int magicCompressStart2 = 0x07;
  static const int magicCompressNoCryptStart = 0x09;
  static const int magicEnd = 0x00;

  final String _privateKey;
  // 缓存机制
  final Map<String, Uint8List> _teaKeyCache = {};

  MarsLogDecoder(this._privateKey);

  // TEA解密实现
  Uint8List teaDecipher(Uint8List v, Uint8List k) {
    if (v.length < 8) return Uint8List(0);

    var v0 = ByteData.view(v.buffer).getUint32(0, Endian.little);
    var v1 = ByteData.view(v.buffer).getUint32(4, Endian.little);

    var k1 = ByteData.view(k.buffer).getUint32(0, Endian.little);
    var k2 = ByteData.view(k.buffer).getUint32(4, Endian.little);
    var k3 = ByteData.view(k.buffer).getUint32(8, Endian.little);
    var k4 = ByteData.view(k.buffer).getUint32(12, Endian.little);

    int delta = 0x9E3779B9;
    int sum = 0xE3779B90;

    for (int i = 0; i < 16; i++) {
      v1 = (v1 - (((v0 << 4) + k3) ^ (v0 + sum) ^ ((v0 >> 5) + k4))) &
          0xFFFFFFFF;
      v0 = (v0 - (((v1 << 4) + k1) ^ (v1 + sum) ^ ((v1 >> 5) + k2))) &
          0xFFFFFFFF;
      sum = (sum - delta) & 0xFFFFFFFF;
    }

    var result = ByteData(8);
    result.setUint32(0, v0, Endian.little);
    result.setUint32(4, v1, Endian.little);
    return Uint8List.view(result.buffer);
  }

  // TEA解密整个缓冲区
  Uint8List teaDecrypt(Uint8List v, Uint8List k) {
    int num = (v.length ~/ 8) * 8;
    var result = <int>[];

    for (int i = 0; i < num; i += 8) {
      var block = v.sublist(i, i + 8);
      result.addAll(teaDecipher(block, k));
    }

    result.addAll(v.sublist(num));
    return Uint8List.fromList(result);
  }

  // 获取ECDH密钥，使用缓存
  Uint8List getECDHKey(Uint8List pubkeyData) {
    var pubKeyHex = hex.encode(pubkeyData);
    if (_teaKeyCache.containsKey(pubKeyHex)) {
      return _teaKeyCache[pubKeyHex]!;
    }

    try {
      var curve = ECCurve_secp256k1();
      var privKey = ECPrivateKey(BigInt.parse(_privateKey, radix: 16), curve);

      var x = pubkeyData.sublist(0, 32);
      var y = pubkeyData.sublist(32, 64);

      var pubKey = ECPublicKey(
          curve.curve.createPoint(BigInt.parse(hex.encode(x), radix: 16),
              BigInt.parse(hex.encode(y), radix: 16)),
          curve);

      var agreement = ECDHBasicAgreement();
      agreement.init(privKey);
      var sharedSecret = agreement.calculateAgreement(pubKey);
      var sharedSecretBytes = sharedSecret.toRadixString(16).padLeft(64, '0');
      var fullKey = hexToBytes(sharedSecretBytes);
      var teaKey = fullKey.sublist(0, 16);

      _teaKeyCache[pubKeyHex] = teaKey;
      return teaKey;
    } catch (e) {
      print('ECC密钥生成错误: $e');
      return Uint8List(16);
    }
  }

  // 解压缩数据
  Uint8List decompressData(Uint8List data) {
    var withHeader = Uint8List(data.length + 2);
    withHeader[0] = 0x78;
    withHeader[1] = 0x9C;
    withHeader.setRange(2, withHeader.length, data);
    return Uint8List.fromList(ZLibDecoder().decodeBytes(withHeader));
  }

  Future<int> processLogBlock(
      Uint8List buffer, int offset, List<int> outBuffer) async {
    // 检查基本边界
    if (offset >= buffer.length) {
      print('错误：偏移量超出缓冲区范围');
      return -1;
    }

    int magicStart = buffer[offset];
    int cryptKeyLen = (magicStart == magicNoCompressStart ||
            magicStart == magicCompressStart ||
            magicStart == magicCompressStart1)
        ? 4
        : 64;

    int headerLen = 1 + 2 + 1 + 1 + 4 + cryptKeyLen;

    // 检查header是否完整
    if (offset + headerLen > buffer.length) {
      print('错误：头部数据不完整');
      return -1;
    }

    // 读取长度前先检查范围
    if (offset + headerLen - 4 - cryptKeyLen + 4 > buffer.length) {
      print('错误：无法读取数据长度');
      return -1;
    }

    int length = ByteData.view(buffer.buffer)
        .getUint32(offset + headerLen - 4 - cryptKeyLen, Endian.little);

    // 检查数据长度的合理性
    if (length < 0 || length > buffer.length - offset - headerLen) {
      print(
          '错误：数据长度无效 (length=$length, remaining=${buffer.length - offset - headerLen})');
      return -1;
    }

    // 检查是否有足够的数据
    if (offset + headerLen + length >= buffer.length) {
      print('错误：数据不完整');
      return -1;
    }

    var data = buffer.sublist(offset + headerLen, offset + headerLen + length);

    try {
      if (magicStart == magicNoCompressStart1) {
        outBuffer.addAll(data);
      } else if (magicStart == magicCompressStart2) {
        if (cryptKeyLen != 64) {
          print('错误：COMPRESS_START2需要64字节的密钥长度');
          return -1;
        }
        var pubkeyData = buffer.sublist(
            offset + headerLen - cryptKeyLen, offset + headerLen);
        var teaKey = getECDHKey(pubkeyData);
        var decrypted = teaDecrypt(data, teaKey);
        var decompressed = decompressData(decrypted);
        outBuffer.addAll(decompressed);
      } else if (magicStart == magicCompressStart ||
          magicStart == magicCompressNoCryptStart) {
        var decompressed = decompressData(data);
        outBuffer.addAll(decompressed);
      } else if (magicStart == magicCompressStart1) {
        var decompressData = <int>[];
        var pos = 0;
        while (pos < data.length) {
          // 检查是否有足够的数据来读取长度
          if (pos + 2 > data.length) {
            print('错误：无法读取单条日志长度');
            break;
          }
          int singleLogLen =
              ByteData.view(data.buffer).getUint16(pos, Endian.little);

          // 检查单条日志长度的合理性
          if (singleLogLen < 0 || pos + 2 + singleLogLen > data.length) {
            print('错误：单条日志长度无效');
            break;
          }

          decompressData.addAll(data.sublist(pos + 2, pos + 2 + singleLogLen));
          pos += singleLogLen + 2;
        }
        var decompressed = ZLibDecoder().decodeBytes(decompressData);
        outBuffer.addAll(decompressed);
      }
    } catch (e) {
      print('处理日志块错误: $e');
      outBuffer
          .addAll(utf8.encode('[F]decode_log_file.dart decompress err: $e\n'));
    }

    return offset + headerLen + length + 1;
  }

  // 检查日志缓冲区是否有效
  bool isGoodLogBuffer(Uint8List buffer, int offset, int count) {
    if (offset >= buffer.length) {
      print('检查缓冲区: 偏移量超出范围');
      return false;
    }

    int magicStart = buffer[offset];
    int cryptKeyLen = (magicStart == magicNoCompressStart ||
            magicStart == magicCompressStart ||
            magicStart == magicCompressStart1)
        ? 4
        : 64;

    int headerLen = 1 + 2 + 1 + 1 + 4 + cryptKeyLen;

    if (offset + headerLen + 1 + 1 > buffer.length) {
      print('检查缓冲区: 头部数据不完整');
      return false;
    }

    // 读取长度前先检查范围
    if (offset + headerLen - 4 - cryptKeyLen + 4 > buffer.length) {
      print('检查缓冲区: 无法读取数据长度');
      return false;
    }

    int length = ByteData.view(buffer.buffer)
        .getUint32(offset + headerLen - 4 - cryptKeyLen, Endian.little);

    if (length < 0 || length > buffer.length - offset - headerLen) {
      print('检查缓冲区: 数据长度无效 (length=$length)');
      return false;
    }

    if (offset + headerLen + length + 1 > buffer.length) {
      print('检查缓冲区: 数据不完整');
      return false;
    }

    if (buffer[offset + headerLen + length] != magicEnd) {
      print('检查缓冲区: 未找到结束标记');
      return false;
    }

    if (count <= 1) return true;
    return isGoodLogBuffer(buffer, offset + headerLen + length + 1, count - 1);
  }

  // 获取日志开始位置
  int getLogStartPos(Uint8List buffer, int count) {
    print('\n查找日志起始位置:');
    print('- 缓冲区大小: ${buffer.length} 字节');
    print('- 查找块数量: $count');

    int offset = 0;
    while (offset < buffer.length) {
      int magicStart = buffer[offset];
      if (magicStart == magicNoCompressStart ||
          magicStart == magicNoCompressStart1 ||
          magicStart == magicCompressStart ||
          magicStart == magicCompressStart1 ||
          magicStart == magicCompressStart2 ||
          magicStart == magicCompressNoCryptStart ||
          magicStart == magicNoCompressNoCryptStart) {
        print(
            '在位置 $offset 发现可能的魔数: 0x${magicStart.toRadixString(16).padLeft(2, '0')}');
        if (isGoodLogBuffer(buffer, offset, count)) {
          print('确认为有效的日志起始位置');
          return offset;
        }
        print('不是有效的日志起始位置，继续搜索...');
      }
      offset++;
    }
    return -1;
  }

  // 主解码方法
  Future<void> decodeFile(String inputPath, String outputPath) async {
    try {
      var file = File(inputPath);
      if (!await file.exists()) {
        print('错误：输入文件不存在: $inputPath');
        return;
      }

      var buffer = await file.readAsBytes();
      print('读取文件大小: ${buffer.length} 字节');

      var outBuffer = <int>[];

      int startPos = getLogStartPos(buffer, 2);
      if (startPos == -1) {
        print('错误：未找到有效的日志起始位置');
        return;
      }
      print('找到日志起始位置: $startPos');

      int blockCount = 0;
      while (startPos != -1 && startPos < buffer.length) {
        print('\n处理日志块 #${blockCount + 1}:');
        print('当前偏移量: $startPos');

        if (startPos >= buffer.length) {
          print('错误：偏移量超出缓冲区范围');
          break;
        }

        print('魔数: 0x${buffer[startPos].toRadixString(16).padLeft(2, '0')}');

        int newPos = await processLogBlock(buffer, startPos, outBuffer);
        if (newPos == -1 || newPos <= startPos) {
          print('错误：处理日志块失败或位置未前进');
          break;
        }

        startPos = newPos;
        blockCount++;
      }

      print('\n处理完成:');
      print('- 处理的日志块数: $blockCount');
      print('- 输出数据大小: ${outBuffer.length} 字节');

      if (outBuffer.isEmpty) {
        print('警告：没有解码出任何数据');
        return;
      }

      await File(outputPath).writeAsBytes(outBuffer);
      print('解码完成: $outputPath');
    } catch (e, stackTrace) {
      print('文件解码错误: $e');
      print('堆栈跟踪:\n$stackTrace');
    }
  }

  Uint8List hexToBytes(String hex) {
    var result = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < hex.length; i += 2) {
      var num = int.parse(hex.substring(i, i + 2), radix: 16);
      result[i ~/ 2] = num;
    }
    return result;
  }
}
