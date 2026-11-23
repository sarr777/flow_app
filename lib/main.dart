import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_nav_bar.dart';
import 'screens/tasks_screen.dart';
import 'screens/habits_screen.dart';
import 'screens/focus_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const FlowApp());
}

class FlowApp extends StatelessWidget {
  const FlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLOW',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final List<String> titles = [
    'FLOW',
    'Mes tâches',
    'Mes habitudes',
    'Focus',
    'Mon profil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex == 0
          ? null
          : AppBar(
              title: Text(
                titles[currentIndex],
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
      body: currentIndex == 0
    ? const HomeScreen()
    : currentIndex == 1
        ? const TasksScreen()
        : currentIndex == 2
            ? const HabitsScreen()
            : currentIndex == 3
                ? const FocusScreen()
                : const ProfileScreen(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}