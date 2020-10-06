import 'package:aff/infrastructure.dart';
 
class ApplicationSettings {
  ApplicationSettings({this.useLiteMap});

  factory ApplicationSettings.fromJson(Map<String, dynamic> json) => ApplicationSettings(
        useLiteMap: json.getValue<String>('useLiteMap'),
      );

  final String useLiteMap;


  Map<String, dynamic> toJson() => <String, dynamic>{
        'useLiteMap': useLiteMap,
      };
}
