import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'breathing_engine.dart';

class BreathingPlayerScreen extends StatefulWidget {
  const BreathingPlayerScreen({super.key});

  @override
  State<BreathingPlayerScreen> createState() => _BreathingPlayerScreenState();
}

class _BreathingPlayerScreenState extends State<BreathingPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _circleController;
  late Animation<double> _scale;
  
  final BreathingEngine engine = BreathingEngine();

  @override
  void initState() {
    super.initState();

    _circleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scale = Tween<double>(
      begin: 0.8, // smaller (exhale)
      end: 1.2,   // bigger (inhale)
    ).animate(
      CurvedAnimation(
        parent: _circleController,
        curve: Curves.easeInOutSine,
      ),
    );

    engine.addListener(_syncAnimationWithPhase);
  }

  void _syncAnimationWithPhase() {
    if (!mounted) return;

    switch (engine.phase) {
      case BreathingPhase.inhale:
        _circleController.duration = Duration(seconds: engine.secondsLeft);
        _circleController.forward();
        break;
      case BreathingPhase.exhale:
        _circleController.duration = Duration(seconds: engine.secondsLeft);
        _circleController.reverse();
        break;
      case BreathingPhase.hold:
        _circleController.stop();
        break;
      case BreathingPhase.ready:
        _circleController.reset();
        break;
    }
    setState(() {});
  }

  @override
  void dispose() {
    engine.removeListener(_syncAnimationWithPhase);
    engine.disposeEngine();
    _circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context, listen: true).isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: engine,
          builder: (_, __) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.getMonoIcon(isDark),
                            size: 24,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Sama Vritti",
                              style: AppTextStyles.monoBold22(isDark).copyWith(
                                fontSize: 24,
                                letterSpacing: 2,
                              ),
                            ),
                            Text(
                              "Box Breathing",
                              style: AppTextStyles.monoSecondary14(isDark),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40), // Balance out the back button for centering
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // Layered Breathing Circle
                _breathingCircle(isDark),

                const Spacer(flex: 3),

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

  Widget _breathingCircle(bool isDark) {
    return Center(
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer layer
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.getMonoDivider(isDark).withOpacity(0.2),
                ),
              ),
              // Middle layer
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.getMonoDivider(isDark).withOpacity(0.5),
                ),
              ),
              // Inner solid layer
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black, // keep standard solid inner circle
                  border: Border.all(
                    color: AppColors.getMonoDivider(isDark),
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          engine.instruction,
                          key: ValueKey<String>(engine.instruction),
                          style: AppTextStyles.monoMedium18(isDark).copyWith(
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          "${engine.secondsLeft}",
                          key: ValueKey<int>(engine.secondsLeft),
                          style: AppTextStyles.monoBold22(isDark).copyWith(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
            engine.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(width: 20),
        FloatingActionButton(
          heroTag: "end",
          backgroundColor: AppColors.getMonoSurface(isDark),
          onPressed: engine.reset,
          child: Icon(
            Icons.stop_rounded,
            color: AppColors.getMonoIcon(isDark),
            size: 28,
          ),
        ),
      ],
    );
  }
}
