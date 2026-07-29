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

  static const int _maxChars = 500;

  // ─── PICK FROM GALLERY ──────────────────────────────────────────
  Future<void> pickImages() async {
    final imgs = await _picker.pickMultiImage(imageQuality: 85);
    if (imgs.isNotEmpty) {
      setState(() => images.addAll(imgs.map((e) => File(e.path))));
    }
  }

  // ─── PICK FROM CAMERA ───────────────────────────────────────────
  Future<void> pickFromCamera() async {
    final img = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (img != null) {
      setState(() => images.add(File(img.path)));
    }
  }

  // ─── REMOVE IMAGE ───────────────────────────────────────────────
  void _removeImage(int index) {
    setState(() => images.removeAt(index));
  }

  // ─── SUBMIT ─────────────────────────────────────────────────────
  Future<void> submitPost() async {
    if (controller.text.trim().isEmpty && images.isEmpty) {
      MessageService.showError(context, "Write something or add a photo");
      return;
    }
    try {
      setState(() => isPosting = true);
      await SocialService.createPostV2(
        caption: controller.text.trim(),
        images: images,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      MessageService.showError(context, "Failed to create post");
    } finally {
      if (mounted) setState(() => isPosting = false);
    }
  }

  // ─── SHOW PICKER OPTIONS ────────────────────────────────────────
  void _showPickerOptions(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        decoration: BoxDecoration(
          color: AppColors.getMonoCard(isDark),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.getMonoBorder(isDark),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _optionTile(Icons.photo_library_rounded, "Choose from Gallery", pickImages, isDark),
            const SizedBox(height: 12),
            _optionTile(Icons.camera_alt_rounded, "Take a Photo", pickFromCamera, isDark),
          ],
        ),
      ),
    );
  }

  Widget _optionTile(IconData icon, String label, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.getMonoSurface(isDark),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.getMonoIcon(isDark), size: 24),
            const SizedBox(width: 16),
            Text(label, style: AppTextStyles.monoMedium18(isDark).copyWith(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final charCount = controller.text.length;
    final isOverLimit = charCount > _maxChars;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.getMonoCard(isDark),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── DRAG HANDLE ─────────────────────────────────────
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.getMonoBorder(isDark),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── TOP BAR ─────────────────────────────────────────
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text("Cancel", style: AppTextStyles.monoSecondary14(isDark)),
              ),
              const Spacer(),
              Text("New Post", style: AppTextStyles.monoMedium18(isDark).copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              GestureDetector(
                onTap: (isPosting || isOverLimit) ? null : submitPost,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                  decoration: BoxDecoration(
                    color: isOverLimit
                        ? AppColors.getMonoBorder(isDark)
                        : AppColors.getMonoTextPrimary(isDark),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: isPosting
                      ? SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.getMonoBackground(isDark),
                          ),
                        )
                      : Text(
                          "Post",
                          style: TextStyle(
                            color: AppColors.getMonoBackground(isDark),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── TEXT INPUT ──────────────────────────────────────
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.monoRegular16(isDark).copyWith(fontSize: 16, height: 1.6),
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                hintStyle: AppTextStyles.monoSecondary14(isDark).copyWith(fontSize: 16),
                border: InputBorder.none,
              ),
            ),
          ),

          // ── PHOTO GRID (Drag-to-Reorder) ────────────────────
          if (images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 130,
              child: ReorderableListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = images.removeAt(oldIndex);
                    images.insert(newIndex, item);
                  });
                },
                itemBuilder: (_, i) {
                  return _photoTile(i, context, isDark);
                },
              ),
            ),
          ],

          const SizedBox(height: 12),
          Divider(color: AppColors.getMonoDivider(isDark), height: 1),
          const SizedBox(height: 12),

          // ── BOTTOM TOOLBAR ──────────────────────────────────
          Row(
            children: [
              // Gallery
              _toolbarIcon(
                Icons.photo_library_outlined,
                "Gallery",
                () => _showPickerOptions(context, isDark),
                isDark,
              ),
              const SizedBox(width: 20),
              // Camera
              _toolbarIcon(
                Icons.camera_alt_outlined,
                "Camera",
                pickFromCamera,
                isDark,
              ),

              const Spacer(),

              // Character counter
              Text(
                "$charCount / $_maxChars",
                style: AppTextStyles.monoMuted12(isDark).copyWith(
                  color: isOverLimit ? Colors.red : AppColors.getMonoTextMuted(isDark),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── PHOTO TILE ───────────────────────────────────────────────────
  Widget _photoTile(int i, BuildContext context, bool isDark) {
    return Container(
      key: ValueKey(images[i].path),
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          // Image
          GestureDetector(
            onTap: () => _viewPhotoFullScreen(context, images[i]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                images[i],
                width: 120,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Index badge
          Positioned(
            top: 8, left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${i + 1}",
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Remove button
          Positioned(
            top: 6, right: 6,
            child: GestureDetector(
              onTap: () => _removeImage(i),
              child: Container(
                width: 26, height: 26,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── VIEW FULL SCREEN ──────────────────────────────────────────────
  void _viewPhotoFullScreen(BuildContext context, File image) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(image, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolbarIcon(IconData icon, String label, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, color: AppColors.getMonoIcon(isDark), size: 22),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.monoMuted12(isDark).copyWith(fontSize: 13)),
        ],
      ),
    );
  }
}
