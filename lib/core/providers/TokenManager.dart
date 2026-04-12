class TokenManager {
  static String? _token;

  static String? get token => _token;

  static void setToken(String? token) {
    _token = token;
  }

  static void clear() {
    _token = null;
  }

  static bool get hasToken => _token != null && _token!.isNotEmpty;
}