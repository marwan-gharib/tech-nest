import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/constants/endpoints.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/auth/domain/entities/user_entity.dart';
import 'package:tech_nest/core/theme/app_radius.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/features/settings/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:tech_nest/features/settings/presentation/cubits/user_profile/user_profile_state.dart';

class SettingsProfileHeader extends StatelessWidget {
  const SettingsProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        UserEntity? user;
        String? subtitle;

        if (state is UserProfileLoaded) {
          user = state.user;
          subtitle = user.email;
        } else if (state is UserProfileLoading) {
          subtitle = 'Loading profile...';
        } else if (state is UserProfileError) {
          subtitle = 'Error loading profile';
        } else {
          subtitle = 'Please sign in to access full features';
        }

        final colorScheme = context.colorScheme;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.xxl),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              _avatarSection(context, user?.image),
              const SizedBox(height: AppSpacing.md),
              Text(
                user?.name ?? 'Guest User',
                style: context.headlineMedium.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: context.bodyMedium.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _avatarSection(BuildContext context, String? image) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 55,
        backgroundColor: context.colors.background,
        backgroundImage: image != null
            ? NetworkImage(Endpoints.baseUrl + image)
            : null,
        child: image == null
            ? Icon(
                Icons.person_rounded,
                size: 45,
                color: context.colorScheme.primary,
              )
            : null,
      ),
    );
  }
}

