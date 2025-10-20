import 'package:flutter/material.dart';
import 'package:guardian_angel/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/blood_type.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  // Controller dei campi
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _dobController = TextEditingController();
  DateTime? _dob;
  BloodType _selectedBloodType = BloodType.oPositive;
  final _allergiesController = TextEditingController();
  final _conditionsController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _notesController = TextEditingController();

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _surnameController.text.isNotEmpty &&
        _dob != null &&
        _allergiesController.text.isNotEmpty &&
        _conditionsController.text.isNotEmpty &&
        _contactNameController.text.isNotEmpty &&
        _contactPhoneController.text.isNotEmpty;
  }

  Future<void> _saveAndContinue() async {
    final prefs = await SharedPreferences.getInstance();
    final user = User(
      name: _nameController.text,
      surname: _surnameController.text,
      dob: _dob ?? DateTime(2000, 1, 1),
      bloodType: _selectedBloodType,
      allergies: _allergiesController.text,
      conditions: _conditionsController.text,
      contactName: _contactNameController.text,
      contactPhone: _contactPhoneController.text,
      medications: _medicationsController.text,
      notes: _notesController.text,
    );
    await prefs.setString('user_data', user.encode());
    await prefs.setBool('introSeen', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed("/main");
  }

  Future<void> _pickDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  void _updateFormState() {
    setState(() {}); // trigger rebuild per abilitare/disabilitare il bottone
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateFormState);
    _surnameController.addListener(_updateFormState);
    _allergiesController.addListener(_updateFormState);
    _conditionsController.addListener(_updateFormState);
    _contactNameController.addListener(_updateFormState);
    _contactPhoneController.addListener(_updateFormState);
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
    _medicationsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) => setState(() => _pageIndex = index),
        children: [
          _buildWelcomePage(),
          _buildUserInfoPage(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 18.0, left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_pageIndex > 0)
              TextButton(
                onPressed: () => _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease),
                child: const Text('Indietro'),
              ),
            const Spacer(),
            (_pageIndex == 0)
                ? ElevatedButton(
                    onPressed: () => _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease),
                    child: const Text('Avanti'),
                  )
                : ElevatedButton(
                    onPressed: _isFormValid ? _saveAndContinue : null,
                    child: const Text('Salva e inizia'),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, color: AppColors.primary, size: 80),
            const SizedBox(height: 28),
            const Text(
              'Benvenuto in Guardian Angel!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            const Text(
              'Prima di iniziare, inserisci alcune informazioni utili per la tua sicurezza.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('I tuoi dati:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome')),
          const SizedBox(height: 12),
          TextField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Cognome')),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _pickDOB,
            child: AbsorbPointer(
              child: TextField(
                controller: _dobController,
                readOnly: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_month),
                  labelText: 'Data di nascita',
                  hintText: 'Seleziona data',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<BloodType>(
            value: _selectedBloodType,
            items: BloodType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(bloodTypeToString(type)),
              );
            }).toList(),
            onChanged: (val) => setState(() => _selectedBloodType = val ?? BloodType.oPositive),
            decoration: const InputDecoration(labelText: 'Gruppo sanguigno'),
          ),
          const SizedBox(height: 12),
          TextField(
              controller: _allergiesController,
              decoration: const InputDecoration(labelText: 'Allergie')),
          const SizedBox(height: 12),
          TextField(
              controller: _conditionsController,
              decoration: const InputDecoration(labelText: 'Condizioni mediche')),
          const SizedBox(height: 12),
          TextField(
              controller: _medicationsController,
              decoration: const InputDecoration(labelText: 'Farmaci')),
          const SizedBox(height: 12),
          TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Note aggiuntive')),
          const SizedBox(height: 12),
          TextField(
              controller: _contactNameController,
              decoration: const InputDecoration(labelText: 'Contatto emergenza')),
          const SizedBox(height: 12),
          TextField(
              controller: _contactPhoneController,
              decoration: const InputDecoration(labelText: 'Telefono emergenza')),
        ],
      ),
    );
  }
}
