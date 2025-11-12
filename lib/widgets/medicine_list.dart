import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/theme.dart';
import '../models/medicine.dart';
import 'medicine_card.dart';

class MedicineList extends StatelessWidget {
  final List<Medicine> medicines;
  final Future<void> Function(int index) onDelete;
  const MedicineList({
    super.key,
    required this.medicines,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (medicines.isEmpty) {
      return const Center(child: Text('Nessun farmaco inserito.'));
    }

    final yesterday = DateTime.now().add(Duration(days: -1));
    final active = medicines
        .where((m) => m.endDate == null || !(m.endDate!.isBefore(yesterday)))
        .toList();
    final expired = medicines
        .where((m) => m.endDate != null && m.endDate!.isBefore(yesterday))
        .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (active.isNotEmpty) ...[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                'Farmaci da prendere',
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: active.length,
              itemBuilder: (context, index) {
                final med = active[index];
                final originalIndex = medicines.indexOf(med);
                return MedicineCard(
                  medicine: med,
                  index: originalIndex,
                  primaryColor: AppColors.secondary,
                  backgroundColor: AppColors.backgroundSecondary,
                  onDelete: () => onDelete(originalIndex),
                );
              },
            ),
          ],
          if (expired.isNotEmpty) ...[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Text(
                'Farmaci da non dover prendere più',
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expired.length,
              itemBuilder: (context, index) {
                final med = expired[index];
                final originalIndex = medicines.indexOf(med);
                return MedicineCard(
                  medicine: med,
                  index: originalIndex,
                  primaryColor: AppColors.primary,
                  backgroundColor: AppColors.backgroundPrimary,
                  onDelete: () => onDelete(originalIndex),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
