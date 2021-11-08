// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DailyQ.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyQAdapter extends TypeAdapter<DailyQ> {
  @override
  final int typeId = 1;

  @override
  DailyQ read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyQ(
      dateTaken: fields[0] as DateTime,
      sleepTime: fields[1] as DateTime,
      wakeupTime: fields[2] as DateTime,
      timeToSleep: fields[3] as String,
      numberOfWakeupTimes: fields[4] as int,
      wellRestedness: fields[5] as String,
      qualityOfSleep: fields[6] as int,
      painIntensity: fields[7] as int,
      notes: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DailyQ obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.dateTaken)
      ..writeByte(1)
      ..write(obj.sleepTime)
      ..writeByte(2)
      ..write(obj.wakeupTime)
      ..writeByte(3)
      ..write(obj.timeToSleep)
      ..writeByte(4)
      ..write(obj.numberOfWakeupTimes)
      ..writeByte(5)
      ..write(obj.wellRestedness)
      ..writeByte(6)
      ..write(obj.qualityOfSleep)
      ..writeByte(7)
      ..write(obj.painIntensity)
      ..writeByte(8)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyQAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
