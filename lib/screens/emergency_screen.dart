import 'package:flutter/material.dart';
import 'package:guardian_angel/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/blood_type.dart';

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
          medications: '---',
          notes: '---',
        );
      });
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(
                        icon: Icons.person,
                        label: 'Full Name',
                        value: _user?.name ?? '---',
                      ),
                      _infoRow(
                        icon: Icons.calendar_month,
                        label: 'Date of Birth',
                        value: _user != null
                            ? '${_user!.dob.day}/${_user!.dob.month}/${_user!.dob.year}'
                            : '---',
                        valueStyle: const TextStyle(color: Colors.green),
                      ),
                      _infoRow(
                        icon: Icons.bloodtype,
                        label: 'Blood Type',
                        value: _user != null
                            ? bloodTypeToString(_user!.bloodType)
                            : '---',
                        valueStyle: const TextStyle(color: Colors.red),
                      ),
                      _infoRow(
                        icon: Icons.warning,
                        label: 'Allergies',
                        value: _user?.allergies ?? '---',
                        valueStyle: const TextStyle(color: Colors.red),
                      ),
                      _infoRow(
                        icon: Icons.medical_services,
                        label: 'Medical Conditions',
                        value: _user?.conditions ?? '---',
                      ),
                      _infoRow(
                        icon: Icons.call,
                        label: 'Emergency Contact',
                        value:
                            '${_user?.contactName ?? '---'} – ${_user?.contactPhone ?? '---'}',
                        valueStyle: const TextStyle(color: Colors.green),
                      ),
                      _infoRow(
                        icon: Icons.medication,
                        label: 'Medications',
                        value: _user?.medications ?? '---',
                      ),
                      _infoRow(
                        icon: Icons.info,
                        label: 'Additional Notes',
                        value: _user?.notes ?? '---',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Azione chiamata emergenza da implementare
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Call Emergency Contact',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'End Emergency',
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

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    TextStyle valueStyle = const TextStyle(),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[800]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: valueStyle.merge(
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
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
