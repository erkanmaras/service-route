import 'package:service_route/infrastructure/infrastructure.dart';

class ServiceDocument {
  ServiceDocument({
    this.description,
  });

  factory ServiceDocument.fromJson(Map<String, dynamic> json) =>
      ServiceDocument(description: json.getValue<String>('description'));

  final String description;

  Map<String, dynamic> toJson() => <String, dynamic>{'description': description};
}
