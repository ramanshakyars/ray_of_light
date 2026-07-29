import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/profile/provider/profile_provider.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String? _localPhotoUrl; // tracks optimistically after upload

  Future<void> _pickAndUpload(BuildContext context) async {
    final profileProvider = context.read<ProfileProvider>();
    final isDark = context.read<ThemeProvider>().isDarkMode;

    // Show bottom sheet to pick source
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.getMonoCard(isDark),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _PickerSheet(isDark: isDark),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (picked == null) return;

    final file = File(picked.path);
    final newUrl = await profileProvider.uploadProfilePhoto(file);

    if (newUrl != null && mounted) {
      setState(() => _localPhotoUrl = newUrl);
      // Also persist in local storage so it survives restarts
      final user = await LocalStorageService.getUser() ?? {};
      user['profilePhotoUrl'] = newUrl;
      await LocalStorageService.setUser(user);
    } else if (profileProvider.photoUploadError != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(profileProvider.photoUploadError!),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final auth = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    // Derive photo URL: local optimistic → from auth user data → null
    final photoUrl = _localPhotoUrl ??
        (auth.user?['profilePhotoUrl'] as String?);

    final name = auth.name.isNotEmpty ? auth.name : 'User';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Column(
      children: [
        // ─── Avatar with camera overlay ───
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: () => _pickAndUpload(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.getMuted(isDark),
                  border: Border.all(
                    color: AppColors.getMonoBorder(isDark),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: profileProvider.isUploadingPhoto
                      ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                      : photoUrl != null && photoUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: photoUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Center(
                                child: Text(initials,
                                    style: AppTextStyles.bold22(isDark)),
                              ),
                              errorWidget: (_, __, ___) => Center(
                                child: Text(initials,
                                    style: AppTextStyles.bold22(isDark)),
                              ),
                            )
                          : Center(
                              child: Text(initials,
                                  style: AppTextStyles.bold22(isDark)),
                            ),
                ),
              ),
            ),

            // Camera edit button
            if (!profileProvider.isUploadingPhoto)
              GestureDetector(
                onTap: () => _pickAndUpload(context),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.getMonoTextPrimary(isDark),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.getMonoBackground(isDark),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 14,
                    color: AppColors.getMonoBackground(isDark),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 14),

        // ─── Name ───
        Text(name, style: AppTextStyles.bold28(isDark)),

        const SizedBox(height: 4),

        // ─── Email / subtitle ───
        Text(
          auth.user?['email'] as String? ?? 'Spreading light ✨',
          style: AppTextStyles.regular14(isDark).copyWith(
            color: AppColors.getMonoTextMuted(isDark),
          ),
        ),
      ],
    );
  }
}

// ─── Bottom sheet picker ───
class _PickerSheet extends StatelessWidget {
  final bool isDark;
  const _PickerSheet({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.getMonoBorder(isDark),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text('Change Profile Photo',
                style: AppTextStyles.monoMedium18(isDark)),
            const SizedBox(height: 16),
            _tile(
              context,
              icon: Icons.camera_alt_outlined,
              label: 'Take Photo',
              isDark: isDark,
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            _tile(
              context,
              icon: Icons.photo_library_outlined,
              label: 'Choose from Gallery',
              isDark: isDark,
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            _tile(
              context,
              icon: Icons.close,
              label: 'Cancel',
              isDark: isDark,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context,
      {required IconData icon,
      required String label,
      required bool isDark,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.getMonoTextPrimary(isDark)),
      title: Text(label, style: AppTextStyles.monoRegular16(isDark)),
      onTap: onTap,
    );
  }
}