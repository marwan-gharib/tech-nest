import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tech_nest/core/animations/scale_tap.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/core/widgets/app_button.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class OnboardingControls extends StatelessWidget {
  final PageController pageController;
  final int pageCount;
  final bool isLastPage;
  final VoidCallback onComplete;

  const OnboardingControls({
    required this.pageController,
    required this.pageCount,
    required this.isLastPage,
    required this.onComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final t = context.t;

    return Positioned(
      bottom: AppSpacing.xxl,
      left: AppSpacing.xl,
      right: AppSpacing.xl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SmoothPageIndicator(
            controller: pageController,
            count: pageCount,
            effect: ExpandingDotsEffect(
              activeDotColor: colorScheme.primary,
              dotColor: colorScheme.primary.withValues(alpha: 0.2),
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 4,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isLastPage
                ? AppButton(onTap: onComplete, text: t.onboarding.getStarted)
                : ScaleTap(
                    onTap: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

