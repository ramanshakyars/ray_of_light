import 'package:rayoflite/presentation/screens/features/%E1%B9%83ood-manager/UserMoodsEnum.dart';

class UserMood {
  final UserMoodsEnum type;
  final int intensity;
  final String? description;
  final DateTime timestamp;

  UserMood({
    required this.type,
    required this.intensity,
    this.description,
    required this.timestamp,
  });

  factory UserMood.fromJson(Map<String, dynamic> json) => UserMood(
        type: UserMoodsEnum.values.firstWhere(
          (e) => e.name == (json['type'] as String).toLowerCase(),
        ),
        intensity: json['intensity'] as int,
        description: json['description'] as String?,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  Map<String, dynamic> toJson() => {
        'type': type.name.toUpperCase(),
        'intensity': intensity,
        if (description != null) 'description': description,
        'timestamp': timestamp.toIso8601String(),
      };
}