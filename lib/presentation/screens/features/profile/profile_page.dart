import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/app_theme_colors.dart';
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
    final colors = context.watch<ThemeProvider>().colors;
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async => _loadAllData(),
              color: colors.primary,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    const SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          ProfileHeader(),
                          SizedBox(height: 28),
                          WeeklyChart(),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverTabBarDelegate(
                        TabBar(
                          controller: _tabController,
                          indicatorColor: colors.primary,
                          indicatorWeight: 2.5,
                          dividerColor: colors.divider,
                          labelColor: colors.textPrimary,
                          unselectedLabelColor: colors.textMuted,
                          labelStyle: AppTextStyles.cardTitle(colors),
                          unselectedLabelStyle: AppTextStyles.cardTitle(colors),
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          tabs: const [
                            Tab(text: 'Thoughts'),
                            Tab(text: 'Posts'),
                          ],
                        ),
                        colors,
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    // ─── Thoughts Tab ───
                    _buildThoughtsTab(profileProvider, colors),

                    // ─── Posts Tab ───
                    _buildPostsTab(profileProvider, colors),
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
                  color: colors.icon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThoughtsTab(ProfileProvider provider, ThemeColors colors) {
    if (provider.isLoadingThoughts) {
      return Center(child: CircularProgressIndicator(color: colors.primary));
    }
    if (provider.thoughtsError != null) {
      return _errorState(provider.thoughtsError!, colors,
          onRetry: () => provider.fetchThoughts());
    }
    if (provider.thoughts.isEmpty) {
      return _emptyState(
        icon: Icons.edit_note_rounded,
        message: 'No thoughts yet',
        sub: 'Your journal entries will appear here.',
        colors: colors,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 16),
      itemCount: provider.thoughts.length,
      itemBuilder: (_, i) => ThoughtCard(thought: provider.thoughts[i]),
    );
  }

  Widget _buildPostsTab(ProfileProvider provider, ThemeColors colors) {
    if (provider.isLoadingPosts) {
      return Center(child: CircularProgressIndicator(color: colors.primary));
    }
    if (provider.postsError != null) {
      return _errorState(provider.postsError!, colors,
          onRetry: () => provider.fetchPosts());
    }
    if (provider.posts.isEmpty) {
      return _emptyState(
        icon: Icons.photo_library_outlined,
        message: 'No posts yet',
        sub: 'Your shared posts will appear here.',
        colors: colors,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 16),
      itemCount: provider.posts.length,
      itemBuilder: (_, i) => PostCard(post: provider.posts[i]),
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String message,
    required String sub,
    required ThemeColors colors,
  }) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: colors.textMuted),
            ),
            const SizedBox(height: 14),
            Text(message, style: AppTextStyles.sectionTitle(colors)),
            const SizedBox(height: 6),
            Text(
              sub,
              style: AppTextStyles.bodySecondary(colors),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(
    String message,
    ThemeColors colors, {
    required VoidCallback onRetry,
  }) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 40, color: colors.textMuted),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyles.bodySecondary(colors),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: Text('Retry', style: AppTextStyles.cardTitle(colors)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final ThemeColors _colors;

  _SliverTabBarDelegate(this._tabBar, this._colors);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: _colors.background,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
