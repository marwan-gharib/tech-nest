import 'package:flutter/material.dart';

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
        text: isLabeled
            ? "Price: ${price.toStringAsFixed(1)}"
            : price.toStringAsFixed(1),
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
          fontSize: size,
          fontWeight: FontWeight.w500,
          color:
              numberColor ??
              Theme.of(context).shadowColor.withValues(alpha: 0.6),
        ),
        children: [
          TextSpan(
            text: " \$",
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              fontSize: size,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}
