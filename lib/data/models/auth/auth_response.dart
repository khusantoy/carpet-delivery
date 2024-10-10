import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final String token;
  final String refreshToken;
  const AuthResponse({required this.token, required this.refreshToken});

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      token: map['access_token'],
      refreshToken: map['refresh_token'],
    );
  }
  @override
  List<Object> get props {
    return [token, refreshToken];
  }
}
