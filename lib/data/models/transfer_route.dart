import 'package:service_route/infrastructure/infrastructure.dart';

class TransferRoute {
  TransferRoute({
    this.id,
    this.completed,
    this.transferDate,
    this.lineDescription,
    this.accountDescription,
  });

  factory TransferRoute.fromJson(Map<String, dynamic> json) => TransferRoute(
        id: json.getValue<double>('id'),
        completed: json.getValue<bool>('completed'),
        transferDate: json.getValue<DateTime>('transferDate'),
        lineDescription: json.getValue<String>('lineDescription'),
        accountDescription: json.getValue<String>('accountDescription'),
      );

  final double id;
  final bool completed;
  final DateTime transferDate;
  final String lineDescription;
  final String accountDescription;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'completed': completed,
        'transferDate': transferDate,
        'lineDescription': lineDescription,
        'accountDescription': accountDescription,
      };
}
