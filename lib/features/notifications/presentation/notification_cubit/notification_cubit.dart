import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_nest/core/error/failures/failure.dart';
import 'package:tech_nest/features/notifications/domain/entities/notification_entity.dart';
import 'package:tech_nest/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:tech_nest/features/notifications/domain/usecases/mark_notification_read_usecase.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;

  NotificationCubit({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
  }) : super(const NotificationInitial());

  int _currentPage = 1;

  Future<void> initialFetching() async {
    _currentPage = 1;
    emit(const NotificationLoading());

    final result = await getNotificationsUseCase(page: _currentPage);

    result.fold((failure) => emit(NotificationError(failure)), (notifications) {
      emit(
        NotificationLoaded(
          notifications: notifications,
          hasReachedMax: notifications.length < 20,
          isLoadingMore: false,
          loadMoreFailure: null,
        ),
      );
    });
  }

  Future<void> fetchMore() async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;
    if (currentState.hasReachedMax) return;

    emit(currentState.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    final int previousPage = _currentPage;
    _currentPage++;

    final result = await getNotificationsUseCase(page: _currentPage);

    result.fold(
      (failure) {
        _currentPage = previousPage;
        final loaded = state;
        if (loaded is! NotificationLoaded) return;
        emit(loaded.copyWith(isLoadingMore: false, loadMoreFailure: failure));
      },
      (notifications) {
        final loaded = state;
        if (loaded is! NotificationLoaded) return;

        emit(
          loaded.copyWith(
            notifications: List.of(loaded.notifications)..addAll(notifications),
            isLoadingMore: false,
            clearLoadMoreError: true,
            hasReachedMax: notifications.length < 20,
          ),
        );
      },
    );
  }

  Future<void> markAsRead(int notificationId) async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    final result = await markNotificationReadUseCase(notificationId);

    result.fold((failure) => emit(NotificationError(failure)), (_) {
      final index = currentState.notifications.indexWhere(
        (n) => n.id == notificationId,
      );
      if (index != -1) {
        final List<NotificationEntity> updatedList = List.of(
          currentState.notifications,
        );
        updatedList[index] = updatedList[index].copyWith(isRead: true);

        emit(currentState.copyWith(notifications: updatedList));
      }
    });
  }

  Future<void> markAllAsRead() async {
    final currentState = state;
    if (currentState is! NotificationLoaded) return;

    final notificationIds = List.of(
      currentState.notifications,
    ).where((n) => !n.isRead).map((n) => n.id).toList();
    if (notificationIds.isEmpty) return;

    final List<int> successedIds = [];

    for (final int id in notificationIds) {
      final res = await markNotificationReadUseCase(id);

      res.fold((_) {}, (_) => successedIds.add(id));
    }

    final List<NotificationEntity> updatedList =
        List.of(currentState.notifications)
            .map(
              (n) => successedIds.contains(n.id) ? n.copyWith(isRead: true) : n,
            )
            .toList();

    emit(currentState.copyWith(notifications: updatedList));
  }
}
