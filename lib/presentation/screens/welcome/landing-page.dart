import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<String> messages = [
    "Unlock your potential with AI",
    "Transform your habits, transform your life",
    "Your personal growth companion",
    "Smart goals for a better you",
    "AI-powered self-improvement",
  ];
  int _currentMessage = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    // Rotate messages every 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _currentMessage = (_currentMessage + 1) % messages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1 + 0.05 * _controller.value,
                  child: FloatingActionButton(
                    onPressed: () {
                       GoRouter.of(context).push('/login');
                    },
                    backgroundColor: Colors.deepPurple,
                    elevation: 4,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Animated title
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: const Text(
                    'Ray of lite',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Rotating messages
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  messages[_currentMessage],
                  key: ValueKey<int>(_currentMessage),
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Feature cards with animations
              _buildFeatureCard(
                icon: Icons.auto_awesome,
                title: "AI-Powered Insights",
                description:
                    "Get personalized recommendations based on your goals",
                color: Colors.blue,
                delay: 0.2,
              ),
              _buildFeatureCard(
                icon: Icons.trending_up,
                title: "Progress Tracking",
                description: "Visualize your improvement over time",
                color: Colors.green,
                delay: 0.4,
              ),
              _buildFeatureCard(
                icon: Icons.psychology,
                title: "Mindfulness Tools",
                description: "Meditation and focus exercises tailored for you",
                color: Colors.orange,
                delay: 0.6,
              ),
              _buildFeatureCard(
                icon: Icons.self_improvement, // Perfect for self-improvement!
                title: "Daily Challenges",
                description: "Boost your growth with small, achievable tasks",
                color: Colors.purple, // or Colors.indigo
                delay: 0.8,
              ),
              const SizedBox(height: 40),
              // Animated CTA button
              Center(
                child: AnimatedButton(
                  onPressed: () {
                    GoRouter.of(context).push('/login');
                  },
                  label: "Start Your Journey",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required double delay,
  }) {
    return SlideInAnimation(
      delay: delay,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class SlideInAnimation extends StatelessWidget {
  final Widget child;
  final double delay;

  const SlideInAnimation({super.key, required this.child, required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: (500 + delay * 500).round()),
      tween: Tween(begin: 1.0, end: 0.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * value),
          child: Opacity(opacity: 1 - value, child: child),
        );
      },
      child: child,
    );
  }
}
