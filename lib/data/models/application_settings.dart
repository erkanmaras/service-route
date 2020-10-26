import 'package:aff/infrastructure.dart';
 
class ApplicationSettings {
  ApplicationSettings({this.mapPointCheckRateInSeconds});

  factory ApplicationSettings.fromJson(Map<String, dynamic> json) => ApplicationSettings(
        mapPointCheckRateInSeconds: json.getValue<String>('mapPointCheckRateInSeconds'),
      );

  final String mapPointCheckRateInSeconds;


  Map<String, dynamic> toJson() => <String, dynamic>{
        'mapPointCheckRateInSeconds': mapPointCheckRateInSeconds,
      };
}
