import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:service_route/domain/bloc/completed_transfer/completed_transfer_state.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
export 'package:service_route/domain/bloc/completed_transfer/completed_transfer_state.dart';

class CompletedTransferBloc extends Cubit<CompletedTransferState> {
  CompletedTransferBloc({@required this.repository, @required this.logger})
      : assert(logger != null),
        super(CompletedTransferLoaded.initial());

  final Logger logger;
  final IServiceRouteRepository repository;

  Future<void> load() async {
    try {
      emit(CompletedTransferLoading());
      var transfers = await repository.getCompletedTransfers();
      emit(CompletedTransferLoaded(transfers: transfers));
    } on AppException catch (e, s) {
      emit(CompletedTransferFail(reason: e.message));
      logger.error(e, stackTrace: s);
    } catch (e, s) {
      emit(CompletedTransferFail(reason: AppString.anUnExpectedErrorOccurred));
      logger.error(e, stackTrace: s);
    }
  }

  Future<void> filter(DateTime filter) async {
    try {
      if (state is CompletedTransferLoaded) {
        var loadedSate = state as CompletedTransferLoaded;
        var filtered = loadedSate.transfers
            .where((element) => element.transferDate.year == filter.year && element.transferDate.month == filter.month)
            .toList();
        emit(CompletedTransferFiltered(transfers: filtered));
      }
    } on AppException catch (e, s) {
      emit(CompletedTransferFail(reason: e.message));
      logger.error(e, stackTrace: s);
    } catch (e, s) {
      emit(CompletedTransferFail(reason: AppString.anUnExpectedErrorOccurred));
      logger.error(e, stackTrace: s);
    }
  }
}
