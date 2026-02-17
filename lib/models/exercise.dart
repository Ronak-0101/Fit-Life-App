class Exercise {
  final String id;
  final String name;
  final String description;
  final List<String> bodyparts;
  final List<String> muscleGroups;
  final List<String> equipment;
  final String difficulty;
  final String type;
  final bool isPopular;
  final List<String> targetMuscles;
  final List<String> steps;
  final List<String> tips;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.bodyparts,
    required this.muscleGroups,
    required this.equipment,
    required this.difficulty,
    required this.type,
    required this.isPopular,
    required this.targetMuscles,
    required this.steps,
    required this.tips,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    List<String> readStringList(dynamic value) {
      if (value is List) {
        return value.map((item) => item.toString()).toList();
      }
      return const [];
    }

    return Exercise(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      bodyparts: readStringList(json['bodyparts'] ?? json['bodypart']),
      muscleGroups:
          readStringList(json['muscleGroups'] ?? json['muscleGroup']),
      equipment: readStringList(json['equipment']),
      difficulty: (json['difficulty'] ?? 'beginner').toString(),
      type: (json['type'] ?? 'strength').toString(),
      isPopular: json['isPopular'] == true,
      targetMuscles:
          readStringList(json['targetMuscles'] ?? json['targetMuscle']),
      steps: readStringList(json['steps'] ?? json['instructions']),
      tips: readStringList(json['tips']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'bodyparts': bodyparts,
      'muscleGroups': muscleGroups,
      'equipment': equipment,
      'difficulty': difficulty,
      'type': type,
      'isPopular': isPopular,
      'targetMuscles': targetMuscles,
      'steps': steps,
      'tips': tips,
    };
  }
}
