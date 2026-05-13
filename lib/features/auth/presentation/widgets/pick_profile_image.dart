import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_nest/core/constants/assets.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/auth/presentation/notifiers/profile_image_cubit.dart';

class PickProfileImage extends StatelessWidget {
  static const double _avatarRadius = 64.0;
  static const double _haloRadius = 70.0;
  static const double _cameraIconBtnPadding = 8.0;
  static const double _cameraIconSize = 22.0;

  const PickProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileImageCubit>();
    final primary = context.colorScheme.primary;

    return BlocBuilder<ProfileImageCubit, XFile?>(
      builder: (context, img) {
        return GestureDetector(
          onTap: () => cubit.clear(),
          child: Container(
            width: _haloRadius * 2,
            height: _haloRadius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withValues(alpha: 0.10),
              border: Border.all(
                color: primary.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            child: Center(
              child: CircleAvatar(
                backgroundColor: context.colors.shimmerBase,
                backgroundImage: img != null
                    ? FileImage(File(img.path))
                    : AssetImage(Assets.profileAvatar) as ImageProvider,
                radius: _avatarRadius,
                child: img == null ? _CameraOverlay(cubit: cubit) : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CameraOverlay extends StatelessWidget {
  final ProfileImageCubit cubit;

  const _CameraOverlay({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: context.isArabic
          ? Alignment.bottomLeft
          : Alignment.bottomRight,
      child: GestureDetector(
        onTap: () => cubit.pickImage(),
        child: Container(
          padding: const EdgeInsets.all(PickProfileImage._cameraIconBtnPadding),
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.camera_alt_rounded,
            size: PickProfileImage._cameraIconSize,
            color: context.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
