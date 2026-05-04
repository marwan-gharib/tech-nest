import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_nest/core/routing/routes.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class CheckoutAddressCard extends StatefulWidget {
  final ValueChanged<String?>? onLocationSelected;

  const CheckoutAddressCard({this.onLocationSelected, super.key});

  @override
  State<CheckoutAddressCard> createState() => _CheckoutAddressCardState();
}

class _CheckoutAddressCardState extends State<CheckoutAddressCard> {
  String? _deliveryLocation;

  Future<void> _openLocationPicker() async {
    final result = await context.pushNamed<String?>(RouteNames.locationPicker);

    if (result != null) {
      setState(() => _deliveryLocation = result);
      widget.onLocationSelected?.call(_deliveryLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return GestureDetector(
      onTap: _openLocationPicker,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.colors.border.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: colorScheme.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                _deliveryLocation ?? context.t.orders.pickLocation,
                style: context.bodyMedium,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
