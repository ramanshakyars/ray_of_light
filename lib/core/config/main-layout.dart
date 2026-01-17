import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  late final List<String> _routes;

  late AnimationController _pulseController;
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();

    _routes = [
      RouteNames.home,
      RouteNames.talkToLight,
      RouteNames.junerlism,
      RouteNames.breathingExercise,
      RouteNames.goalTracker,
    ];

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;

          // 👉 Swipe Left → Next tab
          if (velocity < -300) {
            _goNext();
          }

          // 👉 Swipe Right → Previous tab
          if (velocity > 300) {
            _goPrevious();
          }
        },
        child: widget.child,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ------------------ NAVIGATION LOGIC ------------------

  void _goNext() {
    if (_currentIndex < _routes.length - 1) {
      _navigateToTab(context, _currentIndex + 1);
    }
  }

  void _goPrevious() {
    if (_currentIndex > 0) {
      _navigateToTab(context, _currentIndex - 1);
    }
  }

  void _navigateToTab(BuildContext context, int index) {
    setState(() => _currentIndex = index);
    context.push('${RouteNames.mainApp}/${_routes[index]}');
  }

  // ------------------ BOTTOM NAV ------------------

  BottomNavigationBar _buildBottomNavigationBar() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => _navigateToTab(context, index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.slectedBottomIconColor,
      unselectedItemColor: AppColors.getIconColor(isDarkMode),
      backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          label: 'Talk',
          icon: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _rotateController,
                builder: (_, child) => Transform.rotate(
                  angle: _rotateController.value * 2 * 3.1416,
                  child: child,
                ),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Color.fromARGB(25, 35, 74, 246),
                        Color.fromARGB(25, 210, 47, 239),
                      ],
                      stops: [0.1, 1.0],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              ScaleTransition(
                scale: Tween(begin: 0.9, end: 1.1).animate(
                  CurvedAnimation(
                    parent: _pulseController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.newspaper),
          label: 'Nest',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.filter_vintage),
          label: 'Breath',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Wishes',
        ),
      ],
    );
  }
}
