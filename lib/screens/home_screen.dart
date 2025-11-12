import 'package:flutter/material.dart';
import 'package:guardian_angel/models/blood_type.dart';
import 'package:guardian_angel/services/shared_prefs_service.dart';
import 'package:guardian_angel/styles/app_colors.dart';
import '../models/user.dart';
import '../styles/theme.dart';
import '../services/medicine_database_service.dart';
import '../widgets/info_card.dart';
import '../services/location_service.dart';
import '../services/gemini_service.dart';
import 'package:guardian_angel/widgets/loading_screen.dart';

class HomeScreen extends StatefulWidget {
  final MedicineDatabase? medicineDatabase;
  final GeminiService geminiService;
  final SharedPrefsService? sharedPrefsService;
  final LocationService locationService;

  const HomeScreen({
    super.key,
    this.medicineDatabase,
    required this.geminiService,
    required this.sharedPrefsService,
    required this.locationService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<String?> _geminiFuture = Future.value(null);
  late final LocationService _locationService;
  User? _user;

  @override
  void initState() {
    super.initState();
    _locationService = widget.locationService;
    _loadUserInfo().then((_) => _requestGemini());
  }

  Future<void> _requestGemini() async {
    final prompt = '''
è stato chiesto ad un utente alcune informazioni personali per fornire consigli sanitari personalizzati. Ecco i dati raccolti:
- Data di nascita: ${_user?.dateOfBirth}
- Nome: ${_user?.name}
- Stato di salute: ${_user?.medicalConditions}
- Allergie: ${_user?.allergens}

In base a questi dati, dammi un consiglio sulla salute giornaliera utile in massimo 20 parole.
Fornisci il consiglio in italiano e dammi in output solo il testo del consiglio, senza ulteriori spiegazioni o introduzioni.
Se pensi che l'utente ha fornito informazioni volgari o non appropriate, rispondi con un consiglio motivazionale senza
inserire nella risposta i dati dell'utente.
''';
    setState(() {
      _geminiFuture = widget.geminiService.askGemini(prompt);
    });
  }

  Future<void> _loadUserInfo() async {
    final userJson = await widget.sharedPrefsService?.getString('user_data');

    if (userJson != null) {
      setState(() {
        _user = User.decode(userJson);
      });
    } else {
      setState(() {
        _user = User(
          name: '---',
          lastName: '---',
          dateOfBirth: DateTime(1900, 1, 1),
          bloodType: BloodType.oPositive,
          allergens: '---',
          medicalConditions: '---',
          emergencyContactName: '---',
          emergencyContactPhone: '---',
          additionalNotes: '---',
        );
      });
    }
  }

  String _formattedDate() {
    final now = DateTime.now();
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[now.month]} ${now.day}, ${now.year}';
  }

  Future<String?> _getPosition() async {
    return await _locationService.getCurrentPositionString();
  }

  @override
  Widget build(BuildContext context) {
    // Mostra loading screen finché non carica l'utente
    if (_user == null) {
      return const LoadingScreen();
    }

    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Health Overview',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.black,
                ),
                const SizedBox(width: 6),
                Text(
                  _formattedDate(),
                  style: const TextStyle(color: AppColors.black),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.black),
                const SizedBox(width: 6),
                Expanded(
                  child: FutureBuilder<String?>(
                    future: _getPosition(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'Caricamento posizione...',
                          style: TextStyle(color: AppColors.black),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text(
                          'Posizione non disponibile',
                          style: TextStyle(color: AppColors.black),
                        );
                      }
                      final posText =
                          snapshot.data ?? 'Posizione non disponibile';
                      return Text(
                        posText,
                        style: const TextStyle(color: AppColors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lista di card
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  InfoCard(
                    icon: Icons.wb_sunny,
                    title: 'prova titolo',
                    subtitle: 'prova sottotitolo',
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<String?>(
                    future: _geminiFuture,
                    builder: (context, snapshot) {
                      // non mostrare la card se è ancora in caricamento, c'è un errore o la risposta è vuota
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const SizedBox.shrink();
                      }
                      if (snapshot.hasError) {
                        return const SizedBox.shrink();
                      }
                      final advice = snapshot.data;
                      if (advice == null || advice.trim().isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return InfoCard(
                        icon: Icons.smart_toy,
                        title: "consiglio dell'IA",
                        subtitle: advice,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
