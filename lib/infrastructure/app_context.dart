 
import 'package:service_route/data/data.dart';

class AppContext {
  AppUser _user;
  AppUser get user {
    return _user;
  }

  void setAppUser(
    AuthenticationToken authToken,
    String userGroupName,
    String userName,
    String password,
    String language,
  ) {
    _user = AppUser(authToken, userGroupName, userName, password, language);
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
  AppUser(this.authToken, this.userGroupName, this.userName, this.password, this.language);

  final AuthenticationToken authToken;
  final String userGroupName;
  final String userName;
  final String password;
  final String language;
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
