import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Ray of Light'),
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        // ),
      ),
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
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Talk'),
        BottomNavigationBarItem(
          icon: Icon(Icons.newspaper),
          label: 'Junerlism',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.filter_vintage),
          label: 'Breath',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Goal'),
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
    ];

    context.push('${RouteNames.mainApp}/${routes[index]}');

    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.pop(context);
    }
  }
}
