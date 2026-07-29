import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/profile/provider/profile_provider.dart';
import 'package:rayoflite/presentation/screens/features/profile/widgets/post_card.dart';
import 'package:rayoflite/presentation/screens/features/profile/widgets/profile_header.dart';
import 'package:rayoflite/presentation/screens/features/profile/widgets/thought_card.dart';
import 'package:rayoflite/presentation/screens/features/profile/widgets/weekly_chart.dart';
import 'package:rayoflite/presentation/screens/features/screen_time/data/ScreenTimeProvider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAllData();
  }

  void _loadAllData() {
    Future.microtask(() {
      context.read<ScreenTimeProvider>().fetchWeekly();
      context.read<ProfileProvider>().fetchThoughts();
      context.read<ProfileProvider>().fetchPosts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async => _loadAllData(),
              color: AppColors.getPrimary(isDark),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          const ProfileHeader(),
                          const SizedBox(height: 28),
                          const WeeklyChart(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverTabBarDelegate(
                        TabBar(
                          controller: _tabController,
                          indicatorColor: AppColors.getMonoTextPrimary(isDark),
                          indicatorWeight: 2,
                          dividerColor: AppColors.getMonoBorder(isDark),
                          labelColor: AppColors.getMonoTextPrimary(isDark),
                          unselectedLabelColor:
                              AppColors.getMonoTextMuted(isDark),
                          labelStyle: AppTextStyles.monoMedium18(isDark),
                          unselectedLabelStyle:
                              AppTextStyles.monoMedium18(isDark),
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          tabs: const [
                            Tab(text: 'Thoughts'),
                            Tab(text: 'Posts'),
                          ],
                        ),
                        isDark,
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    // ─── Thoughts Tab ───
                    _buildThoughtsTab(profileProvider, isDark),

                    // ─── Posts Tab ───
                    _buildPostsTab(profileProvider, isDark),
                  ],
                ),
              ),
            ),

            // ─── Settings icon (fixed top-right) ───
            Positioned(
              top: 8,
              right: 16,
              child: IconButton(
                onPressed: () => context.push(
                    '${RouteNames.mainApp}/${RouteNames.settings}'),
                icon: Icon(
                  Icons.settings_outlined,
                  size: 26,
                  color: AppColors.getIconColor(isDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThoughtsTab(ProfileProvider provider, bool isDark) {
    if (provider.isLoadingThoughts) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.thoughtsError != null) {
      return _errorState(provider.thoughtsError!, isDark,
          onRetry: () => provider.fetchThoughts());
    }
    if (provider.thoughts.isEmpty) {
      return _emptyState(
        icon: Icons.edit_note_rounded,
        message: 'No thoughts yet',
        sub: 'Your journal entries will appear here.',
        isDark: isDark,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 32),
      itemCount: provider.thoughts.length,
      itemBuilder: (_, i) =>
          ThoughtCard(thought: provider.thoughts[i], isDark: isDark),
    );
  }

  Widget _buildPostsTab(ProfileProvider provider, bool isDark) {
    if (provider.isLoadingPosts) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.postsError != null) {
      return _errorState(provider.postsError!, isDark,
          onRetry: () => provider.fetchPosts());
    }
    if (provider.posts.isEmpty) {
      return _emptyState(
        icon: Icons.photo_library_outlined,
        message: 'No posts yet',
        sub: 'Your shared posts will appear here.',
        isDark: isDark,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 32),
      itemCount: provider.posts.length,
      itemBuilder: (_, i) =>
          PostCard(post: provider.posts[i], isDark: isDark),
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String message,
    required String sub,
    required bool isDark,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 48, color: AppColors.getMonoTextMuted(isDark)),
          const SizedBox(height: 12),
          Text(message, style: AppTextStyles.monoMedium18(isDark)),
          const SizedBox(height: 6),
          Text(sub,
              style: AppTextStyles.monoMuted12(isDark),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _errorState(String message, bool isDark,
      {required VoidCallback onRetry}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded,
              size: 40, color: AppColors.getMonoTextMuted(isDark)),
          const SizedBox(height: 12),
          Text(message,
              style: AppTextStyles.monoMuted12(isDark),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onRetry,
            child: Text('Retry',
                style: AppTextStyles.monoMedium18(isDark)),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar, this.isDark);
  final TabBar _tabBar;
  final bool isDark;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.getMonoBackground(isDark),
      child: Material(
        color: AppColors.getMonoBackground(isDark),
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
