import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/constants/common_button.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _glowOpacityAnimation;

  late final AnimationController _entranceController;
  late final Animation<double> _fadeLogo;
  late final Animation<Offset> _slideLogo;
  late final Animation<double> _fadeText;
  late final Animation<Offset> _slideText;
  late final Animation<double> _fadeButtons;
  late final Animation<Offset> _slideButtons;

  @override
  void initState() {
    super.initState();

    // ── Continuous breathing glow animation for logo ──
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutSine,
      ),
    );

    _glowOpacityAnimation = Tween<double>(begin: 0.35, end: 0.75).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOutSine,
      ),
    );

    // ── Staggered entrance animations on screen launch ──
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fadeLogo = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideLogo = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _fadeText = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideText = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _fadeButtons = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideButtons = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final backgroundColor = AppColors.getMonoBackground(isDark);
    final textPrimaryColor = AppColors.getMonoTextPrimary(isDark);
    final textSecondaryColor = AppColors.getMonoTextSecondary(isDark);
    final textMutedColor = AppColors.getMonoTextMuted(isDark);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // ── Atmospheric Background Light Aura ──
          Positioned(
            top: -120,
            left: MediaQuery.of(context).size.width * 0.5 - 180,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 360,
                  height: 360,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: isDark
                          ? [
                              const Color(0xFFF59E0B).withValues(alpha: 0.18 * _glowOpacityAnimation.value),
                              const Color(0xFF8B5CF6).withValues(alpha: 0.12 * _glowOpacityAnimation.value),
                              Colors.transparent,
                            ]
                          : [
                              const Color(0xFFFBBF24).withValues(alpha: 0.25 * _glowOpacityAnimation.value),
                              const Color(0xFF38BDF8).withValues(alpha: 0.10 * _glowOpacityAnimation.value),
                              Colors.transparent,
                            ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Main Page Content ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ── Brand Tag Chip ──
                  FadeTransition(
                    opacity: _fadeLogo,
                    child: SlideTransition(
                      position: _slideLogo,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.12)
                                : Colors.black.withValues(alpha: 0.08),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF59E0B),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'WELCOME TO RAY OF LIGHT',
                              style: AppTextStyles.monoMuted12(isDark).copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Animated Logo with Breathing Halo ──
                  FadeTransition(
                    opacity: _fadeLogo,
                    child: SlideTransition(
                      position: _slideLogo,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (isDark
                                            ? const Color(0xFFF59E0B)
                                            : const Color(0xFFD97706))
                                        .withValues(alpha: 0.25 * _glowOpacityAnimation.value),
                                    blurRadius: 36,
                                    spreadRadius: 8,
                                  ),
                                  BoxShadow(
                                    color: (isDark
                                            ? const Color(0xFF8B5CF6)
                                            : const Color(0xFF6366F1))
                                        .withValues(alpha: 0.15 * _glowOpacityAnimation.value),
                                    blurRadius: 48,
                                    spreadRadius: 16,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Frosted inner ring container
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(70),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 8,
                                        sigmaY: 8,
                                      ),
                                      child: Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isDark
                                              ? const Color(0xFF171717).withValues(alpha: 0.7)
                                              : Colors.white.withValues(alpha: 0.85),
                                          border: Border.all(
                                            color: isDark
                                                ? Colors.white.withValues(alpha: 0.18)
                                                : Colors.black.withValues(alpha: 0.10),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Actual App Logo PNG
                                  Image.asset(
                                    'assets/logo.png',
                                    width: 92,
                                    height: 92,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Title & Slogan ──
                  FadeTransition(
                    opacity: _fadeText,
                    child: SlideTransition(
                      position: _slideText,
                      child: Column(
                        children: [
                          Text(
                            'Ray of Light',
                            style: AppTextStyles.monoBold22(isDark).copyWith(
                              fontSize: 30,
                              letterSpacing: -0.5,
                              color: textPrimaryColor,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Find your calm, share your light,\nnurture your inner peace',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.monoSecondary14(isDark).copyWith(
                              fontSize: 15,
                              height: 1.5,
                              color: textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // ── Action Buttons ──
                  FadeTransition(
                    opacity: _fadeButtons,
                    child: SlideTransition(
                      position: _slideButtons,
                      child: Column(
                        children: [
                          CommonButton(
                            text: "Get Started",
                            onPressed: () => context.push(RouteNames.register),
                          ),

                          const SizedBox(height: 14),

                          CommonButton(
                            text: "Log In",
                            variant: ButtonVariant.outline,
                            onPressed: () => context.push(RouteNames.login),
                          ),

                          const SizedBox(height: 28),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                size: 14,
                                color: textMutedColor.withValues(alpha: 0.7),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'A space for reflection, connection, and gentle growth',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.monoMuted12(isDark).copyWith(
                                    fontSize: 12,
                                    color: textMutedColor,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
