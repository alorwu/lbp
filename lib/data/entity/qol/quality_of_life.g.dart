// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quality_of_life.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QoLAdapter extends TypeAdapter<QoL> {
  @override
  final int typeId = 3;

  @override
  QoL read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QoL(
      generalHealth: fields[0] as String?,
      qualityOfLife: fields[1] as String?,
      physicalHealth: fields[2] as String?,
      mentalHealth: fields[3] as String?,
      socialSatisfaction: fields[4] as String?,
      carryOutSocialActivities: fields[5] as String?,
      carryOutPhysicalActivities: fields[6] as String?,
      emotionalProblems: fields[7] as String?,
      fatigue: fields[8] as String?,
      pain: fields[9] as String?,
      dateTaken: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, QoL obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.generalHealth)
      ..writeByte(1)
      ..write(obj.qualityOfLife)
      ..writeByte(2)
      ..write(obj.physicalHealth)
      ..writeByte(3)
      ..write(obj.mentalHealth)
      ..writeByte(4)
      ..write(obj.socialSatisfaction)
      ..writeByte(5)
      ..write(obj.carryOutSocialActivities)
      ..writeByte(6)
      ..write(obj.carryOutPhysicalActivities)
      ..writeByte(7)
      ..write(obj.emotionalProblems)
      ..writeByte(8)
      ..write(obj.fatigue)
      ..writeByte(9)
      ..write(obj.pain)
      ..writeByte(10)
      ..write(obj.dateTaken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QoLAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
