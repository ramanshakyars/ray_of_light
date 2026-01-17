import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/main-layout.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/goalService.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
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
        // MessageService.showError(context, 'Error: ${response['message']}');
        MessageService.showError(context, 'Getting issue in fetching goals');
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

  Future<void> updateGoalStatus(String goalId, bool isCompleted) async {
    try {
      final String updatedStatus = isCompleted ? 'COMPLETED' : 'PENDING';
      final url =
          '${PathConfig.updateGoalStatus}/$goalId?status=$updatedStatus';
      final response = await GoalService.updateGoalStatus(url);
      if (response['success']) {
        // reload goals after status update
        await _loadGoals();
        MessageService.showSuccess(
          context,
          'Goal status updated to $updatedStatus',
        );
      } else {
        MessageService.showError(
          context,
          'Failed to update goal status: ${response['message']}',
        );
      }
    } catch (e) {
      MessageService.showError(context, 'Error updating goal status: $e');
    }
  }

  void _rotateQuotes() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          currentQuoteIndex =
              (currentQuoteIndex + 1) % motivationalQuotes.length;
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

  Widget _buildGoalCard(Map<String, dynamic> goal, bool isDarkMode) {
    final isCompleted = (goal['status'] == 'COMPLETED');
    final backgroundColor = AppColors.getCard(isDarkMode);
    final borderColor = isCompleted ? Colors.greenAccent : Colors.amberAccent;
    final textColor = AppColors.getTextPrimaryColor(isDarkMode);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.8),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black : Colors.grey,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  goal['title'] ?? '',
                  style: AppTextStyles.bold22(isDarkMode),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: isCompleted,
                    onChanged: (bool? value) {
                      if (value != null) {
                        updateGoalStatus(goal['id'], value);
                      }
                    },
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.getFormSubmitButtonColor(isDarkMode),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "${goal['streak'] ?? '0'} day streak",
                      style: AppTextStyles.regular14(isDarkMode).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            goal['description'] ?? '',
            style: AppTextStyles.button16(
              isDarkMode,
            ).copyWith(color: textColor),
          ),
          const SizedBox(height: 10),
          if (goal['reason'] != null && goal['reason'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                "Reason: ${goal['reason']}",
                style: AppTextStyles.regular14(
                  isDarkMode,
                ).copyWith(color: textColor),
              ),
            ),
          if (goal['objective'] != null && goal['objective'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                "Objective: ${goal['objective']}",
                style: AppTextStyles.regular14(
                  isDarkMode,
                ).copyWith(color: textColor),
              ),
            ),
          if (goal['category'] != null && goal['category'].isNotEmpty)
            Text(
              "Category: ${goal['category']}",
              style: AppTextStyles.regular14(isDarkMode).copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.getFormSubmitButtonColor(isDarkMode),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.getCard(isDarkMode),
        elevation: 1,
        title: Text('wishes', style: AppTextStyles.bold22(isDarkMode)),
        actions: [
          IconButton(
            icon: Image.asset('assets/logo.png'),
            onPressed:
                () => GoRouter.of(
                  context,
                ).push('${RouteNames.mainApp}/${RouteNames.home}'),
            iconSize: 32,
          ),
        ],
      ),
      backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
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
                        padding: const EdgeInsets.all(18),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: AppColors.getAccent(isDarkMode),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode ? Colors.black : Colors.grey,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily Motivation',
                              style: AppTextStyles.regular14(
                                isDarkMode,
                              ).copyWith(
                                color: AppColors.getTextPrimaryColor(
                                  isDarkMode,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              motivationalQuotes[currentQuoteIndex],
                              style: AppTextStyles.bold22(
                                isDarkMode,
                              ).copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showAddGoalDialog,
                        icon: const Icon(Icons.add),
                        label: Text(
                          "Add Wish",
                          style: AppTextStyles.button16(
                            isDarkMode,
                          ).copyWith(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.getFormSubmitButtonColor(
                            isDarkMode,
                          ),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: AppColors.getFormSubmitButtonColor(
                            isDarkMode,
                          ),
                          elevation: 5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (goals.isEmpty)
                        Text(
                          "No goals added yet.",
                          style: AppTextStyles.bold22(isDarkMode).copyWith(
                            color: AppColors.getTextSecondaryColor(isDarkMode),
                          ),
                        )
                      else
                        ...goals.map(
                          (goal) => _buildGoalCard(goal, isDarkMode),
                        ),
                    ],
                  ),
                ),
              ),
    );
  }
}
