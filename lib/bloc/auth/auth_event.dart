part of "auth_bloc.dart";

abstract class AuthEvent {}

class LoginAuthEvent extends AuthEvent {
  final LoginRequest request;
  LoginAuthEvent({
    required this.request,
  });
}

class LogoutAuthEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}
