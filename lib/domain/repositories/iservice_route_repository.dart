import 'dart:io';
import 'package:service_route/data/data.dart';

abstract class IServiceRouteRepository {
  Future<AuthenticationToken> authenticate(AuthenticationModel model);
  Future<ApplicationSettings> getApplicationSettings();
  Future<List<TransferRoute>> getTransferRoutes();
  List<DocumentCategory> getServiceDocumentCategories();
  Future<List<CompletedTransfer>> getCompletedTransfers();
  Future<void> uploadTransferFile(File file);
  Future<void> uploadServiceDocumentFile(File file);
}
