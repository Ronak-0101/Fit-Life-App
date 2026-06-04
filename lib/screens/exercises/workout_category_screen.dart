import 'package:fit_life_app_/models/exercise.dart';
import 'package:fit_life_app_/screens/exercises/workout_detail_screen.dart';
import 'package:fit_life_app_/services/exercise_service.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 30),
              _buildFilters(),
              const SizedBox(height: 35),
              _buildExerciseList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.titleColor,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'FIT LIFE',
          style: GoogleFonts.oswald(
            fontSize: 26,
            color: AppColors.logoColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const Spacer(),
        Text(
          categoryLabel.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.subtitleColor,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.widgetBG,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.filter_list_alt, color: AppColors.titleColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'FILTERS',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.titleColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 1,
            height: 25,
            color: Colors.white24,
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.registerTxtField,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'LEVEL : INTERMEDIATE',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.titleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.registerTxtField,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'DURATION',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.titleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList() {
    return FutureBuilder<List<ExercisesClass>>(
      future: ExerciseService.getExerciseByBodyparts(categoryKey),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: AppColors.logoColor),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Could not load workouts right now \n${snapshot.error}',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final exercises = snapshot.data ?? [];

        if (exercises.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'No Workouts available for this category yet...',
                style: GoogleFonts.poppins(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: exercises.length,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return _buildExerciseCard(context, exercise);
          },
        );
      },
    );
  }

  Widget _buildExerciseCard(BuildContext context, ExercisesClass exercise) {
    // Determine image based on category if possible, or use a default one.
    // In a real app, this should probably come from the exercise object.
    String imagePath = 'assets/images/workout_cate/Chest.png'; // Fallback
    if (categoryLabel.toLowerCase().contains('chest')) {
      imagePath = 'assets/images/workout_cate/Chest.png';
    } else if (categoryLabel.toLowerCase().contains('back')) imagePath = 'assets/images/workout_cate/Back.png';
    else if (categoryLabel.toLowerCase().contains('shoulder')) imagePath = 'assets/images/workout_cate/Shoulder.png';
    else if (categoryLabel.toLowerCase().contains('leg')) imagePath = 'assets/images/workout_cate/Leg.png';
    else if (categoryLabel.toLowerCase().contains('core')) imagePath = 'assets/images/workout_cate/Core.png';
    else if (categoryLabel.toLowerCase().contains('tricep')) imagePath = 'assets/images/workout_cate/Tricep.png';
    else if (categoryLabel.toLowerCase().contains('bicep')) imagePath = 'assets/images/workout_cate/Bicep.png';

    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.widgetBG,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        (exercise.type ?? 'Workout').toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    (exercise.name ?? 'Unknown').toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatColumn('DURATION', '${exercise.duration ?? 0} MIN'),
                      const SizedBox(width: 32),
                      _buildStatColumn('CALORIES', '420 KCAL'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutDetailScreen(
                            exercise: exercise,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.accentColor,
                            Color(0xFF8B0000), // Dark red
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'START WORKOUT',
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.subtitleColor,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
