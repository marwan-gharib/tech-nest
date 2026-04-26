import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/constants/app_constants.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/onboarding/presentation/models/onboarding_page_data.dart';
import 'package:tech_nest/features/onboarding/presentation/widgets/onboarding_controls.dart';
import 'package:tech_nest/features/onboarding/presentation/widgets/onboarding_page_view.dart';
import 'package:tech_nest/features/onboarding/presentation/widgets/onboarding_skip_button.dart';
import 'package:tech_nest/i18n/strings.g.dart';
import 'package:tech_nest/app/service_locator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await sl<CacheService>().setData(
      key: AppConstants.onboardingKey,
      value: true,
    );
    if (!mounted) return;
    context.go(Routes.loginScreenPath);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    final List<OnboardingPageData> pages = [
      OnboardingPageData(
        title: t.onboarding.pages[0].title,
        description: t.onboarding.pages[0].description,
        icon: Icons.devices,
        color: context.colorScheme.primary,
      ),
      OnboardingPageData(
        title: t.onboarding.pages[1].title,
        description: t.onboarding.pages[1].description,
        icon: Icons.payment,
        color: context.colors.success,
      ),
      OnboardingPageData(
        title: t.onboarding.pages[2].title,
        description: t.onboarding.pages[2].description,
        icon: Icons.local_shipping,
        color: context.colors.warning,
      ),
    ];

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  _isLastPage = index == pages.length - 1;
                });
              },
              itemBuilder: (context, index) {
                return OnboardingPageView(pageData: pages[index]);
              },
            ),
            OnboardingSkipButton(
              onPressed: _completeOnboarding,
              isVisible: !_isLastPage,
            ),
            OnboardingControls(
              pageController: _pageController,
              pageCount: pages.length,
              isLastPage: _isLastPage,
              onComplete: _completeOnboarding,
            ),
          ],
        ),
      ),
    );
  }
}
