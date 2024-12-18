import 'package:flutter/material.dart';

class HealthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Form'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text('Health Form Screen', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}