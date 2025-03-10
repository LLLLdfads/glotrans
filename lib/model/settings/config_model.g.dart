// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigModelAdapter extends TypeAdapter<ConfigModel> {
  @override
  final int typeId = 0;

  @override
  ConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfigModel(
      deeplKey: fields[0] as String,
      targetLanguageConfigList:
          (fields[1] as List).cast<TargetLanguageConfigModel>(),
      l10nFlag: fields[2] as String?,
      insertBeforeL10nFlag: fields[3] as bool,
      androidFlag: fields[4] as String?,
      insertBeforeAndroidFlag: fields[5] as bool,
      systemLanguage: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ConfigModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.deeplKey)
      ..writeByte(1)
      ..write(obj.targetLanguageConfigList)
      ..writeByte(2)
      ..write(obj.l10nFlag)
      ..writeByte(3)
      ..write(obj.insertBeforeL10nFlag)
      ..writeByte(4)
      ..write(obj.androidFlag)
      ..writeByte(5)
      ..write(obj.insertBeforeAndroidFlag)
      ..writeByte(6)
      ..write(obj.systemLanguage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
