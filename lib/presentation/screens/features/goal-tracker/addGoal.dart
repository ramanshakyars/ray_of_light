import 'package:flutter/material.dart';

class AddGoalDialog extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController targetController;
  // final TextEditingController unitController;
  final VoidCallback onAddGoal;

  const AddGoalDialog({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.targetController,
    // required this.unitController,
    required this.onAddGoal,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Goal'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                // hintText: 'e.g. Drink Water',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Why you want to do it ?',
                // hintText: 'e.g. Drink 8 glasses daily',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: targetController,
              decoration: const InputDecoration(
                labelText: 'What you want to achieve ?',
                // hintText: 'e.g. 8',
              ),
              // keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            // TextField(
            //   controller: unitController,
            //   decoration: const InputDecoration(
            //     labelText: 'Unit',
            //     // hintText: 'e.g. glasses',
            //   ),
            // ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: onAddGoal, child: const Text('Add Goal')),
      ],
    );
  }
}
