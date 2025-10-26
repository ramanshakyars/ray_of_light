import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/theme/appcolors.dart';

class WebLandingPage extends StatefulWidget {
  const WebLandingPage({super.key});

  @override
  State<WebLandingPage> createState() => _WebLandingPageState();
}

class _WebLandingPageState extends State<WebLandingPage> {
  final Color darkColor = AppColors.appBackgroundColor;
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: darkColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Ray of Light',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/logo.png',
                  height: 40,
                  width: 40,
                  color: Colors.black,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.stars,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            title: Text(
              'Features',
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            onTap: () {
              Navigator.pop(context);
              _scrollToSection(_featuresKey);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            title: Text(
              'About Us',
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            onTap: () {
              Navigator.pop(context);
              _scrollToSection(_aboutKey);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.login,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            title: Text(
              'Login/signup',
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go(RouteNames.login);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.rule,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            title: Text(
              'Privacy Policy',
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            onTap: () {
              GoRouter.of(context).go(RouteNames.privacyPolicy);
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureCards(bool isMobile) {
    return [
      _buildHoverFeatureCard(
        icon: Icons.chat_bubble_outline,
        title: "Talk to Lite",
        description:
            "Our AI companion provides 24/7 support for stress, anxiety, and self-doubt. Get personalized advice and coping strategies anytime.",
        color: const Color.fromARGB(255, 0, 0, 0),
        isMobile: isMobile,
      ),
      _buildHoverFeatureCard(
        icon: Icons.book_outlined,
        title: "Nest",
        description:
            "Private Nest for daily reflections or share with our supportive community. Track your mood patterns over time.",
        color: const Color.fromARGB(255, 0, 0, 0),
        isMobile: isMobile,
      ),
      _buildHoverFeatureCard(
        icon: Icons.self_improvement_outlined,
        title: "Breathing Exercises",
        description:
            "20+ guided breathing techniques with customizable timers. Reduce stress in just 5 minutes with our science-backed methods.",
        color: const Color.fromARGB(255, 0, 0, 0),
        isMobile: isMobile,
      ),
      _buildHoverFeatureCard(
        icon: Icons.flag_outlined,
        title: "Wish",
        description:
            "Set and track personal goals with reminders. Build healthy habits with our routine management system.",
        color: const Color.fromARGB(255, 0, 0, 0),
        isMobile: isMobile,
      ),
    ];
  }

  Widget _buildHoverFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required bool isMobile,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(isMobile ? 10 : 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            GoRouter.of(context).go(RouteNames.login);
          },
          hoverColor: darkColor.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 15.0 : 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 30, color: darkColor),
                ),
                SizedBox(width: isMobile ? 15 : 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Learn more →",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: AppBar(
        title:
            isMobile
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Ray of Light',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      'assets/logo.png',
                      height: 40,
                      width: 40,
                      color: Colors.black,
                      fit: BoxFit.contain,
                    ),
                  ],
                )
                : Row(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 40,
                      width: 40,
                      color: Colors.black,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Ray of Light',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        _scrollToSection(_featuresKey);
                      },
                      child: Text(
                        "Features",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    TextButton(
                      onPressed: () {
                        _scrollToSection(_aboutKey);
                      },
                      child: Text(
                        "About",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).go(RouteNames.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        "Login/Signup",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
        backgroundColor: darkColor,
        elevation: 10,
        toolbarHeight: isMobile ? 60 : 80,
      ),
      drawer: isMobile ? _buildMobileDrawer(context) : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              height: isMobile ? 500 : 600,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [darkColor.withOpacity(0.8), darkColor],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 20.0 : 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 100,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        " Your Friend Ray of light",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 28 : 36,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : 40,
                        ),
                        child: Text(
                          "Ray of Light helps you overcome stress, anxiety, and loneliness through AI-powered support, self-reflection tools, and wellness exercises.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 20,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _scrollToSection(_featuresKey);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 20 : 30,
                                vertical: isMobile ? 12 : 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Just outline",
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 18,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // OutlinedButton(
                          //   onPressed: () {
                          //     _scrollToSection(_aboutKey);
                          //   },
                          //   style: OutlinedButton.styleFrom(
                          //     side: const BorderSide(
                          //       color: Color.fromARGB(255, 0, 0, 0),
                          //     ),
                          //     padding: EdgeInsets.symmetric(
                          //       horizontal: isMobile ? 20 : 30,
                          //       vertical: isMobile ? 12 : 15,
                          //     ),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(30),
                          //     ),
                          //   ),
                          //   child: Text(
                          //     "Explore button",
                          //     style: TextStyle(
                          //       fontSize: isMobile ? 16 : 18,
                          //       color: const Color.fromARGB(255, 0, 0, 0),
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              key: _aboutKey,
              padding: EdgeInsets.symmetric(
                vertical: 60,
                horizontal: isMobile ? 20 : 40,
              ),
              color: darkColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Our Story",
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 36,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Sometimes, we forget who we are.\n"
                    "Not all at once, but slowly — in moments when we try too hard to fit in, when we rush to meet expectations, when we keep saying \"yes\" just to feel enough. Over time, we stop hearing ourselves. And something soft and quiet inside us begins to fade. That something… is our light.\n\n"
                    "Ray of Light wasn't built as a company, or an idea, or a perfect solution. It began as a feeling, the feeling that maybe, just maybe, there's more to us than what we've been told. It's a space created not to change you, but to help you find your way back. To remind you of what's always been there.\n\n"
                    "Because your light — it never left. It just got hidden under the noise. And now, you're here. Which means you're already on the way back.\n\n"
                    "This isn't about big answers or quick fixes. We don't offer that. Instead, we ask questions, gentle ones. The kind you might've asked as a child, when curiosity came easier than fear. The kind that don't need to be solved, just felt. What do you love? What do you miss? Who are you when no one's watching?\n\n"
                    "Maybe you haven't asked yourself things like that in a while. That's okay. Life moved fast. People expected a lot. You grew up. You got quiet. And somewhere in all that, the questions stopped.\n\n"
                    "But what if you started asking again?\n\n"
                    "What if you paused, just for a second, and really looked at yourself, not the version you perform, but the one that existed before anyone had an opinion about you? That version is still in there. Still hoping you'll notice.\n\n"
                    "Because the truth is, your story is yours. No one else gets to write it, define it, or shrink it. And no matter how far you feel from yourself, you're never too far to return.\n\n"
                    "That's what this is about. Not a grand transformation. Just a soft return. A gentle remembering.\n\n"
                    "So take a moment. Breathe. Close your eyes, maybe. And feel for that quiet presence within you, the one that doesn't need to prove anything. That's your light.\n\n"
                    "It's the way your laughter feels when it's real. It's how your heart softens when something moves you. It's the part of you that never stopped dreaming, even if the dreams changed shape.\n\n"
                    "Ray of Light is not separate from you. It's just a reflection. A reminder. A small voice saying, \"You're still in there. And you still matter.\"\n\n"
                    "So if you've made it this far, thank you. You've already taken the first step. Keep going, not to become someone new, but to become fully, gently, entirely you.\n\n"
                    "Because you've always been the light.\n"
                    "And deep down, you've always known.\n\n"
                    "With love,\n"
                    "Ray of Light",
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              key: _featuresKey,
              padding: EdgeInsets.symmetric(
                vertical: 50,
                horizontal: isMobile ? 20 : 40,
              ),
              color: darkColor,
              child: Column(
                children: [
                  Text(
                    "How Ray of Light Helps You",
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 36,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Comprehensive tools for mental wellness and personal growth",
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 40),

                  if (isMobile)
                    Column(children: _buildFeatureCards(isMobile))
                  else if (isTablet)
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: _buildFeatureCards(isMobile),
                    )
                  else
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: _buildFeatureCards(isMobile),
                    ),
                ],
              ),
            ),
            // Footer Section
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: isMobile ? 20 : 40,
              ),
              color: darkColor,
              child: Column(
                children: [
                  if (isMobile)
                    Column(
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 40,
                          width: 40,
                          color: Colors.black,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Ray of Light',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),
                        Text(
                          " Your Friend Ray of light",
                          style: TextStyle(
                            fontSize: 16,
                            color: const Color.fromARGB(179, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                _scrollToSection(_featuresKey);
                              },
                              child: Text(
                                "Features",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _scrollToSection(_aboutKey);
                              },
                              child: Text(
                                "About Us",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                GoRouter.of(context).go(RouteNames.login);
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                GoRouter.of(context).go(RouteNames.privacyPolicy);
                              },
                              child: Text(
                                "Privacy Policy",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Social Media Icons for Mobile
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.email,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                size: 24,
                              ),
                              onPressed: () {
                                // Open email client
                                final Uri emailLaunchUri = Uri(
                                  scheme: 'mailto',
                                  path: 'info@rayoflight.life',
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                size: 24,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.facebook,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                size: 24,
                              ),
                              onPressed: () {
                                // Open Facebook
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.link,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                size: 24,
                              ),
                              onPressed: () {
                                // Open LinkedIn
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.chat,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                size: 24,
                              ),
                              onPressed: () {
                                // Open X (Twitter)
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Email contact for mobile
                        GestureDetector(
                          onTap: () {
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'info@rayoflight.life',
                            );
                          },
                          child: Text(
                            'info@rayoflight.life',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/logo.png',
                                    height: 40,
                                    width: 40,
                                    color: Colors.black,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Ray of Light',
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                " Your Friend Ray of light",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Email contact for desktop
                              GestureDetector(
                                onTap: () {
                                  final Uri emailLaunchUri = Uri(
                                    scheme: 'mailto',
                                    path: 'info@rayoflight.life',
                                  );
                                },
                                child: Text(
                                  'info@rayoflight.life',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Social Media Icons for Desktop
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.email,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      final Uri emailLaunchUri = Uri(
                                        scheme: 'mailto',
                                        path: 'info@rayoflight.life',
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      size: 24,
                                    ),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.facebook,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      size: 24,
                                    ),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.link,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      size: 24,
                                    ),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.chat,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      size: 24,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Product",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () {
                                      _scrollToSection(_featuresKey);
                                    },
                                    child: Text(
                                      "Features",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          0,
                                          0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      GoRouter.of(context).go(RouteNames.login);
                                    },
                                    child: Text(
                                      "Login/Signup",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          0,
                                          0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Company",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () {
                                      _scrollToSection(_aboutKey);
                                    },
                                    child: Text(
                                      "About Us",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          0,
                                          0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      GoRouter.of(context).go(RouteNames.privacyPolicy);
                                    
                                    },
                                    child: Text(
                                      "Privacy Policy",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          0,
                                          0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 30),
                  const Divider(color: Color.fromARGB(77, 0, 0, 0)),
                  const SizedBox(height: 20),
                  Text(
                    "© 2025 Ray of Light. All rights reserved.",
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
