import 'package:flutter/material.dart';
import 'package:service_route/data/data.dart';

class CompletedTransfersState {
  CompletedTransfersState._({List<CompletedTransfer> transfers}) : transfers = transfers ?? <CompletedTransfer>[];
  final List<CompletedTransfer> transfers;
}

class CompletedTransfersLoaded extends CompletedTransfersState {
  CompletedTransfersLoaded({
    List<CompletedTransfer> transfers,
  }) : super._(transfers: transfers);
}

class CompletedTransfersInitial extends CompletedTransfersState {
  CompletedTransfersInitial() : super._();
}

class CompletedTransfersLoading extends CompletedTransfersState {
  CompletedTransfersLoading() : super._();
}

class CompletedTransfersLoadFail extends CompletedTransfersState {
  CompletedTransfersLoadFail({@required this.reason}) : super._();

  final String reason;

  @override
  String toString() => 'CompletedTransferFail { reason: $reason }';
}
