import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/theme.dart';
import '../services/shared_prefs_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/user.dart';
import '../models/blood_type.dart';
import 'main_screen.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final SharedPrefsService sharedPrefsService;
  final PageController _controller = PageController();
  int _pageIndex = 0;

  // chiavi per la validazione dei form
  final _userFormKey = GlobalKey<FormState>();
  final _medicalFormKey = GlobalKey<FormState>();
  final _contactFormKey = GlobalKey<FormState>();

  // Controller dei campi
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  DateTime? _dateOfBirth;
  BloodType _selectedBloodType = BloodType.oPositive;
  final _allergensController = TextEditingController();
  final _medicalConditionsController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();
  final _additionalNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIntroSeen();
  }

  Future<void> _checkIntroSeen() async {
    sharedPrefsService = SharedPrefsService();
    await sharedPrefsService.init();
    final introSeen = await sharedPrefsService.getBool(
      'introSeen',
      defaultValue: false,
    );
    if (introSeen) {
      if (!mounted) return;
      // se l'intro è già visto, vai subito a MainScreen
      // messo qui perchè cosi non lo faccio nel main
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MainScreen(sharedPrefsService: sharedPrefsService),
        ),
      );
    }
  }

  Future<void> _saveAndContinue() async {
    await sharedPrefsService.init();
    final user = User(
      name: _nameController.text,
      lastName: _lastNameController.text,
      dateOfBirth: _dateOfBirth ?? DateTime(2000, 1, 1),
      bloodType: _selectedBloodType,
      allergens: _allergensController.text,
      medicalConditions: _medicalConditionsController.text,
      emergencyContactName: _emergencyContactNameController.text,
      emergencyContactPhone: _emergencyContactPhoneController.text,
      additionalNotes: _additionalNotesController.text,
    );
    await sharedPrefsService.setString('user_data', user.encode());
    await sharedPrefsService.setBool('introSeen', true);
    if (!mounted) return;
    // passo al main screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainScreen(sharedPrefsService: sharedPrefsService),
      ),
    );
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
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Cognome'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Inserisci il cognome' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              readOnly: true,
              controller: _dateOfBirthController,
              decoration: const InputDecoration(
                labelText: 'Data di nascita',
                hintText: 'Seleziona una data',
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
              controller: _allergensController,
              decoration: const InputDecoration(labelText: 'Allergie'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Inserisci allergie' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _medicalConditionsController,
              decoration: const InputDecoration(
                labelText: 'Condizioni mediche',
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Inserisci condizioni' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _additionalNotesController,
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
              controller: _emergencyContactNameController,
              decoration: const InputDecoration(
                labelText: 'Nome contatto emergenza',
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Inserisci nome contatto' : null,
            ),
            const SizedBox(height: 12),

            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                _emergencyContactPhoneController.text = number.phoneNumber ?? '';
              },
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
              ),
              initialValue: PhoneNumber(isoCode: 'IT'),
              inputDecoration: InputDecoration(
                labelText: 'Numero di telefono',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Inserisci un numero di telefono';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
