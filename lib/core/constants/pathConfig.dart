class PathConfig {
  static const String baseUrl = 'http://192.168.98.67:9090';

  // Auth endpoints
  static const String login = '$baseUrl/rayoflight/api/public/login';
  static const String register = '$baseUrl/rayoflight/api/public/register';
  static const String logout = '$baseUrl/auth/logout';

  // User endpoints
  static const String userProfile = '$baseUrl/user/profile';
  static const String updateProfile = '$baseUrl/user/update';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';

  //Goal Tracker endpoints
  static const String getGoals = '$baseUrl/rayoflight/api/goal';
  static const String createGoal = '$baseUrl/rayoflight/api/goal';
}
