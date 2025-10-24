import 'package:hive_flutter/hive_flutter.dart';
import '../models/medicine.dart';
import 'package:flutter/foundation.dart'; 



class MedicineDatabase {
  static const String boxName = 'medicines';
  late Box<Medicine> _box;

  // Inizializza Hive e apre la box (da chiamare all'avvio app)
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RepeatAdapter());
    Hive.registerAdapter(MedicineAdapter());
    _box = await Hive.openBox<Medicine>(boxName);
  }

  // Aggiunge una nuova medicina
  Future<void> addMedicine(Medicine medicine) async {
    await _box.add(medicine);
    print('--- Lista Medicine ---');
  for (var med in _box.values) {
    print('Nome: ${med.name}');
    print('Dosaggio: ${med.dosage}');
    print('Istruzioni: ${med.instructions}');
    print('Orari: ${med.reminderTimes}');
    print('Fine: ${med.endDate}');
    print('----');
  }
  }

  // Recupera tutte le medicine salvate
  List<Medicine> getAllMedicines() {
    return _box.values.toList();
  }

  // Esempio di query: recupera medicine il cui nome contiene una stringa (case insensitive)
  List<Medicine> queryMedicinesByName(String namePart) {
    final nameLower = namePart.toLowerCase();
    return _box.values
        .where((med) => med.name.toLowerCase().contains(nameLower))
        .toList();
  }

  // Elimina una medicina per indice
  Future<void> deleteMedicine(int index) async {
    await _box.deleteAt(index);
  }
  ValueListenable<Box<Medicine>> get listenable => _box.listenable();
}
