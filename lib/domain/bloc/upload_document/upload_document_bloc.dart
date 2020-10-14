import 'package:flutter/foundation.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'upload_document_state.dart';
export 'upload_document_state.dart';

class UploadDocumentBloc extends Cubit<UploadDocumentState> {
  UploadDocumentBloc({@required this.repository, @required this.logger})
      : assert(logger != null),
        assert(repository != null),
        super(UploadDocumentState());

  final Logger logger;
  final IServiceRouteRepository repository;

  Future<void> setSelectedFile(String filePath) async {
    try {
      emit(UploadDocumentState(
        pickedFile: DocumentFile(filePath),
        uploadHistory: state.uploadHistory,
      ));
    } on AppException catch (e, s) {
      emit(UploadDocumentFailState(reason: e.message, state: state));
      logger.error(e, stackTrace: s);
    } catch (e, s) {
      emit(UploadDocumentFailState(reason: AppString.anUnExpectedErrorOccurred, state: state));
      logger.error(e, stackTrace: s);
    }
  }

  Future<void> uploadSelectedDocument() async {
    try {
      try {
        await Future<void>.delayed(Duration(seconds: 3));
        state.uploadHistory.add(DocumentFileUploadStatus(state.pickedFile, true));
      } catch (e) {
        state.uploadHistory.add(DocumentFileUploadStatus(state.pickedFile, false));
        rethrow;
      }

      emit(UploadDocumentState(
        pickedFile: null,
        uploadHistory: state.uploadHistory,
      ));
    } on AppException catch (e, s) {
      emit(UploadDocumentFailState(reason: e.message, state: state));
      logger.error(e, stackTrace: s);
    } catch (e, s) {
      emit(UploadDocumentFailState(reason: AppString.anUnExpectedErrorOccurred, state: state));
      logger.error(e, stackTrace: s);
    }
  }
}
