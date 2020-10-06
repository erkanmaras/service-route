import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'locales/messages_all.dart';
 

class Localizer {
  // workaroud for contextless translation
  // see https://github.com/flutter/flutter/issues/14518#issuecomment-447481671
  static Localizer instance;

  static Future<Localizer> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      instance = Localizer();
      return instance;
    });
  }

  static Localizer of(BuildContext context) {
    return Localizations.of<Localizer>(context, Localizer);
  }

  String get appName => Intl.message('V3 Store');
  String get ok => Intl.message('OK');
  String get error => Intl.message('Error');
  String get anUnExpectedErrorOccurred =>
      Intl.message('An unexpected error occurred!');
  String get authenticationParameterMissing =>
      Intl.message('Authentication parameter missing!');
  String get recordNotFound => Intl.message('Record not found!');
  String get connectionCouldNotEstablishWithTheServer =>
      Intl.message('Connection could not be established with server!');
  String get invalidUsernameOrPassword =>
      Intl.message('Invalid user name or password!');
  String get authenticationFailed => Intl.message('Authentication failed!');
  String get apiConnectionTimeout => Intl.message('Api connection timeout!');
  String get apiRequestCanceled => Intl.message('Api request canceled!');

  //dynamic text translate
  String translate(String text,
      {String desc = '',
      Map<String, Object> examples = const {},
      String locale,
      String name,
      List<Object> args,
      String meaning,
      bool skip}) {
    return Intl.message(text,
        desc: desc,
        examples: examples,
        locale: locale,
        name: name,
        args: args,
        meaning: meaning,
        skip: skip);
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<Localizer> {
  const AppLocalizationsDelegate();

static var supportedLocales= [const Locale('tr')];
  @override
  bool isSupported(Locale locale) {
    return supportedLocales
        .any((l) => l.languageCode == locale.languageCode);
  }

  @override
  Future<Localizer> load(Locale locale) {
    return Localizer.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localizer> old) {
    return false;
  }
}
