import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:service_route/domain/bloc/completed_transfers/completed_transfers_state.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
export 'package:service_route/domain/bloc/completed_transfers/completed_transfers_state.dart';

class CompletedTransfersBloc extends Cubit<CompletedTransfersState> {
  CompletedTransfersBloc({@required this.repository, @required this.logger})
      : assert(logger != null),
        super(CompletedTransfersInitial());

  final Logger logger;
  final IServiceRouteRepository repository;

  Future<void> load(int year, int month) async {
    try {
      emit(CompletedTransfersLoading());
      var transfers = await repository.getCompletedTransfers( year, month);
      emit(CompletedTransfersLoaded(transfers: transfers));
    } on AppException catch (e, s) {
      emit(CompletedTransfersLoadFail(reason: e.message));
      logger.error(e, stackTrace: s);
    } catch (e, s) {
      emit(CompletedTransfersLoadFail(reason: AppString.anUnExpectedErrorOccurred));
      logger.error(e, stackTrace: s);
    }
  }
 
}
