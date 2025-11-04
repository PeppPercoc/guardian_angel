import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guardian_angel/alerts/sos_alert.dart';
import 'package:guardian_angel/models/user.dart';
import 'package:guardian_angel/screens/emergency_screen.dart';
import 'package:guardian_angel/screens/settings_screen.dart';
import 'package:guardian_angel/services/sms_service.dart';
import 'package:guardian_angel/widgets/sos_emergency_button.dart';
import 'package:guardian_angel/widgets/app_navigation_bar.dart';
import 'home_screen.dart';
import 'scheduler_screen.dart';
import '../services/medicine_database_service.dart';
import '../services/shared_prefs_service.dart';
import '../services/gemini_service.dart';

class MainScreen extends StatefulWidget {
  final SharedPrefsService? sharedPrefsService;
  const MainScreen({super.key, this.sharedPrefsService});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MedicineDatabase medicineDatabase = MedicineDatabase();
  late final SharedPrefsService _prefsService;
  User? _user;
  final SmsService smsService = SmsService();
  final GeminiService geminiService = GeminiService();
  int _selectedIndex = 1;
  bool _isDBReady = false;

  @override
  void initState() {
    super.initState();
    _prefsService = widget.sharedPrefsService ?? SharedPrefsService();
    _initAll();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {

      final userJson = await _prefsService.getString('user_data');
      if (userJson != null) {
        setState(() {
          _user = User.decode(userJson);
        });
        return;
      }
    
  }
  Future<void> sendMessage() async {
    bool success = await smsService.sendSms(
      'Ciao, questo è un messaggio',
      _user?.emergencyContactPhone ?? '',
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('SMS inviato')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invio SMS fallito')));
    }
  }

  Future<void> _initAll() async {
    await medicineDatabase.init();
    await geminiService.init();
    await _prefsService.init();
    if (!mounted) return;
    setState(() {
      _isDBReady = true;
    });
  }

  List<Widget> get _pages => [
    SchedulerScreen(medicineDatabase: medicineDatabase),
    HomeScreen(
      medicineDatabase: medicineDatabase,
      geminiService: geminiService,
      sharedPrefsService: _prefsService,
    ),
    SettingsScreen(
      medicineDatabase: medicineDatabase,
      sharedPrefsService: _prefsService,
    ),
  ];

  Future<void> showSOSDialog(BuildContext context) async {
    int seconds = 10;
    bool cancelled = false;
    Timer? timer;
    late StateSetter dialogSetState;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!cancelled) {
        if (seconds > 0) {
          dialogSetState(() {
            seconds--;
          });
        } else {
          t.cancel();
          if (mounted) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const EmergencyScreen()));
          }
        }
      }
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            dialogSetState = setState;
            return SOSAlertDialog(
              seconds: seconds,
              onCancel: () {
                // aggiorna lo stato locale, ferma timer e chiudi dialog
                setState(() {
                  cancelled = true;
                });
                timer?.cancel();
                Navigator.of(context).pop();
              },
              onSend: () {
                sendMessage();
                setState(() {
                  cancelled = false;
                });
                timer?.cancel();
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EmergencyScreen()),
                );
              },
            );
          },
        );
      },
    );

    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDBReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    double screenWidth = MediaQuery.of(context).size.width;

    // 5% del lato
    double horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      body: Column(
        children: [
          SOSEmergencyButton(
            onPressed: () {
              showSOSDialog(context);
            },
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: AppNavigationBar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        horizontalPadding: horizontalPadding,
      ),
    );
  }
}
