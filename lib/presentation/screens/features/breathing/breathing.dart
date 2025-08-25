import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:math';

import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';

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
  Color _dotColor = AppColors.inhaleDark;
  double _dotSize = 40.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration)
      ..addListener(_updateAnimation);

    _startBreathingCycle();
  }

  void _updateAnimation() {
    setState(() {
      _angle = 2 * pi * _animation.value;

      if (_instruction == "HOLD") {
        _dotSize = 40.0 + 10.0 * sin(pi * DateTime.now().millisecond / 500);
      } else {
        _dotSize = 40.0;
      }
    });
  }

  void _startBreathingCycle() {
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    setState(() {
      _instruction = "INHALE";
      _dotColor = AppColors.inhaleDark;
    });

    _controller.reset();
    _controller.forward().then((_) {
      setState(() {
        _instruction = "HOLD";
        _dotColor = AppColors.holdDark;
      });

      _holdTimer = Timer(const Duration(seconds: 2), () {
        setState(() {
          _instruction = "EXHALE";
          _dotColor = AppColors.exhaleDark;
        });

        _animation = Tween<double>(begin: 1, end: 0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );

        _controller.reset();
        _controller.forward().then((_) {
          setState(() {
            _totalDuration += _duration * 2 + const Duration(seconds: 2);
          });
          _startBreathingCycle();
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _holdTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotX = _circleRadius * cos(_angle);
    final dotY = _circleRadius * sin(_angle);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Exercise', style: AppTextStyles.medium22),
        backgroundColor: AppColors.textSecondryCOlor,
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
      backgroundColor: AppColors.appBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Instruction with emoji
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _instruction,
                    style: AppTextStyles.medium22.copyWith(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _dotColor,
                    ),
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

            // Breathing circle
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
                      color: AppColors.breathingCircleColor.withOpacity(0.4),
                      border: Border.all(
                        color: AppColors.holdDark.withOpacity(0.8),
                        width: 3,
                      ),
                    ),
                  ),

                  // Moving dot
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

            // Duration text
            Text(
              "⏱️ ${_totalDuration.inSeconds} seconds",
              style: AppTextStyles.medium18.copyWith(
                color: AppColors.textPrimaryColor.withOpacity(0.8),
              ),
            ),

            // Control buttons
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
                      _startBreathingCycle();
                    }
                  },
                  backgroundColor: _dotColor,
                  child: Icon(
                    _controller.isAnimating ? Icons.pause : Icons.play_arrow,
                    size: 30,
                    color: AppColors.textPrimaryColor,
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
                      _dotColor = AppColors.inhaleDark;
                    });
                  },
                  backgroundColor: AppColors.holdDark,
                  child: const Icon(
                    Icons.replay,
                    size: 30,
                    color: AppColors.textSecondryCOlor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
