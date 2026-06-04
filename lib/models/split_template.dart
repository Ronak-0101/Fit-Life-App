import 'package:fit_life_app_/models/exercise.dart';

class SplitTemplate {
  const SplitTemplate({
    required this.slug,
    required this.title,
    required this.description,
    required this.level,
    required this.days,
    required this.estimatedDuration,
    required this.exerciseCount,
    required this.week,
  });

  final String slug;
  final String title;
  final String description;
  final String level;
  final int days;
  final int estimatedDuration;
  final int exerciseCount;
  final List<SplitPlanDay> week;

  factory SplitTemplate.fromJson(Map<String, dynamic> json) {
    final week = _mapDays(
      json['week'] ??
          json['weeklyPlan'] ??
          json['weeklyBlueprint'] ??
          json['weeklySchedule'] ??
          json['schedule'] ??
          json['plan'] ??
          json['days'],
    );
    final workoutDays = week.where((day) => !day.isRestDay).toList();

    return SplitTemplate(
      slug: _string(
        json['slug'] ??
            json['templateSlug'] ??
            json['template_slug'] ??
            json['id'] ??
            json['_id'],
      ),
      title: _string(
        json['title'] ?? json['name'],
        fallback: 'Workout Split',
      ),
      description: _string(
        json['description'] ?? json['summary'],
        fallback: 'A structured weekly workout plan.',
      ),
      level: _string(
        json['level'] ?? json['difficulty'],
        fallback: 'All Levels',
      ),
      days: _integer(
        json['trainingDays'] ?? json['workoutDays'],
        fallback: workoutDays.length,
      ),
      estimatedDuration: _integer(
        json['estimatedDuration'] ?? json['duration'],
        fallback: workoutDays.isEmpty ? 0 : workoutDays.first.estimatedDuration,
      ),
      exerciseCount: _integer(
        json['exerciseCount'] ?? json['totalExercises'],
        fallback: workoutDays.fold(0, (sum, day) => sum + day.exerciseCount),
      ),
      week: week,
    );
  }
}

class SplitPlanDay {
  const SplitPlanDay({
    required this.day,
    required this.title,
    required this.focus,
    required this.isRestDay,
    required this.estimatedDuration,
    required this.exerciseCount,
    required this.exercises,
  });

  final String day;
  final String title;
  final String focus;
  final bool isRestDay;
  final int estimatedDuration;
  final int exerciseCount;
  final List<SplitPlanExercise> exercises;

  factory SplitPlanDay.fromJson(Map<String, dynamic> json) {
    final exercises = _mapList(
      json['exercises'] ??
          json['exerciseDetails'] ??
          json['items'] ??
          json['workouts'],
      SplitPlanExercise.fromJson,
    );
    final rest = json['isRestDay'] == true ||
        _string(json['title'] ?? json['focus']).toLowerCase().contains('rest');

    return SplitPlanDay(
      day: _string(
        json['day'] ?? json['dayName'] ?? json['weekday'] ?? json['name'],
        fallback: 'Day',
      ),
      title: _string(
        json['title'] ?? json['workoutTitle'] ?? json['focus'],
        fallback: rest ? 'Rest Day' : 'Workout Day',
      ),
      focus: _string(
        json['focus'],
        fallback: rest ? 'Recovery' : 'Strength',
      ),
      isRestDay: rest,
      estimatedDuration: _integer(
        json['estimatedDuration'] ?? json['duration'],
      ),
      exerciseCount: _integer(
        json['exerciseCount'],
        fallback: exercises.length,
      ),
      exercises: exercises,
    );
  }
}

class SplitPlanExercise {
  const SplitPlanExercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.sets,
    required this.reps,
    required this.rest,
    required this.imageUrl,
    required this.videoUrl,
    required this.details,
  });

  final String id;
  final String name;
  final String bodyPart;
  final int sets;
  final String reps;
  final String rest;
  final String? imageUrl;
  final String? videoUrl;
  final ExercisesClass? details;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bodyPart': bodyPart,
      'sets': sets,
      'reps': reps,
      'rest': rest,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'details': details?.toJson(),
    };
  }

  factory SplitPlanExercise.fromJson(Map<String, dynamic> json) {
    final exercise = json['exercise'] is Map
        ? Map<String, dynamic>.from(json['exercise'] as Map)
        : json;
    final prescription = json['prescription'] is Map
        ? Map<String, dynamic>.from(json['prescription'] as Map)
        : exercise['prescription'] is Map
            ? Map<String, dynamic>.from(exercise['prescription'] as Map)
            : const <String, dynamic>{};
    final rawImages = exercise['imageUrl'];
    final detailData = <String, dynamic>{
      ...exercise,
      if (rawImages is String) 'imageUrl': [rawImages],
      if (json['sets'] != null || json['reps'] != null || json['rest'] != null)
        'prescription': {
          'sets': json['sets'] ?? prescription['sets'],
          'reps': json['reps'] ?? prescription['reps'],
          'rest': json['rest'] ?? prescription['rest'],
        },
    };

    return SplitPlanExercise(
      id: _string(
        exercise['_id'] ??
            exercise['id'] ??
            json['exerciseId'] ??
            json['exercise_id'] ??
            (json['exercise'] is String ? json['exercise'] : null),
      ),
      name: _string(exercise['name'], fallback: 'Exercise'),
      bodyPart: _string(exercise['bodyPart'] ?? exercise['muscleGroup']),
      sets: _integer(json['sets'] ?? prescription['sets']),
      reps: _string(json['reps'] ?? prescription['reps'], fallback: '-'),
      rest: _string(json['rest'] ?? prescription['rest'], fallback: '-'),
      imageUrl: rawImages is List && rawImages.isNotEmpty
          ? _string(rawImages.first)
          : rawImages is String
              ? rawImages
              : null,
      videoUrl: _nullableString(exercise['videoUrl']),
      details:
          exercise['name'] == null ? null : ExercisesClass.fromJson(detailData),
    );
  }
}

List<T> _mapList<T>(dynamic value, T Function(Map<String, dynamic>) fromJson) {
  if (value is! List) return <T>[];

  return value
      .whereType<Map>()
      .map((item) => fromJson(Map<String, dynamic>.from(item)))
      .toList();
}

List<SplitPlanDay> _mapDays(dynamic value) {
  if (value is Map) {
    final nested = value['days'] ??
        value['week'] ??
        value['schedule'] ??
        value['weeklyPlan'];
    if (nested != null && nested != value) return _mapDays(nested);

    return value.entries.where((entry) => entry.value is Map).map((entry) {
      final day = Map<String, dynamic>.from(entry.value as Map);
      day.putIfAbsent('day', () => entry.key.toString());
      return SplitPlanDay.fromJson(day);
    }).toList();
  }

  return _mapList(value, SplitPlanDay.fromJson);
}

String _string(dynamic value, {String fallback = ''}) {
  if (value is String && value.trim().isNotEmpty) return value.trim();
  if (value is List && value.isNotEmpty) return value.join(', ');
  return fallback;
}

String? _nullableString(dynamic value) {
  final converted = _string(value);
  return converted.isEmpty ? null : converted;
}

int _integer(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}
