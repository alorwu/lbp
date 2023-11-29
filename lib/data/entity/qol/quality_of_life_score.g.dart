// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quality_of_life_score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QoLScoreAdapter extends TypeAdapter<QoLScore> {
  @override
  final int typeId = 5;

  @override
  QoLScore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QoLScore(
      physicalHealth: fields[0] as int?,
      mentalHealth: fields[1] as int?,
      dateTaken: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, QoLScore obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.physicalHealth)
      ..writeByte(1)
      ..write(obj.mentalHealth)
      ..writeByte(2)
      ..write(obj.dateTaken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QoLScoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
