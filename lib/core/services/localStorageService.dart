import 'package:rayoflite/presentation/screens/features/%E1%B9%83ood-manager/UserMood.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  // 👇 Add this method for initialization
  static Future<void> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
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

  static Future<void> setCurrentMood(UserMood mood) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_mood', json.encode(mood.toJson()));
  }

  static Future<UserMood?> getCurrentMood() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('current_mood');
    if (jsonStr == null) return null;
    final jsonMap = json.decode(jsonStr);
    return UserMood.fromJson(jsonMap);
  }

  static Future<void> clearCurrentMood() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_mood');
  }
}
