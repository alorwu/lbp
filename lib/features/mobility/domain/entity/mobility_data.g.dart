// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobility_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MobilityDataAdapter extends TypeAdapter<MobilityData> {
  @override
  final int typeId = 8;

  @override
  MobilityData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MobilityData(
      date: fields[0] as DateTime?,
      stepsTaken: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MobilityData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.stepsTaken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MobilityDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
