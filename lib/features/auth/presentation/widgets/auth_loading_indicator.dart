import 'package:flutter/material.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';

class AuthLoadingIndicator extends StatelessWidget {
  const AuthLoadingIndicator({super.key});

  static const double _height = 52.0;
  static const double _strokeWidth = 2.5;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Center(
        child: CircularProgressIndicator(
          color: context.colorScheme.primary,
          strokeWidth: _strokeWidth,
        ),
      ),
    );
  }
}
