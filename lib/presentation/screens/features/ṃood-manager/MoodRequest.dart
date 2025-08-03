import 'package:rayoflite/presentation/screens/features/%E1%B9%83ood-manager/UserMoodsEnum.dart';

class MoodRequest {
  final UserMoodsEnum type;
  final int intensity;
  final String? description;

  MoodRequest({
    required this.type,
    required this.intensity,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'type': type.name.toUpperCase(),
        'intensity': intensity,
        if (description != null) 'description': description,
      };
}