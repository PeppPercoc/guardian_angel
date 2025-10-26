import 'package:flutter/material.dart';
import 'package:guardian_angel/services/medicine_database_service.dart';
import 'package:guardian_angel/styles/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/medicine.dart';
import 'add_medicine_screen.dart';

class SchedulerScreen extends StatefulWidget {
  final MedicineDatabase medicineDatabase;
  const SchedulerScreen({super.key, required this.medicineDatabase});

  @override
  State<SchedulerScreen> createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.medicineDatabase.listenable,
      builder: (context, Box<Medicine> box, _) {
        final medicines = widget.medicineDatabase.getAllMedicines();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Medicine Scheduler',
              style: TextStyle(color: AppColors.secondary),
            ),
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false,
          ),
          body: medicines.isEmpty
              ? const Center(child: Text('No medicines added yet'))
              : ListView.builder(
                  itemCount: medicines.length,
                  itemBuilder: (context, index) {
                    final med = medicines[index];
                    return Card(
                      child:
                       ListTile(
                        title: Text(med.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${med.dosage} - ${med.instructions}'),
                            Text('Orari: ${med.reminderTimes.join(', ')}'),
                            Text(med.endDate != null
                            ? '${med.endDate?.day}/${med.endDate?.month}/${med.endDate?.year}'
                            : '---'),
                            Text(med.notes != null
                            ? '${med.notes}'
                            : '---')
                          ],
                        ),
                        
                        leading: const Icon(Icons.medical_services_outlined),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.green.shade700,
                          ),
                          onPressed: () async {
                            await widget.medicineDatabase.deleteMedicine(index);
                          },
                        ),
                        onTap: () {
                          //schermata dettaglio
                        },
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => AddMedicineForm(
                    medicineDatabase: widget.medicineDatabase,
                  onSave: (medicine) async {
                    final box = Hive.box<Medicine>('medicines');
                    await box.add(medicine);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}
