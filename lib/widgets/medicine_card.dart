import 'package:flutter/material.dart';
import '../models/medicine.dart';
import 'package:guardian_angel/styles/theme.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final int index;
  final VoidCallback onDelete;
  const MedicineCard({super.key, required this.medicine, required this.index, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10),
              child: Icon((Icons.medical_services_outlined), color: AppColors.secondary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ('${medicine.dosage} - ${medicine.instructions}'),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  Text(
                    ('Orari: ${medicine.reminderTimes.join(', ')}'),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  Text(
                    (medicine.endDate != null
                ? '${medicine.endDate?.day}/${medicine.endDate?.month}/${medicine.endDate?.year}'
                : 'Nessuna data di fine'),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  Text(
                    (medicine.notes != null ? '${medicine.notes}' : '---'),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.green.shade700,
              ),
              onPressed: onDelete,
            ),
            /*
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
      */
          ]
        ),
      ),
    );
  }
}
