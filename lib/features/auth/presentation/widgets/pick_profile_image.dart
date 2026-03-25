import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_nest/core/constants/assets.dart';
import 'package:tech_nest/core/services/image/image_provider.dart';

class PickProfileImage extends ConsumerWidget {
  const PickProfileImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final img = ref.watch(imageProvider);
    final notifire = ref.read(imageProvider.notifier);

    return GestureDetector(
      onTap: () => notifire.clear(),
      child: ClipRRect(
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          backgroundImage: img != null
              ? FileImage(File(img.path))
              : AssetImage(Assets.profileAvatar),
          radius: 56,
          child: img == null
              ? Align(
                  alignment: AlignmentGeometry.bottomEnd,
                  child: GestureDetector(
                    onTap: () => notifire.pickImage(),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera, size: 30),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
