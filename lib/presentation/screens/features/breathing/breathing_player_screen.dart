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

  final engine = BreathingEngine();

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));

    _scale =
        Tween<double>(begin: 0.75, end: 1.05).animate(_controller);
  }

  @override
  void dispose() {
    engine.disposeEngine();
    _controller.dispose();
    super.dispose();
  }

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

                Text(
                  "Sama Vritti",
                  style: AppTextStyles.monoBold22(isDark),
                ),

                const SizedBox(height: 40),

                Expanded(child: _breathingCircle(isDark)),

                const SizedBox(height: 20),

                _controls(isDark),

                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _breathingCircle(bool isDark) {
    return Center(
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? Colors.black : Colors.black,
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
                  style: AppTextStyles.monoBold22(isDark)
                      .copyWith(color: Colors.white, fontSize: 32),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
          child: Icon(Icons.close, color: AppColors.getMonoIcon(isDark)),
        ),
      ],
    );
  }
}
