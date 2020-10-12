import 'package:flutter/material.dart';
import 'package:service_route/infrastructure/infrastructure.dart';

class DocumentsPage extends StatefulWidget {
  @override
  _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.documents),
        actions: <Widget>[],
      ),
      body: const Center(
        child: Text(
          'DocumentsPage',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
