import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:guardian_angel/alerts/sos_alert.dart';
import 'package:guardian_angel/screens/emergency_screen.dart';
import 'package:guardian_angel/screens/settings_screen.dart';
import 'package:guardian_angel/styles/theme.dart';
import 'home_screen.dart';
import 'scheduler_screen.dart';
import '../services/medicine_database_service.dart';
import '../services/shared_prefs_service.dart';

class MainScreen extends StatefulWidget {
  final SharedPrefsService? sharedPrefsService;
  const MainScreen({super.key, this.sharedPrefsService});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MedicineDatabase medicineDatabase = MedicineDatabase();
  late final SharedPrefsService _prefsService;

  int _selectedIndex = 1;
  bool _isDBReady = false;

  @override
  void initState() {
    super.initState();
    _prefsService = widget.sharedPrefsService ?? SharedPrefsService();
    _initAll();
  }

  Future<void> _initAll() async {
      await medicineDatabase.init();
      await _prefsService.init();
      if (!mounted) return;
      setState(() {
        _isDBReady = true;
      });
  }

  List<Widget> get _pages => [
    SchedulerScreen(medicineDatabase: medicineDatabase),
    HomeScreen(medicineDatabase: medicineDatabase),
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
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencyScreen()));
          }
        }
      }
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
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
              setState(() {
                cancelled = false;
              });
              timer?.cancel();
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencyScreen()));
            },
          );
        });
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
          GestureDetector(
            onTap: () {
              showSOSDialog(context);
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Colors.red,
              ),
              child: SafeArea(
                bottom: false,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 14,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'SOS EMERGENCY',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.25 * 255).round()),
              blurRadius: 20,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 12,
          ),
          child: GNav(
            gap: 8,
            activeColor: AppColors.secondary,
            iconSize: 30,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding / 2,
              vertical: 12,
            ),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: AppColors.background,
            color: Colors.grey,
            tabs: const [
              GButton(icon: Icons.medication, text: 'Scheduler'),
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.settings, text: 'Settings'),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
