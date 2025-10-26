import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/theme.dart';
import '../services/medicine_database_service.dart';
import '../widgets/info_card.dart';

class HomeScreen extends StatelessWidget {
  final MedicineDatabase? medicineDatabase;
  const HomeScreen({super.key, this.medicineDatabase});


  String _formattedDate() {
    final now = DateTime.now();
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[now.month]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header info: titolo, data e posizione
            Text(
              'Daily Health Overview',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                const SizedBox(width: 6),
                Text(
                  _formattedDate(),
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: const [
                Icon(Icons.location_on, size: 16, color: Colors.black54),
                SizedBox(width: 6),
                Text(
                  'posizione attuale',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 16),
    
            // Lista di card (scrollabile)
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  InfoCard(
                    icon: Icons.wb_sunny,
                    title: 'prova titolo',
                    subtitle: 'prova sottotitolo',
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}