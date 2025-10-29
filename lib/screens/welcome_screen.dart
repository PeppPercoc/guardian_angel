import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/theme.dart';
import '../services/shared_prefs_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/user.dart';
import '../models/blood_type.dart';
import 'main_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  // Chiavi dei form per pagine con form
  final _userFormKey = GlobalKey<FormState>();
  final _medicalFormKey = GlobalKey<FormState>();
  final _contactFormKey = GlobalKey<FormState>();

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

  @override
  void initState() {
    super.initState();
    _checkIntroSeen();
  }

  Future<void> _checkIntroSeen() async {
    final prefsService = SharedPrefsService();
    await prefsService.init();
    final introSeen = await prefsService.getBool('introSeen', defaultValue: false);
    if (introSeen) {
      if (!mounted) return;
      // se l'intro è già visto, vai subito a MainScreen passando l'istanza inizializzata
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MainScreen(sharedPrefsService: prefsService),
        ),
      );
    }
  }

  Future<void> _saveAndContinue() async {
    final prefsService = SharedPrefsService();
    await prefsService.init();
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
    await prefsService.setString('user_data', user.encode());
    await prefsService.setBool('introSeen', true);
    if (!mounted) return;
    // Pass the initialized SharedPrefsService instance to MainScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainScreen(sharedPrefsService: prefsService),
      ),
    );
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _pageIndex = index),
                children: [
                  _buildWelcomePage(),
                  _buildUserInfoPage(),
                  _buildMedicalInfoPage(),
                  _buildContactInfoPage(),
                ],
              ),
            ),
            if (_pageIndex > 0) ...[
              const SizedBox(height: 10),
              SmoothPageIndicator(
                controller: _controller,
                count: 4,
                effect: WormEffect(
                  activeDotColor: AppColors.secondary,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),
              const SizedBox(height: 10),
            ] else
              const SizedBox(height: 20),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          if (_pageIndex > 0)
            TextButton(
              onPressed: () => _controller.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
              ),
              child: const Text('Indietro'),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              if (_pageIndex == 0) {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              } else if (_pageIndex == 1 &&
                  _userFormKey.currentState!.validate()) {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              } else if (_pageIndex == 2 &&
                  _medicalFormKey.currentState!.validate()) {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              } else if (_pageIndex == 3 &&
                  _contactFormKey.currentState!.validate()) {
                await _saveAndContinue();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
            child: Text(_pageIndex == 3 ? 'Conferma' : 'Avanti'),
          ),
        ],
      ),
    );
  }

  // Pagina welcome iniziale
  Widget _buildWelcomePage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, color: AppColors.secondary, size: 80),
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

  // Pagina 1: Dati utente
  Widget _buildUserInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _userFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Informazioni personali',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Inserisci il nome' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Cognome'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Inserisci il cognome' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              readOnly: true,
              controller: _dobController,
              decoration: const InputDecoration(
                labelText: 'Data di nascita',
                hintText: 'Seleziona una data',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              validator: (_) =>
                  _dob == null ? 'Inserisci la data di nascita' : null,
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _dob ?? DateTime(2000, 1, 1),
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

            const SizedBox(height: 12),
            DropdownButtonFormField<BloodType>(
              initialValue: _selectedBloodType,
              items: BloodType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(bloodTypeToString(type)),
                );
              }).toList(),
              onChanged: (val) => setState(
                () => _selectedBloodType = val ?? BloodType.oPositive,
              ),
              decoration: const InputDecoration(labelText: 'Gruppo sanguigno'),
            ),
          ],
        ),
      ),
    );
  }

  // Pagina 2: Dati medici
  Widget _buildMedicalInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _medicalFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Informazioni mediche',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _allergiesController,
              decoration: const InputDecoration(labelText: 'Allergie'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Inserisci allergie' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _conditionsController,
              decoration: const InputDecoration(
                labelText: 'Condizioni mediche',
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Inserisci condizioni' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _medicationsController,
              decoration: const InputDecoration(labelText: 'Farmaci'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Note aggiuntive'),
            ),
          ],
        ),
      ),
    );
  }

  // Pagina 3: Contatto emergenza
  Widget _buildContactInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _contactFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Contatto di emergenza',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _contactNameController,
              decoration: const InputDecoration(
                labelText: 'Nome contatto emergenza',
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Inserisci nome contatto' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contactPhoneController,
              decoration: const InputDecoration(
                labelText: 'Telefono contatto emergenza',
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Inserisci telefono' : null,
            ),
          ],
        ),
      ),
    );
  }
}
