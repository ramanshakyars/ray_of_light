import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
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
    final colors = context.watch<ThemeProvider>().colors;

    return Container(
      height: MediaQuery.of(context).size.height * .75,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Text(
            "Comments",
            style: AppTextStyles.sectionTitle(colors),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: colors.primary,
                    ),
                  )
                : comments.isEmpty
                    ? Center(
                        child: Text(
                          "No comments yet",
                          style: AppTextStyles.bodySecondary(colors),
                        ),
                      )
                    : ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (_, i) {
                          final c = comments[i];
                          final author = c["author"];
                          final username = author?["username"] ?? "Anonymous";
                          final text = c["text"] ?? "";

                          return ListTile(
                            title: Text(
                              username,
                              style: AppTextStyles.cardTitle(colors),
                            ),
                            subtitle: Text(
                              text,
                              style: AppTextStyles.bodySecondary(colors),
                            ),
                          );
                        },
                      ),
          ),

          // Input row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: colors.inputBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colors.inputBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: AppTextStyles.inputText(colors),
                    decoration: InputDecoration(
                      hintText: "Write something kind...",
                      hintStyle: AppTextStyles.hintText(colors),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: addComment,
                  child: Icon(
                    Icons.send_rounded,
                    color: colors.primary,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
