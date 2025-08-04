import 'UserMoodsEnum.dart';

class MoodRequest {
  final UserMoodsEnum type;
  final int intensity;
  final String? description;

  MoodRequest({
    required this.type,
    required this.intensity,
    this.description,
  });

  /// ✅ This is the missing method causing the error
  Map<String, dynamic> toJson() {
    return {
      'type': type.name.toUpperCase(),
      'intensity': intensity,
      if (description != null) 'description': description,
    };
  }

  factory MoodRequest.fromJson(Map<String, dynamic> json) {
    return MoodRequest(
      type: UserMoodsEnum.values.firstWhere(
        (e) => e.name.toUpperCase() == json['type'],
        orElse: () => UserMoodsEnum.neutral,
      ),
      intensity: json['intensity'] ?? 5,
      description: json['description'],
    );
  }
}
