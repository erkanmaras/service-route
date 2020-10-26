import 'package:aff/infrastructure.dart';

class UserSettings {
  UserSettings({this.userName});

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        userName: json.getValue<String>('userName'),
      );

  final String userName;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userName': userName,
      };
}
