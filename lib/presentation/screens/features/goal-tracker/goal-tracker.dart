import 'package:flutter/material.dart';
import 'package:rayoflite/core/services/goalService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/presentation/screens/features/goal-tracker/addGoal.dart';

class GoalTrackerExercises extends StatefulWidget {
  const GoalTrackerExercises({super.key});

  @override
  State<GoalTrackerExercises> createState() => _GoalTrackerExercisesState();
}

class _GoalTrackerExercisesState extends State<GoalTrackerExercises> {
  List<Map<String, dynamic>> goals = [];
  bool isLoading = true;

  final List<String> motivationalQuotes = [
    "The secret of getting ahead is getting started.",
    "Don't limit your challenges. Challenge your limits.",
    "Small steps every day lead to big results.",
    "You don't have to be great to start.",
    "Success is the sum of small efforts repeated daily.",
  ];
  int currentQuoteIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadGoals();
    _rotateQuotes();
  }

  Future<void> _loadGoals() async {
    setState(() => isLoading = true);
    final response = await GoalService.getGoals();
    if (!mounted) return;
    setState(() => isLoading = false);

    if (response['success']) {
      if (mounted) {
        setState(() {
          goals = List<Map<String, dynamic>>.from(response['data']);
          _calculateStreaks();
        });
      }
    } else {
      if (mounted) {
        MessageService.showError(context, 'Error: ${response['message']}');
      }
    }
  }

  Future<void> _showAddGoalDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder:
          (dialogContext) => AddGoalDialog(
            onSubmit: (goalData) async {
              try {
                final response = await GoalService.addGoal(goalData);
                if (!mounted) return;
                if (response['success']) {
                  MessageService.showSuccess(
                    dialogContext,
                    'Goal added successfully',
                  );
                  Navigator.of(dialogContext, rootNavigator: true).pop();
                  await _loadGoals();
                } else {
                  MessageService.showError(
                    dialogContext,
                    'Failed to add goal: ${response['message']}',
                  );
                }
              } catch (e) {
                if (mounted) {
                  MessageService.showError(
                    dialogContext,
                    'Failed to add goal: $e',
                  );
                }
              }
            },
          ),
    );
  }

  void _rotateQuotes() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          currentQuoteIndex =(currentQuoteIndex + 1) % motivationalQuotes.length;
        });
        _rotateQuotes();
      }
    });
  }

  void _calculateStreaks() {
    for (var goal in goals) {
      final createdAtList = goal['createdAt'];
      if (createdAtList != null && createdAtList.length >= 3) {
        final createdDate = DateTime(
          createdAtList[0], // year
          createdAtList[1], // month
          createdAtList[2], // day
        );
        final today = DateTime.now();
        final difference = today.difference(createdDate).inDays;
        goal['streak'] = difference + 1; // Streak starts from 1
      } else {
        goal['streak'] = 1; // default to 1 if createdAt is not valid
      }
    }
  }

  Widget _buildGoalCard(Map<String, dynamic> goal) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 236, 234, 234),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                goal['title'] ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${goal['streak'] ?? '0'} day streak",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            goal['description'] ?? '',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          if (goal['reason'] != null && goal['reason'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                "Reason: ${goal['reason']}",
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ),
          if (goal['objective'] != null && goal['objective'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                "Objective: ${goal['objective']}",
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ),
          if (goal['category'] != null && goal['category'].isNotEmpty)
            Text(
              "Category: ${goal['category']}",
              style: const TextStyle(fontSize: 12, color: Colors.black45),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wishes',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadGoals,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
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
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              motivationalQuotes[currentQuoteIndex],
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showAddGoalDialog,
                        icon: const Icon(Icons.add),
                        label: const Text("Add Wish"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (goals.isEmpty)
                        const Text(
                          "No goals added yet.",
                          style: TextStyle(color: Colors.grey),
                        )
                      else
                        ...goals.map(_buildGoalCard),
                    ],
                  ),
                ),
              ),
    );
  }
}
