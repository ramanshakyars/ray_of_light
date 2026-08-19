import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/models/post_report_model.dart';
import 'package:rayoflite/presentation/screens/social-insights/socialService.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  bool _isLoading = true;
  String? _errorMessage;
  PostReportPageResDto? _reportPage;
  int _currentPage = 0;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports({int page = 0}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await SocialService.getPendingReports(
        page: page,
        size: _pageSize,
      );
      setState(() {
        _reportPage = res;
        _currentPage = page;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _showReviewDialog(
    PostReportResDto report,
    PostReportReviewAction action,
  ) async {
    final colors = context.read<ThemeProvider>().colors;
    final isTakeAction = action == PostReportReviewAction.TAKE_ACTION;
    final defaultRemark = isTakeAction
        ? 'Post contains prohibited content.'
        : 'No policy violation found.';

    final remarkController = TextEditingController(text: defaultRemark);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(
              isTakeAction ? Icons.gavel_rounded : Icons.check_circle_outline_rounded,
              color: isTakeAction ? Colors.redAccent : Colors.green,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                isTakeAction ? 'Take Action on Post' : 'Dismiss Report',
                style: AppTextStyles.cardTitle(colors).copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isTakeAction
                  ? 'This will deactivate the post and mark the report as Action Taken.'
                  : 'This will dismiss the report without taking down the post.',
              style: AppTextStyles.hintText(colors).copyWith(fontSize: 13),
            ),
            const SizedBox(height: 14),
            Text(
              'Admin Remark:',
              style: AppTextStyles.cardTitle(colors).copyWith(fontSize: 12),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: remarkController,
              maxLines: 2,
              style: AppTextStyles.bodyText(colors),
              decoration: InputDecoration(
                hintText: 'Enter reason / remark...',
                filled: true,
                fillColor: colors.cardBackground,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.border),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isTakeAction ? Colors.redAccent : Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(isTakeAction ? 'Take Action' : 'Dismiss'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final remark = remarkController.text.trim();
      try {
        await SocialService.reviewReport(
          reportId: report.reportId,
          action: action,
          adminRemark: remark,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: isTakeAction ? Colors.redAccent : Colors.green,
              content: Text(
                isTakeAction
                    ? 'Action taken successfully. Post deactivated.'
                    : 'Report dismissed successfully.',
              ),
            ),
          );
          _fetchReports(page: _currentPage);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Failed to submit review: $e'),
            ),
          );
        }
      }
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'N/A';
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pending Reports Moderation',
          style: AppTextStyles.cardTitle(colors).copyWith(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: colors.textPrimary),
            onPressed: () => _fetchReports(page: _currentPage),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              size: 48, color: Colors.redAccent),
                          const SizedBox(height: 12),
                          Text(
                            'Failed to load reports',
                            style: AppTextStyles.cardTitle(colors),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.hintText(colors),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _fetchReports(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          )
                        ],
                      ),
                    ),
                  )
                : (_reportPage == null || _reportPage!.reports.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified_user_rounded,
                                size: 56,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Pending Reports',
                              style: AppTextStyles.cardTitle(colors).copyWith(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Great job! All reported posts have been reviewed.',
                              style: AppTextStyles.hintText(colors),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _fetchReports(page: _currentPage),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _reportPage!.reports.length,
                          itemBuilder: (context, index) {
                            final report = _reportPage!.reports[index];
                            return _buildReportCard(report, colors);
                          },
                        ),
                      ),
      ),
    );
  }

  Widget _buildReportCard(PostReportResDto report, dynamic colors) {
    final post = report.post;
    final reporter = report.reporter;
    final reason = report.reason;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header: Reason Badge & Status Tag
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(reason.icon, size: 14, color: Colors.redAccent),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          reason.title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: report.status.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  report.status.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: report.status.color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Reporter Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.person_outline_rounded, size: 16, color: colors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Reported by: ',
                          style: AppTextStyles.hintText(colors).copyWith(fontSize: 12),
                        ),
                        Expanded(
                          child: Text(
                            reporter.name,
                            style: AppTextStyles.bodyText(colors).copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    if (reporter.username.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        reporter.username,
                        style: AppTextStyles.hintText(colors).copyWith(
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(report.reportedAt),
                style: AppTextStyles.hintText(colors).copyWith(fontSize: 11),
              ),
            ],
          ),

          if (report.description != null && report.description!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.format_quote_rounded, size: 14, color: Colors.orangeAccent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Detail: "${report.description}"',
                      style: AppTextStyles.bodyText(colors).copyWith(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),

          // Post Content Preview Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.article_outlined, size: 16, color: Colors.blueAccent),
                    const SizedBox(width: 6),
                    Text(
                      'Reported Post Details',
                      style: AppTextStyles.cardTitle(colors).copyWith(
                        fontSize: 13,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: post.active ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        post.active ? 'ACTIVE' : 'INACTIVE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: post.active ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  post.caption.isNotEmpty ? post.caption : '[No Caption]',
                  style: AppTextStyles.bodyText(colors).copyWith(fontSize: 13),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                if (post.mediaUrls.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: post.mediaUrls.length,
                      itemBuilder: (ctx, mIdx) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(post.mediaUrls[mIdx]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Action Buttons for Admin Review
          if (report.status == PostReportStatus.PENDING) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showReviewDialog(
                      report,
                      PostReportReviewAction.DISMISS,
                    ),
                    icon: const Icon(Icons.close_rounded, size: 16, color: Colors.grey),
                    label: const Text('Dismiss Report'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.textPrimary,
                      side: BorderSide(color: colors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showReviewDialog(
                      report,
                      PostReportReviewAction.TAKE_ACTION,
                    ),
                    icon: const Icon(Icons.remove_circle_outline_rounded, size: 16),
                    label: const Text('Take Action'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Status Info for reviewed reports
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: report.status.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: report.status.color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reviewed by ${report.reviewedBy ?? "Admin"}: ${report.adminRemark ?? "No remark"}',
                      style: TextStyle(
                        fontSize: 12,
                        color: report.status.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
