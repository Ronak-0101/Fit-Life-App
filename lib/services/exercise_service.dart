import 'dart:convert';

import 'package:fit_life_app_/models/exercise.dart';
import 'package:fit_life_app_/services/api_service.dart';
import 'package:fit_life_app_/utils/constants.dart';
import 'package:http/http.dart';

class ExerciseService {

  // GET EXERCISES BY MUSCLE GROUPS
  static Future<List<Exercise>> getExerciseByMuscleGroups(
      String muscleGroup) async {
    final response = await ApiService.get(
      AppConstants.exercisesEndpoint,
      includeAuth: false,
      queryParams: {
        'muscleGroup': muscleGroup,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load data (${response.statusCode})');
    }
    final decoded = jsonDecode(response.body);
    final dynamic listData = decoded['data'] ?? decoded['exercises'] ?? decoded['results'] ?? decoded;
    if (listData is! List) {
      throw Exception('Unexpected exercise response format');
    }
    return listData.whereType<Map<String, dynamic>>().map(Exercise.fromJson).toList();
  }

  // GET EXERCISES BY ID
  static Future<Exercise> getExerciseById(String exerciseId) async {
    final response = await ApiService.get(
      '${AppConstants.exercisesEndpoint}/$exerciseId',
      includeAuth: false,
    );

    if(response.statusCode != 200) {
      throw Exception('Failed to load exercise details (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);
    final dynamic exerciseData = decoded['data'] ?? decoded['exercise'] ?? decoded;

    if(exerciseData is! Map<String, dynamic>) {
      throw Exception('Unexpected exercise detail response error');
    }

    return Exercise.fromJson(exerciseData);
  }

  // GET EXERCISEX BY BODY PARTS
  static Future<List<Exercise>> getExerciseByBodyparts(String bodypart) async {
    final response = await ApiService.get(
      AppConstants.baseUrl,
      includeAuth: false,
      queryParams: {
        'bodypart': bodypart,
      }
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load data (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);
    final dynamic listData = decoded['data'] ?? decoded['exercises'] ?? decoded['results'] ?? decoded;

    if(listData is! List) {
      throw Exception('Unexpected exercise response format');
    }
    return listData.whereType<Map<String, dynamic>>().map(Exercise.fromJson).toList();
  }
}
