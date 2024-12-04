import 'package:flutter/material.dart';

class RemindersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text('Reminders Screen', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
