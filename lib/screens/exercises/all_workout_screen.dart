import 'package:fit_life_app_/models/exercise.dart';
import 'package:fit_life_app_/screens/exercises/workout_detail_screen.dart';
import 'package:fit_life_app_/services/exercise_service.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:fit_life_app_/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllWorkoutScreen extends StatefulWidget {
  const AllWorkoutScreen({super.key});

  @override
  State<AllWorkoutScreen> createState() => _AllWorkoutScreenState();
}

class _AllWorkoutScreenState extends State<AllWorkoutScreen> {
  late final Future<List<ExercisesClass>> _exercisesFuture;
  final TextEditingController _searchController = TextEditingController();
  String _selectedBodyPart = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _exercisesFuture = ExerciseService.getAllExercises();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildSearchField(),
            _buildCategoryChips(),
            Expanded(
              child: FutureBuilder<List<ExercisesClass>>(
                future: _exercisesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.logoColor,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return _buildMessage(
                      icon: Icons.error_outline,
                      title: 'Unable to load workouts',
                      subtitle: snapshot.error.toString(),
                    );
                  }

                  final exercises = _filteredExercises(snapshot.data ?? []);

                  if (exercises.isEmpty) {
                    return _buildMessage(
                      icon: Icons.search_off_rounded,
                      title: 'No workouts found',
                      subtitle: 'Try a different search or category.',
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: exercises.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return _WorkoutCard(
                        exercise: exercises[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkoutDetailScreen(
                                exercise: exercises[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.widgetBG,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.titleColor,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workout Library',
                  style: GoogleFonts.oswald(
                    fontSize: 27,
                    color: AppColors.logoColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Find the right move for today',
                  style: GoogleFonts.poppins(
                    color: AppColors.subtitleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _searchController,
        cursorColor: AppColors.logoColor,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.widgetBG,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(18),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          prefixIcon: const Icon(Icons.search_rounded),
          prefixIconColor: AppColors.textSecondary,
          suffixIcon: _searchQuery.isEmpty
              ? null
              : IconButton(
                  onPressed: _searchController.clear,
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.textSecondary,
                ),
          hintText: 'Search workouts',
          hintStyle: GoogleFonts.poppins(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        style: GoogleFonts.poppins(
          color: AppColors.titleColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = AppConstants.bodyparts.entries.toList();

    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedBodyPart == category.key;

          return ChoiceChip(
            selected: isSelected,
            showCheckmark: false,
            label: Text(
              category.key == 'all' ? 'All' : category.value,
              overflow: TextOverflow.ellipsis,
            ),
            onSelected: (_) {
              setState(() => _selectedBodyPart = category.key);
            },
            backgroundColor: AppColors.widgetBG,
            selectedColor: AppColors.logoColor,
            side: BorderSide(
              color: isSelected ? AppColors.logoColor : Colors.white10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 12),
            labelStyle: GoogleFonts.poppins(
              color: AppColors.titleColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.logoColor, size: 42),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.titleColor,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: AppColors.subtitleColor,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ExercisesClass> _filteredExercises(List<ExercisesClass> exercises) {
    final query = _searchQuery.toLowerCase();

    return exercises.where((exercise) {
      final matchesCategory = _selectedBodyPart == 'all' ||
          exercise.bodyPart?.toLowerCase() == _selectedBodyPart;

      final searchableText = [
        exercise.name,
        exercise.bodyPart,
        exercise.type,
        exercise.difficulty,
        ...(exercise.muscleGroup ?? []),
      ].whereType<String>().join(' ').toLowerCase();

      return matchesCategory &&
          (query.isEmpty || searchableText.contains(query));
    }).toList();
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({
    required this.exercise,
    required this.onTap,
  });

  final ExercisesClass exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.widgetBG,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                _imagePath,
                width: 92,
                height: 92,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          (exercise.bodyPart ?? 'Workout').toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            color: AppColors.logoColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      if (exercise.difficulty != null) ...[
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            exercise.difficulty!.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              color: AppColors.subtitleColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    exercise.name ?? 'Untitled Workout',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppColors.titleColor,
                      fontSize: 16,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _InfoPill(
                        icon: Icons.timer_rounded,
                        label: '${exercise.duration ?? 0} min',
                      ),
                      _InfoPill(
                        icon: Icons.local_fire_department_rounded,
                        label: '${exercise.averageCaloriesBurned ?? 0} kcal',
                        iconColor: AppColors.logoColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.registerTxtField,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.titleColor,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _imagePath {
    final bodyPart = exercise.bodyPart?.toLowerCase() ?? '';

    if (bodyPart.contains('chest')) {
      return 'assets/images/workout_cate/Chest.png';
    }
    if (bodyPart.contains('back')) {
      return 'assets/images/workout_cate/Back.png';
    }
    if (bodyPart.contains('shoulder')) {
      return 'assets/images/workout_cate/Shoulder.png';
    }
    if (bodyPart.contains('leg')) {
      return 'assets/images/workout_cate/Leg.png';
    }
    if (bodyPart.contains('core')) {
      return 'assets/images/workout_cate/Core.png';
    }
    if (bodyPart.contains('tricep')) {
      return 'assets/images/workout_cate/Tricep.png';
    }
    if (bodyPart.contains('bicep')) {
      return 'assets/images/workout_cate/Bicep.png';
    }

    return 'assets/images/slider_img/all_workout.jpeg';
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
    this.iconColor = AppColors.textSecondary,
  });

  final IconData icon;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.subtitleColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
