import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final String token;
  const AuthResponse({required this.token});

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(token: map['access_token']);
  }
  @override
  List<Object> get props {
    return [token];
  }
}
