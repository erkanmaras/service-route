 
import 'package:service_route/app.dart';
import 'package:service_route/data/api_providers/fake/service_route_api_fake.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';

Future<void> main() async {
  await _AppDevelopment().run();
}

class _AppDevelopment extends App {
  @override
  void buildAppServices() {
    super.buildAppServices();

    AppService.addSingleton<Logger>(
      Logger(name: 'AppDebugLogger', logLevel: LogLevel.all, recordStackTraceAtLevel: LogLevel.all),
    );

    //override with fake service
    AppService.addSingleton<ServiceRouteApi>(
      ServiceRouteApiFake(AppService.get<AppContext>(), AppService.get<Logger>()),
    );
  }

  @override
  Future<void> reportError(AppErrorReport appError) async {
    LogDebugPrint.writeError(appError);
    await ErrorReporter.sendErrorReport(appError);
  }

  @override
  Future<void> run() async {
    Bloc.observer = AppBlocObserver();
    await super.run();
  }
}


class AppBlocObserver  extends BlocObserver  {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    debugPrint('$event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint('$transition');
  }
  
  
  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    super.onError(cubit, error, stackTrace);
    debugPrint('$stackTrace');
  }
}
