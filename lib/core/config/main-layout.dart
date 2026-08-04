import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  static void goToTab(BuildContext context, int index) {
    final routes = [
      RouteNames.home,
      RouteNames.talkToLight,
      RouteNames.junerlism,
      RouteNames.breathingExercise,
      RouteNames.goalTracker,
    ];

    if (index < 0 || index >= routes.length) return;

    context.go('${RouteNames.mainApp}/${routes[index]}');
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  late final List<String> _routes;

  // ── Navigation hide/show on scroll ──
  bool _navVisible = true;
  late final AnimationController _navSlideController;
  late final Animation<Offset> _navSlideAnimation;
  late final Animation<double> _navOpacityAnimation;

  // ── Active tab indicator animation ──
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _routes = [
      RouteNames.home,
      RouteNames.talkToLight,
      RouteNames.junerlism,
      RouteNames.breathingExercise,
      RouteNames.goalTracker,
    ];

    // Nav slide animation
    _navSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _navSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1.5),
    ).animate(CurvedAnimation(
      parent: _navSlideController,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeOutCubic,
    ));
    _navOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _navSlideController, curve: Curves.easeIn),
    );

    // Pulse for active icon glow
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final location = GoRouterState.of(context).uri.toString();
      setState(() {
        _currentIndex = _calculateIndex(location);
      });
    });
  }

  int _calculateIndex(String location) {
    if (location.contains(RouteNames.home)) return 0;
    if (location.contains(RouteNames.talkToLight)) return 1;
    if (location.contains(RouteNames.junerlism)) return 2;
    if (location.contains(RouteNames.breathingExercise)) return 3;
    if (location.contains(RouteNames.goalTracker)) return 4;
    return 0;
  }

  @override
  void dispose() {
    _navSlideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      // Ignore small threshold to avoid jitter
      return;
    }
    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      if (delta > 2 && _navVisible) {
        _hideNav();
      } else if (delta < -2 && !_navVisible) {
        _showNav();
      }
    }
  }

  void _hideNav() {
    setState(() => _navVisible = false);
    _navSlideController.forward();
  }

  void _showNav() {
    setState(() => _navVisible = true);
    _navSlideController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDarkMode = themeProvider.isDarkMode;
    final colors = themeProvider.colors;
    final location = GoRouterState.of(context).uri.toString();

    _currentIndex = _calculateIndex(location);

    // System UI overlay adapts to theme colors
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: colors.background,
        systemNavigationBarIconBrightness:
            isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    return Scaffold(
      backgroundColor: colors.background,
      // extendBody allows content to flow behind the floating nav
      extendBody: true,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _handleScrollNotification(notification);
          return false;
        },
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity ?? 0;
            if (velocity < -300) _goNext();
            if (velocity > 300) _goPrevious();
          },
          child: widget.child,
        ),
      ),
      bottomNavigationBar: _buildFloatingNav(colors, isDarkMode),
    );
  }

  // ─────────────────────────────────────────────────────────
  // NAVIGATION LOGIC
  // ─────────────────────────────────────────────────────────

  void _goNext() {
    if (_currentIndex < _routes.length - 1) {
      _navigateToTab(context, _currentIndex + 1);
    }
  }

  void _goPrevious() {
    if (_currentIndex > 0) {
      _navigateToTab(context, _currentIndex - 1);
    }
  }

  void _navigateToTab(BuildContext context, int index) {
    setState(() => _currentIndex = index);
    MainScreen.goToTab(context, index);
  }

  // ─────────────────────────────────────────────────────────
  // FLOATING GLASSMORPHISM BOTTOM NAV
  // ─────────────────────────────────────────────────────────

  Widget _buildFloatingNav(dynamic colors, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      child: SlideTransition(
        position: _navSlideAnimation,
        child: FadeTransition(
          opacity: _navOpacityAnimation,
          child: SafeArea(
            top: false,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: colors.card, // Solid, brighter background
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: colors.border.withValues(alpha: 0.5),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.08),
                    blurRadius: 24,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_routes.length, (index) {
                  return _buildNavItem(index, colors, isDark);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // INDIVIDUAL NAV ITEM — simpler, no pill
  // ─────────────────────────────────────────────────────────

  Widget _buildNavItem(int index, dynamic colors, bool isDark) {
    final selected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _navigateToTab(context, index),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedScale(
            scale: selected ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            child: _buildNavIcon(index, selected, colors),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // ICON BUILDER — theme-aware colors, updated Nest icon
  // ─────────────────────────────────────────────────────────

  Widget _buildNavIcon(int index, bool selected, dynamic colors) {
    final activeColor = colors.navActive as Color;
    final inactiveColor = colors.navInactive as Color;
    final color = selected ? activeColor : inactiveColor;
    const double size = 24.0;
    final key = ValueKey('nav_icon_${index}_$selected');

    switch (index) {
      case 0:
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Icon(
            selected ? Icons.home_rounded : Icons.home_outlined,
            key: key,
            color: color,
            size: size,
          ),
        );

      case 1:
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Icon(
            selected ? Icons.auto_awesome : Icons.auto_awesome_outlined,
            key: key,
            color: color,
            size: size,
          ),
        );

      case 2:
        // ── Nest / Journalism tab — replaced from nest-logo.png to icon ──
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Icon(
            selected ? Icons.auto_stories : Icons.auto_stories_outlined,
            key: key,
            color: color,
            size: size,
          ),
        );

      case 3:
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Icon(
            selected ? Icons.air : Icons.air_outlined,
            key: key,
            color: color,
            size: size,
          ),
        );

      case 4:
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Icon(
            selected ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            key: key,
            color: color,
            size: size,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
