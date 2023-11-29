// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psqi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PSQIAdapter extends TypeAdapter<PSQI> {
  @override
  final int typeId = 2;

  @override
  PSQI read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PSQI(
      timeToBed: fields[0] as String?,
      timeToSleep: fields[1] as String?,
      wakeUpTime: fields[2] as String?,
      hoursSlept: fields[3] as String?,
      sleepIn30Mins: fields[4] as String?,
      wakeUpNightOrMorning: fields[5] as String?,
      bathroomUse: fields[6] as String?,
      cannotBreatheComfortably: fields[7] as String?,
      coughOrSnoreLoudly: fields[8] as String?,
      feelCold: fields[9] as String?,
      feelHot: fields[10] as String?,
      badDreams: fields[11] as String?,
      havePain: fields[12] as String?,
      otherReasonsUnableToSleep: fields[13] as String?,
      troubleSleepingDueToOtherReason: fields[14] as String?,
      sleepQuality: fields[15] as String?,
      medicineToSleep: fields[16] as String?,
      troubleStayingAwake: fields[17] as String?,
      enthusiasm: fields[18] as String?,
      dateTaken: fields[19] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PSQI obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.timeToBed)
      ..writeByte(1)
      ..write(obj.timeToSleep)
      ..writeByte(2)
      ..write(obj.wakeUpTime)
      ..writeByte(3)
      ..write(obj.hoursSlept)
      ..writeByte(4)
      ..write(obj.sleepIn30Mins)
      ..writeByte(5)
      ..write(obj.wakeUpNightOrMorning)
      ..writeByte(6)
      ..write(obj.bathroomUse)
      ..writeByte(7)
      ..write(obj.cannotBreatheComfortably)
      ..writeByte(8)
      ..write(obj.coughOrSnoreLoudly)
      ..writeByte(9)
      ..write(obj.feelCold)
      ..writeByte(10)
      ..write(obj.feelHot)
      ..writeByte(11)
      ..write(obj.badDreams)
      ..writeByte(12)
      ..write(obj.havePain)
      ..writeByte(13)
      ..write(obj.otherReasonsUnableToSleep)
      ..writeByte(14)
      ..write(obj.troubleSleepingDueToOtherReason)
      ..writeByte(15)
      ..write(obj.sleepQuality)
      ..writeByte(16)
      ..write(obj.medicineToSleep)
      ..writeByte(17)
      ..write(obj.troubleStayingAwake)
      ..writeByte(18)
      ..write(obj.enthusiasm)
      ..writeByte(19)
      ..write(obj.dateTaken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PSQIAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
