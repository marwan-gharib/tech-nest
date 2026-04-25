import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';

class CheckoutAddressCard extends StatefulWidget {
  final ValueChanged<String?>? onLocationSelected;

  const CheckoutAddressCard({this.onLocationSelected, super.key});

  @override
  State<CheckoutAddressCard> createState() => _CheckoutAddressCardState();
}

class _CheckoutAddressCardState extends State<CheckoutAddressCard> {
  String? _deliveryLocation;

  Future<void> _openLocationPicker() async {
    final result = await context.push<String?>(
      "${Routes.cartScreenPath}/${Routes.checkoutScreenPath}/${Routes.locationPickerScreenPath}",
    );

    if (result != null) {
      setState(() => _deliveryLocation = result);
      widget.onLocationSelected?.call(_deliveryLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: _openLocationPicker,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: colorScheme.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                _deliveryLocation ?? "pick the delivery location",
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
