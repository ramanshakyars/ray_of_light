import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';

class WebLandingPage extends StatefulWidget {
  const WebLandingPage({super.key});

  @override
  State<WebLandingPage> createState() => _WebLandingPageState();
}

class _WebLandingPageState extends State<WebLandingPage> {
  // Keys for scrolling to sections
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _testimonialsKey = GlobalKey();

  // Function to scroll to a section
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

  // Mobile drawer
  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.amber, size: 40),
                SizedBox(height: 10),
                Text(
                  'Ray of Light',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.stars),
            title: const Text('Features'),
            onTap: () {
              Navigator.pop(context);
              _scrollToSection(_featuresKey);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.pop(context);
              _scrollToSection(_aboutKey);
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              Navigator.pop(context);
              GoRouter.of(context).go(RouteNames.login);
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
        color: Colors.blue.shade100,
        isMobile: isMobile,
      ),
      _buildHoverFeatureCard(
        icon: Icons.book_outlined,
        title: "Journal",
        description:
            "Private journal for daily reflections or share with our supportive community. Track your mood patterns over time.",
        color: Colors.green.shade100,
        isMobile: isMobile,
      ),
      _buildHoverFeatureCard(
        icon: Icons.self_improvement_outlined,
        title: "Breathing Exercises",
        description:
            "20+ guided breathing techniques with customizable timers. Reduce stress in just 5 minutes with our science-backed methods.",
        color: Colors.orange.shade100,
        isMobile: isMobile,
      ),
      _buildHoverFeatureCard(
        icon: Icons.flag_outlined,
        title: "Goal Tracking",
        description:
            "Set and track personal goals with reminders. Build healthy habits with our routine management system.",
        color: Colors.purple.shade100,
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
          onTap: () {},
          hoverColor: Colors.white.withOpacity(0.1),
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
                  child: Icon(icon, size: 30, color: Colors.deepPurple),
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
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Learn more →",
                        style: TextStyle(
                          color: Colors.deepPurple,
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

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
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
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.amber,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Ray of Light",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Builder(
                      builder:
                          (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                    ),
                  ],
                )
                : Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: Colors.amber,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Ray of Light",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        _scrollToSection(_featuresKey);
                      },
                      child: const Text(
                        "Features",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 15),
                    TextButton(
                      onPressed: () {
                        _scrollToSection(_aboutKey);
                      },
                      child: const Text(
                        "About",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 15),
                    TextButton(
                      onPressed: () {
                        _scrollToSection(_testimonialsKey);
                      },
                      child: const Text(
                        "Testimonials",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).go(RouteNames.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
        backgroundColor: Colors.deepPurple,
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
                  colors: [
                    Colors.deepPurple.shade300,
                    Colors.deepPurple.shade800,
                  ],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 20.0 : 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        size: 100,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Your Mental Wellness Companion",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 28 : 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                            color: Colors.white70,
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
                              backgroundColor: Colors.amber,
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 20 : 30,
                                vertical: isMobile ? 12 : 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Explore Features",
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 18,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              _scrollToSection(_aboutKey);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 20 : 30,
                                vertical: isMobile ? 12 : 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Learn More",
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // About Us Section
            Container(
              key: _aboutKey,
              padding: EdgeInsets.symmetric(
                vertical: 60,
                horizontal: isMobile ? 20 : 40,
              ),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Our Story",
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
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

            // Features Section
            Container(
              key: _featuresKey,
              padding: EdgeInsets.symmetric(
                vertical: 50,
                horizontal: isMobile ? 20 : 40,
              ),
              child: Column(
                children: [
                  Text(
                    "How Ray of Light Helps You",
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Comprehensive tools for mental wellness and personal growth",
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      color: Colors.grey,
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

            // Stats Section
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: isMobile ? 20 : 40,
              ),
              child:
                  isMobile
                      ? Column(
                        children: [
                          _buildStatItem("10,000+", "Happy Users"),
                          const SizedBox(height: 30),
                          _buildStatItem("24/7", "Support Available"),
                          const SizedBox(height: 30),
                          _buildStatItem("4.9", "App Rating"),
                          const SizedBox(height: 30),
                          _buildStatItem("50+", "Exercises"),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem("10,000+", "Happy Users"),
                          _buildStatItem("24/7", "Support Available"),
                          _buildStatItem("4.9", "App Rating"),
                          _buildStatItem("50+", "Exercises"),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
