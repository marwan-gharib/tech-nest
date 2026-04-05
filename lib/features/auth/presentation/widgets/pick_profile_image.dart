import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_nest/core/constants/assets.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/image_provider.dart';

class PickProfileImage extends ConsumerWidget {
  static const double _avatarRadius = 56.0;
  static const double _cameraIconBtnPadding = 3.0;
  static const double _cameraIconSize = 30.0;

  const PickProfileImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final img = ref.watch(imageProvider);
    final notifier = ref.read(imageProvider.notifier);

    return GestureDetector(
      onTap: () => notifier.clear(),
      child: ClipRRect(
        child: CircleAvatar(
          backgroundColor: colorScheme.surface,
          backgroundImage: img != null
              ? FileImage(File(img.path))
              : AssetImage(Assets.profileAvatar) as ImageProvider,
          radius: _avatarRadius,
          child: img == null
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () => notifier.pickImage(),
                    child: Container(
                      padding: const EdgeInsets.all(_cameraIconBtnPadding),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera, size: _cameraIconSize),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
