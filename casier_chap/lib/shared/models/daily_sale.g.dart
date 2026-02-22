// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_sale.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailySaleAdapter extends TypeAdapter<DailySale> {
  @override
  final int typeId = 1;

  @override
  DailySale read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailySale(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      productSales: (fields[2] as Map).cast<String, int>(),
      totalCaisse: fields[3] as double,
      totalMarge: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DailySale obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.productSales)
      ..writeByte(3)
      ..write(obj.totalCaisse)
      ..writeByte(4)
      ..write(obj.totalMarge);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailySaleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
