import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servis Rota'),
        actions: <Widget>[],
      ),
      body: const Center(
        child: Text(
          'Home Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
