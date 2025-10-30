import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/theme.dart';

class GenericAlert extends StatelessWidget {
  final String title;
  final String content;

  const GenericAlert({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('No', style: TextStyle(color: AppColors.secondary)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
          child: Text('Sì', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
