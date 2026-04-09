class User {
  final String id;
  final String email;
  final String name;
  final int? age;
  final double? height;
  final double? weight;
  final String? fitnessGoal;
  final String? activityLevel;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.fitnessGoal,
    required this.activityLevel,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] != null ? int.tryParse(json['age'].toString()) : null,
      height: json['height'] != null
          ? double.tryParse(json['height'].toString())
          : null,
      weight: json['weight'] != null
          ? double.tryParse(json['weight'].toString())
          : null,
      fitnessGoal: json['fitnessGoal'] ?? 'Maintanance',
      activityLevel: json['activityLevel'] ?? 'moderate',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'fitnessGoal': fitnessGoal,
      'activityLevel': activityLevel,
    };
  }
}
