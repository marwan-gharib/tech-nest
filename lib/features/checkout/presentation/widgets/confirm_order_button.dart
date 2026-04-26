import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_cubit.dart';
import 'package:tech_nest/features/checkout/presentation/cubits/create_order/create_order_state.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class ConfirmOrderButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConfirmOrderButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderCubit, CreateOrderState>(
      builder: (context, state) {
        final isLoading = state is CreateOrderLoading;

        return Container(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.md,
            top: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: context.colors.background,
            boxShadow: [
              BoxShadow(
                color: context.colors.textPrimary.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.colorScheme.onPrimary,
                    ),
                  )
                : Text(
                    context.t.orders.confirmOrder,
                    style: context.headlineLarge.copyWith(
                      fontSize: 16,
                      color: context.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
