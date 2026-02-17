import 'package:fit_life_app_/screens/home/workout_category_screen.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:fit_life_app_/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final categories = AppConstants.bodyparts.entries
        .where((entry) => entry.key != 'all')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final category = categories[index];

          return SizedBox(
            height: 250,
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child:
                      const Icon(Icons.arrow_forward, color: AppColors.primary),
                ),
                title: Text(
                  '${category.value} Workout',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => WorkoutCategoryScreen(
                              categoryLabel: category.value,
                              categoryKey: category.key,
                              )));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
