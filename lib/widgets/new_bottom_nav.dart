import 'package:fit_life_app_/utils/app_colors.dart';
import 'package:flutter/material.dart';
// import '../utils/app_colors.dart';

class GymBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GymBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isActive = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.logoColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 5),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.logoColor : Colors.grey,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        border: const Border(
          top: BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        children: [
          _navItem(icon: Icons.fitness_center, label: "Workouts", index: 0),
          _navItem(icon: Icons.layers, label: "Splits", index: 1),
          _navItem(icon: Icons.restaurant, label: "Nutrition", index: 2),
          _navItem(icon: Icons.show_chart, label: "Progress", index: 3),
          _navItem(icon: Icons.person, label: "Profile", index: 4),
        ],
      ),
    );
  }
}