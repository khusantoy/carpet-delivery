part of "auth_bloc.dart";

sealed class AuthState {}

final class InitialAuthState extends AuthState {}

final class LoadingAuthState extends AuthState {}

final class AuthorizedAuthState extends AuthState {}

final class UnauthorizedAuthState extends AuthState {}

final class ErrorAuthState extends AuthState {
  final String message;

  ErrorAuthState({required this.message});
}
