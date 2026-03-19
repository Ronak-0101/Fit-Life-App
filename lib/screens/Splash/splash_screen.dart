import 'package:fit_life_app_/services/auth_service.dart';
import 'package:fit_life_app_/utils/app_colors.dart';
// import 'package:fit_life_app_/utils/constants.dart';
import 'package:fit_life_app_/utils/storage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const Duration _splashDuration = Duration(seconds: 3);

  late AnimationController _animationController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    //setup animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: _splashDuration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.easeIn,
        ),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          0.5,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    // Start animation
    _animationController.forward();
    _progressController.forward();

    //Navigate after delay
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for animation to complete (2 seconds) plus a little extraa
    await Future.delayed(_splashDuration);

    //Check if user is logged in
    final isLoggedIn = StorageService.isLoggedIn();

    if (!mounted) return;

    // Vavigate to appropriate screen
    if (isLoggedIn) {
      // verify token is still valid by fetching user profile
      final result = await AuthService.getCurrentUser();

      if (!mounted) return;

      if (result['success'] == true) {
        // Token is valid, go to home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        //Token expired, go to login
        await StorageService.clearAll();
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      // Not logged in go to login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // const accentColor = Color(0xFFFF2A2E);
    // const titleColor = Color(0xFFF9E9EA);
    // const subtitleColor = Color(0xFFCFA9AE);
    // const baseGlowColor = Color(0xFF8E171D);
    // const darkCircleColor = Color(0xFF56383B);
    // const darkProgressTrack = Color(0xFF5C4B4D);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEA171F),
              Color(0xFF8B1117),
              Color(0xFF1A1214),
            ],
            stops: [0.0, 0.58, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.1),
                    radius: 0.9,
                    colors: [
                      AppColors.baseGlowColor.withOpacity(0.24),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: AnimatedBuilder(
                animation:
                    Listenable.merge([_animationController, _progressController]),
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          SizedBox(height: constraints.maxHeight * 0.14),
                          Container(
                            width: 240,
                            height: 240,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.baseGlowColor.withOpacity(0.32),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                color: AppColors.darkCircleColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.18),
                                    blurRadius: 28,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Transform.rotate(
                                  angle: -0.8,
                                  child: const Icon(
                                    Icons.fitness_center,
                                    size: 52,
                                    color: AppColors.titleColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'FIT LIFE',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.titleColor,
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 1.8,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.18),
                                  offset: const Offset(0, 5),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'YOUR PERSONAL FITNESS\nCOMPANION',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.subtitleColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 4.5,
                              height: 1.45,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                minHeight: 6,
                                value: _progressController.value,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.accentColor,
                                ),
                                backgroundColor:
                                    AppColors.darkProgressTrack.withOpacity(0.75),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1.5,
                                  color: AppColors.subtitleColor.withOpacity(0.35),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18),
                                child: Text(
                                  'PERFORMANCE TIER',
                                  style: TextStyle(
                                    color: AppColors.subtitleColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 3,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1.5,
                                  color: AppColors.subtitleColor.withOpacity(0.35),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: constraints.maxHeight * 0.08),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
