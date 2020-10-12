import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_route/infrastructure/infrastructure.dart';
import 'package:service_route/ui/ui.dart';

class DocumentUploadPage extends StatefulWidget {
  @override
  _DocumentUploadPage createState() => _DocumentUploadPage();
}

class _DocumentUploadPage extends State<DocumentUploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.documentUpload),
        actions: <Widget>[],
      ),
      body: ContentContainer(
        child: Column(
          children: [
            Text(
              'DocumentsPage',
              style: TextStyle(fontSize: 24),
            ),
            UploadImage()
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
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(border: Border.all(color: appTheme.colors.canvasDark)),
          height: 200,
          child: image,
        ),
        SizedBox(height: 10),
        ExpandedRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () async {
                    await pickImageFromGallery();
                  },
                  child: Text('Fofograf Seç')),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  onPressed: () async {
                    await pickImageFromCamera();
                  },
                  child: Text('Fofograf Çek')),
            )
          ],
        )
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
