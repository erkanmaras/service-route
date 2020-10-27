import 'package:flutter/material.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:service_route/ui/ui.dart';
import 'package:service_route/ui/widgets/month_field.dart';

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
  CompletedTransfersBloc bloc;
  DateTime tranferYearMonth = DateTime(Clock().now().year, Clock().now().month);

  @override
  void initState() {
    bloc = CompletedTransfersBloc(repository: iserviceRouteRepository, logger: logger);
    bloc.load(tranferYearMonth.year, tranferYearMonth.month);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    appTheme = context.getTheme();
    super.didChangeDependencies();
  }

  DateTime filterDate;
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
            child: FieldContainer(
              child: MonthField(
                value: tranferYearMonth,
                onChanged: (date) async {
                  setState(() {
                    tranferYearMonth = date;
                  });
                  await bloc.load(tranferYearMonth.year, tranferYearMonth.month);
                },
              ),
            ),
          ),
          Expanded(
            child: ContentContainer(
              child: BlocProvider(
                  create: (context) => bloc,
                  child: BlocConsumer<CompletedTransfersBloc, CompletedTransfersState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return Builder(builder: (context) {
                        if (state is CompletedTransfersLoading) {
                          return BackgroundHint.loading(context, AppString.loading);
                        }

                        if (state is CompletedTransfersLoadFail) {
                          return BackgroundHint.unExpectedError(context);
                        }

                        if (state is CompletedTransfersLoaded && !state.transfers.isNullOrEmpty()) {
                          return buildData(state.transfers);
                        }

                        return BackgroundHint.recordNotFound(context);
                      });
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildData(List<CompletedTransfer> transfers) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => IndentDivider(),
            itemBuilder: (context, index) {
              var transfer = transfers[index];
              return Card(
                  elevation: 0,
                  child: ListTile(
                    leading: Icon(
                      AppIcons.mapMarkerCheckOutline,
                      color: appTheme.colors.primary,
                    ),
                    title: Text(transfer.accountDescription),
                    subtitle: Text(
                        '${transfer.lineDescription}\n${ValueFormat.dateTimeToString(transfer.transferDate)}',
                        style: appTheme.textStyles.subtitle.copyWith(color: appTheme.colors.fontPale)),
                  ));
            },
            itemCount: transfers.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Transfer adedi : ${transfers.length}',
            style: appTheme.textStyles.subtitle,
          ),
        ),
      ],
    );
  }
}
