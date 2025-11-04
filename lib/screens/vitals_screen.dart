import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guardian_angel/styles/app_colors.dart';

class VitalsScreen extends StatelessWidget {
  const VitalsScreen({super.key});

  Future<void> _resetPrefs(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('SharedPreferences resettate con successo!'),
        backgroundColor: AppColors.green,
      ),
    );
    Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (newContext) {
        return ElevatedButton.icon(
          icon: const Icon(Icons.restart_alt, color: AppColors.white),
          label: const Text(
            'Reset SharedPreferences',
            style: TextStyle(color: AppColors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.redAccent,
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
