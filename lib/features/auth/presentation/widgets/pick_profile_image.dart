import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_nest/core/constants/assets.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/profile_image_cubit.dart';

class PickProfileImage extends StatelessWidget {
  static const double _avatarRadius = 56.0;
  static const double _cameraIconBtnPadding = 6.0;
  static const double _cameraIconSize = 24.0;

  const PickProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileImageCubit>();

    return BlocBuilder<ProfileImageCubit, XFile?>(
      builder: (context, img) {
        return GestureDetector(
          onTap: () => cubit.clear(),
          child: CircleAvatar(
            backgroundColor: context.colors.shimmerBase,
            backgroundImage: img != null
                ? FileImage(File(img.path))
                : AssetImage(Assets.profileAvatar) as ImageProvider,
            radius: _avatarRadius,
            child: img == null
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () => cubit.pickImage(),
                      child: Container(
                        padding: const EdgeInsets.all(_cameraIconBtnPadding),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: _cameraIconSize,
                          color: context.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
