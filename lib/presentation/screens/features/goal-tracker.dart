import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';

class GoalTrackerExcerises extends StatelessWidget {
  const GoalTrackerExcerises({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Your Goals', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0))),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        elevation: 10,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: Icon(Icons.menu, color: const Color.fromARGB(255, 0, 0, 0)),
        //   onPressed: () {},
        // ),
        actions: [
          IconButton(
            icon: Image.asset('assets/logo.png'),
            onPressed: () {
              GoRouter.of(
                context,
              ).push('${RouteNames.mainApp}/${RouteNames.home}');
            },
          ),
        ],
      ),
      body: const Center(child: Text('')),
    );
  }
}
