import 'UserMoodsEnum.dart';

class UserMood {
  final UserMoodsEnum type;
  final int intensity;
  final String? description;
  final DateTime setAt;

  UserMood({
    required this.type,
    required this.intensity,
    this.description,
    required this.setAt,
  });

  factory UserMood.fromJson(Map<String, dynamic> json) {
    return UserMood(
      type: UserMoodsEnum.values.firstWhere(
        (e) => e.name.toUpperCase() == json['type'],
        orElse: () => UserMoodsEnum.neutral,
      ),
      intensity: json['intensity'] ?? 5,
      description: json['description'],
      setAt: DateTime.utc(
        json['setAt'][0],
        json['setAt'][1],
        json['setAt'][2],
        json['setAt'][3],
        json['setAt'][4],
        json['setAt'][5],
        json['setAt'][6] ~/ 1000, // microseconds to milliseconds if needed
      ),
    );
  }
}
