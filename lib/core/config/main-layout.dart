import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/social-insights/social-feedPage.dart';
import 'package:rayoflite/presentation/screens/features/talk-to-lite/chat_screen.dart';
import 'package:rayoflite/presentation/screens/features/journalism/junerlism.dart';
import 'package:rayoflite/presentation/screens/features/breathing/breathing.dart';
import 'package:rayoflite/presentation/screens/features/goal-tracker/goal-tracker.dart';

class MainScreen extends StatefulWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  /// 🔹 GLOBAL TAB NAVIGATION (AppBar / anywhere)
  static void goToTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainScreenState>();
    state?._jumpToTab(index);
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;

  late AnimationController _pulseController;
  late AnimationController _rotateController;

  /// 🔹 ALL MAIN TABS
  final List<Widget> _tabs = const [
    SocialFeedPage(), // 0 Home
    ChatScreen(chatId: null), // 1 Talk
    JournalismScreen(), // 2 Nest
    BreathingScreen(), // 3 Breath
    GoalTrackerExercises(), // 4 Wishes
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentIndex);

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
    _pageController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // 🔹 TAB CHANGE LOGIC
  // ---------------------------------------------------------------------------

  /// BottomNav / Drawer → INSTANT jump (NO animation)
  void _jumpToTab(int index) {
    if (_currentIndex == index) return;

    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  /// Swipe → Animated (handled automatically)
  void _onSwipe(int index) {
    setState(() => _currentIndex = index);
  }

  // ---------------------------------------------------------------------------
  // 🔹 UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final isProfilePage = location.contains(RouteNames.profile);

    return Scaffold(
      body:
          isProfilePage
              ? widget
                  .child // 🔥 PROFILE / OTHER NON-TAB PAGES
              : PageView(
                controller: _pageController,
                onPageChanged: _onSwipe,
                children: _tabs,
              ),
      bottomNavigationBar: isProfilePage ? null : _buildBottomNav(),
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

  BottomNavigationBar _buildBottomNav() {
    final isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _jumpToTab, // 🔥 IMPORTANT
      selectedItemColor: AppColors.slectedBottomIconColor,
      unselectedItemColor: AppColors.getIconColor(isDarkMode),
      backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          label: 'Talk',
          icon: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _rotateController,
                builder: (_, child) => Transform.rotate(
                  angle: _rotateController.value * 6.28,
                  child: child,
                ),
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
                child: const Icon(Icons.auto_awesome, color: Colors.white),
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
