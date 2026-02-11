import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool isLoading;
  final bool isEnabled;
  final String label;
  final VoidCallback? onPress;

  const CustomButton({
    required this.isLoading,
    required this.isEnabled,
    required this.label,
    this.onPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }
    return ElevatedButton(
      onPressed: isEnabled ? onPress : null,
      child: Text(label),
    );
  }
}
