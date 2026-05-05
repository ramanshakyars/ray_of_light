import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/profile/provider/profile_provider.dart';
import 'package:rayoflite/presentation/screens/features/profile/widgets/profile_header.dart';
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
      // context.read<ProfileProvider>().fetchThoughts();
      // context.read<ProfileProvider>().fetchPosts();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final profileProvider = context.watch<ProfileProvider>();
    final auth = context.watch<AuthProvider>();
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
                          const SizedBox(height: 24),
                          const WeeklyChart(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        TabBar(
                          controller: _tabController,
                          indicatorColor: AppColors.getMonoTextPrimary(isDark),
                          indicatorWeight: 2,
                          dividerColor: AppColors.getMonoBorder(isDark),

                          labelColor: AppColors.getMonoTextPrimary(isDark),
                          unselectedLabelColor: AppColors.getMonoTextMuted(
                            isDark,
                          ),

                          labelStyle: AppTextStyles.monoMedium18(isDark),
                          unselectedLabelStyle: AppTextStyles.monoMedium18(
                            isDark,
                          ),

                          splashFactory: NoSplash.splashFactory,
                          overlayColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),

                          tabs: const [
                            Tab(text: "Thoughts"),
                            Tab(text: "Posts"),
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
                    _buildTabList(
                      isLoading: profileProvider.isLoadingThoughts,
                      items: profileProvider.thoughts,
                      isDark: isDark,
                      emptyMessage: "No thoughts shared yet.",
                    ),
                    _buildTabList(
                      isLoading: profileProvider.isLoadingPosts,
                      items: profileProvider.posts,
                      isDark: isDark,
                      emptyMessage: "No posts yet.",
                    ),
                  ],
                ),
              ),
            ),

            /// 🔹 Settings Icon (Fixed at top right)
            Positioned(
              top: 8,
              right: 16,
              child: IconButton(
                onPressed:
                    () => context.push(
                      '${RouteNames.mainApp}/${RouteNames.settings}',
                    ),
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
}

Widget _buildTabList({
  required bool isLoading,
  required List items,
  required bool isDark,
  required String emptyMessage,
}) {
  if (isLoading) {
    return const Center(child: CircularProgressIndicator());
  }
  if (items.isEmpty) {
    return Center(
      child: Text(emptyMessage, style: TextStyle(color: Colors.grey[500])),
    );
  }
  return ListView.separated(
    padding: const EdgeInsets.symmetric(vertical: 16),
    itemCount: items.length,
    separatorBuilder:
        (_, __) => Divider(color: isDark ? Colors.white10 : Colors.black12),
    itemBuilder: (context, index) {
      final item = items[index];
      return ListTile(
        title: Text(
          item.content ?? "Untitled",
          style: TextStyle(color: AppColors.getTextPrimaryColor(isDark)),
        ),
        subtitle: Text(
          "Posted on ${item.date}",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      );
    },
  );
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this.isDark);
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
      color: AppColors.getMonoBackground(
        isDark,
      ), // Keeps tabs opaque while scrolling
      child: Material(
        color: AppColors.getMonoBackground(isDark), // 👈 actual background fix
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
