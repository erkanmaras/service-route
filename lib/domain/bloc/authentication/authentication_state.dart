import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:service_route/data/data.dart';

abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  AuthenticationSuccess({@required this.authToken, @required this.authModel});
  final AuthenticationModel authModel;
  final AuthenticationToken authToken;
}

class Authenticating extends AuthenticationState {}

class AuthenticationFail extends AuthenticationState {
  AuthenticationFail({@required this.reason});

  final String reason;

  @override
  String toString() => 'AuthenticationFail { reason: $reason }';
}
