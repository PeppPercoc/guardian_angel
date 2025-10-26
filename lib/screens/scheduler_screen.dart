import 'package:flutter/material.dart';
import 'package:guardian_angel/services/medicine_database_service.dart';
import 'package:guardian_angel/styles/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/medicine.dart';
import 'add_medicine_screen.dart';
import '../widgets/medicine_list.dart';

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
          body: MedicineList(
            medicines: medicines,
            onDelete: (index) async {
              await widget.medicineDatabase.deleteMedicine(index);
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
                    await widget.medicineDatabase.addMedicine(medicine);
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