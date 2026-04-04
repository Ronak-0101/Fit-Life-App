import 'package:fit_life_app_/screens/Splits/create_splits.dart';
// import 'package:fit_life_app_/screens/home/app_bottom_nav_bar.dart';
import 'package:fit_life_app_/screens/home/home_screen.dart';
import 'package:fit_life_app_/widgets/new_bottom_nav.dart';
import 'package:fit_life_app_/screens/nutrition/nutrition_screen.dart';
import 'package:fit_life_app_/screens/profile/profile_screen.dart';
import 'package:fit_life_app_/screens/progress/progress_screen.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // int _selectedIndex = 0;
  // final int _activeSlide = 0;
  // late final PageController _sliderController;

  // static const List<_QuickSlideItem> _quickSlides = [
  //   _QuickSlideItem(
  //     imageUrl:
  //         'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=1200&q=80',
  //     tabIndex: 0,
  //     semanticLabel: 'All Workout Slide',
  //   ),
  //   _QuickSlideItem(
  //     imageUrl:
  //         'https://images.unsplash.com/photo-1534367507873-d2d7e24c797f?auto=format&fit=crop&w=1200&q=80',
  //     tabIndex: 1,
  //     semanticLabel: 'Create splits slide',
  //   ),
  //   _QuickSlideItem(
  //     imageUrl:
  //         'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1200&q=80',
  //     tabIndex: 2,
  //     semanticLabel: 'Nutrition Slide',
  //   ),
  //   _QuickSlideItem(
  //     imageUrl:
  //         'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=1200&q=80',
  //     tabIndex: 3,
  //     semanticLabel: 'Progress Slide',
  //   ),
  // ];
  late int _selectedIndex;

  // @override
  // void initState() {
  //   super.initState();
  //   _sliderController = PageController(viewportFraction: 0.9);
  // }
  static const List<Widget> _screens = [
    HomeScreen(),
    CreateSplits(),
    NutritionScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  // @override
  // void dispose() {
  //   _sliderController.dispose();
  //   super.dispose();
  // }

  // void _onSlideAction(int tabIndex) {
  //   setState(() {
  //     _selectedIndex = tabIndex;
  //   });
  // }
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, _screens.length - 1);
  }

  // void _moveSlide(int direction) {
  //   final nextSlide =
  //       (_activeSlide + direction).clamp(0, _quickSlides.length - 1);
  //   _sliderController.animateToPage(
  //     nextSlide,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeOut,
  //   );
  // }
  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final categories = AppConstants.bodyparts.entries
    //     .where((entry) => entry.key != 'all')
    //     .toList();
    // const screens = [
    // AllExercisesScreen(),
    // BottomNavBar(),
    //   HomeScreen(),
    //   CreateSplits(),
    //   NutritionScreen(),
    //   ProgressScreen(),
    //   ProfileScreen(),

    // ];

    // final contentStack = IndexedStack(
    //   index: _selectedIndex,
    //   children: screens,
    // );

    return SafeArea(
      child: Scaffold(
        // body: GestureDetector(
        //   onTap: () {
        //     Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
        //   },
        //   child: const Text('data'),
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        // appBar: _selectedIndex == 0 ? AppBar(
        //   title: const Text('All Workouts'),
        // ): null,
        // body: SafeArea(
        //   child: _selectedIndex == 0
        //       ? Column(
        //           children: [
        //             SizedBox(
        //               height: 250,
        //               child: Stack(
        //                 alignment: Alignment.center,
        //                 children: [
        //                   PageView.builder(
        //                     controller: _sliderController,
        //                     itemCount: _quickSlides.length,
        //                     onPageChanged: (index) {
        //                       setState(() {
        //                         _activeSlide = index;
        //                       });
        //                     },
        //                     itemBuilder: (contex, index) {
        //                       final slide = _quickSlides[index];
        //                       return Padding(
        //                         padding: const EdgeInsets.symmetric(
        //                             horizontal: 8, vertical: 10),
        //                         child: InkWell(
        //                           onTap: () => _onSlideAction(slide.tabIndex),
        //                           borderRadius: BorderRadius.circular(20),
        //                           child: Ink(
        //                             decoration: BoxDecoration(
        //                               borderRadius: BorderRadius.circular(20),
        //                             ),
        //                             child: ClipRRect(
        //                               borderRadius: BorderRadius.circular(20),
        //                               child: Stack(
        //                                 fit: StackFit.expand,
        //                                 children: [
        //                                   Image.network(
        //                                     slide.imageUrl,
        //                                     fit: BoxFit.cover,
        //                                     semanticLabel: slide.semanticLabel,
        //                                   ),
        //                                   DecoratedBox(
        //                                     decoration: BoxDecoration(
        //                                       color:
        //                                           Colors.black.withOpacity(0.15),
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                       );
        //                     },
        //                   ),
        //                   // Positioned(
        //                   //   left: 2,
        //                   //   child: CircleAvatar(
        //                   //     backgroundColor: Colors.black.withOpacity(0.3),
        //                   //     child: IconButton(
        //                   //       icon: const Icon(Icons.chevron_left, size: 24),
        //                   //       color: Colors.white,
        //                   //       onPressed: _activeSlide == 0
        //                   //           ? null
        //                   //           : () => _moveSlide(-1),
        //                   //     ),
        //                   //   ),
        //                   // ),
        //                   // Positioned(
        //                   //   right: 2,
        //                   //   child: CircleAvatar(
        //                   //     backgroundColor: Colors.black.withOpacity(0.3),
        //                   //     child: IconButton(
        //                   //       icon: const Icon(Icons.chevron_right_rounded,
        //                   //           size: 24),
        //                   //       color: Colors.white,
        //                   //       onPressed: _activeSlide == _quickSlides.length - 1
        //                   //           ? null
        //                   //           : () => _moveSlide(-1),
        //                   //     ),
        //                   //   ),
        //                   // )
        //                 ],
        //               ),
        //             ),
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: List.generate(
        //                 _quickSlides.length,
        //                 (index) => AnimatedContainer(
        //                   duration: const Duration(microseconds: 250),
        //                   margin: const EdgeInsets.symmetric(horizontal: 4),
        //                   height: 8,
        //                   width: _activeSlide == index ? 22 : 8,
        //                   decoration: BoxDecoration(
        //                     color: _activeSlide == index
        //                         ? AppColors.primary
        //                         : AppColors.primary.withOpacity(0.3),
        //                     borderRadius: BorderRadius.circular(999),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             const SizedBox(height: 8),
        //             Expanded(child: contentStack),
        //           ],
        //         )
        //       : contentStack,
        // ),
        // bottomNavigationBar: NavigationBar(
        // elevation: 0,
        // height: 85,
        // surfaceTintColor: Colors.transparent,
        // // indicatorColor: AppColors.primary.withOpacity(0.1),
        // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        // backgroundColor: AppColors.primary.withOpacity(0.1),
        // selectedIndex: _selectedIndex,
        // onDestinationSelected: (index) {
        //   setState(
        //     () {
        //       _selectedIndex = index;
        //     },
        //   );
        // },
        // destinations: const [
        //   NavigationDestination(
        //     icon: Icon(Icons.fitness_center_outlined),
        //     selectedIcon: Icon(Icons.fitness_center),
        //     label: 'Workouts',
        //   ),
        //   NavigationDestination(
        //     icon: Icon(Icons.dashboard_customize_outlined),
        //     selectedIcon: Icon(Icons.dashboard_customize),
        //     label: "Create Splits",
        //   ),
        //   NavigationDestination(
        //     icon: Icon(Icons.restaurant_menu_outlined),
        //     selectedIcon: Icon(Icons.restaurant_menu),
        //     label: "Nutrition",
        //   ),
        //   NavigationDestination(
        //     icon: Icon(Icons.insights_outlined),
        //     selectedIcon: Icon(Icons.insights),
        //     label: "Progress",
        //   ),
        //   NavigationDestination(
        //     icon: Icon(Icons.person_outline),
        //     selectedIcon: Icon(Icons.person),
        //     label: "Profile",
        //   )
        // ],
        //   bottomNavigationBar: AppBottomNavigationBar(
        //   currentIndex: _selectedIndex,
        //   onTap: _onDestinationSelected,
        // ),
        bottomNavigationBar: GymBottomNav(
          currentIndex: _selectedIndex,
          onTap: _onDestinationSelected,
        ),
      ),
    );
  }
}

// class _QuickSlideItem {
//   const _QuickSlideItem({
//     required this.imageUrl,
//     required this.tabIndex,
//     required this.semanticLabel,
//   });

//   final String imageUrl;
//   final int tabIndex;
//   final String semanticLabel;
// }
