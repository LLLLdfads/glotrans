// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_language_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TargetLanguageConfigModelAdapter
    extends TypeAdapter<TargetLanguageConfigModel> {
  @override
  final int typeId = 1;

  @override
  TargetLanguageConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TargetLanguageConfigModel(
      language: fields[0] as String,
      country: fields[1] as String,
      l10nPath: fields[3] as String?,
      usel10n: fields[4] as bool,
      androidPath: fields[5] as String?,
      useAndroid: fields[6] as bool,
      willTranslate: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TargetLanguageConfigModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.country)
      ..writeByte(2)
      ..write(obj.willTranslate)
      ..writeByte(3)
      ..write(obj.l10nPath)
      ..writeByte(4)
      ..write(obj.usel10n)
      ..writeByte(5)
      ..write(obj.androidPath)
      ..writeByte(6)
      ..write(obj.useAndroid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TargetLanguageConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
