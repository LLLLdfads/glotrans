// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate_result_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TranslateResultModelListAdapter
    extends TypeAdapter<TranslateResultModelList> {
  @override
  final int typeId = 3;

  @override
  TranslateResultModelList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslateResultModelList(
      translateResultList: (fields[0] as List).cast<TranslateResultModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, TranslateResultModelList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.translateResultList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslateResultModelListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TranslateResultModelAdapter extends TypeAdapter<TranslateResultModel> {
  @override
  final int typeId = 2;

  @override
  TranslateResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TranslateResultModel(
      time: fields[0] as String,
      header: (fields[1] as List).cast<String>(),
      rows: (fields[2] as List)
          .map((dynamic e) => (e as List).cast<String>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, TranslateResultModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.header)
      ..writeByte(2)
      ..write(obj.rows);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslateResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
