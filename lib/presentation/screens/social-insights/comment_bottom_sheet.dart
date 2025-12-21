// import 'package:flutter/material.dart';
// import 'package:rayoflite/presentation/screens/social-insights/Post.dart';
// import 'package:rayoflite/presentation/screens/social-insights/models/comment_model.dart';
// import 'package:rayoflite/presentation/screens/social-insights/socialService.dart';
// import 'package:rayoflite/presentation/screens/social-insights/widgets/comment_tile.dart';

// class CommentBottomSheet extends StatefulWidget {
//   final Post post;

//   const CommentBottomSheet({super.key, required this.post});

//   @override
//   State<CommentBottomSheet> createState() => _CommentBottomSheetState();
// }

// class _CommentBottomSheetState extends State<CommentBottomSheet> {
//   final TextEditingController _controller = TextEditingController();
//   List<Comment> _comments = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadComments();
//   }

//   Future<void> _loadComments() async {
//     try {
//       final comments = await SocialService.getComments(widget.post.id);
//       if (mounted) {
//         setState(() {
//           _comments = comments;
//           _loading = false; // Data aate hi spinner stop hoga
//         });
//       }
//     } catch (e) {
//       print("Error parsing comments: $e");
//       if (mounted) {
//         setState(() => _loading = false);
//         // Agar error aaye toh user ko batao
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Parsing Error: Check data format")),
//         );
//       }
//     }
//   }

//   Future<void> _postComment() async {
//     if (_controller.text.trim().isEmpty) return;
//     try {
//       final newComment = await SocialService.commentOnPost(
//         postId: widget.post.id,
//         text: _controller.text.trim(),
//       );
//       setState(() {
//         _comments.insert(0, newComment);
//         _controller.clear();
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Failed to comment")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         left: 16,
//         right: 16,
//         top: 16,
//       ),
//       height: MediaQuery.of(context).size.height * 0.8,
//       decoration: BoxDecoration(
//         color: isDark ? Colors.grey[900] : Colors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Colors.grey,
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//           const SizedBox(height: 15),
//           Expanded(
//             child:
//                 _loading
//                     ? const Center(child: CircularProgressIndicator())
//                     : ListView.builder(
//                       itemCount: _comments.length,
//                       itemBuilder:
//                           (context, index) => CommentTile(
//                             comment: _comments[index],
//                             isDark: isDark,
//                           ),
//                     ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: "Write a comment...",
//                       filled: true,
//                       fillColor: isDark ? Colors.black26 : Colors.grey[100],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.blue),
//                   onPressed: _postComment,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
