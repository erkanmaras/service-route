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

  @override
  Widget build(BuildContext context) {
    var files = ['Dosya 1', 'Dosya2', 'Dosya 1', 'Dosya2', 'Dosya 1', 'Dosya2'];
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
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(AppIcons.chevronRight),
                        Expanded(
                            child: Text(
                          'Yüklenecek belgenin fotoğrafını çekebilir veya resim galerisinden seçim yapabilirsiniz.',
                          style: appTheme.textStyles.overline.copyWith(color: appTheme.colors.fontPale),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(AppIcons.chevronRight),
                        Expanded(
                            child: Text(
                          'Seçilen doküman yüklendikten sonra, başka bir doküman seçerek birden fazla belge yükleyebilirsiniz.',
                          style: appTheme.textStyles.overline.copyWith(color: appTheme.colors.fontPale),
                        )),
                      ],
                    ),
                  ),
                  UploadImage(),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          'Yüklenenler:',
                          style: appTheme.textStyles.bodyBold.copyWith(color: appTheme.colors.fontPale),
                        ),
                      )),
                      IndentDivider(),
                  for (var item in files)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          item,
                          style: appTheme.textStyles.body.copyWith(color: appTheme.colors.fontPale),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
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
          decoration: BoxDecoration(border: Border.all(color: appTheme.colors.canvasDark)),
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
