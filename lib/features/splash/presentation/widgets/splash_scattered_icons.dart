import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

final random = math.Random();

class SplashScatteredIcons extends StatelessWidget {
  final AnimationController controller;

  const SplashScatteredIcons({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final gatherProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.55, 0.70, curve: Curves.easeInBack),
      ),
    );

    final items = [
      _IconData(Icons.shopping_cart_outlined, const Offset(-110, -110), 0.0),
      _IconData(Icons.inventory_2_outlined, const Offset(120, -80), 0.05),
      _IconData(Icons.credit_card_outlined, const Offset(-130, 80), 0.10),
      _IconData(Icons.favorite_border_outlined, const Offset(110, 110), 0.15),
      _IconData(Icons.local_shipping_outlined, const Offset(0, -150), 0.20),
      _IconData(Icons.devices_outlined, const Offset(0, 150), 0.25),
    ];

    return Stack(
      alignment: Alignment.center,
      children: items.map((item) {
        final start = 0.05 + item.staggerDelay;
        final end = start + 0.2;

        final scaleIn = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(start, end, curve: Curves.elasticOut),
          ),
        );

        final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(start, start + 0.1, curve: Curves.easeIn),
          ),
        );

        final rotation =
            ((random.nextDouble()) - 0.5) +
            (gatherProgress.value * math.pi * 2.5);

        return AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final gVal = gatherProgress.value;
            final currentOffsetX = item.offset.dx * (1.0 - gVal);
            final currentOffsetY = item.offset.dy * (1.0 - gVal);

            final hoverY =
                math.sin(controller.value * math.pi * 7 + item.offset.dx) *
                10 *
                (1 - gVal);

            final opacity = (fadeIn.value * (1.0 - gVal * 1.2)).clamp(0.0, 1.0);

            final scale = scaleIn.value * (1.0 - gVal * 0.4);

            if (opacity == 0 || gVal == 1) return const SizedBox.shrink();

            return Positioned(
              child: Transform.translate(
                offset: Offset(currentOffsetX, currentOffsetY + hoverY),
                child: Transform.scale(
                  scale: scale,
                  child: Transform.rotate(
                    angle: rotation,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.colorScheme.surface.withValues(
                            alpha: 0.15,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colorScheme.onPrimary.withValues(
                              alpha: 0.3,
                            ),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: context.colorScheme.shadow.withValues(
                                alpha: 0.1,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          item.icon,
                          color: context.colorScheme.onPrimary,
                          size: AppSpacing.lg,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class _IconData {
  final IconData icon;
  final Offset offset;
  final double staggerDelay;

  _IconData(this.icon, this.offset, this.staggerDelay);
}
