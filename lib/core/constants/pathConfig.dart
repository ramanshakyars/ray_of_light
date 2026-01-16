class PathConfig {
   static const String baseUrl = 'http://localhost:9090/rayoflight/api';
  //  static const String baseUrl = 'http://192.168.1.6:9090/rayoflight/api';
  // static const String baseUrl = 'http://ec2-3-111-209-210.ap-south-1.compute.amazonaws.com/rayoflight/api';
//  static const String baseUrl = 'https://api.rayoflight.life/rayoflight/api';

  // Auth endpoints
  static const String login = '$baseUrl/public/login';
  static const String verifyOtp = '$baseUrl/public/register/initiate';
  static const String register = '$baseUrl/public/register/complete';
  static const String passwordReset = '$baseUrl/public/password/reset/initiate';
  static const String passwordResetComplete = '$baseUrl/public/password/reset/complete';
  static const String logout = '$baseUrl/auth/logout';
  static const String deleteAccount = '$baseUrl/log-out/deactivate';


  // User endpoints
  static const String userProfile = '$baseUrl/user/profile';
  static const String updateProfile = '$baseUrl/user/update';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';

  //Goal Tracker endpoints
  static const String getGoals = '$baseUrl/goal';
  static const String createGoal = '$baseUrl/goal';
  static const String updateGoalStatus = '$baseUrl/goal/update-status';

  // Journal endpoints
  static const String getJournals = '$baseUrl/journal/entries';
  static const String postJournals = '$baseUrl/journal/entries';

  // Mood endpoints
  static const String getCurrentMood = '$baseUrl/mood/current';
  static const String setMood = '$baseUrl/mood/set';

  // Talk to light endpoints
  static const String sendChat = '$baseUrl/chat/message';
  static const String getChatHistory = '$baseUrl/chat/conversations/list-title';
  static const String getChatHistoryById = '$baseUrl/chat/conversations';
  static const String renameChat = '$baseUrl/chat/conversations/rename';
  static const String deletechat = '$baseUrl/chat/conversations';
  static const String clearChatsMemory = '$baseUrl/chat//conversations/clear-memory';
  static const String getConversationsList = '$baseUrl/chat/conversations/list';

  // social -feed 
    static const String postInsight = '$baseUrl/insight/post';
    static const String getAllPosts = '$baseUrl/insight/get';
    static const String doCommentOnPost = '$baseUrl/insight/comment';
    static const String doLikeOnPost = '$baseUrl/insight/like';
    static const String getCommentsByPostId = '$baseUrl/insight/comments';

// notifications
    static const String getNotifications = '$baseUrl/notifications';
    static const String readNotifications = '$baseUrl/notifications/read';
    static const String registerDeviceToken = '$baseUrl/device/register';

}
