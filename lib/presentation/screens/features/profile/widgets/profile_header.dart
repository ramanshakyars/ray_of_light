import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/profile/provider/profile_provider.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String? _localPhotoUrl;

  Future<void> _pickAndUpload(BuildContext context) async {
    final profileProvider = context.read<ProfileProvider>();
    final colors = context.read<ThemeProvider>().colors;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _PickerSheet(colors: colors),
    );

    if (source == null) return;

    try {
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
        final user = await LocalStorageService.getUser() ?? {};
        user['profilePhotoUrl'] = newUrl;
        await LocalStorageService.setUser(user);
        if (context.mounted) {
          context.read<AuthProvider>().loadUser();
        }
      } else if (profileProvider.photoUploadError != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(profileProvider.photoUploadError!),
            backgroundColor: colors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Could not access camera or photos"),
            backgroundColor: colors.error,
          ),
        );
      }
    }
  }

  String _formatName(String text) {
    if (text.trim().isEmpty) return text;
    return text.trim().split(' ').map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '').join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final auth = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    final photoUrl = _localPhotoUrl ??
        (auth.user?['profilePhotoUrl'] as String?);

    final name = auth.name.isNotEmpty ? auth.name : 'User';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Column(
      children: [
        // ─── Avatar ───
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
                  color: colors.surface,
                  border: Border.all(
                    color: colors.border,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: profileProvider.isUploadingPhoto
                      ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: colors.primary))
                      : photoUrl != null && photoUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: photoUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Center(
                                child: Text(initials,
                                    style: AppTextStyles.screenTitle(colors)),
                              ),
                              errorWidget: (_, __, ___) => Center(
                                child: Text(initials,
                                    style: AppTextStyles.screenTitle(colors)),
                              ),
                            )
                          : Center(
                              child: Text(initials,
                                  style: AppTextStyles.screenTitle(colors)),
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
                    color: colors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.background,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 14,
                    color: colors.primaryForeground,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 14),

        // ─── Name ───
        Text(_formatName(name), style: AppTextStyles.screenTitle(colors)),

        const SizedBox(height: 4),

        // ─── Subtitle / Email ───
        Text(
          auth.user?['email'] as String? ?? 'Spreading light ✨',
          style: AppTextStyles.bodySecondary(colors),
        ),
      ],
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final ThemeColors colors;
  const _PickerSheet({required this.colors});

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
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text('Change Profile Photo',
                style: AppTextStyles.sectionTitle(colors)),
            const SizedBox(height: 16),
            _tile(
              context,
              icon: Icons.camera_alt_outlined,
              label: 'Take Photo',
              colors: colors,
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            _tile(
              context,
              icon: Icons.photo_library_outlined,
              label: 'Choose from Gallery',
              colors: colors,
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            _tile(
              context,
              icon: Icons.close,
              label: 'Cancel',
              colors: colors,
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
      required ThemeColors colors,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: colors.icon),
      title: Text(label, style: AppTextStyles.bodyText(colors)),
      onTap: onTap,
    );
  }
}