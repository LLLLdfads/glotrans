// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_setting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExportSettingModelAdapter extends TypeAdapter<ExportSettingModel> {
  @override
  final int typeId = 4;

  @override
  ExportSettingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExportSettingModel(
      toL10n: fields[0] as bool,
      toAndroid: fields[1] as bool,
      l10nFiles: (fields[2] as List).cast<String>(),
      l10nFilesEnable: (fields[3] as List).cast<bool>(),
      androidFiles: (fields[4] as List).cast<String>(),
      androidFilesEnable: (fields[5] as List).cast<bool>(),
      l10nFlag: fields[6] as String,
      androidFlag: fields[7] as String,
      isInsertBeforeL10nFlag: fields[8] as bool,
      isInsertBeforeAndroidFlag: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ExportSettingModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.toL10n)
      ..writeByte(1)
      ..write(obj.toAndroid)
      ..writeByte(2)
      ..write(obj.l10nFiles)
      ..writeByte(3)
      ..write(obj.l10nFilesEnable)
      ..writeByte(4)
      ..write(obj.androidFiles)
      ..writeByte(5)
      ..write(obj.androidFilesEnable)
      ..writeByte(6)
      ..write(obj.l10nFlag)
      ..writeByte(7)
      ..write(obj.androidFlag)
      ..writeByte(8)
      ..write(obj.isInsertBeforeL10nFlag)
      ..writeByte(9)
      ..write(obj.isInsertBeforeAndroidFlag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExportSettingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
