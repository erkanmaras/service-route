import 'package:flutter/material.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:service_route/ui/ui.dart';

class DocumentsPage extends StatefulWidget {
  @override
  _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  _DocumentsPageState()
      : logger = AppService.get<Logger>(),
        iserviceRouteRepository = AppService.get<IServiceRouteRepository>(),
        appNavigator = AppService.get<AppNavigator>();

  Logger logger;
  IServiceRouteRepository iserviceRouteRepository;
  AppTheme appTheme;
  AppNavigator appNavigator;
  Future<List<ServiceDocument>> serviceDocuments;

  @override
  void initState() {
    serviceDocuments = iserviceRouteRepository.getServiceDocuments();
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
        title: const Text(AppString.documents),
        actions: <Widget>[],
      ),
      body: ContentContainer(
        child: FutureBuilder<List<ServiceDocument>>(
            future: serviceDocuments,
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

  Widget buildBody(List<ServiceDocument> serviceDocuments) {
    return ListView.separated(
      separatorBuilder: (context, index) => IndentDivider(),
      itemBuilder: (context, index) {
        var document = serviceDocuments[index];
        return Card(
          elevation: 0,
          child: ListTile(
            onTap: () => onTabRoute(document),
            leading: Icon(
              AppIcons.fileDocumentOutline,
              color: appTheme.colors.primary,
            ),
            title: Text(document.description),
            subtitle: Text('Lorem ipsum dolor sit amet'),
            trailing: Icon(AppIcons.chevronRight),
          ),
        );
      },
      itemCount: serviceDocuments.length,
    );
  }

  void onTabRoute(ServiceDocument selectedDocument) {
    appNavigator.pushDocumentUpload(context, selectedDocument);
  }
}
