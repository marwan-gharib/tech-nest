import 'package:flutter/material.dart';

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
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
