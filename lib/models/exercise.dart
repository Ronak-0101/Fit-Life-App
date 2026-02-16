class Exercise {
  final String id;
  final String name;
  final String description;
  final String bodyparts;
  final List<String> muscleGroups;
  final List<String> equipment;
  final String difficulty;
  final String type;
  final bool isPopular;

  Exercise(
      {required this.id,
      required this.name,
      required this.description,
      required this.bodyparts,
      required this.muscleGroups,
      required this.equipment,
      required this.difficulty,
      required this.type,
      required this.isPopular});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      bodyparts: json['bodyparts'] ?? '',
      muscleGroups: List<String>.from(json['muscleGroup'] ?? []),
      equipment: List<String>.from(json['equipment'] ?? []),
      difficulty: json['difficulty'] ?? 'beginner',
      type: json['type'] ?? 'strength',
      isPopular: json['isPopular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'desciption': description,
      'bodyparts': bodyparts,
      'muscleGroup': muscleGroups,
      'equipment':equipment,
      'difficulty': difficulty,
      'type': type,
      'isPopular': isPopular,
    };
  }
}
