import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String username;
  final String fullname;
  final String phoneNumber;

  const User(this.fullname,
      {required this.username, required this.phoneNumber});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['full_name'] as String,
      username: map['username'] as String,
      phoneNumber: map['phone_number'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "full_name": fullname,
      "phone_number": phoneNumber,
    };
  }

  @override
  List<Object> get props => [username, fullname, phoneNumber];
}
