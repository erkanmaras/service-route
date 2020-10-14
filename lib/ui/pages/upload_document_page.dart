import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/domain/domain.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:service_route/ui/ui.dart';

class UploadDocumentPage extends StatefulWidget {
  const UploadDocumentPage({Key key, this.serviceDocument}) : super(key: key);
  final ServiceDocument serviceDocument;

  @override
  _UploadDocumentPage createState() => _UploadDocumentPage();
}

class _UploadDocumentPage extends State<UploadDocumentPage> {
  _UploadDocumentPage()
      : repository = AppService.get<IServiceRouteRepository>(),
        logger = AppService.get<Logger>();

  AppTheme appTheme;
  IServiceRouteRepository repository;
  Logger logger;
  ImagePicker picker = ImagePicker();

  @override
  void didChangeDependencies() {
    appTheme = context.getTheme();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<UploadDocumentBloc>(
            create: (BuildContext context) => UploadDocumentBloc(repository: repository, logger: logger),
          ),
        ],
        child: BlocConsumer<UploadDocumentBloc, UploadDocumentState>(listener: (context, state) {
          if (state is UploadDocumentFailState) {
            SnackBarAlert.error(context: context, message: state.reason);
            return;
          }
        }, builder: (context, state) {
          Widget image;
          if (state.hasFile) {
            image = Image.file(File(state.pickedFile.path));
          } else {
            image = Center(
                child: Icon(
              AppIcons.imageOffOutline,
              color: appTheme.colors.canvasDark,
              size: 100,
            ));
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text(AppString.documentUpload),
              actions: <Widget>[],
            ),
            floatingActionButton: state.hasFile
                ? Builder(
                    builder: (context) => FloatingActionButton.extended(
                        isExtended: true,
                        onPressed: () async {
                          if (state.hasFile) {
                            await WaitDialog.scope(
                              waitMessage: AppString.serviceRouteFileUploading,
                              context: context,
                              call: (_) async => context.getBloc<UploadDocumentBloc>().uploadSelectedDocument(),
                            );
                            SnackBarAlert.info(context: context, message: 'Doküman gönderildi!');
                          }
                        },
                        label: Text('Yükle'),
                        icon: Icon(
                          AppIcons.upload,
                        )),
                  )
                : null,
            body: ContentContainer(
              child: ScrollConfiguration(
                behavior: RemoveEffectScrollBehavior(),
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          CardTitle(
                            title: widget.serviceDocument.description,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                      color: appTheme.colors.canvas,
                                      border: Border.all(color: appTheme.colors.canvasDark)),
                                  height: 200,
                                  width: double.infinity,
                                  child: image,
                                ),
                                ExpandedRow(
                                  children: [
                                    TextButton(
                                        onPressed: () async {
                                          await pickImageFromGallery(context);
                                        },
                                        child: Text('Galeriden Seç')),
                                    TextButton(
                                        onPressed: () async {
                                          await pickImageFromCamera(context);
                                        },
                                        child: Text('Fofograf Çek'))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          _UploadedFiles(state.uploadHistory)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  Future<void> pickImageFromGallery(BuildContext context) async {
    try {
      var pickedFile = await picker.getImage(imageQuality: 50, source: ImageSource.gallery);
      await context.getBloc<UploadDocumentBloc>().setSelectedFile(pickedFile.path);
    } catch (e, s) {
      logger.error(e, stackTrace: s);
      await MessageDialog.error(context: context, message: ErrorMessage.get(e));
    }
  }

  Future<void> pickImageFromCamera(BuildContext context) async {
    try {
      var pickedFile = await picker.getImage(imageQuality: 50, source: ImageSource.camera);
      await context.getBloc<UploadDocumentBloc>().setSelectedFile(pickedFile.path);
    } catch (e, s) {
      logger.error(e, stackTrace: s);
      await MessageDialog.error(context: context, message: ErrorMessage.get(e));
    }
  }
}

class _UploadedFiles extends StatelessWidget {
  _UploadedFiles(this.uploadHistory);

  final List<DocumentFileUploadStatus> uploadHistory;

  @override
  Widget build(BuildContext context) {
    var appTheme = context.getTheme();
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              'Geçmiş',
              style: appTheme.textStyles.bodyBold,
            ),
          ),
        ),
        IndentDivider(),
        ...buildUploadedFiles(appTheme)
      ],
    );
  }

  List<Widget> buildUploadedFiles(AppTheme appTheme) {
    var widgets = <Widget>[];
    for (var item in uploadHistory) {
      Widget statusIcon;
      if (item.uploaded) {
        statusIcon = Icon(AppIcons.check, color: appTheme.colors.success);
      } else {
        statusIcon = Icon(AppIcons.cancel, color: appTheme.colors.error);
      }
      widgets.add(Column(
        children: [
          // if (widgets.isNotEmpty) IndentDivider(),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(
                  AppIcons.circleSmall,
                  color: appTheme.colors.fontPale,
                ),
                Expanded(
                  child: Text(
                    item.file.fileName,
                    overflow: TextOverflow.ellipsis,
                    style: appTheme.textStyles.body,
                  ),
                ),
                statusIcon
              ],
            ),
          ),
        ],
      ));
    }
    return widgets;
  }
}
