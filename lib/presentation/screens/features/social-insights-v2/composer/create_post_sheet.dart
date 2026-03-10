import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/provider/social_feed_provider.dart';
import 'package:rayoflite/presentation/screens/social-insights/socialService.dart';

class CreatePostSheet extends StatefulWidget {
  const CreatePostSheet({super.key});

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController controller = TextEditingController();
  final List<File> images = [];
  bool isPosting = false;

  Future<void> pickImages() async {
    final imgs = await _picker.pickMultiImage();

    if (imgs.isNotEmpty) {
      images.addAll(imgs.map((e) => File(e.path)));
      setState(() {});
    }
  }

 Future<void> submitPost() async {
  if (controller.text.trim().isEmpty && images.isEmpty) {
    MessageService.showError(context, "Write something or add a photo");
    return;
  }

  try {
    setState(() {
      isPosting = true;
    });

    await SocialService.createPostV2(
      caption: controller.text.trim(),
      images: images,
    );

    if (!mounted) return;

    /// return success to parent
    Navigator.pop(context, true);

  } catch (e) {
    MessageService.showError(context, "Failed to create post");
  } finally {
    if (mounted) {
      setState(() {
        isPosting = false;
      });
    }
  }
}
  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Container(
      height: MediaQuery.of(context).size.height * .75,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.getMonoCard(isDark),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP BAR
          Row(
            children: [
              /// CANCEL
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: AppTextStyles.monoSecondary14(isDark),
                ),
              ),

              const Spacer(),

              Text("Create post", style: AppTextStyles.monoMedium18(isDark)),

              const Spacer(),

              /// POST BUTTON
              GestureDetector(
                onTap: isPosting ? null : submitPost,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.getMonoTextPrimary(isDark),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: AppColors.getMonoBackground(isDark),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          /// IMAGE PICKER
          GestureDetector(
            onTap: pickImages,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.getMonoSurface(isDark),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.add,
                size: 36,
                color: AppColors.getMonoIcon(isDark),
              ),
            ),
          ),

          const SizedBox(height: 24),

          /// TEXT INPUT
          TextField(
            controller: controller,
            style: AppTextStyles.monoRegular16(isDark),
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "What's on your mind?",
              hintStyle: AppTextStyles.monoSecondary14(isDark),
              border: InputBorder.none,
            ),
          ),

          const SizedBox(height: 10),

          Divider(color: AppColors.getMonoDivider(isDark)),

          const SizedBox(height: 16),

          /// IMAGE PREVIEW
          if (images.isNotEmpty)
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        images[i],
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

          const Spacer(),

          /// BOTTOM HINT
          Center(
            child: Text(
              "Share your thoughts with kindness and light",
              style: AppTextStyles.monoMuted12(isDark),
            ),
          ),
        ],
      ),
    );
  }
}
