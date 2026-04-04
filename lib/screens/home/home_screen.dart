import 'package:fit_life_app_/models/slider_model.dart';
import 'package:fit_life_app_/screens/Splits/create_splits.dart';
import 'package:fit_life_app_/screens/exercises/Exercise_categories.dart';
// import 'package:fit_life_app_/screens/exercises/all_exercises_screen.dart';
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
      title: "All Workouts",
      subtitle: 'POWER UP',
      image: "assets/images/slider_img/all_workout.jpeg",
      screen: const ExerciseCategoriesScreen(),
    ),
    SliderItem(
      title: "Create Splits",
      subtitle: "CUSTOM FIT",
      image: "assets/images/slider_img/split.jpeg",
      screen: const CreateSplits(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(viewportFraction: 1);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppColors.background,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(50)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        textAlign: TextAlign.left,
                        'FIT LIFE',
                        style: GoogleFonts.oswald(
                          fontSize: 30,
                          color: AppColors.logoColor,
                          fontWeight: FontWeight.bold,
                          // letterSpacing: 4,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'READY TO DOMINATE',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      // fontWeight: FontWeight.bold,
                      color: AppColors.subtitleColor,
                      letterSpacing: 1,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Let's crush today's goals, ",
                      style: GoogleFonts.montserrat(
                        color: AppColors.titleColor,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Alex',
                          style: TextStyle(
                            color: AppColors.logoColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      prefixIconColor: AppColors.subtitleColor,
                      hintText: 'Search workouts or plans',
                      hintStyle: TextStyle(color: AppColors.subtitleColor),
                      fillColor: AppColors.registerTxtField,
                    ),
                    style: const TextStyle(
                      color: AppColors.accentColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: sliderItems.length,
                      itemBuilder: (context, index) {
                        final item = sliderItems[index];
              
                        return Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => item.screen,
                                ),
                              );
                            },
                            child: _buildCard(item),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.33,
                            decoration: BoxDecoration(
                              color: AppColors.widgetBG.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade900),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    color: AppColors.logoColor,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'CALORIES',
                                    style: GoogleFonts.montserrat(
                                        color: AppColors.subtitleColor,
                                        letterSpacing: 1),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: "1,420",
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.titleColor),
                                      children: [
                                        TextSpan(
                                          text: ' kcal',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 20,
                                              color: AppColors.subtitleColor,
                                              letterSpacing: 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.33,
                            decoration: BoxDecoration(
                                color: AppColors.widgetBG.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.grey.shade900)),
                            child: Padding(
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    color: AppColors.logoColor,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'STREAK',
                                    style: GoogleFonts.montserrat(
                                        color: AppColors.subtitleColor,
                                        letterSpacing: 1),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: "12",
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.titleColor),
                                      children: [
                                        TextSpan(
                                          text: ' days',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 20,
                                              color: AppColors.subtitleColor,
                                              letterSpacing: 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            // height: MediaQuery.of(context).size.height * 0.33,
                            decoration: BoxDecoration(
                              color: AppColors.widgetBG.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade900),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    color: AppColors.logoColor,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'WATER',
                                    style: GoogleFonts.montserrat(
                                        color: AppColors.subtitleColor,
                                        letterSpacing: 1),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: "2.5",
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.titleColor),
                                      children: [
                                        TextSpan(
                                          text: ' L',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 20,
                                              color: AppColors.subtitleColor,
                                              letterSpacing: 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            // height: MediaQuery.of(context).size.height * 0.33,
                            decoration: BoxDecoration(
                                color: AppColors.widgetBG.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.grey.shade900)),
                            child: Padding(
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    color: AppColors.logoColor,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'WEIGHT',
                                    style: GoogleFonts.montserrat(
                                        color: AppColors.subtitleColor,
                                        letterSpacing: 1),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: "84.5",
                                      style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.titleColor),
                                      children: [
                                        TextSpan(
                                          text: ' kg',
                                          style: GoogleFonts.montserrat(
                                              fontSize: 20,
                                              color: AppColors.subtitleColor,
                                              letterSpacing: 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Text(
                              "Today's plan",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'VIEW ALL',
                              style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        color: AppColors.widgetBG.withOpacity(0.6),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.logoColor.withOpacity(0.2),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Icon(
                                  Icons.fitness_center,
                                  color: AppColors.logoColor,
                                ),
                              ),
                            ),
                            title: const Text(
                              "Uper Body Power",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor,
                              ),
                            ),
                            subtitle: const Text(
                              '45 min - Hypertrophy',
                              style: TextStyle(
                                color: AppColors.subtitleColor,
                                fontSize: 12,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Card(
                        color: AppColors.widgetBG.withOpacity(0.6),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.logoColor.withOpacity(0.2),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(15),
                                child: Icon(
                                  Icons.fitness_center,
                                  color: AppColors.logoColor,
                                ),
                              ),
                            ),
                            title: const Text(
                              "Uper Body Power",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titleColor,
                              ),
                            ),
                            subtitle: const Text(
                              '45 min - Hypertrophy',
                              style: TextStyle(
                                color: AppColors.subtitleColor,
                                fontSize: 12,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 90)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildCard(SliderItem item) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      image: DecorationImage(
        image: AssetImage(item.image),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.6),
            Colors.transparent,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          item.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
