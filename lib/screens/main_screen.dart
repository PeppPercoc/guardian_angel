import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:guardian_angel/main.dart';
import 'home_screen.dart';
import 'scheduler_screen.dart';
import 'vitals_screen.dart';
import 'emergency_screen.dart';

void main() {
  runApp(const GuardianAngelApp());
}

class GuardianAngelApp extends StatelessWidget {
  const GuardianAngelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardian Angel',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  static final List<Widget> _pages = <Widget>[
    SchedulerScreen(),
    HomeScreen(),
    VitalsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calcola un padding orizzontale dinamico, magari 5% della larghezza per lato
    double horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EmergencyScreen(),
                ),
              );
            },
            child: Container(
              color: Colors.red,
              height: 56,
              width: double.infinity,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_rounded, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'SOS EMERGENCY',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
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
              GButton(icon: Icons.favorite, text: 'Vitals'),
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
