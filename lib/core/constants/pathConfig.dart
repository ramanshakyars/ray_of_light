class PathConfig {
  // static const String baseUrl = 'http://localhost:9090/rayoflight/api';
  static const String baseUrl = 'http://ec2-3-111-209-210.ap-south-1.compute.amazonaws.com/rayoflight/api';

  // Auth endpoints
  static const String login = '$baseUrl/public/login';
  static const String register = '$baseUrl/public/register';
  static const String logout = '$baseUrl/auth/logout';

  // User endpoints
  static const String userProfile = '$baseUrl/user/profile';
  static const String updateProfile = '$baseUrl/user/update';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';

  //Goal Tracker endpoints
  static const String getGoals = '$baseUrl/goal';
  static const String createGoal = '$baseUrl/goal';

  // Journal endpoints
  static const String getJournals = '$baseUrl/journal/entries';
  static const String postJournals = '$baseUrl/journal/entries';

  // Mood endpoints
  static const String getCurrentMood = '$baseUrl/mood/current';
  static const String setMood = '$baseUrl/mood/set';
}
