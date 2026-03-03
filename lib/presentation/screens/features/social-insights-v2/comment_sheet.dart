import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/models/post_view_model.dart';

class CommentSheet extends StatefulWidget {
  final PostViewModel post;

  const CommentSheet({super.key, required this.post});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final controller = TextEditingController();
  bool loading = true;
 List<Map<String, dynamic>> comments = [];

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Future<void> loadComments() async {
    try {
      final res = await HttpService.get("/insight/comments/${widget.post.id}");
      comments = List<Map<String, dynamic>>.from(res);
    } catch (_) {}
    loading = false;
    setState(() {});
  }

  Future<void> addComment() async {
    if (controller.text.trim().isEmpty) return;

    await HttpService.postRaw("/insight/comment", {
      "postId": widget.post.id,
      "text": controller.text,
    });

    controller.clear();
    loadComments();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Container(
      height: MediaQuery.of(context).size.height * .75,
      decoration: BoxDecoration(
        color: AppColors.getMonoCard(isDark),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text("Comments", style: AppTextStyles.monoMedium18(isDark)),

          const SizedBox(height: 12),

          Expanded(
            child:
                loading
                    ? const Center(child: CircularProgressIndicator())
                    : comments.isEmpty
                    ? const Center(child: Text("No comments yet"))
                    : ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (_, i) {
                        final c = comments[i];

                        final author = c["author"];
                        final username = author?["username"] ?? "Anonymous";
                        final text = c["text"] ?? "";

                        return ListTile(
                          title: Text(username),
                          subtitle: Text(text),
                        );
                      },
                    ),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Write something kind...",
                  ),
                ),
              ),
              IconButton(onPressed: addComment, icon: const Icon(Icons.send)),
            ],
          ),
        ],
      ),
    );
  }
}
