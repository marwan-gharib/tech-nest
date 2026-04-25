import 'package:flutter/material.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class AddressSelectionCard extends StatelessWidget {
  final ValueNotifier<String> addressNotifier;
  final VoidCallback onConfirm;

  const AddressSelectionCard({
    required this.addressNotifier,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t.checkout.addressLabel,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: ValueListenableBuilder<String>(
                  valueListenable: addressNotifier,
                  builder: (_, selectedAddress, _) {
                    return Text(
                      selectedAddress,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirm,
              child: Text(context.t.checkout.confirmLocation),
            ),
          ),
        ],
      ),
    );
  }
}
