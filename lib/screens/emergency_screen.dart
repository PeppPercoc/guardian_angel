import 'package:flutter/material.dart';
import 'package:guardian_angel/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  // Variabili per le info recuperate
  String? name;
  String? dob;
  String? bloodType;
  String? allergies;
  String? conditions;
  String? contactName;
  String? contactPhone;
  String? medications;
  String? notes;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('userName') ?? '---';
      dob = prefs.getString('userDOB') ?? '---';
      bloodType = prefs.getString('userBloodType') ?? '---';
      allergies = prefs.getString('userAllergies') ?? '---';
      conditions = prefs.getString('userConditions') ?? '---';
      contactName = prefs.getString('userContactName') ?? '---';
      contactPhone = prefs.getString('userContactPhone') ?? '---';
      medications = prefs.getString('userMedications') ?? '---';
      notes = prefs.getString('userNotes') ?? '---';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('EMERGENCY ACTIVE', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        centerTitle: true,
        toolbarHeight: 56,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow(icon: Icons.person, label: 'Full Name', value: name ?? ''),
                    _infoRow(icon: Icons.calendar_month, label: 'Date of Birth', value: dob ?? '', valueStyle: TextStyle(color: Colors.green)),
                    _infoRow(icon: Icons.bloodtype, label: 'Blood Type', value: bloodType ?? '', valueStyle: TextStyle(color: Colors.red)),
                    _infoRow(icon: Icons.warning, label: 'Allergies', value: allergies ?? '', valueStyle: TextStyle(color: Colors.red)),
                    _infoRow(icon: Icons.medical_services, label: 'Medical Conditions', value: conditions ?? ''),
                    _infoRow(icon: Icons.call, label: 'Emergency Contact', value: '${contactName ?? ''} – ${contactPhone ?? ''}', valueStyle: TextStyle(color: Colors.green)),
                    _infoRow(icon: Icons.medication, label: 'Medications', value: medications ?? ''),
                    _infoRow(icon: Icons.info, label: 'Additional Notes', value: notes ?? ''),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Botttone finto (non chiama nessuno)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Call Emergency Contact', style: TextStyle(fontSize: 18,color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('End Emergency', style: TextStyle(fontSize: 18,color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
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
                Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[600], fontWeight: FontWeight.bold)),
                Text(value, style: valueStyle.merge(TextStyle(fontSize: 17, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
