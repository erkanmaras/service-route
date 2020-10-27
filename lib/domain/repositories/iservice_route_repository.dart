import 'dart:io';
import 'package:service_route/data/data.dart';

abstract class IServiceRouteRepository {
  Future<AuthenticationToken> authenticate(AuthenticationModel model);
  Future<ApplicationSettings> getApplicationSettings();
  Future<List<TransferRoute>> getTransferRoutes();
  List<DocumentCategory> getServiceDocumentCategories();
  Future<List<CompletedTransfer>> getCompletedTransfers(int year, int mont);
  Future<void> uploadTransferFile(File file);
  Future<void> ediDocuments(DocumentCategory documentCategory, String serverFilePath, String fileName);
  Future<String> uploadServiceDocumentFile(DocumentFile file);
}
