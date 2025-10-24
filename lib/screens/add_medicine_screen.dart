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
  String dosage = '';
  String instructions = '';
  Repeat repeat = Repeat.oncePerDay;
  List<String> reminderTimes = [];
  DateTime? endDate;
  String? notes;

  bool _submitted = false;

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        reminderTimes.clear();
        reminderTimes.add(_formatTime(picked));

        switch (repeat) {
          case Repeat.oncePerDay:
            break;

          case Repeat.twicePerDay:
            // Ogni 12 ore
            reminderTimes.add(_addHours(picked, 12));
            break;

          case Repeat.thricePerDay:
            // Ogni 8 ore
            reminderTimes
              ..add(_addHours(picked, 8))
              ..add(_addHours(picked, 16));
            break;

          case Repeat.onceEveryTwoDays:
            // Solo l'orario, ma ripetuto ogni 48 ore (gestirai in futuro la logica di notifica)
            break;

          case Repeat.oncePerWeek:
            // Solo l'orario scelto (gestibile in futuro con giorni della settimana)
            break;
        }
      });
    }
  }

  // Funzione di supporto per aggiungere ore e formattare correttamente
  String _addHours(TimeOfDay time, int addHours) {
    final now = DateTime.now();
    final initial = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    final added = initial.add(Duration(hours: addHours));

    // Se supera le 24 ore, torna al formato corretto (es. 00:00)
    final fixed = TimeOfDay(hour: added.hour % 24, minute: added.minute);
    return _formatTime(fixed);
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

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
              // Medication Name
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Medication Name',
                  hintText: 'e.g. Aspirin 100mg',
                ),
                onSaved: (val) => name = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),

              // Dosage Instructions
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Dosage Instructions',
                  hintText: 'e.g. 1 pill after lunch',
                ),
                onSaved: (val) => dosage = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),

              // Instructions
              TextFormField(
                decoration: const InputDecoration(labelText: 'Instructions'),
                onSaved: (val) => instructions = val ?? '',
              ),
              const SizedBox(height: 10),

              // Reminder Time(s)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          reminderTimes.isEmpty
                              ? 'No times chosen'
                              : reminderTimes.join(', '),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: _pickTime,
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1, // spessore linea
                    color: Colors.grey, // colore linea
                    height: 20, // spazio tra row e divider
                  ),
                  if (_submitted && reminderTimes.isEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Required',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
              // Repeat
              Align(alignment: Alignment.centerLeft, child: Text('Repeat:')),
              Wrap(
                spacing: 8,
                children: Repeat.values.map((rep) {
                  return ChoiceChip(
                    label: Text(_repeatToString(rep)),
                    selected: repeat == rep,
                    selectedColor: AppColors.secondary,
                    disabledColor: AppColors.background,
                    labelStyle: TextStyle(
                      color: repeat == rep ? Colors.white : AppColors.secondary,
                    ),
                    onSelected: (_) => setState(() => repeat = rep),
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
                      : '', // mostra la data formattata se presente
                ),
                decoration: const InputDecoration(
                  labelText: 'End Date (optional)',
                  hintText: 'Select a date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  // Mostra il calendario quando l’utente clicca sul campo
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? DateTime.now(),
                    firstDate: DateTime.now(), // non permettere date passate
                    lastDate: DateTime.now().add(
                      const Duration(days: 365 * 3),
                    ), // 3 anni avanti
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
                  labelText: 'Additional Notes (optional)',
                ),
                onSaved: (val) => notes = val,
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
                      dosage: dosage,
                      instructions: instructions,
                      repeat: repeat,
                      reminderTimes: reminderTimes,
                      endDate: endDate,
                      notes: notes,
                    );
                    widget.medicineDatabase.addMedicine(med);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Save Medication',
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
      return "Daily";
    case Repeat.twicePerDay:
      return "Every 12h";
    case Repeat.thricePerDay:
      return "Every 8h";
    case Repeat.onceEveryTwoDays:
      return "Every 2 Days";
    case Repeat.oncePerWeek:
      return "Weekly";
  }
}
