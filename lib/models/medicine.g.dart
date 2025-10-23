// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicinesAdapter extends TypeAdapter<Medicines> {
  @override
  final int typeId = 8;

  @override
  Medicines read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medicines(
      name: fields[0] as String,
      dosage: fields[1] as String,
      instructions: fields[2] as String,
      repeat: fields[3] as Repeat,
      reminderTimes: (fields[4] as List).cast<String>(),
      endDate: fields[5] as DateTime?,
      notes: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Medicines obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dosage)
      ..writeByte(2)
      ..write(obj.instructions)
      ..writeByte(3)
      ..write(obj.repeat)
      ..writeByte(4)
      ..write(obj.reminderTimes)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicinesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RepeatAdapter extends TypeAdapter<Repeat> {
  @override
  final int typeId = 7;

  @override
  Repeat read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Repeat.oncePerDay;
      case 1:
        return Repeat.twicePerDay;
      case 2:
        return Repeat.thricePerDay;
      case 3:
        return Repeat.onceEveryTwoDays;
      case 4:
        return Repeat.oncePerWeek;
      default:
        return Repeat.oncePerDay;
    }
  }

  @override
  void write(BinaryWriter writer, Repeat obj) {
    switch (obj) {
      case Repeat.oncePerDay:
        writer.writeByte(0);
        break;
      case Repeat.twicePerDay:
        writer.writeByte(1);
        break;
      case Repeat.thricePerDay:
        writer.writeByte(2);
        break;
      case Repeat.onceEveryTwoDays:
        writer.writeByte(3);
        break;
      case Repeat.oncePerWeek:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepeatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
