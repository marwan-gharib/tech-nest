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

  const NotificationLoaded({
    required this.notifications,
    required this.hasReachedMax,
    required this.isLoadingMore,
    this.loadMoreFailure,
  });

  NotificationLoaded copyWith({
    List<NotificationEntity>? notifications,
    bool? hasReachedMax,
    bool? isLoadingMore,
    Failure? loadMoreFailure,
    bool clearLoadMoreError = false,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailure: clearLoadMoreError
          ? null
          : (loadMoreFailure ?? this.loadMoreFailure),
    );
  }

  @override
  List<Object?> get props => [notifications, hasReachedMax];
}

class NotificationError extends NotificationState {
  final Failure failure;

  const NotificationError(this.failure);

  @override
  List<Object?> get props => [failure];
}
