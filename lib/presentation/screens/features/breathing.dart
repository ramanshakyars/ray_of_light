import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

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
  double _angle = 0; // Angle for circular position
  Duration _duration = Duration(seconds: 4);
  Duration _holdDuration = Duration(seconds: 0);
  Duration _totalDuration = Duration.zero;
  final double _circleRadius = 120; // Radius of the circular path

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    )..addListener(_updateAnimation);

    _startBreathingCycle();
  }

  void _updateAnimation() {
    setState(() {
      // Convert linear animation value (0-1) to angle (0-2π)
      _angle = 2 * pi * _animation.value;
    });
  }

  void _startBreathingCycle() {
    // Inhale animation
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _controller.reset();
    _controller.forward().then((_) {
      setState(() {
        _instruction = "HOLD";
        _holdDuration = Duration.zero;
      });
      
      // Hold for 2 seconds
      _holdTimer = Timer(Duration(seconds: 2), () {
        setState(() {
          _instruction = "EXHALE";
        });
        
        // Exhale animation (reverse direction)
        _animation = Tween<double>(begin: 1, end: 0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
        
        _controller.reset();
        _controller.forward().then((_) {
          setState(() {
            _totalDuration += _duration * 2 + Duration(seconds: 2);
            _instruction = "INHALE";
          });
          _startBreathingCycle(); // Repeat the cycle
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
    // Calculate dot position based on angle
    final dotX = _circleRadius * cos(_angle);
    final dotY = _circleRadius * sin(_angle);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Instruction text
            Text(
              _instruction,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            
            // Circular breathing track
            Container(
              width: _circleRadius * 2 + 40,
              height: _circleRadius * 2 + 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circular path
                  Container(
                    width: _circleRadius * 2,
                    height: _circleRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey[800]!,
                        width: 2,
                      ),
                    ),
                  ),
                  
                  // Breathing dot
                  Transform.translate(
                    offset: Offset(dotX, dotY),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.tealAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.tealAccent.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 3,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            
            // Duration display
            Text(
              "Duration: ${_totalDuration.inSeconds} seconds",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            
            // Start/Stop button
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_controller.isAnimating) {
                  _controller.stop();
                  _holdTimer?.cancel();
                  setState(() {});
                } else {
                  _startBreathingCycle();
                }
              },
              child: Text(
                _controller.isAnimating ? "PAUSE" : "RESUME",
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}