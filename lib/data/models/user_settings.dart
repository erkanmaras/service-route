import 'package:aff/infrastructure.dart';

class UserSettings {
  UserSettings({this.serverName, this.userName, this.language});

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        serverName: json.getValue<String>('serverName'),
        userName: json.getValue<String>('userName'),
        language: json.getValue<String>('language'),
      );

  final String serverName;
  final String userName;
  final String language;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'serverName': serverName,
        'userName': userName,
        'language': language,
      };
}
