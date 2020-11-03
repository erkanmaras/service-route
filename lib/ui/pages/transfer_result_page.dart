import 'package:flutter/material.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:service_route/ui/ui.dart';

class TransferResultPage extends StatefulWidget {
  TransferResultPage({this.fileContent});

  final String fileContent;

  @override
  _TransferResultPageState createState() => _TransferResultPageState();
}

class _TransferResultPageState extends State<TransferResultPage> {
  _TransferResultPageState()
      : logger = AppService.get<Logger>(),
        appNavigator = AppService.get<AppNavigator>();

  Logger logger;
  AppTheme appTheme;
  AppNavigator appNavigator;
  Future<List<CompletedTransfer>> completedTransfers;
  TransferResultBloc bloc;

  @override
  void initState() {
    bloc = TransferResultBloc(logger: logger);
    bloc.readTransferFile(widget.fileContent);
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          AppString.transferResult,
        ),
        actions: <Widget>[],
      ),
      body: ContentContainer(
        child: BlocProvider(
            create: (context) => bloc,
            child: BlocConsumer<TransferResultBloc, TransferResultState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Builder(builder: (context) {
                  if (state is TransferResultReading) {
                    return BackgroundHint.loading(context, AppString.loading);
                  }

                  if (state is TransferResultReadComplete) {
                    return buildData(state.summary);
                  }

                  return buildError();
                });
              },
            )),
      ),
    );
  }

  Widget buildData(TransferSummary summary) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: OperationSuccessAnimation(
              color: appTheme.colors.primary, borderColor: appTheme.colors.primary.lighten(0.6)),
        ),
        buildSummaryLine(
          appTheme,
          AppString.transferTime,
          summary.timeInMinutesString,
        ),
        IndentDivider(),
        buildSummaryLine(
          appTheme,
          AppString.transferDistance,
          summary.distanceInKmsString,
        ),
        IndentDivider(),
        buildSummaryLine(
          appTheme,
          AppString.transferPassenger,
          summary.totalPassengers.toString(),
        ),
        IndentDivider(),
        SizedBox(
          height: kMinInteractiveDimension,
        ),
        buildOKButton(appTheme)
      ],
    );
  }

  Widget buildError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          AppIcons.emoticonSadOutline,
          size: kMinInteractiveDimension,
        ),
        SizedBox(
          height: kMinInteractiveDimension,
        ),
        Text(
          AppString.transferFileCannotRead,
          style: appTheme.textStyles.title,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: kMinInteractiveDimension,
        ),
        buildOKButton(appTheme)
      ],
    );
  }

  Widget buildSummaryLine(AppTheme appTheme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              overflow: TextOverflow.ellipsis,
              style: appTheme.textStyles.subtitle.copyWith(color: appTheme.colors.fontPale)),
          Text(value, overflow: TextOverflow.ellipsis, style: appTheme.textStyles.title)
        ],
      ),
    );
  }

  Widget buildOKButton(AppTheme appTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: ElevatedButton(
          onPressed: () {
            appNavigator.pushAndRemoveUntilHome(context);
          },
          child: Text(AppString.ok)),
    );
  }
}
