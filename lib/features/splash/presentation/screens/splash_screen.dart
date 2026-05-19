import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/features/splash/presentation/widgets/splash_background.dart';
import 'package:tech_nest/features/splash/presentation/widgets/splash_icon_story.dart';
import 'package:tech_nest/features/splash/presentation/widgets/splash_tagline.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const Duration _totalDuration = Duration(milliseconds: 3200);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _totalDuration);

    _controller.forward().then((_) => _navigateForward());
  }

  void _navigateForward() {
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        context.goNamed(RouteNames.home);
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          const SplashBackground(),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SplashIconStory(controller: _controller),
                SplashTagline(controller: _controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
