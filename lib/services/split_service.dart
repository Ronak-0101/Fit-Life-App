import 'dart:convert';

import 'package:fit_life_app_/models/exercise.dart';
import 'package:fit_life_app_/models/split_template.dart';
import 'package:fit_life_app_/services/api_service.dart';
import 'package:fit_life_app_/services/exercise_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplitService {
  static const String _splitStoragePrefix = 'split_day_exercises';

  static Future<List<SplitTemplate>> getTemplates() async {
    final response = await ApiService.get('/splits/templates').timeout(
      const Duration(seconds: 20),
    );
    _ensureSuccess(response.statusCode, response.body);
    dynamic payload = jsonDecode(response.body);
    while (payload is Map) {
      final nested =
          payload['templates'] ?? payload['data'] ?? payload['result'];
      if (nested == null) break;
      payload = nested;
    }

    if (payload is! List) return const <SplitTemplate>[];

    return payload
        .whereType<Map>()
        .map((item) => SplitTemplate.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  static Future<SplitTemplate> getTemplate(String slug) async {
    if (slug.trim().isEmpty) {
      throw Exception('This plan is missing its template slug.');
    }

    final response = await ApiService.get('/splits/templates/$slug').timeout(
      const Duration(seconds: 20),
    );
    _ensureSuccess(response.statusCode, response.body);
    final apiTemplate = _parseTemplatePayload(jsonDecode(response.body));
    return await mergeLocalTemplateChanges(apiTemplate);
  }

  static Future<SplitTemplate?> applyTemplate(String slug) async {
    final response = await ApiService.post('/splits/templates/$slug/apply');
    _ensureSuccess(response.statusCode, response.body);

    try {
      final applied = _parseTemplatePayload(jsonDecode(response.body));
      // Copy custom template exercises to active split local storage if they exist
      for (final day in applied.week) {
        final key = _templateStorageKey(slug, day.day.toLowerCase());
        final prefs = await SharedPreferences.getInstance();
        final jsonStr = prefs.getString(key);
        if (jsonStr != null) {
          final decoded = jsonDecode(jsonStr);
          if (decoded is List) {
            final ids = decoded
                .map((e) {
                  if (e is Map) {
                    return e['id'] as String?;
                  }
                  return null;
                })
                .whereType<String>()
                .where((id) => id.isNotEmpty)
                .toSet();
            await _saveSelectedIds(day.day.toLowerCase(), ids);
          }
        }
      }
      return await mergeLocalTemplateChanges(applied);
    } catch (_) {
      return null;
    }
  }

  static Future<SplitTemplate?> getActiveSplit() async {
    final response = await ApiService.get('/splits/active');
    if (response.statusCode == 404) return null;
    _ensureSuccess(response.statusCode, response.body);

    try {
      final template = _parseTemplatePayload(jsonDecode(response.body));
      return await mergeLocalTemplateChanges(template);
    } catch (_) {
      return null;
    }
  }

  static Future<ExercisesClass> getPlannedExerciseDetails(
    SplitPlanExercise planned,
  ) async {
    ExercisesClass? exercise = planned.details;

    if (planned.id.isNotEmpty) {
      try {
        exercise = await ExerciseService.getExerciseById(planned.id);
      } catch (_) {
        // A populated template exercise can still render without a detail call.
      }
    }

    if (exercise == null) {
      final library = await ExerciseService.getAllExercises();
      for (final candidate in library) {
        final matchesId = planned.id.isNotEmpty && candidate.id == planned.id;
        final matchesName =
            candidate.name?.toLowerCase() == planned.name.toLowerCase();
        if (matchesId || matchesName) {
          exercise = candidate;
          break;
        }
      }
    }

    if (exercise == null) {
      throw Exception('Exercise details are not available yet.');
    }

    final data = exercise.toJson();
    data['prescription'] = {
      'sets': planned.sets,
      'reps': planned.reps,
      'rest': planned.rest,
    };
    return ExercisesClass.fromJson(data);
  }

  static Future<List<ExercisesClass>> getDayExercises(String day) async {
    final exercises = await ExerciseService.getAllExercises();
    final exercisesById = _mapExercisesById(exercises);
    final serverExercises = await _getServerDayExercises(day, exercisesById);

    if (serverExercises != null) {
      final serverIds = serverExercises
          .map((exercise) => exercise.id)
          .whereType<String>()
          .where((id) => id.isNotEmpty)
          .toSet();
      final localIds = await _getSelectedIds(day);
      final selectedIds = {...serverIds, ...localIds};

      await _saveSelectedIds(day, selectedIds);

      return _sortByExerciseLibrary(exercises, selectedIds);
    }

    return _sortByExerciseLibrary(exercises, await _getSelectedIds(day));
  }

  static Future<List<ExercisesClass>> getAvailableExercises(String day) async {
    final exercises = await ExerciseService.getAllExercises();
    final selectedExercises = await getDayExercises(day);
    final selectedIds = selectedExercises
        .map((exercise) => exercise.id)
        .whereType<String>()
        .toSet();

    return exercises
        .where((exercise) => !selectedIds.contains(exercise.id))
        .toList();
  }

  static Future<void> addExerciseToDay({
    required String day,
    required String exerciseId,
  }) async {
    final selectedIds = await _getSelectedIds(day);
    selectedIds.add(exerciseId);
    await _saveSelectedIds(day, selectedIds);

    _trySyncAdd(day: day, exerciseId: exerciseId);
  }

  static Future<void> removeExerciseFromDay({
    required String day,
    required String exerciseId,
  }) async {
    final selectedIds = await _getSelectedIds(day);
    selectedIds.remove(exerciseId);
    await _saveSelectedIds(day, selectedIds);

    _trySyncRemove(day: day, exerciseId: exerciseId);
  }

  static Future<Set<String>> _getSelectedIds(String day) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_storageKey(day)) ?? const <String>[])
        .where((id) => id.isNotEmpty)
        .toSet();
  }

  static Future<void> _saveSelectedIds(String day, Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey(day), ids.toList());
  }

  static String _storageKey(String day) => '$_splitStoragePrefix.$day';

  static SplitTemplate _parseTemplatePayload(dynamic decoded) {
    dynamic payload = decoded;

    while (payload is Map) {
      final nested = payload['template'] ??
          payload['split'] ??
          payload['activeSplit'] ??
          payload['data'] ??
          payload['result'];
      if (nested is! Map) break;
      payload = nested;
    }

    if (payload is Map) {
      return SplitTemplate.fromJson(Map<String, dynamic>.from(payload));
    }

    throw const FormatException('Split plan response was not valid.');
  }

  static void _ensureSuccess(int statusCode, String body) {
    if (statusCode >= 200 && statusCode < 300) return;

    var message = 'Unable to load split plans right now.';
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['message'] is String) {
        message = decoded['message'] as String;
      }
    } catch (_) {
      // Use the friendly fallback for non-JSON server errors.
    }

    throw Exception(message);
  }

  static Future<List<ExercisesClass>?> _getServerDayExercises(
    String day,
    Map<String, ExercisesClass> exercisesById,
  ) async {
    try {
      final response = await ApiService.get('/splits/days/$day/exercises');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      return _parseExercises(response.body, exercisesById);
    } catch (_) {
      return null;
    }
  }

  static Map<String, ExercisesClass> _mapExercisesById(
    List<ExercisesClass> exercises,
  ) {
    return {
      for (final exercise in exercises)
        if (exercise.id != null && exercise.id!.isNotEmpty)
          exercise.id!: exercise,
    };
  }

  static List<ExercisesClass> _sortByExerciseLibrary(
    List<ExercisesClass> exercises,
    Set<String> selectedIds,
  ) {
    return exercises
        .where((exercise) => selectedIds.contains(exercise.id))
        .toList();
  }

  static List<ExercisesClass> _parseExercises(
    String responseBody,
    Map<String, ExercisesClass> exercisesById,
  ) {
    final decoded = jsonDecode(responseBody);
    final found = <String, ExercisesClass>{};

    void visit(dynamic value) {
      if (value is List) {
        for (final item in value) {
          visit(item);
        }
        return;
      }

      if (value is! Map) {
        return;
      }

      final map = Map<String, dynamic>.from(value);
      final nestedExercise = map['exercise'];

      if (nestedExercise is Map) {
        final exercise = ExercisesClass.fromJson(
          Map<String, dynamic>.from(nestedExercise),
        );
        final id = exercise.id;
        if (id != null && id.isNotEmpty) {
          found[id] = exercise;
        }
        return;
      }

      if (map['name'] != null && (map['_id'] != null || map['id'] != null)) {
        final exercise = ExercisesClass.fromJson(map);
        final id = exercise.id;
        if (id != null && id.isNotEmpty) {
          found[id] = exercise;
        }
        return;
      }

      final exerciseId = _stringValue(map['exerciseId']) ??
          _stringValue(map['exercise_id']) ??
          _stringValue(map['exercise']);

      if (exerciseId != null) {
        final exercise = exercisesById[exerciseId];
        if (exercise != null) {
          found[exerciseId] = exercise;
        }
      }

      const nestedKeys = [
        'exercises',
        'selectedExercises',
        'dayExercises',
        'workouts',
        'data',
        'result',
        'results',
        'split',
        'day',
      ];

      for (final key in nestedKeys) {
        visit(map[key]);
      }
    }

    visit(decoded);
    return found.values.toList();
  }

  static String? _stringValue(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return null;
  }

  static Future<void> _trySyncAdd({
    required String day,
    required String exerciseId,
  }) async {
    try {
      await ApiService.post(
        '/splits/days/$day/exercises',
        body: {'exerciseId': exerciseId},
      );
    } catch (_) {
      // The split API is optional; local saved splits keep the feature usable.
    }
  }

  static Future<void> _trySyncRemove({
    required String day,
    required String exerciseId,
  }) async {
    try {
      await ApiService.delete('/splits/days/$day/exercises/$exerciseId');
    } catch (_) {
      // The split API is optional; local saved splits keep the feature usable.
    }
  }

  static const String _templateStoragePrefix = 'custom_template_exercises';

  static String _templateStorageKey(String slug, String day) =>
      '$_templateStoragePrefix.$slug.$day';

  static Future<List<SplitPlanExercise>> getTemplateDayExercises(
    String slug,
    String day,
    List<SplitPlanExercise> defaultExercises,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _templateStorageKey(slug, day.toLowerCase());
    final jsonStr = prefs.getString(key);
    if (jsonStr == null) return defaultExercises;

    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is List) {
        return decoded
            .map((item) => SplitPlanExercise.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }
    } catch (_) {}
    return defaultExercises;
  }

  static Future<void> saveTemplateDayExercises(
    String slug,
    String day,
    List<SplitPlanExercise> exercises,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _templateStorageKey(slug, day.toLowerCase());
    final jsonList = exercises.map((e) => e.toJson()).toList();
    await prefs.setString(key, jsonEncode(jsonList));
  }

  static Future<SplitTemplate> mergeLocalTemplateChanges(
    SplitTemplate template,
  ) async {
    final updatedWeek = <SplitPlanDay>[];
    for (final day in template.week) {
      final customExercises = await getTemplateDayExercises(
        template.slug,
        day.day,
        day.exercises,
      );

      final isRest = customExercises.isEmpty;
      final totalDuration = isRest
          ? 0
          : customExercises.fold(0, (sum, ex) => sum + (ex.details?.duration?.toInt() ?? 10));

      updatedWeek.add(SplitPlanDay(
        day: day.day,
        title: isRest ? 'Rest Day' : (day.isRestDay ? 'Workout Day' : day.title),
        focus: isRest ? 'Recovery' : (day.isRestDay ? 'Strength' : day.focus),
        isRestDay: isRest,
        estimatedDuration: totalDuration > 0 ? totalDuration : day.estimatedDuration,
        exerciseCount: customExercises.length,
        exercises: customExercises,
      ));
    }

    return SplitTemplate(
      slug: template.slug,
      title: template.title,
      description: template.description,
      level: template.level,
      days: updatedWeek.where((day) => !day.isRestDay).length,
      estimatedDuration: template.estimatedDuration,
      exerciseCount: updatedWeek.fold(0, (sum, day) => sum + day.exerciseCount),
      week: updatedWeek,
    );
  }
}
