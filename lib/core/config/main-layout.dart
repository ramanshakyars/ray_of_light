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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: _buildDrawer(context),
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menu'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => _navigateToTab(context, 0),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Talk To Lite'),
            onTap: () => _navigateToTab(context, 1),
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text('Junerlism'),
            onTap: () => _navigateToTab(context, 2),
          ),
          ListTile(
            leading: const Icon(Icons.filter_vintage),
            title: const Text('Breathing'),
            onTap: () => _navigateToTab(context, 3),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.track_changes),
            title: const Text('Goal Tracker'),
            onTap: () {
              context.go('${RouteNames.mainApp}/${RouteNames.goalTracker}');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => _navigateToTab(context, index),
      type: BottomNavigationBarType.fixed, // For more than 3 items
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

    switch (index) {
      case 0:
        context.go('${RouteNames.mainApp}/${RouteNames.home}');
        break;
      case 1:
        context.go('${RouteNames.mainApp}/${RouteNames.talkToLight}');
        break;
      case 2:
        context.go('${RouteNames.mainApp}/${RouteNames.junerlism}');
        break;
      case 3:
        context.go('${RouteNames.mainApp}/${RouteNames.breathingExercise}');
        break;
      case 4:
        context.go('${RouteNames.mainApp}/${RouteNames.goalTracker}');
        break;
    }

    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.pop(context);
    }
  }
}
