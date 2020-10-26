import 'dart:io';

import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';

class ServiceRouteRepository extends IServiceRouteRepository {
  ServiceRouteRepository(this.apiClient);
  ServiceRouteApi apiClient;

  @override
  Future<AuthenticationToken> authenticate(AuthenticationModel model) async {
    apiClient.initialize();
    return apiClient.authenticate(model);
  }

  @override
  Future<ApplicationSettings> getApplicationSettings() async {
 
    return apiClient.getApplicationSettings( );
  }


  @override
  Future<List<TransferRoute>> getTransferRoutes() {
    return apiClient.getTransferRoutes();
  }

  @override
  Future<List<CompletedTransfer>> getCompletedTransfers() {
    return apiClient.getCompletedTransfers();
  }
 
  @override
  List<DocumentCategory> getServiceDocumentCategories() {
    var documentTypes = <DocumentCategory>[];
    void add(String n, String i) {
      documentTypes.add(DocumentCategory(n, i));
    }

    add('Ehliyet', 'Ehliyet');
    add('İkametgah', 'İkametgah');
    add('Sabıka Kaydı', 'SabikaKaydi');
    add('Ehliyetli GBT', 'EhliyetliGBT');
    add('SRC', 'SRC');
    add('Psikoteknik', 'Psikoteknik');
    add('Şoför Kartı', 'SoforKarti');
    add('Ruhsat', 'Ruhsat');
    add('Kasko', 'Kasko');
    add('Trafik Sigortası', 'TrafikSigortasi');
    add('Koltuk Sigortası', 'KoltukSigortasi');
    add('Yol Belgesi Sigortası', 'YolBelgesiSigortasi');
    add('D2 Sigortası', 'D2Sigortasi');
    add('Sürücü Sözleşmesi', 'SürücüSözlesmesi');
    add('Yol Belgesi', 'YolBelgesi');
    add('Diğer', 'Diger');

    return documentTypes;
  }

  @override
  Future<void> uploadTransferFile(File file) {
    return apiClient.uploadTransferFile(file);
  }

  @override
  Future<void> uploadServiceDocumentFile(File file) {
    return apiClient.uploadTransferFile(file);
  }
}
