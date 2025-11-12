import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/app_colors.dart';
import '../models/medicine.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final int index;
  final VoidCallback onDelete;
  final Color primaryColor;
  final Color backgroundColor;
  const MedicineCard(
      {super.key,
      required this.medicine,
      required this.index,
      required this.onDelete,
      required this.primaryColor,
      required this.backgroundColor});

  String _displayTimeFromIso(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }

  String _displayTimes() {
    // nessun controllo perchè non può inserire farmaci senza orari
    return medicine.reminderTimes.map(_displayTimeFromIso).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon((Icons.medical_services_outlined),
                color: primaryColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                if (medicine.medicineInstructions.isEmpty)
                  Text(
                    medicine.dosageInstructions,
                    style:
                        const TextStyle(fontSize: 14, color: AppColors.black),
                  )
                else
                  Text(
                    '${medicine.dosageInstructions} - ${medicine.medicineInstructions}',
                    style:
                        const TextStyle(fontSize: 14, color: AppColors.black),
                  ),
                Text(
                  ('Orari: ${_displayTimes()}'),
                  style: const TextStyle(fontSize: 14, color: AppColors.black),
                ),
                Text(
                  (medicine.endDate != null
                      ? '${medicine.endDate?.day}/${medicine.endDate?.month}/${medicine.endDate?.year}'
                      : 'Nessuna data di fine'),
                  style: const TextStyle(fontSize: 14, color: AppColors.black),
                ),
                Text(
                  (medicine.additionalNotes != null
                      ? '${medicine.additionalNotes}'
                      : '---'),
                  style: const TextStyle(fontSize: 14, color: AppColors.black),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: primaryColor,
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
        ]),
      ),
    );
  }
}
