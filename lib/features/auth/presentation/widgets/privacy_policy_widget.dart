import 'package:flutter/material.dart';
import 'package:tech_nest/core/constants/links.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/core/utils/lanch_url.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  final ValueNotifier<bool> _checkBoxNotifier;

  const PrivacyPolicyWidget(this._checkBoxNotifier, {super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _checkBoxNotifier,
          builder: (_, value, child) {
            return Checkbox(
              value: value,
              onChanged: (value) => _checkBoxNotifier.value = value!,
              activeColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.xs),
              ),
              side: BorderSide(color: colorScheme.primary, width: 1.5),
            );
          },
        ),
        Expanded(
          child: Wrap(
            children: [
              Text(
                context.t.auth.privacyPolicy.accept,
                style: context.bodySmall,
              ),
              _textLink(
                context,
                text: context.t.auth.privacyPolicy.terms,
                link: Links.termaAndConditionsLink,
              ),
              Text(context.t.auth.privacyPolicy.and, style: context.bodySmall),
              _textLink(
                context,
                text: context.t.auth.privacyPolicy.policy,
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
    return GestureDetector(
      onTap: () async => await LanchUrl.launch(link),
      child: Text(
        text,
        style: context.bodySmall.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          decorationColor: context.colorScheme.primary,
        ),
      ),
    );
  }
}
