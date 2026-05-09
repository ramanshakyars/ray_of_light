import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

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
    context.go('${RouteNames.mainApp}/${_routes[index]}');
  }

  // ------------------ NEW PREMIUM BOTTOM NAV ------------------

  Widget _buildBottomNavigationBar(bool isDarkMode) {
    // final isDarkMode =
    //     Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    final bg = AppColors.getMonoCard(isDarkMode);
    final border = AppColors.getMonoBorder(isDarkMode);
    final iconColor = AppColors.getMonoIcon(isDarkMode);
    final selectedBg = AppColors.getMonoTextPrimary(isDarkMode);

    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: border)),
      ),
      child: Padding(
        // ✅ THIS is the magic fix
        padding: EdgeInsets.fromLTRB(
          12,
          4,
          12,
          bottomInset > 0 ? bottomInset : 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_routes.length, (index) {
            final selected = _currentIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => _navigateToTab(context, index),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: 65,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// ICON PILL
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          // color: selected ? selectedBg : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: _buildNavIcon(
                          index,
                          selected,
                          iconColor,
                          isDarkMode,
                        ),
                      ),

                      const SizedBox(height: 2),

                      /// LABEL
                      // Text(
                      //   _getLabel(index),
                      //   style: AppTextStyles.monoMuted12(isDarkMode).copyWith(
                      //     color:
                      //         selected
                      //             ? AppColors.getMonoTextPrimary(isDarkMode)
                      //             : AppColors.getMonoTextSecondary(isDarkMode),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ------------------ ICON BUILDER ------------------

  Widget _buildNavIcon(int index, bool selected, Color iconColor, bool isDark) {
    // final isDark =
    //     Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    final selectedIconColor =
        isDark ? Colors.white : AppColors.getMonoTextPrimary(isDark);

    switch (index) {
      case 0:
        return Icon(
          selected ? Icons.home : Icons.home_outlined,
          color: selected ? selectedIconColor : iconColor,
          size: selected ? 30 : 24,
        );

      // case 1:
      //   return Stack(
      //     alignment: Alignment.center,
      //     children: [
      //       AnimatedBuilder(
      //         animation: _rotateController,
      //         builder:
      //             (_, child) => Transform.rotate(
      //               angle: _rotateController.value * 2 * 3.1416,
      //               child: child,
      //             ),
      //         child: Container(
      //           width: 28,
      //           height: 28,
      //           decoration: const BoxDecoration(
      //             shape: BoxShape.circle,
      //             gradient: RadialGradient(
      //               colors: [
      //                 Color.fromARGB(25, 35, 74, 246),
      //                 Color.fromARGB(25, 210, 47, 239),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //       ScaleTransition(
      //         scale: Tween(begin: 0.9, end: 1.1).animate(
      //           CurvedAnimation(
      //             parent: _pulseController,
      //             curve: Curves.easeInOut,
      //           ),
      //         ),
      //         child: Icon(Icons.auto_awesome, size: 17, color: iconColor),
      //       ),
      //     ],
      //   );

      case 1:
        return Icon(
          selected ? Icons.auto_awesome : Icons.auto_awesome_outlined,
          color: selected ? selectedIconColor : iconColor,
          size: selected ? 30 : 24,
        );

      case 2:
        return Image.asset(
          'assets/nest-logo.png',
          width: 45,
          height: 30,
          color: selected ? selectedIconColor : iconColor,
        );

      case 3:
        return Icon(
          selected ? Icons.air : Icons.air_outlined,
          color: selected ? selectedIconColor : iconColor,
          size: selected ? 30 : 24,
        );

      case 4:
        return Icon(
          selected ? Icons.favorite : Icons.favorite_border,
          color: selected ? selectedIconColor : iconColor,
            size: selected ? 30 : 26,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // ------------------ LABEL HELPER ------------------

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Talk";
      case 2:
        return "Nest";
      case 3:
        return "Breathe";
      case 4:
        return "Wishes";
      default:
        return "";
    }
  }
}
