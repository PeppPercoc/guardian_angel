import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/theme.dart';

class SOSAlertDialog extends StatelessWidget {
  final int seconds;
  final VoidCallback onCancel;
  final VoidCallback onSend;

  const SOSAlertDialog({
    super.key,
    required this.seconds,
    required this.onCancel,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.all(20),
      title: Row(
        children: const [
          Icon(Icons.warning_amber_rounded, color: AppColors.primary, size: 28),
          SizedBox(width: 12),
          Text(
            'Emergency Alert',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Un conto alla rovescia SOS è iniziato.\nI tuoi contatti di emergenza saranno avvisati tra',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '$seconds',
            style: const TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary,
            ),
          ),
          const Text('secondi a meno che tu non annulli.', style: TextStyle(fontSize: 16)),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.close),
                label: const Text('Annulla SOS'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onSend,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.send),
                label: const Text('Invia Ora'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}