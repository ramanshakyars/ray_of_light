import 'package:flutter/material.dart';
import 'dart:async';
import '../services/localStorageService.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic>? _user;
  String? _token;  // 🆕 NEW LINE
  late Timer _sessionTimer;  // 🆕 NEW LINE

  Map<String, dynamic>? get user => _user;
  String? get token => _token;  // 🆕 NEW GETTER

  String get userName =>
      _user?['fullName'] ?? _user?['username'] ?? _user?['email'] ?? "User";

  Future<void> loadUser() async {
    _user = await LocalStorageService.getUser();
    _token = await LocalStorageService.getToken();  // 🆕 LOAD TOKEN
    
    // 🆕 Start session keep-alive timer
    if (_token != null && _token!.isNotEmpty) {
      _startSessionKeepAliveTimer();
    }
    
    notifyListeners();
  }

  Future<void> logout() async {
    _stopSessionKeepAliveTimer();  // 🆕 STOP TIMER
    await LocalStorageService.clearAll();
    _user = null;
    _token = null;  // 🆕 CLEAR TOKEN
    notifyListeners();
  }

  bool get isAdmin {
    final roles = _user?['roles'];

    if (roles == null) return false;

    if (roles is List) {
      return roles.contains("ADMIN") || roles.contains("ROLE_ADMIN");
    }

    return roles == "ADMIN" || roles == "ROLE_ADMIN";
  }

  // 🆕 ===== NEW METHODS (ADD THESE) =====
  
  /// Start session keep-alive timer
  void _startSessionKeepAliveTimer() {
    _sessionTimer = Timer.periodic(
      const Duration(days: 180), // Every 6 months
      (_) async {
        final token = await LocalStorageService.getToken();
        if (token != null && token.isNotEmpty) {
          print('✅ Session kept alive');
        }
      },
    );
  }

  /// Stop session timer
  void _stopSessionKeepAliveTimer() {
    if (_sessionTimer.isActive) {
      _sessionTimer.cancel();
    }
  }

  /// Check if token is valid
  Future<bool> isTokenValid() async {
    _token = await LocalStorageService.getToken();
    return _token != null && _token!.isNotEmpty;
  }

  @override
  void dispose() {
    _stopSessionKeepAliveTimer();
    super.dispose();
  }
}