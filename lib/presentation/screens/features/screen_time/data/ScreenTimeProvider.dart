import 'package:flutter/material.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/presentation/screens/features/screen_time/data/ScreenTimeModel.dart';

import '../../../../../core/services/httpService.dart';

class ScreenTimeProvider extends ChangeNotifier {
  List<ScreenTimeModel> weeklyData = [];
  bool isLoading = false;
  bool hasError = false;
  bool isOffline = false;

  Future<void> fetchWeekly() async {
    isLoading = true;
    notifyListeners();

    try {
      const url = PathConfig.getWeeklyScreenTime;
      final response = await HttpService.get(url);

      weeklyData =
          (response as List).map((e) => ScreenTimeModel.fromJson(e)).toList();

      hasError = false;
    } catch (e) {
      hasError = true;
    }

    isLoading = false;
    notifyListeners();
  }
}
