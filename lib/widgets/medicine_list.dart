import 'package:flutter/material.dart';
import '../models/medicine.dart';
import 'medicine_card.dart';

class MedicineList extends StatelessWidget {
  final List<Medicine> medicines;
  final Future<void> Function(int index) onDelete;
  const MedicineList({super.key, required this.medicines, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (medicines.isEmpty) {
      return const Center(child: Text('Nessun farmaco inserito.'));
    }
    return ListView.builder(
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        final med = medicines[index];
        return MedicineCard(
          medicine: med,
          index: index,
          onDelete: () => onDelete(index),
        );
      },
    );
  }
}