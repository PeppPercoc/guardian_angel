import 'package:flutter/material.dart';
import 'package:guardian_angel/services/shared_prefs_service.dart';
import 'package:guardian_angel/styles/theme.dart';
import '../services/medicine_database_service.dart';
import '../widgets/info_card.dart';
import '../services/location_service.dart';
import '../services/gemini_service.dart';

class HomeScreen extends StatelessWidget {
  final MedicineDatabase? medicineDatabase;
  final GeminiService geminiService;
  late final Future<String?> _geminiFuture;
  final SharedPrefsService? sharedPrefsService;
  final locationService = LocationService.instance;

  HomeScreen({
    super.key,
    this.medicineDatabase,
    required this.geminiService, required this.sharedPrefsService,
  }) {
    _geminiFuture = geminiService.askGemini(
      'Dammi una breve frase motivazionale per incoraggiare qualcuno a prendersi cura della propria salute. Vorrei come risposta solo la stringa senza ulteriori spiegazioni, emoticon o altro.',
    );
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
    return await locationService.getCurrentPositionString();
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.black54,
                ),
                const SizedBox(width: 6),
                Text(
                  _formattedDate(),
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.black54),
                const SizedBox(width: 6),
                Expanded(
                  child: FutureBuilder<String?>(
                    future: _getPosition(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Caricamento posizione...',
                            style: TextStyle(color: Colors.black54));
                      }
                      if (snapshot.hasError) {
                        return const Text('Errore posizione',
                            style: TextStyle(color: Colors.black54));
                      }
                      final posText = snapshot.data ?? 'Posizione non disponibile';
                      return Text(
                        posText,
                        style: const TextStyle(color: Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lista di card (scrollabile)
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
