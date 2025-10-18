import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final seen = prefs.getBool('introSeen') ?? false;
  runApp(GuardianAngelApp(showIntro: !seen));
}

class GuardianAngelApp extends StatelessWidget {
  final bool showIntro;
  const GuardianAngelApp({super.key, required this.showIntro});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardian Angel',
      initialRoute: showIntro ? '/welcome' : '/main',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}