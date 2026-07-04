import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_theme.dart';
import '../utils/page_transitions.dart';
import 'auth/welcome_screen.dart';
import 'main_nav/main_screen.dart';

/// Modern Splash Screen with organic geometric shapes
/// Following update_design.md specifications
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!mounted) return;
    
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        PageTransitions.fadeTransition(const MainScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageTransitions.fadeTransition(const WelcomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Organic Shapes
                    Positioned(
                      top: size.height * 0.05,
                      right: size.width * 0.1,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _OrganicShape(
                          size: 120,
                          color: AppTheme.lightGreen.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: size.height * 0.15,
                      left: size.width * 0.05,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _OrganicShape(
                          size: 100,
                          color: AppTheme.accentYellow.withValues(alpha: 0.3),
                          rotation: math.pi / 4,
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.25,
                      left: size.width * 0.15,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _LeafShape(
                          size: 80,
                          color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                        ),
                      ),
                    ),

                    // Main Content
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Plant Icon/Logo
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.local_florist_rounded,
                                size: 80,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXL),

                        // Title
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: const Text(
                            'Plant Doctor',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGreen,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingM),

                        // Tagline
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'Jaga Tanamanmu Tetap Sehat',
                            style: AppTheme.bodyLarge.copyWith(
                              color: AppTheme.textMedium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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

/// Organic geometric shape widget
class _OrganicShape extends StatelessWidget {
  final double size;
  final Color color;
  final double rotation;

  const _OrganicShape({
    required this.size,
    required this.color,
    this.rotation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size * 0.8),
            topRight: Radius.circular(size * 0.3),
            bottomLeft: Radius.circular(size * 0.3),
            bottomRight: Radius.circular(size * 0.8),
          ),
        ),
      ),
    );
  }
}

/// Leaf-shaped decoration
class _LeafShape extends StatelessWidget {
  final double size;
  final Color color;

  const _LeafShape({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 1.5),
      painter: _LeafPainter(color: color),
    );
  }
}

class _LeafPainter extends CustomPainter {
  final Color color;

  _LeafPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(
      size.width,
      size.height / 3,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(
      0,
      size.height / 3,
      size.width / 2,
      0,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
