part of 'status_bloc.dart';

sealed class StatusState {}

class InitialStatusState extends StatusState {}

class LoadingStatusState extends StatusState {}

class LoadedStatusState extends StatusState {
  final bool isSuccess;
  LoadedStatusState({required this.isSuccess});
}

class ErrorStatusState extends StatusState {
  final String message;

  ErrorStatusState({required this.message});
}
