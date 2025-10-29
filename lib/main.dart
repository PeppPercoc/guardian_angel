import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/theme.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const GuardianAngelApp());
}

class GuardianAngelApp extends StatelessWidget {
  const GuardianAngelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardian Angel',
      theme: appTheme,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
