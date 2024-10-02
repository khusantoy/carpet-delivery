import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  final String fullname;
  final String password;
  final String phoneNumber;
  final String username;

  const RegisterRequest({
    required this.fullname,
    required this.password,
    required this.phoneNumber,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      "full_name": fullname,
      "password": password,
      'phone_number': phoneNumber,
      "username": username,
    };
  }

  @override
  List<Object> get props => [
        fullname,
        password,
        phoneNumber,
        username,
      ];
}
