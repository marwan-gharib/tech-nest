import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tech_nest/core/constants/app_constants.dart';
import 'package:tech_nest/core/local/cache/cache_service.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/i18n/strings.g.dart';
import 'package:tech_nest/service_locator.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = context.t;

    final List<_OnboardingPageData> pages = [
      _OnboardingPageData(
        title: t.onboarding.pages[0].title,
        description: t.onboarding.pages[0].description,
        icon: Icons.devices,
        color: const Color(0xff1443C3), // Primary
      ),
      _OnboardingPageData(
        title: t.onboarding.pages[1].title,
        description: t.onboarding.pages[1].description,
        icon: Icons.payment,
        color: const Color(0xff59CDBE), // Teal
      ),
      _OnboardingPageData(
        title: t.onboarding.pages[2].title,
        description: t.onboarding.pages[2].description,
        icon: Icons.local_shipping,
        color: const Color(0xffF35D2F), // Orange
      ),
    ];

    return Scaffold(
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
                return _OnboardingPageView(pageData: pages[index]);
              },
            ),

            // Top-right skip button
            if (!_isLastPage)
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    t.onboarding.skip,
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            // Bottom controls
            Positioned(
              bottom: AppSpacing.xxl,
              left: AppSpacing.xl,
              right: AppSpacing.xl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: pages.length,
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
                    child: _isLastPage
                        ? ElevatedButton(
                            key: const ValueKey('get_started'),
                            onPressed: _completeOnboarding,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xl,
                                vertical: AppSpacing.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(t.onboarding.getStarted),
                          )
                        : IconButton(
                            key: const ValueKey('next'),
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: colorScheme.primaryContainer,
                              foregroundColor: colorScheme.onPrimaryContainer,
                              padding: const EdgeInsets.all(AppSpacing.md),
                            ),
                            icon: const Icon(Icons.arrow_forward_rounded),
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

class _OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  _OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPageData pageData;

  const _OnboardingPageView({required this.pageData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxl * 1.5),
            decoration: BoxDecoration(
              color: pageData.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(pageData.icon, size: 100, color: pageData.color),
          ),
          const SizedBox(height: AppSpacing.xxl * 2),
          Text(
            pageData.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            pageData.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl * 2),
        ],
      ),
    );
  }
}
