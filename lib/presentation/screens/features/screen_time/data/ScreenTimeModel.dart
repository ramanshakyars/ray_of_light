class ScreenTimeModel {
  final String day;
  final double hours;

  ScreenTimeModel({required this.day, required this.hours});

  factory ScreenTimeModel.fromJson(Map<String, dynamic> json) {
    return ScreenTimeModel(
      day: json['day'],
      hours: (json['hours'] as num).toDouble(),
    );
  }
}