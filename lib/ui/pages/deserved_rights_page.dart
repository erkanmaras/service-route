import 'package:flutter/material.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:service_route/ui/ui.dart';

class DeservedRightsPage extends StatefulWidget {
  @override
  _DeservedRightsPageState createState() => _DeservedRightsPageState();
}

class _DeservedRightsPageState extends State<DeservedRightsPage> {
  _DeservedRightsPageState()
      : logger = AppService.get<Logger>(),
        iserviceRouteRepository = AppService.get<IServiceRouteRepository>();

  Logger logger;
  IServiceRouteRepository iserviceRouteRepository;
  AppTheme appTheme;
  Future<List<DeservedRight>> deservedRights;

  @override
  void initState() {
    deservedRights = iserviceRouteRepository.getDeservedRights();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    appTheme = context.getTheme();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.deservedRights),
        actions: <Widget>[],
      ),
      body: ContentContainer(
        child: FutureBuilder<List<DeservedRight>>(
            future: deservedRights,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return BackgroundHint.loading(context, AppString.loading);
              } else {
                if (snapshot.hasError) {
                  return BackgroundHint.unExpectedError(context);
                } else if (!snapshot.hasData || snapshot.data.isNullOrEmpty()) {
                  return BackgroundHint.noData(context);
                } else {
                  return buildBody(snapshot.data);
                }
              }
            }),
      ),
    );
  }

  Widget buildBody(List<DeservedRight> serviceDeservedRight) {
    return ListView.separated(
      separatorBuilder: (context, index) => IndentDivider(),
      itemBuilder: (context, index) {
        var deservedRight = serviceDeservedRight[index];
        return Card(
          elevation: 0,
          child: ListTile(
            leading: Icon(
              AppIcons.fileDocumentOutline,
              color: appTheme.colors.primary,
            ),
            title: Text(deservedRight.description),
            subtitle: Text('Lorem ipsum dolor sit amet'),
          ),
        );
      },
      itemCount: serviceDeservedRight.length,
    );
  }
}
