import 'package:fit_life_app_/screens/exercises/workout_category_screen.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:fit_life_app_/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExerciseCategoriesScreen extends StatefulWidget {
  const ExerciseCategoriesScreen({super.key});

  @override
  State<ExerciseCategoriesScreen> createState() =>
      _ExerciseCategoriesScreenState();
}

class _ExerciseCategoriesScreenState extends State<ExerciseCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final categories = AppConstants.bodyparts.entries
        .where((entry) => entry.key != 'all')
        .toList();

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
              Text(
                'TRAINING LAB',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.logoColor,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'CATEGORIES',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.titleColor,
                ),
              ),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildFullWidthCategory(
                context,
                title: categories[0].value, // Chest
                imagePath: "assets/images/workout_cate/Chest.png",
                onTap: () => _navigateToCategory(context, categories[0]),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildHalfWidthCategory(
                      context,
                      title: categories[1].value, // Back
                      imagePath: "assets/images/workout_cate/Back.png",
                      onTap: () => _navigateToCategory(context, categories[1]),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildHalfWidthCategory(
                      context,
                      title: categories[3].value, // Shoulders
                      imagePath: "assets/images/workout_cate/Shoulder.png",
                      onTap: () => _navigateToCategory(context, categories[3]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildHalfWidthCategory(
                      context,
                      title: categories[4].value, // Triceps
                      imagePath: "assets/images/workout_cate/Tricep.png",
                      onTap: () => _navigateToCategory(context, categories[4]),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildHalfWidthCategory(
                      context,
                      title: categories[5].value, // Biceps
                      imagePath: "assets/images/workout_cate/Bicep.png",
                      onTap: () => _navigateToCategory(context, categories[5]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFullWidthCategory(
                context,
                title: categories[2].value, // Legs
                imagePath: "assets/images/workout_cate/Leg.png",
                onTap: () => _navigateToCategory(context, categories[2]),
              ),
              const SizedBox(height: 16),
              _buildFullWidthCategory(
                context,
                title: categories[6].value, // Core
                imagePath: "assets/images/workout_cate/Core.png",
                onTap: () => _navigateToCategory(context, categories[6]),
              ),
              const SizedBox(height: 100), // padding for bottom nav
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
          'LIBRARY',
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

  Widget _buildSearchBar() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
        hintText: 'FIND YOUR TARGET',
        hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
        fillColor: AppColors.registerTxtField,
        filled: true,
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  void _navigateToCategory(BuildContext context, MapEntry<String, String> category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutCategoryScreen(
          categoryLabel: category.value,
          categoryKey: category.key,
        ),
      ),
    );
  }

  Widget _buildFullWidthCategory(
    BuildContext context, {
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.widgetBG, // Fallback color
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.bottomLeft,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0.0, 0.5],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 20),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHalfWidthCategory(
    BuildContext context, {
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.widgetBG,
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
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0.0, 0.5],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 16),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
