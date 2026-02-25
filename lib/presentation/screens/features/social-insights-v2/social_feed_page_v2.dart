import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/composer/quick_composer.dart';

import ' widgets/empty_state.dart';
import ' widgets/error_state.dart';
import ' widgets/home_header.dart';
import ' widgets/no_internet_state.dart';
import ' widgets/post_card_v2.dart';
import 'provider/social_feed_provider.dart';

class SocialFeedPageV2 extends StatefulWidget {
  const SocialFeedPageV2({super.key});

  @override
  State<SocialFeedPageV2> createState() => _SocialFeedPageV2State();
}

class _SocialFeedPageV2State extends State<SocialFeedPageV2> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SocialFeedProvider>().loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        child: Consumer<SocialFeedProvider>(
          builder: (context, vm, _) {
            if (vm.state == FeedState.noInternet) {
              return NoInternetState(onRetry: vm.loadPosts);
            }

            if (vm.state == FeedState.error) {
              return ErrorState(onRetry: vm.loadPosts);
            }

            return RefreshIndicator(
              onRefresh: vm.loadPosts,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const HomeHeader(userName: "Khushi"),
                  const SizedBox(height: 16),

                  QuickComposer(
                    onPhotoTap: () {},
                    onMoodTap: () {},
                    onTextTap: () {},
                  ),

                  const SizedBox(height: 16),

                  if (vm.posts.isEmpty) const EmptyState(),

                  ...vm.posts.map((e) => PostCardV2(post: e)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}