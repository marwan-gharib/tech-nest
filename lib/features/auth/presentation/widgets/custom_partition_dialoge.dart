import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class CustomPartitionDialoge extends StatelessWidget {
  final TextEditingController pinCodeController;
  final ValueNotifier<bool> isErrNotifire;
  final String label;
  const CustomPartitionDialoge({
    required this.pinCodeController,
    required this.isErrNotifire,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox.shrink(),
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const SizedBox(height: 50),
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: Text(
            "Enter code",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Pinput(
          controller: pinCodeController,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          length: 6,
          animationCurve: Curves.linear,
          animationDuration: const Duration(milliseconds: 200),
          autofocus: true,
          defaultPinTheme: PinTheme(
            margin: const EdgeInsets.all(2),
            width: 35,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 15),
        ValueListenableBuilder(
          valueListenable: isErrNotifire,
          builder: (context, value, child) {
            if (!value) return SizedBox.fromSize();
            return Text(
              "Invalid verification code",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            );
          },
        ),
      ],
    );
  }
}
