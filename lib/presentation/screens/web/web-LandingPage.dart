import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';

class WebLandingPage extends StatelessWidget {
  const WebLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 30),
            const SizedBox(width: 10),
            const Text(
              "Ray of Light",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (!isMobile) const Spacer(),
            if (!isMobile) ...[
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Features",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "About",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Testimonials",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go(RouteNames.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 15 : 20,
                  vertical: isMobile ? 10 : 15,
                ),
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: isMobile ? 14 : 16,
                ),
              ),
            ),
            SizedBox(width: isMobile ? 10 : 20),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 10,
      ),
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
                              Scrollable.ensureVisible(
                                context,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeInOut,
                              );
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
                            onPressed: () {},
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

            // Features Section
            Padding(
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

            // Testimonial Section
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 60,
                horizontal: isMobile ? 20 : 40,
              ),
              color: Colors.deepPurple.shade50,
              child: Column(
                children: [
                  const Icon(
                    Icons.format_quote,
                    size: 50,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Ray of Light has been a game-changer for my mental health. The breathing exercises help me manage my anxiety, and the journal feature lets me process my thoughts in a healthy way.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 22,
                      fontStyle: FontStyle.italic,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/women/43.jpg',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Priya Sharma",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const Text(
                    "Delhi, India",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 30 : 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "Start Your Journey Today",
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        color: Colors.white,
                      ),
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
}
