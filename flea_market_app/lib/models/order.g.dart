// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 2;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order()
      ..productId = fields[0] as int
      ..buyerEmail = fields[1] as String
      ..buyerName = fields[2] as String
      ..buyerAddress = fields[3] as String
      ..buyerPhone = fields[4] as String
      ..purchaseDate = fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.buyerEmail)
      ..writeByte(2)
      ..write(obj.buyerName)
      ..writeByte(3)
      ..write(obj.buyerAddress)
      ..writeByte(4)
      ..write(obj.buyerPhone)
      ..writeByte(5)
      ..write(obj.purchaseDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
