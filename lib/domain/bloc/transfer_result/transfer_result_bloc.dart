import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:service_route/domain/bloc/transfer_result/transfer_result_state.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
export 'package:service_route/domain/bloc/transfer_result/transfer_result_state.dart';

class TransferResultBloc extends Cubit<TransferResultState> {
  TransferResultBloc({ @required this.logger})
      : assert(logger != null),
        super(TransferResultInitial());

  final Logger logger;
 
  Future<void> readTransferFile(String fileContent) async {
    try {
      emit(TransferResultReading());
      var summary = await compute<String, TransferSummary>(TransferSummary.readTransferFile, fileContent);
      emit(TransferResultReadComplete(summary: summary));
    } on AppException catch (e, s) {
      emit(TransferResultReadFail(reason: e.message));
      logger.error(e, stackTrace: s);
    } catch (e, s) {
      emit(TransferResultReadFail(reason: AppString.anUnExpectedErrorOccurred));
      logger.error(e, stackTrace: s);
    }
  }
}
