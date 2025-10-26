import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  Future<void> _resetPrefs(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('SharedPreferences resettate con successo!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
  }
   @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (newContext) {
        return ElevatedButton.icon(
          icon: const Icon(Icons.restart_alt, color: Colors.white),
          label: const Text(
            'Reset SharedPreferences!',
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _resetPrefs(newContext),
        );
      },
    );
  }
}
