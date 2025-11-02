import 'package:flutter/material.dart';
import 'package:guardian_angel/models/blood_type.dart';
import 'package:guardian_angel/models/user.dart';
import 'package:guardian_angel/services/shared_prefs_service.dart';
import 'package:guardian_angel/styles/theme.dart';
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
  late TextEditingController _surnameController;
  late TextEditingController _dobController;
  DateTime? _dob;
  BloodType _bloodType = BloodType.oPositive;
  late TextEditingController _allergiesController;
  late TextEditingController _conditionsController;
  late TextEditingController _contactNameController;
  late TextEditingController _contactPhoneController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _dobController = TextEditingController();
    _allergiesController = TextEditingController();
    _conditionsController = TextEditingController();
    _contactNameController = TextEditingController();
    _contactPhoneController = TextEditingController();
    _notesController = TextEditingController();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      await widget.sharedPrefsService.init();
      final json = await widget.sharedPrefsService.getString('user_data');
      if (json != null) {
        final user = User.decode(json);
        _nameController.text = user.name;
        _surnameController.text = user.surname;
        _dob = user.dob;
        if (_dob != null) {
          _dobController.text =
              '${_dob!.day.toString().padLeft(2, '0')}/'
              '${_dob!.month.toString().padLeft(2, '0')}/'
              '${_dob!.year}';
        }
        _bloodType = user.bloodType;
        _allergiesController.text = user.allergies;
        _conditionsController.text = user.conditions;
        _contactNameController.text = user.contactName;
        _contactPhoneController.text = user.contactPhone;
        _notesController.text = user.notes;
      }
    } catch (e) {
      debugPrint('Errore caricamento user: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }


  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = User(
      name: _nameController.text.trim(),
      surname: _surnameController.text.trim(),
      dob: _dob ?? DateTime(1990, 1, 1),
      bloodType: _bloodType,
      allergies: _allergiesController.text.trim(),
      conditions: _conditionsController.text.trim(),
      contactName: _contactNameController.text.trim(),
      contactPhone: _contactPhoneController.text.trim(),
      notes: _notesController.text.trim(),
    );

    try {
      await widget.sharedPrefsService.setString('user_data', user.encode());
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profilo aggiornato')));
      Navigator.of(context).pop(true);
    } catch (e) {
      debugPrint('Errore salvataggio user: $e');
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
    _surnameController.dispose();
    _dobController.dispose();
    _allergiesController.dispose();
    _conditionsController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    _notesController.dispose();
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
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Cognome'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Inserisci il cognome' : null,
            ),
            const SizedBox(height: 10),
           TextFormField(
              readOnly: true,
              controller: _dobController,
              decoration: const InputDecoration(
                labelText: 'Data di nascita',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              validator: (_) =>
                  _dob == null ? 'Inserisci la data di nascita' : null,
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _dob ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    _dob = pickedDate;
                    _dobController.text =
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
              controller: _allergiesController,
              decoration: const InputDecoration(labelText: 'Allergie'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Inserisci allergie' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _conditionsController,
              decoration: const InputDecoration(
                labelText: 'Condizioni mediche',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Inserisci condizioni' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
            TextFormField(
              controller: _contactNameController,
              decoration: const InputDecoration(
                labelText: 'Nome contatto di emergenza',
              ),
            ),
            const SizedBox(height: 10),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                _contactPhoneController.text = number.phoneNumber ?? '';
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
              ),
              initialValue: PhoneNumber(isoCode: 'IT', phoneNumber: _contactPhoneController.text),
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
              ),
              onPressed: _save,
              child: const Text('Salva', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
