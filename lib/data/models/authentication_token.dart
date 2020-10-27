import 'package:aff/infrastructure.dart';

class AuthenticationToken {
  const AuthenticationToken(this.token);

  factory AuthenticationToken.fromJson(Map<String, dynamic> json) => AuthenticationToken(
        json.getValue<String>('token'),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'token': token,
      };

  final String token;
}
