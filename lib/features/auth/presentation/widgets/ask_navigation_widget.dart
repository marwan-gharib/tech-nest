import 'package:flutter/material.dart';

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
        Text('$question  '),
        InkWell(
          onTap: onTap,
          child: Text(
            screenLabel,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
