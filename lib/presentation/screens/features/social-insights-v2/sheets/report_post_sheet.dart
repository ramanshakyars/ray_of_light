import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/services/messageService.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/models/post_report_model.dart';
import 'package:rayoflite/presentation/screens/social-insights/socialService.dart';

class ReportPostSheet extends StatefulWidget {
  final String postId;

  const ReportPostSheet({super.key, required this.postId});

  @override
  State<ReportPostSheet> createState() => _ReportPostSheetState();
}

class _ReportPostSheetState extends State<ReportPostSheet> {
  PostReportReason? _selectedReason;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  int _getWordCount(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_selectedReason == null) {
      MessageService.showError(context, 'Please select a reason for reporting.');
      return;
    }

    final wordCount = _getWordCount(_descriptionController.text);
    if (wordCount > 200) {
      MessageService.showError(context, 'Description cannot exceed 200 words (currently $wordCount words).');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await SocialService.reportPost(
        postId: widget.postId,
        reason: _selectedReason!,
        description: _descriptionController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context, true);
        MessageService.showSuccess(context, 'Report submitted successfully.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        String errorMsg = 'Failed to submit report';
        if (e is DioException && e.response?.data != null && e.response?.data is Map) {
          errorMsg = e.response?.data['message'] ?? e.response?.data['error'] ?? errorMsg;
        } else {
          errorMsg = e.toString().replaceAll('Exception:', '').trim();
        }
        if (errorMsg.toLowerCase().contains('own post') ||
            errorMsg.toLowerCase().contains('cannot report your own')) {
          errorMsg = 'You cannot report your own post';
        }

        MessageService.showError(context, errorMsg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final wordCount = _getWordCount(_descriptionController.text);
    final isWordCountExceeded = wordCount > 200;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.flag_rounded,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Report Post',
                    style: AppTextStyles.cardTitle(colors).copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: colors.icon),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Select a reason for reporting this post. Reports are kept confidential.',
              style: AppTextStyles.hintText(colors).copyWith(fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Reasons List (Matching Backend Enums)
            Column(
              children: PostReportReason.values.map((reason) {
                final isSelected = _selectedReason == reason;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.cardBackground
                        : colors.cardBackground.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? Colors.redAccent : colors.border,
                      width: isSelected ? 1.8 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedReason = reason;
                      });
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.redAccent.withOpacity(0.15)
                            : colors.border.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        reason.icon,
                        size: 20,
                        color: isSelected ? Colors.redAccent : colors.textPrimary,
                      ),
                    ),
                    title: Text(
                      reason.title,
                      style: AppTextStyles.cardTitle(colors).copyWith(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      reason.description,
                      style: AppTextStyles.hintText(colors).copyWith(fontSize: 12),
                    ),
                    trailing: Radio<PostReportReason>(
                      value: reason,
                      groupValue: _selectedReason,
                      activeColor: Colors.redAccent,
                      onChanged: (val) {
                        setState(() {
                          _selectedReason = val;
                        });
                      },
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Additional details input with 200 word counter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Additional Details (Optional)',
                  style: AppTextStyles.cardTitle(colors).copyWith(fontSize: 13),
                ),
                Text(
                  '$wordCount / 200 words',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isWordCountExceeded ? Colors.redAccent : colors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: AppTextStyles.bodyText(colors),
              decoration: InputDecoration(
                hintText: 'Describe the issue to help our moderation team (max 200 words)...',
                hintStyle: AppTextStyles.hintText(colors),
                filled: true,
                fillColor: colors.cardBackground,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isWordCountExceeded ? Colors.redAccent : colors.border,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isWordCountExceeded ? Colors.redAccent : colors.border,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isWordCountExceeded ? Colors.redAccent : Colors.redAccent,
                    width: 1.8,
                  ),
                ),
              ),
            ),
            if (isWordCountExceeded) ...[
              const SizedBox(height: 4),
              const Text(
                'Description cannot exceed 200 words.',
                style: TextStyle(color: Colors.redAccent, fontSize: 11),
              ),
            ],

            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSubmitting || isWordCountExceeded ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Submit Report',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
