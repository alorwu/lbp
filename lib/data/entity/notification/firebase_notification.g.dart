// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FirebaseNotificationAdapter extends TypeAdapter<FirebaseNotification> {
  @override
  final int typeId = 7;

  @override
  FirebaseNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FirebaseNotification(
      messageId: fields[0] as String?,
      title: fields[1] as String?,
      body: fields[2] as String?,
      sentTime: fields[3] as int?,
      ttl: fields[4] as int?,
      data: fields[5] as Data?,
    );
  }

  @override
  void write(BinaryWriter writer, FirebaseNotification obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.messageId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.sentTime)
      ..writeByte(4)
      ..write(obj.ttl)
      ..writeByte(5)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FirebaseNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
