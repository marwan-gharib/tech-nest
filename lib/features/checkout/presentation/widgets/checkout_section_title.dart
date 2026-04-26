import 'package:flutter/material.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class CheckoutSectionTitle extends StatelessWidget {
  final String title;

  const CheckoutSectionTitle({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.titleMedium.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

