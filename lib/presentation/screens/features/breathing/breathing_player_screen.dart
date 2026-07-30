import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

import 'breathing_engine.dart';
import 'breathing_model.dart';

class BreathingPlayerScreen extends StatefulWidget {
  final BreathingModel? model;

  const BreathingPlayerScreen({super.key, this.model});

  @override
  State<BreathingPlayerScreen> createState() => _BreathingPlayerScreenState();
}

class _BreathingPlayerScreenState extends State<BreathingPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _circleController;
  late Animation<double> _scale;
  late BreathingEngine engine;

  @override
  void initState() {
    super.initState();
    final model = widget.model ?? BreathingModel.defaultExercises.first;
    engine = BreathingEngine(initialPattern: model);

    _circleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: model.inhale),
    );

    _scale = Tween<double>(
      begin: 0.78,
      end: 1.25,
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
      case BreathingPhase.hold1:
      case BreathingPhase.hold2:
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
    final model = engine.pattern;
    final primaryTextColor = AppColors.getMonoTextPrimary(isDark);
    final secondaryTextColor = AppColors.getMonoTextSecondary(isDark);
    final surfaceColor = AppColors.getMonoSurface(isDark);
    final borderColor = AppColors.getMonoBorder(isDark);

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: engine,
          builder: (_, __) {
            return Column(
              children: [
                // ── HEADER BAR ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          engine.pause();
                          context.pop();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: borderColor.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.getMonoIcon(isDark),
                            size: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              model.title,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: primaryTextColor,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              model.subtitle,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 12,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Background Music Toggle Button
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          engine.toggleSound();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: engine.isSoundEnabled
                                ? primaryTextColor.withValues(alpha: 0.12)
                                : surfaceColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: engine.isSoundEnabled
                                  ? primaryTextColor.withValues(alpha: 0.5)
                                  : borderColor,
                            ),
                          ),
                          child: Icon(
                            engine.isSoundEnabled
                                ? Icons.music_note_rounded
                                : Icons.music_off_rounded,
                            color: engine.isSoundEnabled
                                ? primaryTextColor
                                : AppColors.getMonoTextMuted(isDark),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ── STATS BAR ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatChip(
                        icon: Icons.repeat_rounded,
                        label: "${engine.completedCycles} Cycles",
                        isDark: isDark,
                      ),
                      // Volume swell indicator pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryTextColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor.withValues(alpha: 0.6)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.graphic_eq_rounded, size: 14, color: primaryTextColor),
                            const SizedBox(width: 4),
                            Text(
                              "Music ${(engine.volume * 100).toInt()}%",
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: primaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _StatChip(
                        icon: Icons.timer_outlined,
                        label: engine.formattedTotalTime,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── MONO BREATHING VISUALIZER CIRCLE ────────────────
                _buildBreathingCircle(isDark, surfaceColor, borderColor, primaryTextColor),

                const Spacer(),

                // ── MAIN CONTROLS (PLAY / PAUSE / RESET) ────────────
                _buildControlButtons(isDark, surfaceColor, borderColor, primaryTextColor),

                const SizedBox(height: 48),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── BREATHING CIRCLE VISUALIZER ────────────────────────────────────
  Widget _buildBreathingCircle(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryColor,
  ) {
    // Dynamic shadow radius reacting to engine.volume
    final glowRadius = 15.0 + (engine.volume * 35.0);
    final glowOpacity = (engine.volume * 0.25).clamp(0.06, 0.30);

    return Center(
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 270,
          height: 270,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: glowOpacity),
                blurRadius: glowRadius,
                spreadRadius: glowRadius * 0.3,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulse ring 1
              Container(
                width: 270,
                height: 270,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withValues(alpha: isDark ? 0.06 : 0.03),
                  border: Border.all(
                    color: borderColor.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
              ),

              // Middle pulse ring 2
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withValues(alpha: isDark ? 0.12 : 0.06),
                  border: Border.all(
                    color: borderColor.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
              ),

              // Inner solid focus core
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.monoDarkSurface : Colors.white,
                  border: Border.all(
                    color: primaryColor,
                    width: 3.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Instruction text ("Breathe In", "Hold", "Breathe Out")
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: ScaleTransition(scale: anim, child: child),
                        ),
                        child: Text(
                          engine.instruction,
                          key: ValueKey<String>(engine.instruction),
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Countdown timer seconds
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          "${engine.secondsLeft}",
                          key: ValueKey<int>(engine.secondsLeft),
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 48,
                            fontWeight: FontWeight.w300,
                            color: primaryColor,
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

  // ── CONTROL BUTTONS ──────────────────────────────────────────────────
  Widget _buildControlButtons(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color primaryColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Play / Pause Button
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            if (engine.isRunning) {
              engine.pause();
            } else {
              engine.start();
            }
          },
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              engine.isRunning
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              color: AppColors.getMonoBackground(isDark),
              size: 36,
            ),
          ),
        ),

        const SizedBox(width: 24),

        // Reset / Stop Button
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            engine.reset();
          },
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: surfaceColor,
              border: Border.all(
                color: borderColor,
                width: 1.2,
              ),
            ),
            child: Icon(
              Icons.stop_rounded,
              color: AppColors.getMonoIcon(isDark),
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.getMonoSurface(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.getMonoBorder(isDark).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.getMonoTextSecondary(isDark)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.getMonoTextSecondary(isDark),
            ),
          ),
        ],
      ),
    );
  }
}
