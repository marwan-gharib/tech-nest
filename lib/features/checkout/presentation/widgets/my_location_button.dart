import 'package:flutter/material.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class MyLocationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ValueNotifier<bool> isLoadingNotifier;

  const MyLocationButton({
    required this.onPressed,
    required this.isLoadingNotifier,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: FloatingActionButton(
        mini: true,
        onPressed: onPressed,
        child: ValueListenableBuilder<bool>(
          valueListenable: isLoadingNotifier,
          builder: (_, isLoading, _) {
            if (isLoading) {
              return const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              );
            }
            return const Icon(Icons.my_location);
          },
        ),
      ),
    );
  }
}
