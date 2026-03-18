import 'package:rayoflite/presentation/screens/features/ṃood-manager/UserMood.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../presentation/screens/features/ṃood-manager/UserMoodsEnum.dart';

class LocalStorageService {
  // 👇 Add this method for initialization
  static Future<void> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    // 🆕 Track when token was set
    await prefs.setString('token_set_time', DateTime.now().toIso8601String());
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> setUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(user));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    return userStr != null ? json.decode(userStr) : null;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // 🆕 ===== NEW METHODS (ADD THESE) =====
  
  /// Check if token is still valid (5 year expiration)
  static Future<bool> isTokenValid() async {
    final token = await getToken();
    final setTimeStr = await getTokenSetTime();
    
    if (token == null || setTimeStr == null) return false;
    
    // Token valid if set within last 5 years
    final expirationDate = setTimeStr.add(const Duration(days: 1825));
    return DateTime.now().isBefore(expirationDate);
  }

  /// Get when token was set
  static Future<DateTime?> getTokenSetTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeStr = prefs.getString('token_set_time');
    if (timeStr == null) return null;
    return DateTime.parse(timeStr);
  }

  // ===== REST OF YOUR EXISTING CODE =====

  static Future<void> setCurrentMood(UserMood mood) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_mood', json.encode(mood.toJson()));
  }

  static Future<UserMood?> getCurrentMood() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('current_mood');
    if (jsonStr == null) {
      final defaultMood = UserMood(
        type: UserMoodsEnum.neutral,
        intensity: 5,
        description: null,
        setAt: DateTime.now(),
      );
      await setCurrentMood(defaultMood);
      return defaultMood;
    }

    final jsonMap = json.decode(jsonStr);
    return UserMood.fromJson(jsonMap);
  }

  static Future<String> getCurrentMoodType() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('current_mood');

    if (jsonStr == null) {
      final defaultMood = UserMood(
        type: UserMoodsEnum.neutral,
        intensity: 5,
        description: null,
        setAt: DateTime.now(),
      );
      await setCurrentMood(defaultMood);
      return defaultMood.type.name.toUpperCase();
    }

    final jsonMap = json.decode(jsonStr);
    final mood = UserMood.fromJson(jsonMap);
    return mood.type.name.toUpperCase();
  }

  static Future<void> clearCurrentMood() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_mood');
  }
}