import 'package:flutter/foundation.dart';
import 'package:aff/infrastructure.dart';

class AuthenticationModel {
  AuthenticationModel({@required this.serverName, @required this.userGroup, @required this.userName, @required this.password, @required this.language});

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) => AuthenticationModel(
        serverName: json.getValue<String>('serverName'),
        userGroup: json.getValue<String>('userGroup'),
        userName: json.getValue<String>('userName'),
        password: json.getValue<String>('password'),
        language: json.getValue<String>('language'),
      );

  final String serverName;
  final String userGroup;
  final String userName;
  final String password;
  final String language;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'serverName': serverName,
        'userGroup': userGroup,
        'userName': userName,
        'password': password,
        'language': language,
      };

  bool hasEmptyField() {
    return serverName.isNullOrEmpty() ||
        userGroup.isNullOrEmpty() ||
        userName.isNullOrEmpty() ||
        password.isNullOrEmpty() ||
        language.isNullOrEmpty();
  }
}
