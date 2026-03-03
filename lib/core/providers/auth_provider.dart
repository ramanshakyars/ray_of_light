import 'package:flutter/material.dart';
import '../services/localStorageService.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic>? _user;

  Map<String, dynamic>? get user => _user;

  String get userName =>
      _user?['fullName'] ??
      _user?['username'] ??
      _user?['email'] ??
      "User";

  Future<void> loadUser() async {
    _user = await LocalStorageService.getUser();
    notifyListeners();
  }

  Future<void> logout() async {
    await LocalStorageService.clearAll();
    _user = null;
    notifyListeners();
  }
}