import 'package:service_route/infrastructure/infrastructure.dart';

class DeservedRight {
  DeservedRight({
    this.description,
  });

  factory DeservedRight.fromJson(Map<String, dynamic> json) =>
      DeservedRight(description: json.getValue<String>('description'));

  final String description;

  Map<String, dynamic> toJson() => <String, dynamic>{'description': description};
}
