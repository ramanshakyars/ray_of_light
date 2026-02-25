import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/profile/provider/profile_provider.dart';
import 'package:rayoflite/presentation/screens/features/profile/widgets/profile_header.dart';
import 'package:rayoflite/presentation/screens/features/profile/widgets/weekly_chart.dart';

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
  }

  @override
  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final provider = context.watch<ProfileProvider>();
    return Scaffold(
      backgroundColor: AppColors.getAppBackgroundColor(isDark),
    body: SafeArea(
  child: Stack(
    children: [

      /// 🔹 Main Content
      Column(
        children: [
          const SizedBox(height: 16),
          const ProfileHeader(),
          const SizedBox(height: 24),
          WeeklyChart(),
          const SizedBox(height: 24),
          TabBar(
            controller: _tabController,
            labelStyle: AppTextStyles.medium18(isDark),
            tabs: const [
              Tab(text: "Thoughts"),
              Tab(text: "Posts"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                provider.isLoadingThoughts
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: provider.thoughts.length,
                        itemBuilder: (_, i) =>
                            const ListTile(title: Text("Demo Content")),
                      ),
                provider.isLoadingPosts
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: provider.posts.length,
                        itemBuilder: (_, i) =>
                            const ListTile(title: Text("Demo Content")),
                      ),
              ],
            ),
          ),
        ],
      ),

      /// 🔹 Settings Icon (Top Right)
      Positioned(
        top: 8,
        right: 16,
        child: IconButton(
          onPressed: () {
              context.push('${RouteNames.mainApp}/${RouteNames.settings}');
          },
          icon: Icon(
            Icons.settings_outlined,
            size: 26,
            color: AppColors.monoDarkBackground,
          ),
        ),
      ),
    ],
  ),
),
    );
  }
}
