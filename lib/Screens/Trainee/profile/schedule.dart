import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text('Schedule Screen', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}