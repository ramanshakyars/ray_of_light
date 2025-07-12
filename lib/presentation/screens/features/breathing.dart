import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:math';

import 'package:rayoflite/core/config/routenames.dart';

class BreathingScreen extends StatefulWidget {
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
  Duration _duration = Duration(seconds: 4);
  Duration _totalDuration = Duration.zero;
  final double _circleRadius = 140;
  Color _dotColor = Colors.tealAccent;
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

      // Add pulse effect during hold
      if (_instruction == "HOLD") {
        _dotSize = 40.0 + 10.0 * sin(pi * DateTime.now().millisecond / 500);
      } else {
        _dotSize = 40.0;
      }
    });
  }

  void _startBreathingCycle() {
    // Inhale animation
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    setState(() {
      _instruction = "INHALE";
      _dotColor = Colors.tealAccent;
    });

    _controller.reset();
    _controller.forward().then((_) {
      setState(() {
        _instruction = "HOLD";
        _dotColor = Colors.orangeAccent;
      });

      // Hold for 2 seconds
      _holdTimer = Timer(Duration(seconds: 2), () {
        setState(() {
          _instruction = "EXHALE";
          _dotColor = Colors.purpleAccent;
        });

        // Exhale animation
        _animation = Tween<double>(begin: 1, end: 0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );

        _controller.reset();
        _controller.forward().then((_) {
          setState(() {
            _totalDuration += _duration * 2 + Duration(seconds: 2);
          });
          _startBreathingCycle(); // Repeat cycle
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
        title: const Text(
          'Track Your Goals',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
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
      backgroundColor: const Color.fromARGB(255, 51, 50, 50),
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
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _dotColor,
                    ),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
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
            SizedBox(height: 40),

            // Circular breathing track with gradient
            Container(
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
                      gradient: SweepGradient(
                        colors: [
                          Colors.teal.withOpacity(0.3),
                          Colors.blue.withOpacity(0.1),
                          Colors.purple.withOpacity(0.3),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),

                  // Breathing dot with animated size
                  Transform.translate(
                    offset: Offset(dotX, dotY),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
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
            SizedBox(height: 40),

            // Duration with fancy text
            Text(
              "⏱️ ${_totalDuration.inSeconds} seconds",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
                letterSpacing: 1.2,
              ),
            ),

            // Control buttons
            SizedBox(height: 30),
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
                  ),
                ),
                SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: () {
                    _controller.reset();
                    _holdTimer?.cancel();
                    setState(() {
                      _totalDuration = Duration.zero;
                      _instruction = "INHALE";
                      _angle = 0;
                    });
                  },
                  backgroundColor: Colors.grey[800],
                  child: Icon(Icons.replay, size: 30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
