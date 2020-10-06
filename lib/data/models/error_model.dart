import 'package:aff/infrastructure.dart';
class ErrorModel {
  ErrorModel({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.instance,
    this.reason,
    this.reasonDescription,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        type: json.getValue<String>('type'),
        title: json.getValue<String>('title'),
        status: json.getValue<int>('status'),
        detail: json.getValue<String>('detail'),
        instance: json.getValue<String>('instance'),
        reason: json.getValue<int>('reason'),
        reasonDescription: json.getValue<String>('reasonDescription'),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type,
        'title': title,
        'status': status,
        'detail': detail,
        'instance': instance,
        'reason': reason,
        'reasonDescription': reasonDescription,
      };

  String type;
  String title;
  int status;
  String detail;
  String instance;
  int reason;
  String reasonDescription;
}
