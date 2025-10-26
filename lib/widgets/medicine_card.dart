import 'package:flutter/material.dart';
import '../models/medicine.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final int index;
  final VoidCallback onDelete;
  const MedicineCard({super.key, required this.medicine, required this.index, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(medicine.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${medicine.dosage} - ${medicine.instructions}'),
            Text('Orari: ${medicine.reminderTimes.join(', ')}'),
            Text(medicine.endDate != null
                ? '${medicine.endDate?.day}/${medicine.endDate?.month}/${medicine.endDate?.year}'
                : '---'),
            Text(medicine.notes != null ? '${medicine.notes}' : '---'),
          ],
        ),
        leading: const Icon(Icons.medical_services_outlined),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.green.shade700,
          ),
          onPressed: onDelete,
        ),
        onTap: () {
          // schermata dettaglio (se serve, passa medicine/index)
        },
      ),
    );
  }
}
