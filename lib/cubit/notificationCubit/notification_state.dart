part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
}

 class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoadingState extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationErrorState extends NotificationState{
  final DefaultApiResponse errorResponse;
  NotificationErrorState(this.errorResponse);
  @override
  List<Object?> get props => [errorResponse];
}

class NotificationSuccessState extends NotificationState{
  final List<NotificationList> response;
  NotificationSuccessState(this.response);
  @override
  List<Object?> get props => [response];
}