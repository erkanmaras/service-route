import 'package:flutter/material.dart';
import 'package:service_route/data/data.dart';

class UploadDocumentState {
  UploadDocumentState({this.pickedFile, List<DocumentFileUploadStatus> uploadHistory}) {
    this.uploadHistory = uploadHistory ?? <DocumentFileUploadStatus>[];
  }

  bool get hasFile => pickedFile != null;
  List<DocumentFileUploadStatus> uploadHistory;
  DocumentFile pickedFile;
 
}

class UploadDocumentSuccess extends UploadDocumentState {
  UploadDocumentSuccess({DocumentFile pickedFile, List<DocumentFileUploadStatus> uploadHistory})
      : super(pickedFile: pickedFile, uploadHistory: uploadHistory);
}


class UploadDocumentFail extends UploadDocumentState {
  UploadDocumentFail({@required this.reason, UploadDocumentState state})
      : super(pickedFile: state.pickedFile, uploadHistory: state.uploadHistory);

  final String reason;
}

class DocumentFileUploadStatus {
  DocumentFileUploadStatus(this.file, this.uploaded);
  final DocumentFile file;
  final bool uploaded;
}
