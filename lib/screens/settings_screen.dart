import 'package:flutter/material.dart';
import 'package:guardian_angel/alerts/generic_alert.dart';
import 'package:guardian_angel/styles/theme.dart';
import '../services/medicine_database_service.dart';
import '../services/shared_prefs_service.dart';

class SettingsScreen extends StatefulWidget {
  final MedicineDatabase medicineDatabase;
  final SharedPrefsService sharedPrefsService;
  const SettingsScreen({
    super.key,
    required this.medicineDatabase,
    required this.sharedPrefsService,
  });

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
      const SnackBar(content: Text('Tutte le medicine sono state cancellate')),
    );
  }

  Future<void> _resetAll() async {
    await widget.sharedPrefsService.clear();
    await _clearMedicines();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('App reset effettuato')));
    // torna a WelcomeScreen
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
            Text(
              'Settings',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Profilo Utente'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Modifica'),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_forever,
                color: Colors.redAccent,
              ),
              title: const Text('Cancella medicine'),
              subtitle: const Text('Rimuovi tutte le medicine salvate'),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => GenericAlert(
                    title: 'Cancella tutte le medicine',
                    content:
                        'Sei sicuro di voler cancellare tutte le medicine? Questa operazione è irreversibile.',
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
                  builder: (context) => GenericAlert(
                    title: 'Reset app',
                    content:
                        'Sei sicuro di voler resettare l\'app? Questa operazione è irreversibile.',
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
