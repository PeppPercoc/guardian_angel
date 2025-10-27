import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:guardian_angel/styles/theme.dart';
import '../services/medicine_database_service.dart';
import '../models/medicine.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = false;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _clearMedicines() async {
    // ensure DB initialized
    await MedicineDatabase().init();
    if (Hive.isBoxOpen(MedicineDatabase.boxName)) {
      await Hive.box<Medicine>(MedicineDatabase.boxName).clear();
    } else {
      await Hive.openBox<Medicine>(MedicineDatabase.boxName);
      await Hive.box<Medicine>(MedicineDatabase.boxName).clear();
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Medicines cleared')),
    );
  }

  Future<void> _resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _clearMedicines();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('App reset effettuato')),
    );
    // go back to welcome flow
    Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('User Profile'),
              trailing: TextButton(onPressed: () {}, child: const Text('Edit')),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
              title: const Text('Clear medicines'),
              subtitle: const Text('Rimuovi tutte le medicine salvate'),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Conferma'),
                    content: const Text('Vuoi cancellare tutte le medicine?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(context).pop(false),child: const Text('No', style: TextStyle(color: AppColors.secondary),)),
                      ElevatedButton(onPressed: () => Navigator.of(context).pop(true),style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary), child: const Text('Sì', style: TextStyle(color: Colors.white),)),
                    ],
                  ),
                );
                if (confirm == true) await _clearMedicines();
              },
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt, color: Colors.orange),
              title: const Text('Reset app'),
              subtitle: const Text('Cancella tutti dati locali'),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset app'),
                    content: const Text('Sei sicuro di voler resettare l\'app? Questa operazione è irreversibile.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('No', style: TextStyle(color: AppColors.secondary),)),
                      ElevatedButton(onPressed: () => Navigator.of(context).pop(true), style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary), child: const Text('Sì', style: TextStyle(color: Colors.white),)),
                    ],
                  ),
                );
                if (confirm == true) await _resetAll();
              },
            ),
          ],
        ),
      ),
    );
  }
}
