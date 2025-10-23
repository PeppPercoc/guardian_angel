import 'package:flutter/material.dart';
import 'package:guardian_angel/styles/theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/medicine.dart';
import 'add_medicine_screen.dart';

class SchedulerScreen extends StatefulWidget {
  const SchedulerScreen({super.key});

  @override
  State<SchedulerScreen> createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  late Box<Medicine> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Medicine>('medicines');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _box.listenable(),
      builder: (context, Box<Medicine> box, _) {
        final medicines = box.values.toList();

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
                      child: ListTile(
                        title: Text(med.name),
                        subtitle: Text('${med.dosage} - ${med.instructions}'),
                        leading: const Icon(Icons.medical_services_outlined),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.green.shade700,
                          ),
                          onPressed: () async {
                            _box.deleteAt(index);
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
                  onSave: (medicine) async {
                    final box = Hive.box<Medicine>('medicines');
                    await box.add(medicine);
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
