import 'package:hive/hive.dart';

part 'medicine.g.dart';

@HiveType(typeId: 7)
enum Repeat { // enum per i tipi di ricorrenza
  @HiveField(0)
  oncePerDay,
  @HiveField(1)
  twicePerDay,
  @HiveField(2)
  thricePerDay,
}

@HiveType(typeId: 8)
class Medicine extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String dosage;

  @HiveField(2)
  String instructions;

  @HiveField(3)
  Repeat repeat;

  @HiveField(4)
  List<String> reminderTimes;

  @HiveField(5)
  DateTime? endDate;

  @HiveField(6)
  String? notes;

  Medicine({
    required this.name,
    required this.dosage,
    required this.instructions,
    required this.repeat,
    required this.reminderTimes,
    this.endDate,
    this.notes,
  });
}
