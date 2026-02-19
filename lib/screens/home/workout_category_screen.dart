import 'package:fit_life_app_/models/exercise.dart';
import 'package:fit_life_app_/screens/home/workout_detail_screen.dart';
import 'package:fit_life_app_/services/exercise_service.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:flutter/material.dart';

class WorkoutCategoryScreen extends StatelessWidget {
  final String categoryLabel;
  final String categoryKey;

  const WorkoutCategoryScreen({
    super.key,
    required this.categoryLabel,
    required this.categoryKey,
  }); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryLabel Workouts'),
      ),
      body: FutureBuilder<List<Exercise>>(
        future: ExerciseService.getExerciseByBodyparts(categoryKey),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Could not load workout right now \n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final exercises = snapshot.data ?? [];

          if (exercises.isEmpty) {
            return const Center(
              child: Text(
                'No Workouts available for this category yet...',
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: exercises.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    child: const Icon(
                      Icons.fitness_center,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    exercise.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${exercise.type} • ${exercise.difficulty}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WorkoutDetailScreen(),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
