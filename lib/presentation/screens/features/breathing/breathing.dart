import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/main-layout.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  Timer? _phaseTimer;
  String _instruction = "Breathe In";
  int _count = 4;
  bool _isRunning = false;

  // selected exercise
  String selectedExercise = "Box Breathing";

  // breathing pattern configurations
  final Map<String, Map<String, int>> breathingPatterns = {
    "Box Breathing": {"inhale": 4, "hold1": 4, "exhale": 4, "hold2": 4},
    "4-7-8 Breathing": {"inhale": 4, "hold1": 7, "exhale": 8, "hold2": 0},
    "Morning Energizer": {"inhale": 3, "hold1": 2, "exhale": 3, "hold2": 0},
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _startCycle() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
      _instruction = "Breathe In";
      _count = breathingPatterns[selectedExercise]!["inhale"]!;
    });
    _runPhase("inhale");
  }

  void _runPhase(String phase) {
    _phaseTimer?.cancel();

    final config = breathingPatterns[selectedExercise]!;

    if (phase == "inhale") {
      _controller.duration = Duration(seconds: config["inhale"]!);
      _controller.forward(from: 0);
      _instruction = "Breathe In";
      _count = config["inhale"]!;
    } else if (phase == "hold1") {
      _instruction = "Hold";
      _count = config["hold1"]!;
    } else if (phase == "exhale") {
      _controller.duration = Duration(seconds: config["exhale"]!);
      _controller.reverse(from: 1);
      _instruction = "Breathe Out";
      _count = config["exhale"]!;
    } else if (phase == "hold2" && config["hold2"]! > 0) {
      _instruction = "Hold";
      _count = config["hold2"]!;
    }

    _startCountdown(phase);
  }

  void _startCountdown(String phase) {
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count > 1) {
        setState(() => _count--);
      } else {
        timer.cancel();
        _nextPhase(phase);
      }
    });
  }

  void _nextPhase(String current) {
    final config = breathingPatterns[selectedExercise]!;

    switch (current) {
      case "inhale":
        _runPhase("hold1");
        break;
      case "hold1":
        _runPhase("exhale");
        break;
      case "exhale":
        if (config["hold2"]! > 0) {
          _runPhase("hold2");
        } else {
          _runPhase("inhale");
        }
        break;
      case "hold2":
        _runPhase("inhale");
        break;
    }
  }

  void _pauseCycle() {
    _phaseTimer?.cancel();
    if (_controller.isAnimating) _controller.stop();
    setState(() => _isRunning = false);
  }

  void _resetCycle() {
    _phaseTimer?.cancel();
    if (mounted) _controller.reset();
    setState(() {
      _isRunning = false;
      _instruction = "Breathe In";
      _count = breathingPatterns[selectedExercise]!["inhale"]!;
    });
  }

  void _selectExercise(String name) {
    _resetCycle();
    setState(() {
      selectedExercise = name;
      _instruction = "Breathe In";
      _count = breathingPatterns[name]!["inhale"]!;
    });
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    if (mounted) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
      appBar: AppBar(
        title: Text(
          'Breathing Exercise',
          style: AppTextStyles.medium18(isDarkMode),
        ),
        backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Image.asset('assets/logo.png', height: 30),
            onPressed:
                () => GoRouter.of(
                  context,
                ).push('${RouteNames.mainApp}/${RouteNames.home}'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildBreathingCard(isDarkMode),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Practice Sessions",
                style: AppTextStyles.medium18(isDarkMode),
              ),
            ),
            const SizedBox(height: 15),
            _buildSessionCard(
              isDarkMode,
              title: 'Box Breathing',
              subtitle: 'Equal breathing for balance and calm',
              duration: '5 min',
              onTap: () => _selectExercise("Box Breathing"),
            ),
            const SizedBox(height: 10),
            _buildSessionCard(
              isDarkMode,
              icon: Icons.air_rounded,
              bgColor: AppColors.hexToColor('#E9D5FF'),
              title: '4-7-8 Breathing',
              subtitle: 'Relaxation technique for better sleep',
              duration: '10 min',
              onTap: () => _selectExercise("4-7-8 Breathing"),
            ),
            const SizedBox(height: 10),
            _buildSessionCard(
              isDarkMode,
              icon: Icons.self_improvement_rounded,
              bgColor: AppColors.hexToColor('#E0E7FF'),
              title: 'Morning Energizer',
              subtitle: 'Start your day with vitality',
              duration: '3 min',
              onTap: () => _selectExercise("Morning Energizer"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreathingCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.hexToColor('#8E2DE2'),
            AppColors.hexToColor('#4A00E0'),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(selectedExercise, style: AppTextStyles.medium22(isDarkMode)),
          const SizedBox(height: 4),
          Text("Find your center", style: AppTextStyles.regular14(isDarkMode)),
          const SizedBox(height: 25),
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.hexToColor('#6A11CB'),
                        AppColors.hexToColor('#2575FC'),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _instruction,
                          style: AppTextStyles.medium18(
                            isDarkMode,
                          ).copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _count.toString(),
                          style: AppTextStyles.bold28(
                            isDarkMode,
                          ).copyWith(color: Colors.white, fontSize: 48),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: "startBtn",
                onPressed: _isRunning ? _pauseCycle : _startCycle,
                backgroundColor: Colors.white,
                child: Icon(
                  _isRunning ? Icons.pause : Icons.play_arrow,
                  color: AppColors.hexToColor('#6A11CB'),
                  size: 30,
                ),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                heroTag: "resetBtn",
                onPressed: _resetCycle,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.replay,
                  color: AppColors.hexToColor('#6A11CB'),
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(
    bool isDarkMode, {
    String? image,
    IconData? icon,
    Color? bgColor,
    required String title,
    required String subtitle,
    required String duration,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.getCard(isDarkMode),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: bgColor ?? AppColors.getAccent(isDarkMode),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.getPrimary(isDarkMode)),
              ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.medium18(isDarkMode)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.regular14(
                      isDarkMode,
                    ).copyWith(color: AppColors.getMutedForeground(isDarkMode)),
                  ),
                ],
              ),
            ),
            Text(
              duration,
              style: AppTextStyles.regular14(
                isDarkMode,
              ).copyWith(color: AppColors.getMutedForeground(isDarkMode)),
            ),
          ],
        ),
      ),
    );
  }
}
