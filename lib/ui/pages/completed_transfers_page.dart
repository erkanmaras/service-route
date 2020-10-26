import 'package:flutter/material.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:service_route/ui/ui.dart';

class CompletedTransfersPage extends StatefulWidget {
  @override
  _CompletedTransfersPageState createState() => _CompletedTransfersPageState();
}

class _CompletedTransfersPageState extends State<CompletedTransfersPage> {
  _CompletedTransfersPageState()
      : logger = AppService.get<Logger>(),
        iserviceRouteRepository = AppService.get<IServiceRouteRepository>();

  Logger logger;
  AppTheme appTheme;
  IServiceRouteRepository iserviceRouteRepository;
  Future<List<CompletedTransfer>> completedTransfers;

  @override
  void initState() {
    completedTransfers = iserviceRouteRepository.getCompletedTransfers();
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
        elevation: 0,
        title: const Text(AppString.completedTransfers),
        actions: <Widget>[],
      ),
      body: Column(
        children: [
          AppBarContainer(
            child: DateField(
              value: Clock().now(),
              onChanged: filterDate,
            ),
          ),
          ContentContainer(
            child: FutureBuilder<List<CompletedTransfer>>(
                future: completedTransfers,
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
        ],
      ),
    );
  }

  Widget buildBody(List<CompletedTransfer> transfers) {
    return ListView.separated(
      separatorBuilder: (context, index) => IndentDivider(),
      itemBuilder: (context, index) {
        var transfer = transfers[index];
        return Card(
            elevation: 0,
            child: ListTile(
              leading: Icon(
                AppIcons.mapMarkerOutline,
                color: appTheme.colors.primary,
              ),
              title: Text(transfer.accountDescription),
              subtitle: Text('${transfer.lineDescription}\n${ValueFormat.dateTimeToString(transfer.transferDate)}',
                  style: appTheme.textStyles.subtitle.copyWith(color: appTheme.colors.fontPale)),
              trailing: Icon(
                AppIcons.chevronRight,
                color: appTheme.colors.primary,
              ),
            ));
      },
      itemCount: transfers.length,
    );
  }

  void filterDate(DateTime value) {}
}
