
class AppConstants {
  // API Configuration
  static const String baseUrl = "https://fit-life-api.onrender.com/api";

  //Storage keys
  static const String authTokenKey = "auth_token";
  static const String userIdKey = "user_id";
  static const String userEmailKey = "user_email";
  static const String userNameKey = "user_name";

  // App constants
  static const String appName = "Fit Life";

  // API Endpoints
  static const String healthEndpoint = '/health';
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String currentUserEndpoint = '/auth/me';
  static const String exercisesEndpoint = '/exercises';
  static const String workoutsEndpoint = '/workouts';
  static const String nutritionEndpoint = '/nutrition';
  static const String progressEndpoint = '/progress';
  static const String userProfileEndpoint = '/users/me';

  // Muscle Groups
  static const Map<String, String> bodyparts = {
    'all': 'All Exercises',
    'chest': 'Chest',
    'back': 'Back',
    'legss': 'Legs',
    'shoulders': 'Shoulders',
    'triceps': 'Triceps',
    'biceps': 'Biceps',
    'core': 'Core',
    'full-body': 'Full Body',
  };

  // Exercise Difficulties
  static const List<String> difficulties = [
    'beginner',
    'intermediate',
    'advanced',
  ];

  // Colors
  static const int primaryColor = 0xFF4A90E2;
  static const int secondaryColor  = 0xFF50C878;
  static const int accentColor  = 0xFFFF6B6B;
  static const int seedColor = 0xFF4A90E2;
  
}
