import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  bool _initialized = false;

  // Singleton
  static final GeminiService _instance = GeminiService._internal();
  GeminiService._internal();
  factory GeminiService() => _instance;

  Future<void> init() async {
    if (_initialized) return;
    // legge la chiave dal .env (caricato in main.dart)
    final apiKey = dotenv.env['GEMINI_API_KEY']?.trim();
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY non trovata nel .env. Aggiungi GEMINI_API_KEY=la_tua_chiave nel file .env');
    }
    Gemini.init(apiKey: apiKey, enableDebugging: true);
    _initialized = true;
  }

  Future<String?> askGemini(String prompt) async {
    try {
      final response = await Gemini.instance.prompt(parts: [Part.text(prompt)]);
      return response?.output;
    } catch (e) {
      return null;
    }
  }
}
