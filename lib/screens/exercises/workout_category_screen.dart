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
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppColors.background,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.titleColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$categoryLabel Workouts',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.logoColor,
                          // letterSpacing: 2,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        textAlign: TextAlign.left,
                        'FIT LIFE',
                        style: GoogleFonts.oswald(
                          fontSize: 30,
                          color: AppColors.logoColor,
                          fontWeight: FontWeight.bold,
                          // letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.widgetBG,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.filter_list_alt,
                                    color: AppColors.titleColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'FILTERS',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: AppColors.titleColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 1,
                            height: 25,
                            decoration:
                                const BoxDecoration(color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.registerTxtField,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text(
                                    'LEVEL : INTERMEDIATE',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: AppColors.titleColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.registerTxtField,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text(
                                    'DURATION',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: AppColors.titleColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  FutureBuilder<List<ExercisesClass>>(
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
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(5),
                        itemCount: exercises.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                // color: AppColors.logoColor,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.grey.shade900,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Stack(
                                children: [
                                  ClipRect(
                                    child: Image.asset(
                                      'assets/images/workout_cate/Chest.png',
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                      // height: ,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(13),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.textSecondary
                                                    .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    exercise.type.toString()),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          textAlign: TextAlign.left,
                                          exercises[index].name.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: AppColors.titleColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'DURATION',
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.subtitleColor,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                                Text(
                                                  '${exercise.duration}MIN',
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 17,
                                                    color: AppColors.titleColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(width: 20),
                                            Column(
                                              children: [
                                                Text(
                                                  'CALORIES',
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.subtitleColor,
                                                    letterSpacing: 1,
                                                  ),
                                                ),
                                                Text(
                                                  '420 KCAL',
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 17,
                                                    color: AppColors.logoColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    WorkoutDetailScreen(
                                                      exercise: exercise,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  end: Alignment.centerRight,
                                                  begin: Alignment.centerLeft,
                                                  colors: [
                                                    AppColors.accentColor,
                                                    Color.fromARGB(
                                                        255, 111, 29, 29)
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'START WORKOUT',
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.titleColor,
                                                    letterSpacing: 5,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                const Icon(
                                                  Icons.play_arrow,
                                                  color: AppColors.titleColor,
                                                ),
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
                        },
                      );
                    },
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
