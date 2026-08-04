import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme_colors.dart';

class ThemeProvider with ChangeNotifier {
  // ── Internal state ──
  bool _isDarkMode = false;
  AppTheme _selectedTheme = AppTheme.mono;

  // ── Persistence keys ──
  static const String _kDarkMode = 'pref_dark_mode';
  static const String _kTheme = 'pref_selected_theme';

  ThemeProvider() {
    _loadFromStorage();
  }

  // ── Getters ──
  bool get isDarkMode => _isDarkMode;
  AppTheme get selectedTheme => _selectedTheme;

  /// Returns the full semantic color set for the current theme+mode.
  ThemeColors get colors =>
      AppThemeColors.fromTheme(_selectedTheme, _isDarkMode);

  // ── Actions ──

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveToStorage();
    notifyListeners();
  }

  void setDarkMode(bool isDark) {
    if (_isDarkMode == isDark) return;
    _isDarkMode = isDark;
    _saveToStorage();
    notifyListeners();
  }

  /// Select a new app theme — applies immediately, persists automatically.
  void setAppTheme(AppTheme theme) {
    if (_selectedTheme == theme) return;
    _selectedTheme = theme;
    _saveToStorage();
    notifyListeners();
  }

  // Backward-compat alias
  void setTheme(bool isDark) => setDarkMode(isDark);

  // ── Persistence ──

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    _isDarkMode = prefs.getBool(_kDarkMode) ?? false;

    final themeKey = prefs.getString(_kTheme);
    if (themeKey != null) {
      _selectedTheme = AppTheme.values.firstWhere(
        (t) => t.storageKey == themeKey,
        orElse: () => AppTheme.mono,
      );
    }

    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkMode, _isDarkMode);
    await prefs.setString(_kTheme, _selectedTheme.storageKey);
  }
}