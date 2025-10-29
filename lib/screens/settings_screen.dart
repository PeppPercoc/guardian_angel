import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/theme.dart';
import '../services/medicine_database_service.dart';
import '../services/shared_prefs_service.dart';

class SettingsScreen extends StatefulWidget {

  final MedicineDatabase medicineDatabase;
  final SharedPrefsService sharedPrefsService;
  const SettingsScreen({super.key, required this.medicineDatabase, required this.sharedPrefsService});

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
    setState(() {
      _loading = false;
    });
  }

  Future<void> _clearMedicines() async {
    // usa l'API centralizzata del singleton
    await widget.medicineDatabase.clearAll();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Medicines cleared')),
    );
  }

  Future<void> _resetAll() async {
    await widget.sharedPrefsService.clear();
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
