import 'package:flutter/material.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/presentation/screens/features/screen_time/data/ScreenTimeModel.dart';

import '../../../../../core/services/httpService.dart';

class ScreenTimeProvider extends ChangeNotifier {
  List<ScreenTimeModel> weeklyData = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchWeekly() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // PathConfig.getWeeklyScreenTime should point to /api/screen-time/{userId}
      const url = PathConfig.getWeeklyScreenTime;
      final response = await HttpService.get(url);

      if (response is List) {
        weeklyData = response.map((e) => ScreenTimeModel.fromJson(e)).toList();
      }
    } catch (e) {
      errorMessage = "Could not load screen time data.";
      print("ScreenTimeProvider Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
