import 'package:flutter/material.dart';
import 'package:tech_nest/core/constants/links.dart';
import 'package:tech_nest/core/shared/utils/lanch_url.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  final ValueNotifier<bool> _checkBoxNotifier;
  const PrivacyPolicyWidget(this._checkBoxNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder(
          valueListenable: _checkBoxNotifier,
          builder: (_, value, child) {
            return Checkbox(
              value: value,
              onChanged: (value) => _checkBoxNotifier.value = value!,
              activeColor: colorScheme.tertiary,
              side: BorderSide(
                color: colorScheme.primary,
                width: 1,
                strokeAlign: 3,
              ),
            );
          },
        ),
        Expanded(
          child: Wrap(
            children: [
              Text(
                'By Creating an Account, i accept Tech Nest ',
                style: theme.textTheme.bodySmall,
              ),
              _textLink(
                context,
                text: "Terms of Use",
                link: Links.termaAndConditionsLink,
              ),
              Text(' and ', style: theme.textTheme.bodySmall),
              _textLink(
                context,
                text: "Privacy Policy",
                link: Links.privacyPolicyLink,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _textLink(
    BuildContext context, {
    required String text,
    required String link,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () async {
        await LanchUrl.launch(link);
      },
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
