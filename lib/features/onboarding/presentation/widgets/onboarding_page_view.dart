import 'package:flutter/material.dart';
import 'package:tech_nest/core/animations/fade_in_slide.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/onboarding/presentation/models/onboarding_page_data.dart';

class OnboardingPageView extends StatelessWidget {
  final OnboardingPageData pageData;

  const OnboardingPageView({required this.pageData, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInSlide(
            duration: const Duration(milliseconds: 600),
            direction: FadeInSlideDirection.ttb,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xxl * 1.5),
              decoration: BoxDecoration(
                color: pageData.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(pageData.icon, size: 100, color: pageData.color),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl * 2),
          FadeInSlide(
            delay: const Duration(milliseconds: 200),
            child: Text(
              pageData.title,
              style: context.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FadeInSlide(
            delay: const Duration(milliseconds: 400),
            child: Text(
              pageData.description,
              style: context.bodyLarge.copyWith(
                color: context.colors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl * 2),
        ],
      ),
    );
  }
}

