import 'package:fit_life_app_/models/slider_model.dart';
import 'package:fit_life_app_/screens/exercises/Exercise_categories.dart';
import 'package:fit_life_app_/screens/exercises/all_workout_screen.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<SliderItem> sliderItems = [
    SliderItem(
      title: "Exercises",
      subtitle: 'POWER UP',
      image: "assets/images/slider_img/all_workout.jpeg",
      screen: const ExerciseCategoriesScreen(),
    ),
    SliderItem(
      title: "All Workouts",
      subtitle: "CUSTOM FIT",
      image: "assets/images/slider_img/split.jpeg",
      screen: const AllWorkoutScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(viewportFraction: 0.9);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 25),
              _buildWelcomeText(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildSlider(pageController),
              const SizedBox(height: 25),
              _buildStatsGrid(),
              const SizedBox(height: 25),
              _buildTodaysPlanHeader(),
              const SizedBox(height: 10),
              _buildTodaysPlanList(),
              const SizedBox(height: 90), // padding for bottom nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 24),
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
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'READY TO DOMINATE',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: AppColors.subtitleColor,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            text: "Let's crush today's goals, ",
            style: GoogleFonts.montserrat(
              color: AppColors.titleColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            children: const [
              TextSpan(
                text: 'Alex',
                style: TextStyle(
                  color: AppColors.logoColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        prefixIcon: const Icon(Icons.search, color: AppColors.subtitleColor),
        hintText: 'Search workouts or plans',
        hintStyle: const TextStyle(color: AppColors.subtitleColor, fontSize: 14),
        fillColor: AppColors.registerTxtField,
        filled: true,
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildSlider(PageController controller) {
    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: controller,
        itemCount: sliderItems.length,
        padEnds: false,
        itemBuilder: (context, index) {
          final item = sliderItems[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item.screen),
                );
              },
              child: _buildSliderCard(item),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliderCard(SliderItem item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(item.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: const [0.0, 0.6],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.subtitle,
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('CALORIES', '1,420', 'kcal')),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('STREAK', '12', 'days')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard('WATER', '2.5', 'L')),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('WEIGHT', '84.5', 'kg')),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.widgetBG,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.local_fire_department, color: AppColors.logoColor, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: AppColors.subtitleColor,
              fontSize: 10,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: ' $unit',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: AppColors.subtitleColor,
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

  Widget _buildTodaysPlanHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "Today's plan",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'VIEW ALL',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.logoColor,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysPlanList() {
    return Column(
      children: [
        _buildPlanCard("Upper Body Power", "45 min - Hypertrophy"),
        const SizedBox(height: 12),
        _buildPlanCard("Core Finisher", "15 min - Endurance"),
      ],
    );
  }

  Widget _buildPlanCard(String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.widgetBG,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.logoColor.withOpacity(0.15),
          ),
          child: const Icon(Icons.fitness_center, color: AppColors.logoColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.subtitleColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}
