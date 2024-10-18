part of 'status_bloc.dart';

sealed class StatusState {}

class InitialStatusState extends StatusState {}

class LoadingStatusState extends StatusState {}

class LoadedStatusState extends StatusState {
  final bool isSuccess;
  final String status;
  final String orderId;
  LoadedStatusState({required this.isSuccess, required this.status, required this.orderId});
}

class ErrorStatusState extends StatusState {
  final String message;

  ErrorStatusState({required this.message});
}
