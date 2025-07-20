class PathConfig {
  static const String baseUrl = 'http://localhost:9090';

  // Auth endpoints
  static const String login = '$baseUrl/rayoflight/api/public/login';
  static const String register = '$baseUrl/rayoflight/api/public/register';
  static const String logout = '$baseUrl/auth/logout';

  // User endpoints
  static const String userProfile = '$baseUrl/user/profile';
  static const String updateProfile = '$baseUrl/user/update';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';

  // Add other endpoints as needed
  // static const String someEndpoint = '$baseUrl/some/path';
}
