// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

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
      username: fields[0] as String,
      age: fields[1] as int,
      gender: fields[2] as String,
      employment: fields[3] as String,
      academic: fields[4] as String,
      activeLifeStyleLevel: fields[5] as double,
      hasHadLowBackPain: fields[6] as String,
      sciatica: fields[7] as String,
      painIntensity: fields[8] as String,
      hasHadBackSurgery: fields[9] as String,
      hasHadLbpFor: fields[10] as String,
      diagnosedOfLbp: fields[11] as String,
      lbpTreatment: fields[12] as String,
      date: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.employment)
      ..writeByte(4)
      ..write(obj.academic)
      ..writeByte(5)
      ..write(obj.activeLifeStyleLevel)
      ..writeByte(6)
      ..write(obj.hasHadLowBackPain)
      ..writeByte(7)
      ..write(obj.sciatica)
      ..writeByte(8)
      ..write(obj.painIntensity)
      ..writeByte(9)
      ..write(obj.hasHadBackSurgery)
      ..writeByte(10)
      ..write(obj.hasHadLbpFor)
      ..writeByte(11)
      ..write(obj.diagnosedOfLbp)
      ..writeByte(12)
      ..write(obj.lbpTreatment)
      ..writeByte(13)
      ..write(obj.date);
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
