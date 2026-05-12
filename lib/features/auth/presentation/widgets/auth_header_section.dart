import 'package:flutter/material.dart';
import 'package:tech_nest/core/animations/fade_in_slide.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class AuthHeaderSection extends StatelessWidget {
  final String headline;
  final String? subtitle;

  const AuthHeaderSection({required this.headline, this.subtitle, super.key});

  static const double _logoSize = 64.0;
  static const double _iconSize = 32.0;

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;
    final onPrimary = context.colorScheme.onPrimary;

    return FadeInSlide(
      direction: FadeInSlideDirection.ttb,
      delay: Duration.zero,
      child: Column(
        children: [
          _LogoMark(primary: primary, onPrimary: onPrimary),
          const SizedBox(height: AppSpacing.md),
          Text(
            headline,
            style: context.headlineLarge.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          if (subtitle != null)
            Text(
              subtitle!,
              style: context.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  final Color primary;
  final Color onPrimary;

  const _LogoMark({required this.primary, required this.onPrimary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AuthHeaderSection._logoSize,
      height: AuthHeaderSection._logoSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, primary.withValues(alpha: 0.75)],
        ),
        borderRadius: AppRadius.cardLg,
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.shopping_bag_rounded,
        color: onPrimary,
        size: AuthHeaderSection._iconSize,
      ),
    );
  }
}
