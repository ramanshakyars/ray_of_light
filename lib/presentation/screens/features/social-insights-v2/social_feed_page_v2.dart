import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/composer/create_post_sheet.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/composer/quick_composer.dart';

import ' widgets/empty_state.dart';
import ' widgets/error_state.dart';
import ' widgets/feed_shimmer.dart';
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

  void _openCreateSheet() async {
    final created = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreatePostSheet(),
    );

    if (created == true) {
      context.read<SocialFeedProvider>().loadPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDark),
      body: SafeArea(
        child: Consumer<SocialFeedProvider>(
          builder: (context, vm, _) {
            // ================= LOADING =================
            if (vm.state == FeedState.loading) {
              return const FeedShimmer();
            }

            // ================= NO INTERNET =================
            if (vm.state == FeedState.noInternet) {
              return NoInternetState(onRetry: vm.loadPosts);
            }

            // ================= ERROR =================
            if (vm.state == FeedState.error) {
              vm.state = FeedState.loaded; // fallback
            }

            return RefreshIndicator(
              onRefresh: vm.loadPosts,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 3 + vm.posts.length,
                itemBuilder: (context, index) {
                  // HEADER
                  if (index == 0) {
                    return HomeHeader(userName: auth.name);
                  }

                  // COMPOSER

                  if (index == 1) {
                    if (!auth.isAdmin) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: QuickComposer(
                        onPhotoTap: _openCreateSheet,
                        onMoodTap: _openCreateSheet,
                        onTextTap: _openCreateSheet,
                      ),
                    );
                  }

                  // SPACING
                  if (index == 2) {
                    return const SizedBox(height: 16);
                  }

                  // EMPTY STATE
                  if (vm.posts.isEmpty) {
                    return const EmptyState();
                  }

                  final post = vm.posts[index - 3];
                  return PostCardV2(post: post);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
