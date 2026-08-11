import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/providers/auth_provider.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/composer/create_post_sheet.dart';
import 'package:rayoflite/presentation/screens/features/social-insights-v2/composer/quick_composer.dart';

import ' widgets/empty_state.dart';
import ' widgets/error_state.dart';
import ' widgets/feed_shimmer.dart';
import ' widgets/home_header.dart';
import ' widgets/no_internet_state.dart';
import ' widgets/post_card_v2.dart';
import '../../notifications/dummy_notification_scheduler.dart';
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
    Future.delayed(const Duration(seconds: 2), () async {
      await DummyNotificationScheduler.requestPermissionAndSchedule();
    });
  }

  void _openCreateSheet() async {
    final created = await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
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
    final colors = context.watch<ThemeProvider>().colors;
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Consumer<SocialFeedProvider>(
          builder: (context, vm, _) {
            return RefreshIndicator(
              onRefresh: vm.loadPosts,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: (vm.state == FeedState.loaded && vm.posts.isNotEmpty)
                    ? 2 + vm.posts.length
                    : 3,
                itemBuilder: (context, index) {
                  // HEADER
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: HomeHeader(userName: auth.name),
                    );
                  }

                  // COMPOSER
                  if (index == 1) {
                    return QuickComposer(
                      onPhotoTap: _openCreateSheet,
                      onMoodTap: _openCreateSheet,
                      onTextTap: _openCreateSheet,
                    );
                  }

                  // STATE HANDLING (index == 2)
                  if (vm.state == FeedState.loading || vm.state == FeedState.initial) {
                    return const FeedShimmer();
                  }

                  if (vm.state == FeedState.noInternet) {
                    return NoInternetState(onRetry: vm.loadPosts);
                  }

                  if (vm.state == FeedState.error) {
                    return ErrorState(onRetry: vm.loadPosts);
                  }

                  // EMPTY STATE
                  if (vm.state == FeedState.empty || vm.posts.isEmpty) {
                    return const EmptyState();
                  }

                  final post = vm.posts[index - 2];
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
