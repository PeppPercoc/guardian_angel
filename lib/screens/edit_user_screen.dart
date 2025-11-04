import 'package:flutter/material.dart';
import 'package:guardian_angel/models/blood_type.dart';
import 'package:guardian_angel/models/user.dart';
import 'package:guardian_angel/services/shared_prefs_service.dart';
import 'package:guardian_angel/styles/theme.dart';
import 'package:guardian_angel/styles/app_colors.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

typedef OnSaveCallback = void Function(User user);

class EditUserScreen extends StatefulWidget {
  final SharedPrefsService sharedPrefsService;
  final OnSaveCallback onSave;
  const EditUserScreen({super.key, required this.sharedPrefsService, required this.onSave});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}
class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = true;

  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dateOfBirthController;
  DateTime? _dateOfBirth;
  BloodType _bloodType = BloodType.oPositive;
  late TextEditingController _allergensController;
  late TextEditingController _medicalConditionsController;
  late TextEditingController _emergencyContactNameController;
  late TextEditingController _emergencyContactPhoneController;
  late TextEditingController _additionalNotesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _allergensController = TextEditingController();
    _medicalConditionsController = TextEditingController();
    _emergencyContactNameController = TextEditingController();
    _emergencyContactPhoneController = TextEditingController();
    _additionalNotesController = TextEditingController();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      await widget.sharedPrefsService.init();
      final json = await widget.sharedPrefsService.getString('user_data');
      if (json != null) {
        final user = User.decode(json);
        _nameController.text = user.name;
        _lastNameController.text = user.lastName;
        _dateOfBirth = user.dateOfBirth;
        if (_dateOfBirth != null) {
          _dateOfBirthController.text =
              '${_dateOfBirth!.day.toString().padLeft(2, '0')}/'
              '${_dateOfBirth!.month.toString().padLeft(2, '0')}/'
              '${_dateOfBirth!.year}';
        }
        _bloodType = user.bloodType;
        _allergensController.text = user.allergens;
        _medicalConditionsController.text = user.medicalConditions;
        _emergencyContactNameController.text = user.emergencyContactName;
        _emergencyContactPhoneController.text = user.emergencyContactPhone;
        _additionalNotesController.text = user.additionalNotes;
      }
    } catch (e) {
      // Errore caricamento user
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = User(
      name: _nameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      dateOfBirth: _dateOfBirth ?? DateTime(1990, 1, 1),
      bloodType: _bloodType,
      allergens: _allergensController.text.trim(),
      medicalConditions: _medicalConditionsController.text.trim(),
      emergencyContactName: _emergencyContactNameController.text.trim(),
      emergencyContactPhone: _emergencyContactPhoneController.text.trim(),
      additionalNotes: _additionalNotesController.text.trim(),
    );

    try {
      await widget.sharedPrefsService.setString('user_data', user.encode());
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profilo aggiornato')));
      Navigator.of(context).pop(true);
    } catch (e) {
      // Errore salvataggio user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Errore salvataggio profilo')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _allergensController.dispose();
    _medicalConditionsController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 50, left: 16, right: 16, top: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Inserisci il nome' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Cognome'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Inserisci il cognome' : null,
            ),
            const SizedBox(height: 10),
           TextFormField(
              readOnly: true,
              controller: _dateOfBirthController,
              decoration: const InputDecoration(
                labelText: 'Data di nascita',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              validator: (_) =>
                  _dateOfBirth == null ? 'Inserisci la data di nascita' : null,
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _dateOfBirth ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    _dateOfBirth = pickedDate;
                    _dateOfBirthController.text =
                        '${pickedDate.day.toString().padLeft(2, '0')}/'
                        '${pickedDate.month.toString().padLeft(2, '0')}/'
                        '${pickedDate.year}';
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<BloodType>(
              initialValue: _bloodType,
              items: BloodType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(bloodTypeToString(type)),
                );
              }).toList(),
              onChanged: (val) => setState(
                () => _bloodType = val ?? BloodType.oPositive,
              ),
              decoration: const InputDecoration(labelText: 'Gruppo sanguigno'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _allergensController,
              decoration: const InputDecoration(labelText: 'Allergie'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Inserisci allergie' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _medicalConditionsController,
              decoration: const InputDecoration(
                labelText: 'Condizioni mediche',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Inserisci condizioni' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _additionalNotesController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
            TextFormField(
              controller: _emergencyContactNameController,
              decoration: const InputDecoration(
                labelText: 'Nome contatto di emergenza',
              ),
            ),
            const SizedBox(height: 10),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                _emergencyContactPhoneController.text = number.phoneNumber ?? '';
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
              ),
              initialValue: PhoneNumber(isoCode: 'IT', phoneNumber: _emergencyContactPhoneController.text),
              inputDecoration: InputDecoration(
                labelText: 'Numero di telefono',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Inserisci un numero di telefono';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
              ),
              onPressed: _save,
              child: const Text('Salva', style: TextStyle(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
