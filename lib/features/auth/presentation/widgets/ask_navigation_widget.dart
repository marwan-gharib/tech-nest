import 'package:flutter/material.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class AskNavigationWidget extends StatelessWidget {
  final String question;
  final String screenLabel;
  final VoidCallback onTap;

  const AskNavigationWidget({
    required this.question,
    required this.screenLabel,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$question  ',
          style: context.bodyMedium.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            screenLabel,
            style: context.labelMedium.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: context.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
