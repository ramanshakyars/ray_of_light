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

  // Sample motivational quotes - replace with your own or API data
  final List<String> motivationalQuotes = [
    "The secret of getting ahead is getting started.",
    "Don't limit your challenges. Challenge your limits.",
    "Small steps every day lead to big results.",
    "You don't have to be great to start, but you have to start to be great.",
    "Success is the sum of small efforts repeated daily."
  ];
  int currentQuoteIndex = 0;

  @override
  void initState() {
    super.initState();
    // Rotate quotes every 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          currentQuoteIndex = (currentQuoteIndex + 1) % motivationalQuotes.length;
        });
      }
    });
  }

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
      builder: (context) => AddGoalDialog(
        titleController: _titleController,
        descriptionController: _descriptionController,
        targetController: _targetController,
        // unitController: _unitController,
        onAddGoal: () {
          setState(() {
            goals.add({
              'title': _titleController.text,
              'description': _descriptionController.text,
              'target': _targetController.text,
              // 'unit': _unitController.text,
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
    // _unitController.clear();
  }

  Widget _buildGoalCard(Map<String, dynamic> goal) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${goal['streak']} day streak',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 12),
            // LinearProgressIndicator(
            //   value: 0.5,
            //   backgroundColor: Colors.grey[200],
            //   valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            // ),
            const SizedBox(height: 8),
            Text(
              '0/${goal['target']} ${goal['unit']}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            if (goal['description'] != null && goal['description'].isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  goal['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddGoalButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: _showAddGoalDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 20),
            SizedBox(width: 8),
            Text('Add New Goal', style: TextStyle(fontSize: 16)),
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
        elevation: 4,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Image.asset('assets/logo.png'),
            onPressed: () => GoRouter.of(context).push('${RouteNames.mainApp}/${RouteNames.home}'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Motivational Quotes Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Motivation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    motivationalQuotes[currentQuoteIndex],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Add Goal Button (always visible)
            _buildAddGoalButton(),

            // Goals List
            if (goals.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                child: const Center(
                  child: Text(
                    'No goals yet. Add your first goal to get started!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              )
            else
              Column(
                children: goals.map((goal) => _buildGoalCard(goal)).toList(),
              ),
          ],
        ),
      ),
    );
  }
}