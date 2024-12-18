import 'package:flutter/material.dart';

class ExercisesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercises Library'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Text('Exercises Library Screen', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}