// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      deviceId: fields[0] as String,
      oneSignalId: fields[1] as String,
      nickname: fields[2] as String,
      age: fields[3] as int,
      gender: fields[4] as String,
      employment: fields[5] as String,
      academic: fields[6] as String,
      activeLifeStyleLevel: fields[7] as double,
      hasHadLowBackPain: fields[8] as String,
      sciatica: fields[9] as String,
      painIntensity: fields[10] as String,
      hasHadBackSurgery: fields[11] as String,
      hasHadLbpFor: fields[12] as String,
      diagnosedOfLbp: fields[13] as String,
      lbpTreatment: fields[14] as String,
      date: fields[15] as String,
      segment: fields[16] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.deviceId)
      ..writeByte(1)
      ..write(obj.oneSignalId)
      ..writeByte(2)
      ..write(obj.nickname)
      ..writeByte(3)
      ..write(obj.age)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.employment)
      ..writeByte(6)
      ..write(obj.academic)
      ..writeByte(7)
      ..write(obj.activeLifeStyleLevel)
      ..writeByte(8)
      ..write(obj.hasHadLowBackPain)
      ..writeByte(9)
      ..write(obj.sciatica)
      ..writeByte(10)
      ..write(obj.painIntensity)
      ..writeByte(11)
      ..write(obj.hasHadBackSurgery)
      ..writeByte(12)
      ..write(obj.hasHadLbpFor)
      ..writeByte(13)
      ..write(obj.diagnosedOfLbp)
      ..writeByte(14)
      ..write(obj.lbpTreatment)
      ..writeByte(15)
      ..write(obj.date)
      ..writeByte(16)
      ..write(obj.segment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
