// chat_history.dart
class ChatHistory {
  
  final String id;
  final String title;
  final DateTime timestamp;
  final String lastMessage;

  ChatHistory({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.lastMessage,
  });

  // Simulated history data
  static List<ChatHistory> get simulatedHistory => [
    ChatHistory(
      id: '1',
      title: 'Introduction',
      timestamp: DateTime.now().subtract(Duration(minutes: 30)),
      lastMessage: 'Hi, I was thinking about you',
    ),
    ChatHistory(
      id: '2',
      title: 'Curious question',
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      lastMessage: 'What were you doing?',
    ),
    ChatHistory(
      id: '3',
      title: 'General chat',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      lastMessage: 'Tell me something interesting',
    ),
  ];
}
