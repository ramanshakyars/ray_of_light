import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'breathing_engine.dart';

class BreathingPlayerScreen extends StatefulWidget {
  const BreathingPlayerScreen({super.key});

  @override
  State<BreathingPlayerScreen> createState() =>
      _BreathingPlayerScreenState();
}

class _BreathingPlayerScreenState extends State<BreathingPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  final BreathingEngine engine = BreathingEngine();

  // =========================================================
  // INIT
  // =========================================================
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scale = Tween<double>(
      begin: 0.82, // smaller (exhale)
      end: 1.12,   // bigger (inhale)
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // 🔥 IMPORTANT — sync animation with breathing phase
    engine.addListener(_syncAnimationWithPhase);
  }

  // =========================================================
  // SYNC ANIMATION WITH ENGINE
  // =========================================================
  void _syncAnimationWithPhase() {
    if (!mounted) return;

    switch (engine.phase) {
      case BreathingPhase.inhale:
        _controller.duration = Duration(seconds: engine.secondsLeft);
        _controller.forward();
        break;

      case BreathingPhase.exhale:
        _controller.duration = Duration(seconds: engine.secondsLeft);
        _controller.reverse();
        break;

      case BreathingPhase.hold:
        _controller.stop();
        break;

      case BreathingPhase.ready:
        _controller.reset();
        break;
    }
  }

  // =========================================================
  // DISPOSE
  // =========================================================
  @override
  void dispose() {
    engine.removeListener(_syncAnimationWithPhase);
    engine.disposeEngine();
    _controller.dispose();
    super.dispose();
  }

  // =========================================================
  // UI
  // =========================================================
  @override
  Widget build(BuildContext context) {
    final isDark =
        Provider.of<ThemeProvider>(context, listen: true).isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: engine,
          builder: (_, __) {
            return Column(
              children: [
                const SizedBox(height: 40),

                // Title
                Text(
                  "Sama Vritti",
                  style: AppTextStyles.monoBold22(isDark),
                ),

                const SizedBox(height: 40),

                // Breathing circle
                Expanded(child: _breathingCircle(isDark)),

                const SizedBox(height: 20),

                // Controls
                _controls(isDark),

                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // BREATHING CIRCLE
  // =========================================================
  Widget _breathingCircle(bool isDark) {
    return Center(
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black, // always black (design requirement)
            border: Border.all(
              color: AppColors.getMonoDivider(isDark),
              width: 12,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  engine.instruction,
                  style: AppTextStyles.monoMedium18(isDark)
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  "${engine.secondsLeft}s",
                  style: AppTextStyles.monoBold22(isDark).copyWith(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // CONTROLS
  // =========================================================
  Widget _controls(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          heroTag: "play",
          backgroundColor: Colors.black,
          onPressed: engine.isRunning ? engine.pause : engine.start,
          child: Icon(
            engine.isRunning ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 20),
        FloatingActionButton(
          heroTag: "end",
          backgroundColor: AppColors.getMonoSurface(isDark),
          onPressed: engine.reset,
          child: Icon(
            Icons.close,
            color: AppColors.getMonoIcon(isDark),
          ),
        ),
      ],
    );
  }
}
