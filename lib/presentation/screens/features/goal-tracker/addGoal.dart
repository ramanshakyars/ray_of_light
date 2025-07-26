import 'package:flutter/material.dart';

class AddGoalDialog extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController targetController;
  final VoidCallback onAddGoal;

  AddGoalDialog({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.targetController,
    required this.onAddGoal,
  });

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Goal'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Why you want to do it?',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: targetController,
                decoration: const InputDecoration(
                  labelText: 'What you want to achieve?',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Target is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              onAddGoal();
              Navigator.of(context).pop(); // Close dialog after success
            }
          },
          child: const Text('Add Goal'),
        ),
      ],
    );
  }
}
