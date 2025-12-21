// import 'package:rayoflite/presentation/screens/social-insights/Post.dart';

// class Comment {
//   final String id;
//   final String text;
//   final DateTime createdAt;
//   final String postId;
//   final Author author;

//   Comment({
//     required this.id,
//     required this.text,
//     required this.createdAt,
//     required this.postId,
//     required this.author,
//   });

//   factory Comment.fromJson(Map<String, dynamic> json) {
//     // Backend se array aa raha hai: [year, month, day, hour, minute, second, nanosecond]
//     DateTime parsedDate;
//     if (json['createdAt'] is List) {
//       List<dynamic> dateList = json['createdAt'];
//       parsedDate = DateTime(
//         dateList[0], // Year
//         dateList[1], // Month
//         dateList[2], // Day
//         dateList[3], // Hour
//         dateList[4], // Minute
//         dateList[5], // Second
//       );
//     } else {
//       parsedDate = DateTime.now();
//     }

//     return Comment(
//       id: json['id'] ?? '',
//       text: json['text'] ?? '',
//       postId: json['postId'] ?? '',
//       createdAt: parsedDate,
//       author: Author.fromJson(json['author'] ?? {}),
//     );
//   }
// }