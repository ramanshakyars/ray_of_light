import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';

import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  _BreathingScreenState createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _holdTimer;
  String _instruction = "INHALE";
  double _angle = 0;
  final Duration _duration = Duration(seconds: 4);
  Duration _totalDuration = Duration.zero;
  final double _circleRadius = 140;
  Color _dotColor = Colors.black;
  // Color _dotColor = AppColors.inhaleDark;
  double _dotSize = 40.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
      // ..addListener(_updateAnimation);

    // _startBreathingCycle();
  }

  // ... rest of your methods unchanged ...

  @override
  Widget build(BuildContext context) {
    // ✅ Move provider access here
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final dotX = _circleRadius * cos(_angle);
    final dotY = _circleRadius * sin(_angle);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Exercise'),
        backgroundColor: AppColors.getTextSecondaryColor(isDarkMode),
        elevation: 4,
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
      backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🫁 Instruction with emoji
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _instruction,
                    style: AppTextStyles.medium22(isDarkMode),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Icon(
                        _instruction == "INHALE"
                            ? Icons.arrow_upward
                            : _instruction == "EXHALE"
                            ? Icons.arrow_downward
                            : Icons.pause,
                        color: _dotColor,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 🌫️ Breathing circle
            SizedBox(
              width: _circleRadius * 2 + 60,
              height: _circleRadius * 2 + 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: _circleRadius * 2,
                    height: _circleRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.getBreathingCircleColor(isDarkMode),
                      border: Border.all(
                        color: AppColors.getHoldDark(isDarkMode),
                        width: 3,
                      ),
                    ),
                  ),

                  // 🟢 Moving dot
                  Transform.translate(
                    offset: Offset(dotX, dotY),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _dotSize,
                      height: _dotSize,
                      decoration: BoxDecoration(
                        color: _dotColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _dotColor.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ⏱️ Duration
            Text(
              "⏱️ ${_totalDuration.inSeconds} seconds",
              style: AppTextStyles.medium18(isDarkMode),
            ),

            // 🎛️ Control buttons
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    if (_controller.isAnimating) {
                      _controller.stop();
                      _holdTimer?.cancel();
                      setState(() {});
                    } else {
                      // _startBreathingCycle();
                    }
                  },
                  backgroundColor: _dotColor,
                  child: Icon(
                    _controller.isAnimating ? Icons.pause : Icons.play_arrow,
                    size: 30,
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                  ),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: () {
                    _controller.reset();
                    _holdTimer?.cancel();
                    setState(() {
                      _totalDuration = Duration.zero;
                      _instruction = "INHALE";
                      _angle = 0;
                      _dotColor = Colors.black;
                    });
                  },
                  backgroundColor: AppColors.getHoldDark(isDarkMode),
                  child: const Icon(Icons.replay, size: 30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
