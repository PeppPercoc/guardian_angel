import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:guardian_angel/styles/theme.dart';
import 'package:guardian_angel/services/shared_prefs_service.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final sharedPrefsService = SharedPrefsService();
  await sharedPrefsService.init();
  final introSeen = await sharedPrefsService.getBool('introSeen', defaultValue: false);
  final initialRoute = introSeen ? '/main' : '/welcome';
  runApp(GuardianAngelApp(
    sharedPrefsService: sharedPrefsService,
    initialRoute: initialRoute,
  ));
}

class GuardianAngelApp extends StatelessWidget {
  final SharedPrefsService sharedPrefsService;
  final String initialRoute;
  
  const GuardianAngelApp({
    super.key,
    required this.sharedPrefsService,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardian Angel',
      theme: appTheme,
      initialRoute: initialRoute,
      routes: {
        '/welcome': (context) => WelcomeScreen(sharedPrefsService: sharedPrefsService),
        '/main': (context) => MainScreen(sharedPrefsService: sharedPrefsService),
      },
    );
  }
}
