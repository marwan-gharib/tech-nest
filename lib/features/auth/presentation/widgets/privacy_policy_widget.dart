import 'package:flutter/material.dart';
import 'package:tech_nest/core/constants/links.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  final ValueNotifier<bool> _checkBoxNotifire;
  const PrivacyPolicyWidget(ValueNotifier<bool> checkBoxNotifire, {super.key})
    : _checkBoxNotifire = checkBoxNotifire;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder(
          valueListenable: _checkBoxNotifire,
          builder: (_, value, child) {
            return Checkbox(
              value: value,
              onChanged: (value) => _checkBoxNotifire.value = value!,
              activeColor: Theme.of(context).colorScheme.tertiary,
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
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
                'By Creating an Account, i accept Hiring Hub ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              _textLink(
                context,
                text: "Terms of Use",
                link: Links.termaAndConditionsLink,
              ),
              Text(' and ', style: Theme.of(context).textTheme.bodySmall),
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

  GestureDetector _textLink(
    BuildContext context, {
    required String text,
    required String link,
  }) {
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse(link));
      },
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
