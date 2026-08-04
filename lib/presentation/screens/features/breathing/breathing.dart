import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/widgets/app_screen_header.dart';

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

  String selectedExercise = "Box Breathing";

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
    final colors = context.watch<ThemeProvider>().colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ───────────────────────────────────────
              AppScreenHeader(
                title: "Breathing Exercise",
                subtitle: "Relax, focus and find your center",
                actions: [
                  GestureDetector(
                    onTap: () => context.push('${RouteNames.mainApp}/${RouteNames.home}'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.border.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Icon(
                        Icons.air_rounded,
                        color: colors.icon,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _buildBreathingCard(colors),
              const SizedBox(height: 28),
              Text(
                "Practice Sessions",
                style: AppTextStyles.sectionTitle(colors),
              ),
              const SizedBox(height: 14),
              _buildSessionCard(
                colors,
                title: 'Box Breathing',
                subtitle: 'Equal breathing for balance and calm',
                duration: '5 min',
                icon: Icons.square_outlined,
                onTap: () => _selectExercise("Box Breathing"),
              ),
              const SizedBox(height: 10),
              _buildSessionCard(
                colors,
                icon: Icons.air_rounded,
                title: '4-7-8 Breathing',
                subtitle: 'Relaxation technique for better sleep',
                duration: '10 min',
                onTap: () => _selectExercise("4-7-8 Breathing"),
              ),
              const SizedBox(height: 10),
              _buildSessionCard(
                colors,
                icon: Icons.self_improvement_rounded,
                title: 'Morning Energizer',
                subtitle: 'Start your day with vitality',
                duration: '3 min',
                onTap: () => _selectExercise("Morning Energizer"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreathingCard(ThemeColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(selectedExercise, style: AppTextStyles.sectionTitle(colors)),
          const SizedBox(height: 4),
          Text("Find your center", style: AppTextStyles.hintText(colors)),
          const SizedBox(height: 28),
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary.withValues(alpha: 0.15),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: ColorScheme != null
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.center,
                      children: [
                        Text(
                          _instruction,
                          style: AppTextStyles.cardTitle(colors),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _count.toString(),
                          style: AppTextStyles.screenTitle(colors).copyWith(
                            fontSize: 44,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: "startBtn",
                onPressed: _isRunning ? _pauseCycle : _startCycle,
                backgroundColor: colors.primary,
                foregroundColor: colors.primaryForeground,
                child: Icon(
                  _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 30,
                ),
              ),
              const SizedBox(width: 20),
              FloatingActionButton(
                heroTag: "resetBtn",
                onPressed: _resetCycle,
                backgroundColor: colors.surface,
                foregroundColor: colors.icon,
                child: const Icon(
                  Icons.replay_rounded,
                  size: 26,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(
    ThemeColors colors, {
    IconData? icon,
    required String title,
    required String subtitle,
    required String duration,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedExercise == title;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primary.withValues(alpha: 0.15)
                    : colors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon ?? Icons.air_rounded,
                color: isSelected ? colors.primary : colors.icon,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.cardTitle(colors).copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.hintText(colors),
                  ),
                ],
              ),
            ),
            Text(
              duration,
              style: AppTextStyles.labelSmall(colors),
            ),
          ],
        ),
      ),
    );
  }
}
