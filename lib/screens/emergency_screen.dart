import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:guardian_angel/styles/theme.dart';
import 'package:guardian_angel/widgets/info_row.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/blood_type.dart';
import 'package:screen_brightness/screen_brightness.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    setMaxBrightness();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');

    if (userJson != null) {
      setState(() {
        _user = User.decode(userJson);
      });
    } else {
      setState(() {
        _user = User(
          name: '---',
          surname: '---',
          dob: DateTime(1900, 1, 1),
          bloodType: BloodType.oPositive,
          allergies: '---',
          conditions: '---',
          contactName: '---',
          contactPhone: '---',
          notes: '---',
        );
      });
    }
  }

  _callNumber() async {
    final number = _user?.contactPhone;
    await FlutterPhoneDirectCaller.callNumber(number!);
  }

  Future<void> setMaxBrightness() async {
    try {
      await ScreenBrightness().setApplicationScreenBrightness(1.0);
    } catch (e) {
      print('Errore impostando la luminosità: $e');
    }
  }

  Future<void> _resetBrightness() async {
    try {
      await ScreenBrightness().resetApplicationScreenBrightness();
    } catch (e) {
      print('Errore nel resettare luminosità: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'EMERGENCY ACTIVE',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        toolbarHeight: 56,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 22,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoRow(
                        icon: Icons.person,
                        label: 'Nome Completo',
                        value: _user != null
                            ? '${_user!.name} ${_user!.surname}'
                            : '---',
                      ),
                      InfoRow(
                        icon: Icons.calendar_month,
                        label: 'Data di nascita',
                        value: _user != null
                            ? '${_user!.dob.day}/${_user!.dob.month}/${_user!.dob.year}'
                            : '---',
                        valueStyle: const TextStyle(color: Colors.green),
                      ),
                      InfoRow(
                        icon: Icons.bloodtype,
                        label: 'Gruppo Sanguineo',
                        value: _user != null
                            ? bloodTypeToString(_user!.bloodType)
                            : '---',
                        valueStyle: const TextStyle(color: Colors.red),
                      ),
                      InfoRow(
                        icon: Icons.warning,
                        label: 'Allergie',
                        value: _user?.allergies ?? '---',
                        valueStyle: const TextStyle(color: Colors.red),
                      ),
                      InfoRow(
                        icon: Icons.medical_services,
                        label: 'Condizioni Mediche',
                        value: _user?.conditions ?? '---',
                      ),
                      InfoRow(
                        icon: Icons.call,
                        label: 'Contatto di Emergenza',
                        value:
                            '${_user?.contactName ?? '---'} – ${_user?.contactPhone ?? '---'}',
                        valueStyle: const TextStyle(color: Colors.green),
                      ),
                      InfoRow(
                        icon: Icons.info,
                        label: 'Note Aggiuntive',
                        value: _user?.notes ?? '---',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 20,
              top: 6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _callNumber,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Chiama Contatto di Emergenza',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () async {
                    await _resetBrightness();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Termina Emergenza',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
