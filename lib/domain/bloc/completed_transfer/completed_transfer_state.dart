import 'package:flutter/material.dart';
import 'package:service_route/data/data.dart';

class CompletedTransferState {}

class CompletedTransferLoaded extends CompletedTransferState {
  CompletedTransferLoaded({
    List<CompletedTransfer> transfers,
  }) : transfers = transfers ?? <CompletedTransfer>[];
  factory CompletedTransferLoaded.initial() {
    return CompletedTransferLoaded();
  }

  final List<CompletedTransfer> transfers;
}

class CompletedTransferFiltered extends CompletedTransferState {
  CompletedTransferFiltered({
    List<CompletedTransfer> transfers,
  }) : transfers = transfers ?? <CompletedTransfer>[];

  final List<CompletedTransfer> transfers;
}

class CompletedTransferLoading extends CompletedTransferState {
  CompletedTransferLoading() : super();
}

class CompletedTransferFail extends CompletedTransferState {
  CompletedTransferFail({@required this.reason}) : super();

  final String reason;

  @override
  String toString() => 'CompletedTransferFail { reason: $reason }';
}
