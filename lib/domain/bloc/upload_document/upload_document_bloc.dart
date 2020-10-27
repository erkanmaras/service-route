import 'package:flutter/foundation.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'upload_document_state.dart';
export 'upload_document_state.dart';

class UploadDocumentBloc extends Cubit<UploadDocumentState> {
  UploadDocumentBloc({@required this.documentCategory, @required this.repository, @required this.logger})
      : assert(logger != null),
        assert(repository != null),
        super(UploadDocumentState());

  final Logger logger;
  final IServiceRouteRepository repository;
  final DocumentCategory documentCategory;

  Future<void> setSelectedFile(String filePath) async {
    try {
      emit(UploadDocumentState(
        pickedFile: DocumentFile(documentCategory, filePath),
        uploadHistory: state.uploadHistory,
      ));
    } on AppException catch (e, s) {
      emit(UploadDocumentFail(reason: e.message, state: state));
      logger.error(e, stackTrace: s);
    } catch (e, s) {
      emit(UploadDocumentFail(reason: AppString.anUnExpectedErrorOccurred, state: state));
      logger.error(e, stackTrace: s);
    }
  }

  Future<void> uploadSelectedDocument() async {
    try {
      try {
        var serverFilePath = await repository.uploadServiceDocumentFile(state.pickedFile);
        await repository.ediDocuments(documentCategory, serverFilePath, state.pickedFile.prettyFileName);
        state.uploadHistory.add(DocumentFileUploadStatus(state.pickedFile, true));
      } catch (e) {
        state.uploadHistory.add(DocumentFileUploadStatus(state.pickedFile, false));
        rethrow;
      }

      emit(UploadDocumentSuccess(
        pickedFile: null,
        uploadHistory: state.uploadHistory,
      ));
    } on AppException catch (e, s) {
      emit(UploadDocumentFail(reason: e.message, state: state));
      logger.error(e, stackTrace: s);
    } catch (e, s) {
      emit(UploadDocumentFail(reason: AppString.anUnExpectedErrorOccurred, state: state));
      logger.error(e, stackTrace: s);
    }
  }
}
