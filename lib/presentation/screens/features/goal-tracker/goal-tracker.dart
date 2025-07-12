import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/presentation/screens/features/goal-tracker/addGoal.dart';

class GoalTrackerExercises extends StatefulWidget {
  const GoalTrackerExercises({super.key});

  @override
  State<GoalTrackerExercises> createState() => _GoalTrackerExercisesState();
}

class _GoalTrackerExercisesState extends State<GoalTrackerExercises> {
  List<Map<String, dynamic>> goals = [];
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetController = TextEditingController();
  final _unitController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AddGoalDialog(
            titleController: _titleController,
            descriptionController: _descriptionController,
            targetController: _targetController,
            unitController: _unitController,
            onAddGoal: () {
              setState(() {
                goals.add({
                  'title': _titleController.text,
                  'description': _descriptionController.text,
                  'target': _targetController.text,
                  'unit': _unitController.text,
                  'streak': 1,
                  'startDate': DateTime.now().toString(),
                });
              });
              _clearControllers();
              Navigator.of(context).pop();
            },
          ),
    );
  }

  void _clearControllers() {
    _titleController.clear();
    _descriptionController.clear();
    _targetController.clear();
    _unitController.clear();
  }

  Widget _buildGoalCard(Map<String, dynamic> goal) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goal['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            '${goal['streak']} day streak',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const Spacer(),
          LinearProgressIndicator(
            value: 0.5,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(
            '0/${goal['target']} ${goal['unit']}',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildAddGoalButton() {
    return GestureDetector(
      onTap: _showAddGoalDialog,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 40, color: Colors.black54),
            SizedBox(height: 8),
            Text('Add Goal', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Track Your Goals',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 10,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Image.asset('assets/logo.png'),
            onPressed:
                () => GoRouter.of(
                  context,
                ).push('${RouteNames.mainApp}/${RouteNames.home}'),
          ),
        ],
      ),
      body:
          goals.isEmpty
              ? Center(
                child: GestureDetector(
                  onTap: _showAddGoalDialog,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 50,
                          color: Colors.black54,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Add Your First Goal',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: goals.length + 1,
                  itemBuilder: (context, index) {
                    return index == goals.length
                        ? _buildAddGoalButton()
                        : _buildGoalCard(goals[index]);
                  },
                ),
              ),
      floatingActionButton:
          goals.isNotEmpty
              ? FloatingActionButton(
                onPressed: _showAddGoalDialog,
                backgroundColor: Colors.white,
                child: const Icon(Icons.add, color: Colors.black),
              )
              : null,
    );
  }
}
