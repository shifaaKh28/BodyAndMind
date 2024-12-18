import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Tracker'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text('Progress Tracker Screen', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}