import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_route/data/data.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:service_route/ui/ui.dart';

class DocumentUploadPage extends StatefulWidget {
  const DocumentUploadPage({Key key, this.serviceDocument}) : super(key: key);
  final ServiceDocument serviceDocument;

  @override
  _DocumentUploadPage createState() => _DocumentUploadPage();
}

class _DocumentUploadPage extends State<DocumentUploadPage> {
  AppTheme appTheme;

  @override
  void didChangeDependencies() {
    appTheme = context.getTheme();
    super.didChangeDependencies();
  }

  final List<String> files = <String>[
    'mcmcdmdc20122122.jpg',
    'dfsdfsdf.jpg',
    '45334f34ferfef23.jpg',
    '45334f34ferfef23.png',
    '45334f34ferfef23.png',
    '45334f34ferfef2345334f.png'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.documentUpload),
        actions: <Widget>[],
      ),
      floatingActionButton: FloatingActionButton.extended(
          isExtended: true,
          onPressed: () {},
          label: Text('Yükle'),
          icon: Icon(
            AppIcons.upload,
          )),
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
                      child: UploadImage(),
                    ),
                    _UploadedFiles(files)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  _UploadImageState() : logger = AppService.get<Logger>();

  PickedFile pickedFile;
  Logger logger;
  AppTheme appTheme;
  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    appTheme = context.getTheme();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (pickedFile != null) {
      image = Image.file(File(pickedFile.path));
    } else {
      image = Center(
          child: Icon(
        AppIcons.imageOffOutline,
        color: appTheme.colors.canvasDark,
        size: 100,
      ));
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration:
              BoxDecoration(color: appTheme.colors.canvas, border: Border.all(color: appTheme.colors.canvasDark)),
          height: 200,
          width: double.infinity,
          child: image,
        ),
        ExpandedRow(
          children: [
            TextButton(
                onPressed: () async {
                  await pickImageFromGallery();
                },
                child: Text('Galeriden Seç')),
            TextButton(
                onPressed: () async {
                  await pickImageFromCamera();
                },
                child: Text('Fofograf Çek'))
          ],
        ),
      ],
    );
  }

  Future<void> pickImageFromGallery() async {
    try {
      pickedFile = await _picker.getImage(imageQuality: 50, source: ImageSource.gallery);

      setState(() {});
    } catch (e, s) {
      logger.error(e, stackTrace: s);
      await MessageDialog.error(context: context, message: ErrorMessage.get(e));
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      pickedFile = await _picker.getImage(imageQuality: 50, source: ImageSource.camera);
      setState(() {});
    } catch (e, s) {
      logger.error(e, stackTrace: s);
      await MessageDialog.error(context: context, message: ErrorMessage.get(e));
    }
  }
}

class _UploadedFiles extends StatelessWidget {
  _UploadedFiles(this.fileNames);

  final List<String> fileNames;

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
                'Yüklenen',
                style: appTheme.textStyles.bodyBold,
              ),
            )),
        IndentDivider(),
        ...buildUploadedFiles(appTheme)
      ],
    );
  }

  List<Widget> buildUploadedFiles(AppTheme appTheme) {
    var widgets = <Widget>[];
    for (var item in fileNames) {
      widgets.add(Column(
        children: [
          // if (widgets.isNotEmpty) IndentDivider(),
          Row(
            children: [
              Icon(
                AppIcons.circleSmall,
                color: appTheme.colors.fontPale,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    item,
                    style: appTheme.textStyles.body,
                  ),
                ),
              ),
            ],
          ),
        ],
      ));
    }
    return widgets;
  }
}
