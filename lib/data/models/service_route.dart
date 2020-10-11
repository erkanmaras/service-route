import 'package:service_route/infrastructure/infrastructure.dart';

class ServiceRoute {
  ServiceRoute({
    this.description,
  });

  factory ServiceRoute.fromJson(Map<String, dynamic> json) =>
      ServiceRoute(description: json.getValue<String>('description'));

  final String description;

  Map<String, dynamic> toJson() => <String, dynamic>{'description': description};
}
