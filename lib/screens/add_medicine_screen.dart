import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/theme.dart';
import '../models/medicine.dart';

typedef OnSaveCallback = void Function(Medicine medicine);

class AddMedicineForm extends StatefulWidget {
  final OnSaveCallback onSave;

  const AddMedicineForm({super.key, required this.onSave});

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

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        reminderTimes.add(picked.format(context));
      });
    }
  }

  void _saveMedicine() {
    if (_formKey.currentState!.validate()) {
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
      widget.onSave(med);
    }
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
              const SizedBox(height: 10),

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
                    labelStyle: TextStyle(color: repeat == rep ? Colors.white : AppColors.secondary,),
                    onSelected: (_) => setState(() => repeat = rep),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),

              // End Date
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'End Date (optional)',
                  hintText: 'YYYY-MM-DD',
                ),
                onSaved: (val) => endDate = val != null && val.isNotEmpty
                    ? DateTime.tryParse(val)
                    : null,
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
                onPressed: _saveMedicine,
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
