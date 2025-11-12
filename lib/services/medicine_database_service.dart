import 'package:hive_flutter/hive_flutter.dart';
import '../models/medicine.dart';
import 'package:flutter/foundation.dart';

class MedicineDatabase {
  static const String boxName = 'medicines';
  late Box<Medicine> _box;
  bool _initialized = false;

  // Singleton
  static final MedicineDatabase _instance = MedicineDatabase._internal();
  MedicineDatabase._internal();
  factory MedicineDatabase() => _instance;

  // inizializza Hive e apre la box
  Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Registra adapter solo se non sono già registrati
    final repeatAdapter = RepeatAdapter();
    final medicineAdapter = MedicineAdapter();
    if (!Hive.isAdapterRegistered(repeatAdapter.typeId)) {
      Hive.registerAdapter(repeatAdapter);
    }
    if (!Hive.isAdapterRegistered(medicineAdapter.typeId)) {
      Hive.registerAdapter(medicineAdapter);
    }

    _box = await Hive.openBox<Medicine>(boxName);
    _initialized = true;
  }

  Future<void> _ensureInit() async {
    if (!_initialized) await init();
  }

  /// Cancella tutti i record della box (idempotente).
  Future<void> clearAll() async {
    await _ensureInit();
    if (_box.isOpen) {
      await _box.clear();
    } else {
      // apri temporaneamente e cancella
      final b = await Hive.openBox<Medicine>(boxName);
      await b.clear();
      await b.close();
    }
  }

  /// Chiude la box (se aperta).
  Future<void> close() async {
    if (_initialized && _box.isOpen) {
      await _box.close();
      _initialized = false;
    }
  }

  // Aggiunge una nuova medicina
  Future<void> addMedicine(Medicine medicine) async {
    await _ensureInit();
    await _box.add(medicine);
  }

  // Stampa tutte le medicine
  List<Medicine> getAllMedicines() {
    if (!_initialized) return <Medicine>[];
    return _box.values.toList();
  }

  // Elimina una medicina per indice
  Future<void> deleteMedicine(int index) async {
    await _box.deleteAt(index);
  }

  ValueListenable<Box<Medicine>> get listenable => _box.listenable();
}
