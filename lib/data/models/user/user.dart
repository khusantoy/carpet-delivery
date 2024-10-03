import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String fullname;
  final String phoneNumber;
  final String role;

  const User({
    required this.id,
    required this.fullname,
    required this.username,
    required this.phoneNumber,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      fullname: map['full_name'] as String,
      username: map['username'] as String,
      phoneNumber: map['phone_number'] as String,
      role: map['role'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "full_name": fullname,
      "phone_number": phoneNumber,
      "role": role,
    };
  }

  @override
  List<Object?> get props => [id, username, fullname, phoneNumber, role];
}
