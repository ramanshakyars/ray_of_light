class PathConfig {
 // static const String baseUrl = 'http://localhost:9090';
  static const String baseUrl = 'http://ec2-3-111-209-210.ap-south-1.compute.amazonaws.com';

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

  // Journal endpoints
  static const String getJournals = '$baseUrl/rayoflight/api/journal/entries';
  static const String postJournals = '$baseUrl/rayoflight/api/journal/entries';

  // Mood endpoints
  static const String getCurrentMood = '$baseUrl/rayoflight/api/mood/current';
  static const String setMood = '$baseUrl/rayoflight/api/mood/set';
}
