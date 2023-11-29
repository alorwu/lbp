// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_component_score.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SleepComponentScoresAdapter extends TypeAdapter<SleepComponentScores> {
  @override
  final int typeId = 4;

  @override
  SleepComponentScores read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SleepComponentScores(
      sleepQuality: fields[0] as int?,
      sleepLatency: fields[1] as int?,
      sleepDuration: fields[2] as int?,
      sleepEfficiency: fields[3] as int?,
      sleepDisturbance: fields[4] as int?,
      sleepMedication: fields[5] as int?,
      dayTimeDysfunction: fields[6] as int?,
      pSQIScore: fields[7] as int?,
      dateTaken: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SleepComponentScores obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.sleepQuality)
      ..writeByte(1)
      ..write(obj.sleepLatency)
      ..writeByte(2)
      ..write(obj.sleepDuration)
      ..writeByte(3)
      ..write(obj.sleepEfficiency)
      ..writeByte(4)
      ..write(obj.sleepDisturbance)
      ..writeByte(5)
      ..write(obj.sleepMedication)
      ..writeByte(6)
      ..write(obj.dayTimeDysfunction)
      ..writeByte(7)
      ..write(obj.pSQIScore)
      ..writeByte(8)
      ..write(obj.dateTaken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepComponentScoresAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
