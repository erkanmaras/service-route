 
import 'package:service_route/data/data.dart';

class AppContext {
  AppUser _user;
  AppUser get user {
    return _user;
  }

  void setAppUser(
    AuthenticationToken authToken,
    String userName,
    String password
  ) {
    _user = AppUser(authToken, userName, password);
  }

  AppSettings _appSetting = AppSettings();
  AppSettings get settings {
    return _appSetting;
  }

  void setAppSettings({ApplicationSettings app, UserSettings user}) {
    if (app != null) {
      settings._app = app;
    }

    if (user != null) {
      settings._user = user;
    }
  }

  AppConnection _connection;
  AppConnection get connection {
    return _connection;
  }

  void setAppConnection(String apiUrl) {
    _connection = AppConnection(apiUrl);
  }
}

class AppUser {
  AppUser(this.authToken,  this.userName, this.password );

  final AuthenticationToken authToken;
  
  final String userName;
  final String password;
  
}

class AppSettings {
  ApplicationSettings _app;
  ApplicationSettings get app {
    return _app;
  }

  UserSettings _user;
  UserSettings get user {
    return _user;
  }
}

class AppConnection {
  AppConnection(this.apiUrl);
  final String apiUrl;
}
