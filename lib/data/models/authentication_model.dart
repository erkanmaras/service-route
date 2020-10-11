import 'package:flutter/foundation.dart';
import 'package:aff/infrastructure.dart';

class AuthenticationModel {
  AuthenticationModel({@required this.userName, @required this.password});

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) =>
      AuthenticationModel(
        userName: json.getValue<String>('userName'),
        password: json.getValue<String>('password'),
      );

  final String userName;
  final String password;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userName': userName,
        'password': password,
      };

  bool hasEmptyField() {
    return userName.isNullOrEmpty() || password.isNullOrEmpty();
  }
}
