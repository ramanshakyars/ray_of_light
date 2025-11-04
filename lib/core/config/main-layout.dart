import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();
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
      key: _scaffoldKey,
      // appBar: AppBar(
      // title: const Text('Ray of Light'),
      // leading: IconButton(
      //   icon: const Icon(Icons.menu),
      //   onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      // ),
      // ),
      // drawer: _buildDrawer(context),
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // Drawer _buildDrawer(BuildContext context) {
  //   return Drawer(
  //     child: ListView(
  //       children: [
  //         const DrawerHeader(
  //           decoration: BoxDecoration(color: Colors.blue),
  //           child: Text('Menu'),
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.home),
  //           title: const Text('Home'),
  //           onTap: () => _navigateToTab(context, 0),
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.chat),
  //           title: const Text('Talk To Lite'),
  //           onTap: () => _navigateToTab(context, 1),
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.newspaper),
  //           title: const Text('Junerlism'),
  //           onTap: () => _navigateToTab(context, 2),
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.filter_vintage),
  //           title: const Text('Breathing'),
  //           onTap: () => _navigateToTab(context, 3),
  //         ),
  //         const Divider(),
  //         ListTile(
  //           leading: const Icon(Icons.track_changes),
  //           title: const Text('Goal Tracker'),
  //           onTap: () {
  //             context.push('${RouteNames.mainApp}/${RouteNames.goalTracker}');
  //             Navigator.pop(context);
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.logout),
  //           title: const Text('Logout'),
  //           onTap: () {
  //             context.push('${RouteNames.login}');
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => _navigateToTab(context, index),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Stack(
            alignment: Alignment.center,
            children: [
              // Glass circle background
              AnimatedBuilder(
                animation: _rotateController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotateController.value * 2 * 3.1416,
                    child: child,
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color.fromARGB(25, 35, 74, 246),
                        const Color.fromARGB(25, 210, 47, 239),
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
              // Pulsing chat icon with neon effect
              ScaleTransition(
                scale: Tween(begin: 0.9, end: 1.1).animate(
                  CurvedAnimation(
                    parent: _pulseController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                    ).createShader(bounds);
                  },
                  child: Icon(Icons.chat, size: 28, color: Colors.white),
                ),
              ),
              // AI badge with glow
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.8),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    'AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          label: 'Talk',
        ),

        BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'Nest'),
        BottomNavigationBarItem(
          icon: Icon(Icons.filter_vintage),
          label: 'Breath',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.track_changes),
          label: 'Wishes',
        ),
        // BottomNavigationBarItem(icon: Icon(Icons.person_pin), label: 'Profile'),
      ],
    );
  }

  void _navigateToTab(BuildContext context, int index) {
    setState(() => _currentIndex = index);
    final routes = [
      RouteNames.home,
      RouteNames.talkToLight,
      RouteNames.junerlism,
      RouteNames.breathingExercise,
      RouteNames.goalTracker,
      // RouteNames.profile,
    ];
    context.push('${RouteNames.mainApp}/${routes[index]}');
    // if (Scaffold.of(context).isDrawerOpen) {
    //   Navigator.pop(context);
    // }
  }
}
