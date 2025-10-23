import 'package:hive/hive.dart';
import '../models/medicine.dart';

class MedicineDatabase {
  static const String boxName = 'medicines';
  late Box<Medicines> _box;

  // Inizializza Hive e apre la box (da chiamare all'avvio app)
  Future<void> init() async {
    _box = await Hive.openBox<Medicines>(boxName);
  }

  // Aggiunge una nuova medicina
  Future<void> addMedicine(Medicines medicine) async {
    await _box.add(medicine);
  }

  // Recupera tutte le medicine salvate
  List<Medicines> getAllMedicines() {
    return _box.values.toList();
  }

  // Esempio di query: recupera medicine il cui nome contiene una stringa (case insensitive)
  List<Medicines> queryMedicinesByName(String namePart) {
    final nameLower = namePart.toLowerCase();
    return _box.values.where((med) =>
      med.name.toLowerCase().contains(nameLower)
    ).toList();
  }

  // Elimina una medicina per indice
  Future<void> deleteMedicine(int index) async {
    await _box.deleteAt(index);
  }
}
