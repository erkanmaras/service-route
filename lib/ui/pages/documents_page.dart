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
  List<DocumentCategory> documentCategories;

  @override
  void initState() {
    documentCategories = iserviceRouteRepository.getServiceDocumentCategories();
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
          child: ListView.separated(
        separatorBuilder: (context, index) => IndentDivider(),
        itemBuilder: (context, index) {
          var document = documentCategories[index];
          return Card(
            elevation: 0,
            child: ListTile(
              onTap: () => onTabRoute(document),
              leading: Icon(
                AppIcons.fileDocumentOutline,
                color: appTheme.colors.primary,
              ),
              title: Text(document.name),
              trailing: Icon(
                AppIcons.chevronRight,
                color: appTheme.colors.primary,
              ),
            ),
          );
        },
        itemCount: documentCategories.length,
      )),
    );
  }

  void onTabRoute(DocumentCategory documentCategory) {
    appNavigator.pushDocumentUpload(context, documentCategory);
  }
}
