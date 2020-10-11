import 'package:flutter/material.dart';

class DeservedsPage extends StatefulWidget {
  @override
  _DeservedsPageState createState() => _DeservedsPageState();
}

class _DeservedsPageState extends State<DeservedsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servis Rota'),
        actions: <Widget>[],
      ),
      body: const Center(
        child: Text(
          'DeservedsPage',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
