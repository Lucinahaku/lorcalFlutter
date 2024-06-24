// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

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
    return User()
      ..username = fields[0] as String
      ..email = fields[1] as String
      ..password = fields[2] as String
      ..profileImage = fields[3] as String
      ..bio = fields[4] as String
      ..likeCount = fields[5] as int
      ..address = fields[6] as String
      ..phoneNumber = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.profileImage)
      ..writeByte(4)
      ..write(obj.bio)
      ..writeByte(5)
      ..write(obj.likeCount)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.phoneNumber);
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
