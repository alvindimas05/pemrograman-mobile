import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'explore_screen.dart';
import 'saved_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
    SavedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: Container(
          width: 375,
          height: 812,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          clipBehavior: Clip.none,
          child: _screens[_currentIndex],
        ),
      ),
    );
  }
}
