import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_screen.dart';

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
      theme: appTheme,
      initialRoute: showIntro ? '/welcome' : '/main',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
