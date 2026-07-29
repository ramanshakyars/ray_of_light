import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
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

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;

  late final List<String> _routes;

  late AnimationController _pulseController;
  late AnimationController _rotateController;

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

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

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
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final location = GoRouterState.of(context).uri.toString();

    _currentIndex = _calculateIndex(location);

    return Scaffold(
      backgroundColor: AppColors.getMonoBackground(isDarkMode),
      extendBody: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;
          if (velocity < -300) _goNext();
          if (velocity > 300) _goPrevious();
        },
        child: widget.child,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(isDarkMode),
    );
  }

  // ------------------ NAVIGATION LOGIC ------------------

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
    // context.push('${RouteNames.mainApp}/${_routes[index]}');
    // context.go('${RouteNames.mainApp}/${_routes[index]}');
    MainScreen.goToTab(context, index);
  }

  // ------------------ NEW PREMIUM BOTTOM NAV ------------------

  Widget _buildBottomNavigationBar(bool isDarkMode) {
    final bg = AppColors.getMonoCard(isDarkMode);
    final border = AppColors.getMonoBorder(isDarkMode);
    final iconColor = AppColors.getMonoIcon(isDarkMode);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(
            color: border.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: true,
        top: false,
        child: SizedBox(
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_routes.length, (index) {
              final selected = _currentIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _navigateToTab(context, index),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: Tween<double>(begin: 0.85, end: 1.0).animate(animation),
                          child: child,
                        );
                      },
                      child: _buildNavIcon(
                        index,
                        selected,
                        iconColor,
                        isDarkMode,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ------------------ ICON BUILDER ------------------

  Widget _buildNavIcon(int index, bool selected, Color iconColor, bool isDark) {
    final selectedIconColor =
        isDark ? Colors.white : AppColors.getMonoTextPrimary(isDark);
    final color = selected ? selectedIconColor : iconColor;
    const double size = 24.0;

    switch (index) {
      case 0:
        return Icon(
          selected ? Icons.home : Icons.home_outlined,
          key: ValueKey('icon_0_$selected'),
          color: color,
          size: size,
        );

      case 1:
        return Icon(
          selected ? Icons.auto_awesome : Icons.auto_awesome_outlined,
          key: ValueKey('icon_1_$selected'),
          color: color,
          size: size,
        );

      case 2:
        return Image.asset(
          'assets/nest-logo.png',
          key: ValueKey('icon_2_$selected'),
          width: 26,
          height: 26,
          color: color,
        );

      case 3:
        return Icon(
          selected ? Icons.air : Icons.air_outlined,
          key: ValueKey('icon_3_$selected'),
          color: color,
          size: size,
        );

      case 4:
        return Icon(
          selected ? Icons.favorite : Icons.favorite_border,
          key: ValueKey('icon_4_$selected'),
          color: color,
          size: size,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
