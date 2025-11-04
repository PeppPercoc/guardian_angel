import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/theme.dart';
import '../models/medicine.dart';
import '../services/medicine_database_service.dart';

typedef OnSaveCallback = void Function(Medicine medicine);

class AddMedicineForm extends StatefulWidget {
  final OnSaveCallback onSave;
  final MedicineDatabase medicineDatabase;
  const AddMedicineForm({
    super.key,
    required this.onSave,
    required this.medicineDatabase,
  });

  @override
  State<AddMedicineForm> createState() => _AddMedicineFormState();
}

class _AddMedicineFormState extends State<AddMedicineForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String dosageInstructions = '';
  String medicineInstructions = '';
  Repeat repeat = Repeat.oncePerDay;
  List<String> reminderTimes = [];
  DateTime? endDate;
  String? additionalNotes;

  bool _submitted = false;

  // Mostra una stringa leggibile dalle ISO (es. "08:30")
  String _displayTimeFromIso(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }

  String _displayTimes() {
    if (reminderTimes.isEmpty) return 'Nessun orario scelto';
    return reminderTimes.map(_displayTimeFromIso).join(', ');
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final base = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      setState(() {
        // calcola e salva come ISO8601 strings
        reminderTimes = _computeReminderTimesFromBase(base, repeat);
      });
    }
  }

  String _addHoursIso(DateTime dt, int addHours) {
    final added = dt.add(Duration(hours: addHours));
    return added.toIso8601String();
  }

  List<String> _computeReminderTimesFromBase(DateTime base, Repeat rep) {
    final times = <String>[];
    times.add(base.toIso8601String());
    switch (rep) {
      case Repeat.oncePerDay:
        break;
      case Repeat.twicePerDay:
        times.add(_addHoursIso(base, 12));
        break;
      case Repeat.thricePerDay:
        times.add(_addHoursIso(base, 8));
        times.add(_addHoursIso(base, 16));
        break;
    }
    return times;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 50, left: 16, right: 16, top: 16),
      child: Form(
        key: _formKey,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome Farmaco',
                  hintText: 'e.g. Aspirin 100mg',
                ),
                onSaved: (val) => name = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Inserisci il nome del farmaco' : null,
              ),
              const SizedBox(height: 10),

              // Dosage Instructions
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Istruzioni Dosaggio',
                  hintText: 'e.g. 1 pillola dopo pranzo',
                ),
                onSaved: (val) => dosageInstructions = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Inserisci le istruzioni di dosaggio' : null,
              ),
              const SizedBox(height: 10),

              // Instructions
              TextFormField(
                decoration: const InputDecoration(labelText: 'Istruzioni'),
                onSaved: (val) => medicineInstructions = val ?? '',
              ),
              const SizedBox(height: 10),

              // Reminder Time(s)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(_displayTimes()),
                      ),
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: _pickTime,
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                    height: 20,
                  ),
                  if (_submitted && reminderTimes.isEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Inserisci un orario',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
              // Repeat
              Align(alignment: Alignment.centerLeft, child: Text('Ripeti:')),
              Wrap(
                spacing: 8,
                children: Repeat.values.map((rep) {
                  return ChoiceChip(
                    label: Text(_repeatToString(rep)),
                    selected: repeat == rep,
                    selectedColor: AppColors.secondary,
                    disabledColor: AppColors.backgroundSecondary,
                    labelStyle: TextStyle(
                      color: repeat == rep ? Colors.white : AppColors.secondary,
                    ),
                    onSelected: (selected) async {
                      if (!selected) return;
                      // aggiorna il repeat prima di calcolare i tempi
                      setState(() {
                        repeat = rep;
                      });
                      // se c'è già almeno un orario scelto, ri-calcola automaticamente
                      if (reminderTimes.isNotEmpty) {
                        final base = DateTime.tryParse(reminderTimes.first);
                        if (base != null) {
                          setState(() {
                            reminderTimes = _computeReminderTimesFromBase(base, repeat);
                          });
                        } else {
                          // fallback: richiedi nuovo orario
                          _pickTime();
                        }
                      } else {
                        // altrimenti chiedi all'utente di scegliere l'orario base
                        _pickTime();
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),

              // End Date
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: endDate != null
                      ? '${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}'
                      : '',
                ),
                decoration: const InputDecoration(
                  labelText: 'Data di Fine (opzionale)',
                  hintText: 'Seleziona una data',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(
                      const Duration(days: 365 * 3),
                    ), // 3 anni avanti, messo perchè devo metterci qualcosa
                  );
                  if (picked != null) {
                    setState(() {
                      endDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),

              // Notes
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Note Aggiuntive (opzionale)',
                ),
                onSaved: (val) => additionalNotes = val,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _submitted = true;
                  });
                  if (_formKey.currentState!.validate() &&
                      reminderTimes.isNotEmpty) {
                    _formKey.currentState!.save();
                    final med = Medicine(
                      name: name,
                      dosageInstructions: dosageInstructions,
                      medicineInstructions: medicineInstructions,
                      repeat: repeat,
                      reminderTimes: reminderTimes,
                      endDate: endDate,
                      additionalNotes: additionalNotes,
                    );
                    widget.medicineDatabase.addMedicine(med);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Salva Farmaco',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _repeatToString(Repeat r) {
  switch (r) {
    case Repeat.oncePerDay:
      return "Uno al giorno";
    case Repeat.twicePerDay:
      return "Ogni 12h";
    case Repeat.thricePerDay:
      return "Ogni 8h";
  }
}
