import 'package:flutter/material.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class BuildPrice extends StatelessWidget {
  final double price;
  final bool isLabeled;
  final double size;
  final Color? numberColor;

  const BuildPrice({
    required this.price,
    this.size = 20,
    this.isLabeled = false,
    this.numberColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: isLabeled ? "Price: " : "",
        style: context.labelLarge.copyWith(
          fontSize: size * 0.8,
          fontWeight: FontWeight.w400,
          color: context.colors.textSecondary,
        ),
        children: [
          TextSpan(
            text: price.toStringAsFixed(1),
            style: context.labelLarge.copyWith(
              fontSize: size,
              fontWeight: FontWeight.bold,
              color: numberColor ?? context.colors.textPrimary,
            ),
          ),
          TextSpan(
            text: " \$",
            style: context.labelLarge.copyWith(
              fontSize: size * 0.9,
              fontWeight: FontWeight.bold,
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

