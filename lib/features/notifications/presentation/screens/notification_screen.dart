import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/theme/app_spacing.dart';
import 'package:tech_nest/core/utils/extensions/context_extensions.dart';
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
  final ScrollController _scrollController = ScrollController();

  static const double _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - _scrollThreshold) {
      context.read<NotificationCubit>().fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.notifications.title, style: context.titleLarge),
        centerTitle: true,
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
                              itemCount: state.hasReachedMax
                                  ? state.notifications.length
                                  : state.notifications.length + 1,
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
