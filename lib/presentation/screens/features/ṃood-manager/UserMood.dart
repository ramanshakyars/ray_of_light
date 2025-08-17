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
    final setAtList = json['setAt'] as List<dynamic>;
    return UserMood(
      type: UserMoodsEnum.values.firstWhere(
        (e) => e.name.toUpperCase() == json['type'],
        orElse: () => UserMoodsEnum.neutral,
      ),
      intensity: json['intensity'] ?? 5,
      description: json['description'],
      setAt: DateTime.utc(
        setAtList[0], // year
        setAtList[1], // month
        setAtList[2], // day
        setAtList[3], // hour
        setAtList[4], // minute
        setAtList[5], // second
        setAtList[6] ~/ 1000, // microsecond -> millisecond
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name.toUpperCase(),
      'intensity': intensity,
      'description': description,
      'setAt': [
        setAt.year,
        setAt.month,
        setAt.day,
        setAt.hour,
        setAt.minute,
        setAt.second,
        setAt.microsecond
      ],
    };
  }
}
