
import 'package:aff/infrastructure.dart';
class AuthenticationToken {
  const AuthenticationToken(this.token, this.validTo);

  factory AuthenticationToken.fromJson(Map<String, dynamic> json) => AuthenticationToken(
        json.getValue<String>('token'),
        DateTime.parse(json.getValue<String>('validTo')),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{'token': token, 'validTo': validTo?.toIso8601String()};

  final String token;

  final DateTime validTo;
}
