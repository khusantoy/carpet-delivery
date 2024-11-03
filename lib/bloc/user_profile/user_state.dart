part of "user_bloc.dart";

sealed class UserState {}

class InitialState extends UserState {}

class LoadingState extends UserState {}

class LoadedState extends UserState {
  final User user;

  LoadedState({required this.user});
}

class ErrorState extends UserState {
  final String message;

  ErrorState({required this.message});
}
