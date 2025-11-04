import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guardian_angel/alerts/sos_alert.dart';
import 'package:guardian_angel/models/user.dart';
import 'package:guardian_angel/screens/emergency_screen.dart';
import 'package:guardian_angel/screens/settings_screen.dart';
import 'package:guardian_angel/services/sms_service.dart';
import 'package:guardian_angel/services/location_service.dart';
import 'package:guardian_angel/widgets/sos_emergency_button.dart';
import 'package:guardian_angel/widgets/app_navigation_bar.dart';
import 'home_screen.dart';
import 'scheduler_screen.dart';
import '../services/medicine_database_service.dart';
import '../services/shared_prefs_service.dart';
import '../services/gemini_service.dart';

class MainScreen extends StatefulWidget {
  final SharedPrefsService sharedPrefsService;
  const MainScreen({super.key, required this.sharedPrefsService});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MedicineDatabase medicineDatabase = MedicineDatabase();
  late final SharedPrefsService _prefsService;
  late final LocationService _locationService;
  User? _user;
  final SmsService smsService = SmsService();
  final GeminiService geminiService = GeminiService();
  int _selectedIndex = 1;
  bool _isDBReady = false;

  @override
  void initState() {
    super.initState();
    _prefsService = widget.sharedPrefsService;
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
    final positionLatLong = await _locationService.getCurrentPositionStringLatLong() ?? "Posizione non disponibile";
    final positionAddress = await _locationService.getCurrentPositionString() ?? "Indirizzo non disponibile";
    
    bool success = await smsService.sendSms('''
SOS! ${_user?.name} ${_user?.lastName} ha bisogno di aiuto.
La sua posizione: $positionLatLong
Indirizzo: $positionAddress
''',
      _user?.emergencyContactPhone ?? '',
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('SMS inviato')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invio SMS fallito')));
    }
  }

  Future<void> _initAll() async {
    await medicineDatabase.init();
    await geminiService.init();
    await _prefsService.init();
    _locationService = LocationService();
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
      locationService: _locationService,
    ),
    SettingsScreen(
      medicineDatabase: medicineDatabase,
      sharedPrefsService: _prefsService,
    ),
  ];

  Future<void> showSOSDialog(BuildContext context) async {
    int seconds = 10;
    bool cancelled = false;
    bool timeExpired = false;
    Timer? timer;
    late StateSetter dialogSetState;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!cancelled && !timeExpired) {
        if (seconds > 0) {
          dialogSetState(() {
            seconds--;
          });
        } else {
          // il tempo è scaduto, fermiamo il timer e chiudiamo il dialog
          timeExpired = true;
          t.cancel();
          if (mounted) {
            Navigator.of(context).pop();
            // dopo aver chiuso il dialog, mandiamo il messaggio e andiamo in emergency
            sendMessage();
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
                // annulla il SOS e ferma il timer
                cancelled = true;
                timer?.cancel();
                Navigator.of(context).pop();
              },
              onSend: () {
                // ferma il timer, chiude il dialog, manda il messaggio e va in emergency
                cancelled = true;
                timer?.cancel();
                Navigator.of(context).pop();
                sendMessage();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EmergencyScreen()),
                );
              },
            );
          },
        );
      },
    );
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
