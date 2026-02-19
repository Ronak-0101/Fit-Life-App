import 'package:fit_life_app_/screens/Splits/create_splits.dart';
import 'package:fit_life_app_/screens/exercises/all_exercises_screen.dart';
import 'package:fit_life_app_/screens/exercises/workout_category_screen.dart';
import 'package:fit_life_app_/screens/nutrition/nutrition_screen.dart';
import 'package:fit_life_app_/screens/profile/profile_screen.dart';
import 'package:fit_life_app_/screens/progress/progress_screen.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:fit_life_app_/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final categories = AppConstants.bodyparts.entries
    //     .where((entry) => entry.key != 'all')
    //     .toList();
    const screens = [
      AllExercisesScreen(),
      CreateSplits(),
      NutritionScreen(),
      ProgressScreen(),
      ProfileScreen(),
    ];

    //
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 0,
        height: 85,
        surfaceTintColor: Colors.transparent,
        // indicatorColor: AppColors.primary.withOpacity(0.1),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        backgroundColor: AppColors.primary.withOpacity(0.1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'All Workouts',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_customize_outlined),
            selectedIcon: Icon(Icons.dashboard_customize),
            label: "Create Splits",
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: "Nutrition",
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: "Progress",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          )
        ],
      ),
    );
  }
}
