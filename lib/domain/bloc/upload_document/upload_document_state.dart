import 'package:flutter/material.dart';
import 'package:path/path.dart';

class UploadDocumentState {
  UploadDocumentState({this.pickedFile, List<DocumentFileUploadStatus> uploadHistory}) {
    this.uploadHistory = uploadHistory ?? <DocumentFileUploadStatus>[];
  }

  bool get hasFile => pickedFile != null;
  List<DocumentFileUploadStatus> uploadHistory;
  DocumentFile pickedFile;
 
}

class UploadDocumentFailState extends UploadDocumentState {
  UploadDocumentFailState({@required this.reason, UploadDocumentState state})
      : super(pickedFile: state.pickedFile, uploadHistory: state.uploadHistory);

  final String reason;
}

class DocumentFile {
  DocumentFile(this.path) : fileName = basename(path);
  final String path;
  final String fileName;
}

class DocumentFileUploadStatus {
  DocumentFileUploadStatus(this.file, this.uploaded);
  final DocumentFile file;
  final bool uploaded;
}
