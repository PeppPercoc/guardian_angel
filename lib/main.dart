import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_screen.dart';

// Esempio di classe colori riutilizzabile
class AppColors {
  static const primary = Color(0xFFB71C1C);  // rosso scuro
  static const secondary = Color(0xFF388E3C); // verde
  static const background = Color(0xFFD0EEC8); // verde chiaro sfondo
  static const textDark = Color(0xFF263238);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GuardianAngelRoot());
  
}

class GuardianAngelRoot extends StatefulWidget {
  const GuardianAngelRoot({super.key});

  @override
  State<GuardianAngelRoot> createState() => _GuardianAngelRootState();
}

class _GuardianAngelRootState extends State<GuardianAngelRoot> {
  bool? showIntro; // null = loading, true/false = decisione

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final introSeen = prefs.getBool('introSeen') ?? false;
    setState(() {
      showIntro = !introSeen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showIntro == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return GuardianAngelApp(showIntro: showIntro!);
  }
}

class GuardianAngelApp extends StatelessWidget {
  final bool showIntro;
  const GuardianAngelApp({super.key, required this.showIntro});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardian Angel',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: AppColors.textDark),
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          labelLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.secondary,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: Colors.grey,
          backgroundColor: Color(0xFFF7F7F7),
        ),
      ),
      initialRoute: showIntro ? '/welcome' : '/main',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
