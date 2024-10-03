part of "auth_bloc.dart";

abstract class AuthEvent {}

class LoginAuthEvent extends AuthEvent {
  final LoginRequest request;
  LoginAuthEvent({
    required this.request,
  });
}

class LogoutAuthEvent extends AuthEvent {}

class RegisterAuthEvent extends AuthEvent {
  final RegisterRequest request;
  RegisterAuthEvent({
    required this.request,
  });
}

class CheckAuthStatusEvent extends AuthEvent {}
