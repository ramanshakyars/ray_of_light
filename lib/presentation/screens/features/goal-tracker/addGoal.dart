import 'package:flutter/material.dart';

class AddGoalDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const AddGoalDialog({super.key, required this.onSubmit});

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _reasonController = TextEditingController();
  final _objectiveController = TextEditingController();
  String? _selectedCategory;

  final List<String> _categories = [
    'DAILY_ROUTINE',
    'CAREER',
    'HEALTH',
    'MINDFULNESS',
    'RELATIONSHIPS',
    'PERSONAL_GROWTH',
    'OTHER',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _reasonController.dispose();
    _objectiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add New Goal"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator:
                    (val) =>
                        val == null || val.isEmpty ? "Title is required" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: "Reason"),
              ),
              TextFormField(
                controller: _objectiveController,
                decoration: const InputDecoration(labelText: "Objective"),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items:
                    _categories
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.toString()),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                decoration: const InputDecoration(
                  labelText: "Select Goal Category",
                ),
                validator:
                    (val) =>
                        val == null || val.isEmpty ? "Select category" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit({
                'title': _titleController.text,
                'description': _descriptionController.text,
                'reason': _reasonController.text,
                'objective': _objectiveController.text,
                'category': _selectedCategory,
              });
            }
          },
          child: const Text("Add Goal"),
        ),
      ],
    );
  }
}
