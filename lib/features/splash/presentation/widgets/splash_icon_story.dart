import 'package:flutter/material.dart';
import 'package:tech_nest/features/splash/presentation/widgets/splash_scattered_icons.dart';
import 'package:tech_nest/features/splash/presentation/widgets/splash_flash_effect.dart';
import 'package:tech_nest/features/splash/presentation/widgets/splash_core_brand.dart';

class SplashIconStory extends StatelessWidget {
  final AnimationController controller;

  const SplashIconStory({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 350,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SplashScatteredIcons(controller: controller),
          SplashFlashEffect(controller: controller),
          SplashCoreBrand(controller: controller),
        ],
      ),
    );
  }
}
