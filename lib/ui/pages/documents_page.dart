import 'package:flutter/material.dart';

class DocumentsPage extends StatefulWidget {
  @override
  _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servis Rota'),
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