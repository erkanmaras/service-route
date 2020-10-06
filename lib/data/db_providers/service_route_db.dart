import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:service_route/data/data.dart';

class ServiceRouteDb {
  final settingsStore = StoreRef<String, dynamic>('settings');

  Future<void> saveUser(UserSettings user) async {
    var storeDb = await _getSettingsDb();
    await settingsStore.record('user').put(storeDb, user.toJson());
  }

  Future<UserSettings> getUser() async {
    var storeDb = await _getSettingsDb();
    var record = await settingsStore.record('user').get(storeDb) as Map<String,dynamic>;
    return record != null ? UserSettings.fromJson(record) : null;
  }

  Future<Database> _getSettingsDb() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    await documentDirectory.create(recursive: true);
    return databaseFactoryIo.openDatabase(path.join(documentDirectory.path, 'v3StoreData.db'));
  }
}
