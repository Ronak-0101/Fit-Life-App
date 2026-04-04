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
      // appBar: AppBar(
      //   title: const Text('All Workouts'),
      //   backgroundColor: Colors.grey.shade400,
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
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
                    ),
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
                    // SizedBox(height: 5),
                    Text(
                      'CATEGORIES',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.titleColor,
                        // letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                        prefixIcon: const Icon(
                          Icons.search,
                        ),
                        prefixIconColor: AppColors.textSecondary,
                        hintText: 'FIND YOUR TARGET',
                        hintStyle: GoogleFonts.poppins(
                          color: AppColors.textSecondary,
                          // letterSpacing: 2,
                        ),
                        fillColor: AppColors.registerTxtField,
                      ),
                      style: const TextStyle(
                        color: AppColors.accentColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Handle tap event
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkoutCategoryScreen(
                              categoryLabel: categories[0].value,
                              categoryKey: categories[0].key,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 210,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Image.asset(
                                "assets/images/workout_cate/Chest.png",
                                // fit: BoxFit.cover
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, bottom: 10),
                                child: Text(
                                  categories[0].value.toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.titleColor,
                                    // letterSpacing: 2,
                                  ),
                                  // textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WorkoutCategoryScreen(
                                  categoryLabel: categories[1].value,
                                  categoryKey: categories[1].key,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 210,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Image.asset(
                                    "assets/images/workout_cate/Back.png",
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, bottom: 10),
                                    child: Text(
                                      categories[1].value.toUpperCase(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.titleColor,
                                        // letterSpacing: 2,
                                      ),
                                      // textAlign: TextAlign.end,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WorkoutCategoryScreen(
                                  categoryLabel: categories[3].value,
                                  categoryKey: categories[3].key,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 210,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Image.asset(
                                    "assets/images/workout_cate/Shoulder.png",
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, bottom: 10),
                                    child: Text(
                                      categories[3].value.toUpperCase(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.titleColor,
                                        // letterSpacing: 2,
                                      ),
                                      // textAlign: TextAlign.end,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WorkoutCategoryScreen(
                                  categoryLabel: categories[4].value,
                                  categoryKey: categories[4].key,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 210,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Image.asset(
                                  "assets/images/workout_cate/Tricep.png",
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 10),
                                  child: Text(
                                    categories[4].value.toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.titleColor,
                                      // letterSpacing: 2,
                                    ),
                                    // textAlign: TextAlign.end,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WorkoutCategoryScreen(
                                  categoryLabel: categories[5].value,
                                  categoryKey: categories[5].key,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 210,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Image.asset(
                                  "assets/images/workout_cate/Bicep.png",
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 10),
                                  child: Text(
                                    categories[5].value.toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.titleColor,
                                      // letterSpacing: 2,
                                    ),
                                    // textAlign: TextAlign.end,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkoutCategoryScreen(
                              categoryLabel: categories[2].value,
                              categoryKey: categories[2].key,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 210,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30)),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Image.asset(
                              "assets/images/workout_cate/Leg.png",
                              width: MediaQuery.of(context).size.width,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              child: Text(
                                categories[2].value.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.titleColor,
                                  // letterSpacing: 2,
                                ),
                                // textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkoutCategoryScreen(
                              categoryLabel: categories[6].value,
                              categoryKey: categories[6].key,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 215,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Image.asset(
                              "assets/images/workout_cate/Core.png",
                              width: MediaQuery.of(context).size.width,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              child: Text(
                                categories[6].value.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.titleColor,
                                  // letterSpacing: 2,
                                ),
                                // textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100)

                    // SingleChildScrollView(
                    //   child: SizedBox(
                    //     height: MediaQuery.of(context).size.height,
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         gradient: LinearGradient(
                    //           end: Alignment.bottomRight,
                    //           begin: Alignment.topLeft,
                    //           colors: [
                    //             AppColors.primary.withOpacity(0.2),
                    //             AppColors.secondary.withOpacity(0.2)
                    //           ],
                    //         ),
                    //       ),
                    //       child: ListView.separated(
                    //         padding: const EdgeInsets.all(16),
                    //         itemCount: categories.length,
                    //         separatorBuilder: (_, __) => const SizedBox(height: 12),
                    //         itemBuilder: (context, index) {
                    //           final category = categories[index];

                    //           return SizedBox(
                    //             height: 150,
                    //             child: Card(
                    //               child: ListTile(
                    //                 contentPadding:
                    //                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    //                 leading: CircleAvatar(
                    //                   backgroundColor: AppColors.primary.withOpacity(0.15),
                    //                   child: const Icon(
                    //                     Icons.arrow_forward,
                    //                     color: AppColors.primary,
                    //                   ),
                    //                 ),
                    //                 title: Text(
                    //                   '${category.value} Workout',
                    //                   style: const TextStyle(fontWeight: FontWeight.bold),
                    //                 ),
                    //                 trailing: const Icon(Icons.chevron_right),
                    //                 onTap: () {
                    //                   Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                       builder: (_) => WorkoutCategoryScreen(
                    //                         categoryLabel: category.value,
                    //                         categoryKey: category.key,
                    //                       ),
                    //                     ),
                    //                   );
                    //                 },
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
