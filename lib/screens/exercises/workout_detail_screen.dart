import 'package:fit_life_app_/models/exercise.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final ExercisesClass exercise;
  const WorkoutDetailScreen({super.key, required this.exercise});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 12, right: 20, left: 20, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 30),
              Text(
                '${exercise.type?.toUpperCase() ?? 'WORKOUT'} TRAINING',
                style: GoogleFonts.montserrat(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.logoColor,
                  letterSpacing: 2,
                ),
              ),
              Text(
                exercise.name?.toUpperCase() ?? 'UNKNOWN EXERCISE',
                style: GoogleFonts.poppins(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildTagBadge(
                    context,
                    text: exercise.difficulty?.toUpperCase() ?? 'BEGINNER',
                    icon: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.logoColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _buildTagBadge(
                    context,
                    text: '${exercise.duration ?? 0}M',
                    icon: const Icon(Icons.timer, color: AppColors.titleColor, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _buildImageCollage(context),
              const SizedBox(height: 25),
              _buildStatsRow(exercise),
              const SizedBox(height: 25),
              _buildTargetMuscleSection(exercise),
              const SizedBox(height: 40),
              _buildExecutionGuideHeader(),
              const SizedBox(height: 20),
              _buildExecutionGuideSteps(exercise),
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
          'DETAILS',
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

  Widget _buildTagBadge(BuildContext context, {required String text, required Widget icon}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.widgetcolorbg,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
              letterSpacing: 1,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImageCollage(BuildContext context) {
    // Ideally map these images based on the exercise bodypart
    const String defaultImage = 'assets/images/workout_cate/Shoulder.png';
    return SizedBox(
      height: 300,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  defaultImage,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        defaultImage,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        defaultImage,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ExercisesClass exercise) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('SETS', exercise.prescription?.sets?.toString() ?? '3'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('REPS', exercise.prescription?.reps?.toString() ?? '10-12'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('REST', exercise.prescription?.rest ?? '60s'),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.widgetBG,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.subtitleColor,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget _buildTargetMuscleSection(ExercisesClass exercise) {
    final muscles = exercise.muscleGroup ?? [];
    if (muscles.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.widgetcolorbg,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TARGET MUSCLE',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.subtitleColor,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: muscles.map((muscle) {
              final isPrimary = muscle == muscles.first;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isPrimary ? AppColors.accentColor : AppColors.widgetBG,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  muscle.toUpperCase(),
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildExecutionGuideHeader() {
    return Row(
      children: [
        Container(
          width: 30,
          height: 3,
          decoration: const BoxDecoration(color: AppColors.accentColor),
        ),
        const SizedBox(width: 12),
        Text(
          'EXECUTION GUIDE',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor,
          ),
        ),
      ],
    );
  }

  Widget _buildExecutionGuideSteps(ExercisesClass exercise) {
    final guide = exercise.executionGuide ?? [];
    if (guide.isEmpty) {
      return Text(
        'No execution guide available for this exercise.',
        style: GoogleFonts.poppins(color: Colors.white70),
      );
    }

    return ListView.builder(
      itemCount: guide.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final step = guide[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.widgetBG,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (index + 1).toString().padLeft(2, '0'),
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.15),
                  height: 1.1,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      step.instruction ?? '',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: AppColors.subtitleColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
