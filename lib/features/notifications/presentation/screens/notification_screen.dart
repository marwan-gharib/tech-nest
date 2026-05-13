import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
import 'package:tech_nest/core/widgets/custom_snack_bar.dart';
import 'package:tech_nest/core/widgets/loading_indicator.dart';
import 'package:tech_nest/core/widgets/no_results_found_view.dart';
import 'package:tech_nest/core/widgets/remote_data_failure_view.dart';
import 'package:tech_nest/features/notifications/presentation/notification_cubit/notification_cubit.dart';
import 'package:tech_nest/features/notifications/presentation/widgets/notification_item.dart';
import 'package:tech_nest/i18n/strings.g.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent - 300 &&
          !_scrollController.position.outOfRange &&
          mounted) {
        context.read<NotificationCubit>().fetchMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.notifications.title, style: context.titleLarge),
        centerTitle: true,
        actions: [
          BlocConsumer<NotificationCubit, NotificationState>(
            buildWhen: (previous, current) {
              if (previous is NotificationLoaded &&
                  current is NotificationLoaded) {
                return previous.notifications.where((n) => !n.isRead).length !=
                    current.notifications.where((n) => !n.isRead).length;
              }
              return true;
            },
            listenWhen: (p, c) =>
                p is NotificationLoaded &&
                c is NotificationLoaded &&
                c.isMarkingAllAsReadFailed,
            listener: (context, state) {
              CustomSnackBar.show(
                context,
                message: context.t.errors.someNotificationsNotMaskedAsRead,
              );
            },
            builder: (context, state) {
              if (state is! NotificationLoaded) return const SizedBox.shrink();
              if (state.isMarkingAllAsRead) {
                return const Center(child: LoadingIndicator());
              }
              final unreadCount = state.notifications
                  .where((n) => !n.isRead)
                  .length;
              if (unreadCount < 1) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  Icons.mark_email_read_rounded,
                  color: context.colorScheme.primary,
                  size: AppSpacing.lg,
                ),
                onPressed: state.isMarkingAllAsRead
                    ? null
                    : () => context.read<NotificationCubit>().markAllAsRead(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          switch (state) {
            case NotificationInitial() || NotificationLoading():
              return const Center(child: CircularProgressIndicator());
            case NotificationError(failure: final f):
              return RemoteDataFailureView(
                onRetry: () =>
                    context.read<NotificationCubit>().initialFetching(),
                failure: f,
              );
            case NotificationLoaded():
              return state.notifications.isEmpty
                  ? NoResultsFoundView(
                      title: context.t.notifications.title,
                      message: context.t.notifications.empty,
                      icon: Icons.notifications_off_rounded,
                      onRefresh: () =>
                          context.read<NotificationCubit>().initialFetching(),
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          context.read<NotificationCubit>().initialFetching(),
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.sm,
                            ),
                            sliver: SliverList.builder(
                              itemCount: state.notifications.length,
                              itemBuilder: (context, index) {
                                final notification = state.notifications[index];
                                return NotificationItem(
                                  notification: notification,
                                );
                              },
                            ),
                          ),
                          if (state.loadMoreFailure != null)
                            SliverToBoxAdapter(
                              child: RemoteDataFailureView(
                                failure: state.loadMoreFailure!,
                                titleOverride: context.t.errors.loadMoreFailed,
                                compact: true,
                                onRetry: () => context
                                    .read<NotificationCubit>()
                                    .fetchMore(),
                              ),
                            ),
                          if (state.isLoadingMore)
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.all(AppSpacing.lg),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
          }
        },
      ),
    );
  }
}
