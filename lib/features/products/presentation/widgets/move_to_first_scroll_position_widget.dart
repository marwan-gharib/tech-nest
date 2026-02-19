import 'package:flutter/material.dart';

class MoveToFirstScrollPositionWidget extends StatelessWidget {
  final VoidCallback onTap;

  const MoveToFirstScrollPositionWidget({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      right: 10,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Icon(
            Icons.keyboard_double_arrow_up_rounded,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
