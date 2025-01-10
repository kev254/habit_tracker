import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/local_database.dart';
import '../models/habit.dart';
import '../util/app_colors.dart';
import 'app_global_widgets.dart';

class CreateHabitDialog extends StatefulWidget {
  final Habit? habit;
  final Function(Habit) onSave;

  const CreateHabitDialog({Key? key, this.habit, required this.onSave}) : super(key: key);

  @override
  _HabitDialogState createState() => _HabitDialogState();
}

class _HabitDialogState extends State<CreateHabitDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageCtrl = TextEditingController();
  final TextEditingController selectedDateCtrl = TextEditingController();

  String? selectedFrequency;
  DateTime? selectedStartDate;
  String? imagePath;

  @override
  void initState() {
    super.initState();

    if (widget.habit != null) {
      // If editing, prepopulate the fields
      nameController.text = widget.habit!.name;
      descriptionController.text = widget.habit!.description ?? '';
      imageCtrl.text = widget.habit!.imageUrl ?? '';
      selectedFrequency = widget.habit!.frequency;
      selectedStartDate = widget.habit!.startDate;
      selectedDateCtrl.text = widget.habit!.startDate.toString().split(' ')[0];
    }
  }



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: AlertDialog(
        title: TitleText(text: widget.habit == null ? "Create New Habit" : "Edit Habit"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(controller: nameController, hintText: "Habit Name"),
              AppTextField(controller: descriptionController, hintText: "Habit Description"),
              AppTextField(controller: imageCtrl, hintText: "Image Url",),
              const SizedBox(height: 10),

              const SizedBox(height: 10),
              AppDropdown(
                items: ["Daily", "Weekly", "Monthly"],
                hintText: "Select Frequency",
                onChanged: (String? value) {
                  setState(() {
                    selectedFrequency = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              AppDatePicker(controller: selectedDateCtrl, label: "Start Date"),

            ],
          ),
        ),
        actions: [
          AppButton(
            onPressed: () {
              Navigator.pop(context);
            },
            label: 'Cancel',
            color: AppColors.primaryColor,
          ),
          // Save button
          AppButton(
            onPressed: () {
              String habitName = nameController.text;
              String description = descriptionController.text;
              String frequency = selectedFrequency ?? "Daily";
              DateTime startDate = selectedStartDate ?? DateTime.now();
              DateTime createdAt = widget.habit?.createdAt ?? DateTime.now();
              DateTime updatedAt = DateTime.now();
              String status = widget.habit?.status ?? "Started";

              final newHabit = Habit(
                id: widget.habit?.id,
                name: habitName,
                description: description.isEmpty ? null : description,
                frequency: frequency,
                startDate: startDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                status: status,
                completedDays: widget.habit?.completedDays ?? [],
                imageUrl: imageCtrl.text,
              );
              if(widget.habit != null){
                context.read<HabitDatabase>().updateHabit(newHabit);
              }
              else{
                context.read<HabitDatabase>().addHabit(newHabit);
              }

              widget.onSave(newHabit);
              Navigator.pop(context);
            },
            label: widget.habit == null ? 'Create Habit' : 'Update Habit',
            color: AppColors.secondaryColor,
          ),

        ],
      ),
    );
  }
}
