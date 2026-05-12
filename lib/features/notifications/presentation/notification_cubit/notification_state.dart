part of 'notification_cubit.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final Failure? loadMoreFailure;
  final bool isMarkingAllAsRead;
  final bool isMarkingAllAsReadFailed;

  const NotificationLoaded({
    required this.notifications,
    required this.hasReachedMax,
    required this.isLoadingMore,
    this.loadMoreFailure,
    this.isMarkingAllAsRead = false,
    this.isMarkingAllAsReadFailed = false,
  });

  NotificationLoaded copyWith({
    List<NotificationEntity>? notifications,
    bool? hasReachedMax,
    bool? isLoadingMore,
    Failure? loadMoreFailure,
    bool clearLoadMoreError = false,
    bool? isMarkingAllAsRead,
    bool? isMarkingAllAsReadFailed,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailure: clearLoadMoreError
          ? null
          : (loadMoreFailure ?? this.loadMoreFailure),
      isMarkingAllAsRead: isMarkingAllAsRead ?? this.isMarkingAllAsRead,
      isMarkingAllAsReadFailed:
          isMarkingAllAsReadFailed ?? this.isMarkingAllAsReadFailed,
    );
  }

  @override
  List<Object?> get props => [
    notifications,
    hasReachedMax,
    isLoadingMore,
    loadMoreFailure,
    isMarkingAllAsRead,
  ];
}

class NotificationError extends NotificationState {
  final Failure failure;

  const NotificationError(this.failure);

  @override
  List<Object?> get props => [failure];
}
